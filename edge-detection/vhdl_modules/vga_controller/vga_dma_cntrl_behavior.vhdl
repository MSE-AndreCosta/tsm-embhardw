ARCHITECTURE MSE OF vga_dma_cntrl IS

   TYPE MEM_TYPE IS ARRAY( 512 DOWNTO 0 ) OF std_logic_vector( 31 DOWNTO 0 );
   
   COMPONENT synchro_flop IS
      PORT ( clock_in    : IN  std_logic;
             clock_out   : IN  std_logic;
             reset       : IN  std_logic;
             tick_in     : IN  std_logic;
             tick_out    : OUT std_logic);
   END COMPONENT;

   SIGNAL s_line_buffer_1_memory   : MEM_TYPE;
   SIGNAL s_line_buffer_2_memory   : MEM_TYPE;
   SIGNAL s_line_buffer_write_addr : unsigned( 9 DOWNTO 0 );
   SIGNAL s_line_buffer_1_we       : std_logic;
   SIGNAL s_line_buffer_2_we       : std_logic;
   SIGNAL s_line_buffer_select_reg : std_logic;
   SIGNAL s_line_buffer_1_data     : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_line_buffer_2_data     : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_get_new_line           : std_logic;
   SIGNAL s_start_dma              : std_logic;
   SIGNAL s_next_line_clk          : std_logic;
   SIGNAL s_next_frame_clk         : std_logic;
   SIGNAL s_bus_address_next       : unsigned( 31 DOWNTO 2 );
   SIGNAL s_bus_address_reg        : unsigned( 31 DOWNTO 2 );
   SIGNAL s_line_width             : unsigned( 30 DOWNTO 0 );
   SIGNAL s_del_reg                : std_logic_vector( 1 DOWNTO 0 );
   SIGNAL s_read_address           : unsigned( 8 DOWNTO 0 );

BEGIN
--------------------------------------------------------------------------------
---                                                                          ---
--- In this section the output signals are defined                           ---
---                                                                          ---
--------------------------------------------------------------------------------
   make_del_reg : PROCESS( PixelClock )
   BEGIN
      IF (rising_edge(PixelClock)) THEN
         s_del_reg <= PixelIndex(1 DOWNTO 0);
      END IF;
   END PROCESS make_del_reg;
   make_RGB565Data : PROCESS( s_line_buffer_1_data , s_line_buffer_2_data ,
                              s_line_buffer_select_reg, GrayScale)
      VARIABLE v_data   : std_logic_vector(31 DOWNTO 0 );
      VARIABLE v_gray   : std_logic_vector( 7 DOWNTO 0 );
   BEGIN
      IF (s_line_buffer_select_reg = '0') THEN v_data := s_line_buffer_2_data;
                                          ELSE v_data := s_line_buffer_1_data;
      END IF;
      IF (GrayScale = '0') THEN
         IF (s_del_reg(0) = '0') THEN RGB565Data <= v_data( 15 DOWNTO  0 );
                                 ELSE RGB565Data <= v_data( 31 DOWNTO 16 );
         END IF;
                           ELSE
         CASE (s_del_reg) IS
            WHEN  "00"  => v_gray := v_data(  7 DOWNTO  0 );
            WHEN  "01"  => v_gray := v_data( 15 DOWNTO  8 );
            WHEN  "10"  => v_gray := v_data( 23 DOWNTO 16 );
            WHEN OTHERS => v_gray := v_data( 31 DOWNTO 24 );
         END CASE;
         RGB565Data <= v_gray(7 DOWNTO 3)&v_gray(7 DOWNTO 2)&v_gray(7 DOWNTO 3);
      END IF;
   END PROCESS make_RGB565Data;

--------------------------------------------------------------------------------
---                                                                          ---
--- In this section the avalon master signals are defined                    ---
---                                                                          ---
--------------------------------------------------------------------------------
   make_start_dma : PROCESS( Clock )
   BEGIN
      IF (rising_edge(Clock)) THEN
         s_start_dma <= NOT(Reset) AND s_get_new_line;
      END IF;
   END PROCESS make_start_dma;

   make_master_sigs : PROCESS( Clock )
   BEGIN
      IF (rising_edge(Clock)) THEN
         IF (s_start_dma = '1') THEN 
            master_address    <= std_logic_vector(s_bus_address_reg)&"00";
            master_read       <= '1';
            IF (GrayScale = '0') THEN
               master_burstcount <= std_logic_vector(NrOfPixelsEachLine(10 DOWNTO 1));
                                 ELSE
               master_burstcount <= "0"&std_logic_vector(NrOfPixelsEachLine(10 DOWNTO 2));
            END IF;
         ELSIF (Reset = '1' OR
                master_waitrequest = '0') THEN
            master_address    <= (OTHERS => '0');
            master_read       <= '0';
            master_burstcount <= (OTHERS => '0');
         END IF;
      END IF;
   END PROCESS make_master_sigs;

   
--------------------------------------------------------------------------------
---                                                                          ---
--- In this section the bus address counter is defined                       ---
---                                                                          ---
--------------------------------------------------------------------------------
   s_line_width       <= X"00000"&unsigned(NrOfPixelsEachLine) 
                            WHEN GrayScale = '0' ELSE
                         X"00000"&"0"&unsigned(NrOfPixelsEachLine(10 DOWNTO 1));
   s_bus_address_next <= unsigned(MemoryPointer) 
                            WHEN s_next_frame_clk = '1' ELSE
                         s_bus_address_reg+s_line_width(30 DOWNTO 1) 
                            WHEN s_next_line_clk = '1' ELSE
                         s_bus_address_reg;
   
   make_bus_address_reg : PROCESS( Clock )
   BEGIN
      IF (rising_edge(Clock)) THEN
         IF (Reset = '1') THEN s_bus_address_reg <= (OTHERS => '0');
                          ELSE s_bus_address_reg <= s_bus_address_next;
         END IF;
      END IF;
   END PROCESS make_bus_address_reg;

--------------------------------------------------------------------------------
---                                                                          ---
--- In this section the line_buffer control signals are defined              ---
---                                                                          ---
--------------------------------------------------------------------------------
   s_get_new_line <= s_next_line_clk OR s_next_frame_clk;
   s_read_address <= unsigned(PixelIndex(9 DOWNTO 1)) WHEN GrayScale = '0' ELSE
                     "0"&unsigned(PixelIndex(9 DOWNTO 2));
   
   make_line_buffer_select_reg : PROCESS( Clock )
   BEGIN
      IF (rising_edge(Clock)) THEN
         IF (Reset = '1') THEN s_line_buffer_select_reg <= '0';
         ELSIF (s_get_new_line = '1') THEN
            s_line_buffer_select_reg <= NOT(s_line_buffer_select_reg);
         END IF;
      END IF;
   END PROCESS make_line_buffer_select_reg;
   
   s_line_buffer_1_we <= master_data_valid AND NOT(s_line_buffer_select_reg)
                         AND NOT (s_line_buffer_write_addr(9));
   s_line_buffer_2_we <= master_data_valid AND s_line_buffer_select_reg
                         AND NOT (s_line_buffer_write_addr(9));
   
   make_line_buffer_write_addr : PROCESS( Clock )
   BEGIN
      IF (rising_edge(Clock)) THEN
         IF (Reset = '1' OR
             s_get_new_line = '1') THEN 
            s_line_buffer_write_addr <= (OTHERS => '0');
         ELSIF (s_line_buffer_write_addr(9) = '0' AND
                master_data_valid = '1') THEN
            s_line_buffer_write_addr <= s_line_buffer_write_addr + 1;
         END IF;
      END IF;
   END PROCESS make_line_buffer_write_addr;
   
--------------------------------------------------------------------------------
---                                                                          ---
--- In this section the line_buffer 1 is defined                             ---
---                                                                          ---
--------------------------------------------------------------------------------
   mem_write_1 : PROCESS( clock )
   BEGIN
      IF (rising_edge(clock)) THEN
         IF (s_line_buffer_1_we = '1') THEN
            s_line_buffer_1_memory(
               to_integer(s_line_buffer_write_addr(8 DOWNTO 0))) <=
               master_read_data;
         END IF;
      END IF;
   END PROCESS mem_write_1;
   
   mem_read_1 : PROCESS( PixelClock )
   BEGIN
      IF (rising_edge(PixelClock)) THEN
         s_line_buffer_1_data <= s_line_buffer_1_memory(to_integer(s_read_address));
      END IF;
   END PROCESS mem_read_1;
   
--------------------------------------------------------------------------------
---                                                                          ---
--- In this section the line_buffer 2 is defined                             ---
---                                                                          ---
--------------------------------------------------------------------------------
   mem_write_2 : PROCESS( clock )
   BEGIN
      IF (rising_edge(clock)) THEN
         IF (s_line_buffer_2_we = '1') THEN
            s_line_buffer_2_memory(
               to_integer(s_line_buffer_write_addr(8 DOWNTO 0))) <=
               master_read_data;
         END IF;
      END IF;
   END PROCESS mem_write_2;
   
   mem_read_2 : PROCESS( PixelClock )
   BEGIN
      IF (rising_edge(PixelClock)) THEN
         s_line_buffer_2_data <= s_line_buffer_2_memory(to_integer(s_read_address));
      END IF;
   END PROCESS mem_read_2;

--------------------------------------------------------------------------------
---                                                                          ---
--- In this section the clock domain synchronisation is defined              ---
---                                                                          ---
--------------------------------------------------------------------------------
   lineSync : synchro_flop
      PORT MAP ( clock_in    => PixelClock,
                 clock_out   => Clock,
                 reset       => Reset,
                 tick_in     => NextLine,
                 tick_out    => s_next_line_clk);

   frameSync : synchro_flop
      PORT MAP ( clock_in    => PixelClock,
                 clock_out   => Clock,
                 reset       => Reset,
                 tick_in     => NextFrame,
                 tick_out    => s_next_frame_clk);
   
END MSE;
