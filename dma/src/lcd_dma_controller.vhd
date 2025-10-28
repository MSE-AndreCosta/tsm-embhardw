library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity lcd_dma_controller is
	generic(
		N: natural := 16
	);
	port(
		-- avalon interfaces signals
		clk : in std_logic;
		reset : in std_logic;

		-- Slave interface CPU <=> LCD Controller
		cpu_address : in std_logic_vector (2 downto 0);
		cpu_cs : in std_logic;
		cpu_read : in std_logic;
		cpu_write : in std_logic;
		cpu_read_data: out std_logic_vector (31 downto 0);
		cpu_write_data : in std_logic_vector (31 downto 0);
	        cpu_wait_request : out std_logic;

		-- Master interface LCD Controller <=> DDRAM
		master_address :  out std_logic_vector(31 downto 0);
		master_read :  out std_logic;
		master_read_data : in std_logic_vector(N - 1 downto 0);
		master_wait_request : in std_logic;
		
		dma_transaction_end_irq : out std_logic;

		-- lcd interface
		lcd_data : inout std_logic_vector (N - 1 downto 0);
		lcd_ncd : out std_logic;
		lcd_ncs : out std_logic;
		lcd_nwr : out std_logic;
		lcd_nrd : out std_logic
	);
end lcd_dma_controller;

architecture comp of lcd_dma_controller is

        constant DEVICE_ID : std_logic_vector(cpu_write_data'range) := x"1234cafe";

	signal test_register_s : std_logic_vector(cpu_write_data'range);


	signal lcd_data_direct_s : std_logic_vector(lcd_data'range);
	signal lcd_ncd_direct_s : std_logic;

	signal lcd_data_dma_s : std_logic_vector(lcd_data'range);
	signal next_lcd_data_dma_s : std_logic_vector(lcd_data'range);
	signal lcd_ncd_dma_s : std_logic;

	signal lcd_wr : std_logic;
	signal lcd_dma_cs : std_logic;
	signal lcd_cpu_cs : std_logic;

	signal irq_enable_s : std_logic;
	signal irq_s : std_logic;

	signal draw_buffer_address : std_logic_vector(master_address'range);
	signal draw_buffer_size    : std_logic_vector(master_address'range);

	signal master_address_s :  std_logic_vector(master_address'range);
	signal next_master_address_s :  std_logic_vector(master_address'range);

	signal is_write : std_logic;
	signal is_read : std_logic;

	signal is_control_reg_access : std_logic;

	signal start_dma_transaction : std_logic;

	signal i : unsigned(master_address_s'range);
	signal next_i : unsigned(master_address_s'range);

	type dma_state_t is (
		DMA_IDLE,
		DMA_FETCH_PIXEL,
		DMA_READ_PIXEL,
		DMA_SEND_PIXEL_START,
		DMA_SEND_PIXEL,
		DMA_FINISH
	);

	type lcd_state_t is (
		LCD_IDLE,
	        LCD_SEND_DATA,
		LCD_DATA_SENT,
		LCD_FINISH_WRITE
	);

	signal curr_lcd_state : lcd_state_t;
	signal next_lcd_state : lcd_state_t;

	signal curr_dma_state : dma_state_t;
	signal next_dma_state : dma_state_t;

	signal clk_counter : unsigned(2 downto 0);
	signal clk_counter_rst_s : std_logic;
	signal twr : std_logic;

	signal start_dma_write : std_logic;
	signal is_direct_write : std_logic;
	signal irq_ack_s : std_logic;
begin

	is_write <= '1' when cpu_cs = '1' and cpu_write = '1' else '0';
	is_read <= '1' when cpu_cs = '1' and cpu_read = '1' else '0';
	-- lsb indicates command or data
	is_direct_write <= '1' when is_write = '1' and cpu_address(2 downto 1) = "01" else '0';

	is_control_reg_access <= '1' when is_write = '1' and cpu_address(2 downto 0) = "110" else '0';

	start_dma_transaction <= '1' when is_control_reg_access = '1' and cpu_write_data(0) = '1' else '0';
	irq_ack_s <= '1' when is_control_reg_access = '1' and cpu_write_data(2) = '1' else '0';

	register_write: process(clk, reset) begin
		if reset = '1' then
			test_register_s <= (others => '0');
			lcd_data_direct_s <= (others => '0');
			draw_buffer_address <= (others => '0');
			draw_buffer_size <= (others => '0');
			lcd_ncd_direct_s <= '0';
			irq_enable_s <= '0';
			lcd_cpu_cs <= '0';
		elsif rising_edge(clk) then
			if is_write = '1' then
				case cpu_address(2 downto 0) is
					when "001" => test_register_s <= cpu_write_data;
					when "010" => 
						lcd_data_direct_s <= cpu_write_data(lcd_data_direct_s'range);
						lcd_ncd_direct_s <= '0';
					when "011" => 
						lcd_data_direct_s <= cpu_write_data(lcd_data_direct_s'range);
						lcd_ncd_direct_s <= '1';
					when "100" =>  draw_buffer_address <= cpu_write_data;
					when "101" =>  draw_buffer_size <= cpu_write_data;
					when "110" =>  
						irq_enable_s <= cpu_write_data(1);
					when "111" =>  
						lcd_cpu_cs <= cpu_write_data(0);
					when others => null;
				end case;
			end if;
		end if;
	end process;

	register_read: process(
		is_read,
		cpu_address,
		test_register_s,
		draw_buffer_address,
		draw_buffer_size,
		irq_enable_s,
		irq_s,
		lcd_cpu_cs)
	begin
		cpu_read_data <= (others => '0');
		if is_read = '1' then
			case cpu_address(2 downto 0) is
				when "000" => cpu_read_data <= DEVICE_ID;
				when "001" => cpu_read_data <= test_register_s;
				when "100" => cpu_read_data <= draw_buffer_address;
				when "101" => cpu_read_data <= draw_buffer_size;
				when "110" => 
					cpu_read_data(1) <= irq_enable_s;
					cpu_read_data(2) <= irq_s;
				when "111" => cpu_read_data(0) <= lcd_cpu_cs;
				when others => cpu_read_data <= x"deadbeef";
			end case;
		end if;
	end process;

	fsm_reg : process (clk, reset) is
	begin
		if reset = '1' then
			clk_counter <= (others => '0');
			curr_lcd_state <= LCD_IDLE;
			curr_dma_state <= DMA_IDLE;
			i <= (others => '0');
			lcd_data_dma_s <= (others => '0');
			master_address_s <= (others => '0');
		elsif rising_edge(clk) then
			master_address_s <= next_master_address_s;
			curr_lcd_state <= next_lcd_state;
			lcd_data_dma_s <= next_lcd_data_dma_s;
			curr_dma_state <= next_dma_state;
			i <= next_i;
			if clk_counter_rst_s = '1' then
				clk_counter <= (others => '0');
			else
				clk_counter <= clk_counter + 1;
			end if;
		end if;
	end process fsm_reg;

	process(curr_dma_state,
		next_lcd_state,
		start_dma_transaction,
		master_wait_request,
		master_read_data,
		i,
		lcd_data_dma_s, 
		master_address_s, 
		draw_buffer_address,
		irq_ack_s,
		draw_buffer_size
	)
	begin
		next_dma_state <= curr_dma_state;
		next_master_address_s <= master_address_s;
		master_read <= '0';
		start_dma_write <= '0';
		next_lcd_data_dma_s <= lcd_data_dma_s;
		lcd_ncd_dma_s <= '1';
		next_i <= i;
		irq_s <= '0';
		lcd_dma_cs <= '0';
		case curr_dma_state is
			when DMA_IDLE => 
				next_i <= (others => '0');
				next_lcd_data_dma_s <= (others => '0');
				next_master_address_s <= draw_buffer_address;
				if start_dma_transaction = '1' then
					next_dma_state <= DMA_FETCH_PIXEL;
				end if;
			when DMA_FETCH_PIXEL => 
				master_read <= '1';
				next_dma_state <= DMA_READ_PIXEL;
			when DMA_READ_PIXEL => 
				lcd_dma_cs <= '1';
				next_lcd_data_dma_s <= master_read_data;
				master_read <= master_wait_request;
				if master_wait_request = '0' then
					next_dma_state <= DMA_SEND_PIXEL_START;
					start_dma_write <= '1';
					next_i <= i + 2;
				end if;
			when DMA_SEND_PIXEL_START => 
				lcd_dma_cs <= '1';
				next_dma_state <= DMA_SEND_PIXEL;
				next_master_address_s <= std_logic_vector(unsigned(draw_buffer_address) + i);
			when DMA_SEND_PIXEL => 
				lcd_dma_cs <= '1';
				if next_lcd_state = LCD_IDLE then
					if i >= unsigned(draw_buffer_size) then
						next_dma_state <= DMA_FINISH;
					else 
						master_read <= '1';
						next_dma_state <= DMA_READ_PIXEL;
					end if;
				end if;
			when DMA_FINISH => 
				irq_s <= '1';
				if irq_ack_s = '1' then
					next_dma_state <= DMA_IDLE;
				end if;
		end case;

	end process;
	

	dec_fut_sort : process (curr_lcd_state, start_dma_write, is_direct_write, twr) is
	begin
		next_lcd_state <= curr_lcd_state;
		lcd_wr <= '0';
		cpu_wait_request <= '0';
		clk_counter_rst_s <= '0';
		case curr_lcd_state is 
		    when LCD_IDLE => 
			if is_direct_write = '1' or start_dma_write = '1' then
				cpu_wait_request <= '1';
				clk_counter_rst_s <= '1';
				next_lcd_state <= LCD_SEND_DATA;
			end if;
		    when LCD_SEND_DATA =>
			cpu_wait_request <= '1';
			lcd_wr <= '1';
			if twr = '1' then 
				clk_counter_rst_s <= '1';
				next_lcd_state <= LCD_DATA_SENT;
			end if;
		    when LCD_DATA_SENT =>
			lcd_wr <= '0';
			cpu_wait_request <= '1';
			next_lcd_state <= LCD_FINISH_WRITE;
		    when LCD_FINISH_WRITE => 
			lcd_wr <= '0';
			if twr = '1' then 
				-- Adding this line, the cpu_wait_request signal is only set to 1 for 3 clock cycles which
				-- can mean the CPU unsets the CS line too early for the LCD
				cpu_wait_request <= '0'; 
				next_lcd_state <= LCD_IDLE;
			end if;
		end case;
	end process;

	
	twr <= '1' when clk_counter = "001" else '0';
	lcd_data <= lcd_data_direct_s when curr_dma_state = DMA_IDLE else lcd_data_dma_s;
	lcd_ncd <= lcd_ncd_direct_s when curr_dma_state = DMA_IDLE else lcd_ncd_dma_s;

	lcd_ncs <= '0' when lcd_dma_cs = '1' or lcd_cpu_cs = '1' else '1';
	lcd_nwr <= not lcd_wr;
	lcd_nrd <= '1';
	dma_transaction_end_irq <= irq_s and irq_enable_s;
	master_address <= master_address_s;


end comp;
