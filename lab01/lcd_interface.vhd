library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity lcd_interface is
	generic(
		N: natural := 16
	);
	port(
		-- avalon interfaces signals
		clk : in std_logic;
		nreset : in std_logic;
		address : in std_logic_vector (2 downto 0);
		chipselect : in std_logic;
		read : in std_logic;
		write : in std_logic;
		readdata: out std_logic_vector (N - 1 downto 0);
		writedata : in std_logic_vector (N - 1 downto 0);
	        waitrequest : out std_logic;

		-- lcd interface
		lcd_data : inout std_logic_vector (N - 1 downto 0);
		lcd_ncd : out std_logic;
		lcd_nwr : out std_logic;
		lcd_nrd : out std_logic
	);
end lcd_interface;

architecture comp of lcd_interface is

        constant DEVICE_ID : std_logic_vector(writedata'range) := x"cafe";

	signal lcd_data_s : std_logic_vector(lcd_data'range);
	signal lcd_wr : std_logic;

	signal reset: std_logic;
	type lcd_state_t is (
		IDLE,
	        SEND_DATA,
		DATA_SENT
	);

	signal curr_lcd_state : lcd_state_t;
	signal next_lcd_state : lcd_state_t;
	signal clk_counter : unsigned(2 downto 0);
	signal clk_counter_rst_s : std_logic;
	signal twr : std_logic;
begin

	reset <= not nreset;

	register_write: process(clk,reset) begin
		if reset = '1' then
			lcd_data_s <= (others => '0');
			lcd_ncd <= '0';
		elsif rising_edge(clk) then
			if chipselect = '1' and write = '1' then
				case address(2 downto 0) is
					when "001" => 
						lcd_data_s <= writedata;
						lcd_ncd <= '0';
					when "100" => 
						lcd_data_s <= writedata;
						lcd_ncd <= '1';
					when others => null;
				end case;
			end if;
		end if;
	end process;

	register_read: process(clk)
	begin
		if rising_edge(clk) then
			readdata <= (others => '0');
			if chipselect = '1' and read = '1' then
				case address(2 downto 0) is
					when "000" => readdata <= DEVICE_ID;
					when "010" => readdata <= x"aaaa" ;
					when "100" => readdata <= x"bbbb";
					when others => readdata <= x"dead";
				end case;
			end if;
		end if;
	end process;

	fsm_reg : process (clk, reset) is
	begin
		if reset = '1' then
			clk_counter <= (others => '0');
			curr_lcd_state <= IDLE;
		elsif rising_edge(clk) then
			curr_lcd_state <= next_lcd_state;

			if clk_counter_rst_s = '1' then
				clk_counter <= (others => '0');
			else
				clk_counter <= clk_counter + 1;
			end if;
		end if;
	end process fsm_reg;

	dec_fut_sort : process (curr_lcd_state, chipselect, write, twr) is
	begin
		next_lcd_state <= curr_lcd_state;
		lcd_wr <= '0';
		waitrequest <= '0';
		clk_counter_rst_s <= '0';
		case curr_lcd_state is 
		    when IDLE => 
			if chipselect = '1' and write = '1' then
				waitrequest <= '1';
				clk_counter_rst_s <= '1';
				next_lcd_state <= SEND_DATA;
			end if;
		    when SEND_DATA =>
			waitrequest <= '1';
			lcd_wr <= '1';
			if twr = '1' then 
				clk_counter_rst_s <= '1';
				next_lcd_state <= DATA_SENT;
			end if;
		    when DATA_SENT =>
			waitrequest <= '1';
			lcd_wr <= '0';
			if twr = '1' then 
				-- Adding this line, the waitrequest signal is only set to 1 for 3 clock cycles which
				-- can mean the CPU unsets the CS line too early for the LCD
				-- waitrequest <= '0'; 
				next_lcd_state <= IDLE;
			end if;
		end case;
	end process;
	
	twr <= '1' when clk_counter = "001" else '0';
	lcd_data <= lcd_data_s;
	lcd_nwr <= not lcd_wr;
	lcd_nrd <= '1';

end comp;
