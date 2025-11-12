ARCHITECTURE MSE OF pixel_interface IS

   TYPE MEM_TYPE IS ARRAY( 512 DOWNTO 0 ) OF std_logic_vector( 31 DOWNTO 0 );
   
   SIGNAL s_line_buffer_1_memory   : MEM_TYPE;
   SIGNAL s_line_buffer_2_memory   : MEM_TYPE;
   SIGNAL s_line_buffer_read_addr  : unsigned( 8 DOWNTO 0 );
   SIGNAL s_line_buffer_read_addr_n: unsigned( 8 DOWNTO 0 );
   SIGNAL s_line_buffer_write_addr : unsigned( 9 DOWNTO 0 );
   SIGNAL s_line_buffer_1_we       : std_logic;
   SIGNAL s_line_buffer_2_we       : std_logic;
   SIGNAL s_line_buffer_select_reg : std_logic;
   SIGNAL s_line_buffer_1_data     : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_line_buffer_2_data     : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_line_buffer_write_data : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_reset                  : std_logic;
   SIGNAL s_data_1_reg             : std_logic_vector(  7 DOWNTO 0 );
   SIGNAL s_data_2_reg             : std_logic_vector(  7 DOWNTO 0 );
   SIGNAL s_data_3_reg             : std_logic_vector(  7 DOWNTO 0 );
   SIGNAL s_data_cnt_reg           : unsigned( 1 DOWNTO 0 );
   SIGNAL s_we                     : std_logic;

BEGIN
--------------------------------------------------------------------------------
---                                                                          ---
--- In this section the output signals are defined                           ---
---                                                                          ---
--------------------------------------------------------------------------------
   PixelData <= s_line_buffer_1_data WHEN s_line_buffer_select_reg = '1' ELSE
                s_line_buffer_2_data;
                
   make_NrOfWords : PROCESS( PixelClk )
   BEGIN
      IF (rising_edge(PixelClk)) THEN
         IF (s_reset = '1') THEN NrOfWords <= (OTHERS => '0');
         ELSIF (NextLinePxlClk = '1') THEN
            NrOfWords <= std_logic_vector(s_line_buffer_write_addr);
         END IF;
      END IF;
   END PROCESS make_NrOfWords;


--------------------------------------------------------------------------------
---                                                                          ---
--- In this section the pixel interface is defined                           ---
---                                                                          ---
--------------------------------------------------------------------------------
   s_we <= '1' WHEN s_data_cnt_reg = "11" AND HSync = '1' ELSE '0';
   
   make_data_cnt_reg : PROCESS( PixelClk )
   BEGIN
      IF (rising_edge(PixelClk)) THEN
         IF (s_reset = '1' OR
             NextLinePxlClk = '1') THEN
            s_data_cnt_reg <= "00";
         ELSIF (HSync = '1') THEN
            s_data_cnt_reg <= s_data_cnt_reg + 1;
         END IF;
      END IF;
   END PROCESS make_data_cnt_reg;
   
   make_data_1_reg : PROCESS( PixelClk )
   BEGIN
      IF (rising_edge(PixelClk)) THEN
         IF (s_reset = '1') THEN s_data_1_reg <= (OTHERS => '0');
         ELSIF (HSync = '1' AND
                s_data_cnt_reg = "00") THEN
            s_data_1_reg <= CamData( 9 DOWNTO 2 );
         END IF;
      END IF;
   END PROCESS make_data_1_reg;

   make_data_2_reg : PROCESS( PixelClk )
   BEGIN
      IF (rising_edge(PixelClk)) THEN
         IF (s_reset = '1') THEN s_data_2_reg <= (OTHERS => '0');
         ELSIF (HSync = '1' AND
                s_data_cnt_reg = "01") THEN
            s_data_2_reg <= CamData( 9 DOWNTO 2 );
         END IF;
      END IF;
   END PROCESS make_data_2_reg;

   make_data_3_reg : PROCESS( PixelClk )
   BEGIN
      IF (rising_edge(PixelClk)) THEN
         IF (s_reset = '1') THEN s_data_3_reg <= (OTHERS => '0');
         ELSIF (HSync = '1' AND
                s_data_cnt_reg = "10") THEN
            s_data_3_reg <= CamData( 9 DOWNTO 2 );
         END IF;
      END IF;
   END PROCESS make_data_3_reg;
   
   s_line_buffer_write_data <= s_data_3_reg&CamData( 9 DOWNTO 2 )&
                               s_data_1_reg&s_data_2_reg;

--------------------------------------------------------------------------------
---                                                                          ---
--- In this section the line buffer control signals are defined              ---
---                                                                          ---
--------------------------------------------------------------------------------
   s_reset            <= Reset;
   s_line_buffer_1_we <= s_we AND NOT(s_line_buffer_select_reg);
   s_line_buffer_2_we <= s_we AND s_line_buffer_select_reg;
   
   make_select_reg : PROCESS( PixelClk )
   BEGIN
      IF (rising_edge(PixelClk)) THEN
         IF (s_reset = '1') THEN s_line_buffer_select_reg <= '0';
         ELSIF (NextLinePxlClk = '1') THEN
            s_line_buffer_select_reg <= NOT(s_line_buffer_select_reg);
         END IF;
      END IF;
   END PROCESS make_select_reg;
   
   make_write_addr : PROCESS( PixelClk )
   BEGIN
      IF (rising_edge(PixelClk)) THEN
         IF (s_reset = '1' OR
             NextLinePxlClk = '1') THEN 
            s_line_buffer_write_addr <= (OTHERS => '0');
         ELSIF (s_we = '1') THEN
            s_line_buffer_write_addr <= s_line_buffer_write_addr + 1;
         END IF;
      END IF;
   END PROCESS make_write_addr;
   
   s_line_buffer_read_addr_n <= (OTHERS => '0') 
                                   WHEN NextLine = '1' ELSE
                                s_line_buffer_read_addr + 1
                                   WHEN Pop = '1' ELSE
                                s_line_buffer_read_addr;
                                
   make_read_addr : PROCESS( Clock )
   BEGIN
      IF (rising_edge(Clock)) THEN
         IF (s_reset = '1') THEN s_line_buffer_read_addr <= (OTHERS => '0');
                            ELSE
            s_line_buffer_read_addr <= s_line_buffer_read_addr_n;
         END IF;
      END IF;
   END PROCESS make_read_addr;
   
--------------------------------------------------------------------------------
---                                                                          ---
--- In this section the line_buffer 1 is defined                             ---
---                                                                          ---
--------------------------------------------------------------------------------
   mem_write_1 : PROCESS( PixelClk )
   BEGIN
      IF (rising_edge(PixelClk)) THEN
         IF (s_line_buffer_1_we = '1') THEN
            s_line_buffer_1_memory(
               to_integer(s_line_buffer_write_addr(8 DOWNTO 0))) <=
               s_line_buffer_write_data;
         END IF;
      END IF;
   END PROCESS mem_write_1;
   
   mem_read_1 : PROCESS( Clock )
   BEGIN
      IF (rising_edge(Clock)) THEN
         s_line_buffer_1_data <= s_line_buffer_1_memory(to_integer(s_line_buffer_read_addr_n));
      END IF;
   END PROCESS mem_read_1;
   
--------------------------------------------------------------------------------
---                                                                          ---
--- In this section the line_buffer 2 is defined                             ---
---                                                                          ---
--------------------------------------------------------------------------------
   mem_write_2 : PROCESS( PixelClk )
   BEGIN
      IF (rising_edge(PixelClk)) THEN
         IF (s_line_buffer_2_we = '1') THEN
            s_line_buffer_2_memory(
               to_integer(s_line_buffer_write_addr(8 DOWNTO 0))) <=
               s_line_buffer_write_data;
         END IF;
      END IF;
   END PROCESS mem_write_2;
   
   mem_read_2 : PROCESS( Clock )
   BEGIN
      IF (rising_edge(Clock)) THEN
         s_line_buffer_2_data <= s_line_buffer_2_memory(to_integer(s_line_buffer_read_addr_n));
      END IF;
   END PROCESS mem_read_2;
   
END MSE;
