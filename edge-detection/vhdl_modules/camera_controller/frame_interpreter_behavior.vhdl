ARCHITECTURE MSE OF frame_interpreter IS

   COMPONENT synchro_flop IS
      PORT ( clock_in    : IN  std_logic;
             clock_out   : IN  std_logic;
             reset       : IN  std_logic;
             tick_in     : IN  std_logic;
             tick_out    : OUT std_logic);
   END COMPONENT;

   SIGNAL s_second_counter_reg  : unsigned( 26 DOWNTO 0 );
   SIGNAL s_second_counter_next : unsigned( 26 DOWNTO 0 );
   SIGNAL s_second_tick         : std_logic;
   SIGNAL s_reset               : std_logic;
   SIGNAL s_Vsync_delay_reg     : std_logic;
   SIGNAL s_Hsync_delay_reg     : std_logic;
   SIGNAL s_Line_End_pxlclk     : std_logic;
   SIGNAL s_Line_End_clk50m     : std_logic;
   SIGNAL s_Frame_End_pxlclk    : std_logic;
   SIGNAL s_Frame_End_clk50m    : std_logic;
   SIGNAL s_Frame_count_reg     : unsigned( 7 DOWNTO 0);
   SIGNAL s_Frame_count_next    : unsigned( 7 DOWNTO 0);
   SIGNAL s_Frame_rate_reg      : std_logic_vector( 7 DOWNTO 0 );
   SIGNAL s_valid_data_cntr     : unsigned( 1 DOWNTO 0 );
   SIGNAL s_pixel_byte_counter  : unsigned(15 DOWNTO 0 );
   SIGNAL s_pixel_byte_value    : std_logic_vector(15 DOWNTO 0);
   SIGNAL s_line_counter        : unsigned(15 DOWNTO 0 );
   SIGNAL s_nr_of_lines         : std_logic_vector(15 DOWNTO 0);

BEGIN
--------------------------------------------------------------------------------
---                                                                          ---
--- In this section the outpus signals are defined                           ---
---                                                                          ---
--------------------------------------------------------------------------------
   NextFrame      <= s_Frame_End_clk50m;
   NextLine       <= s_Line_End_clk50m;
   NextLinePxlClk <= s_Line_End_pxlclk;

   frameRate      <= s_Frame_rate_reg;
   DataValid      <= '1' WHEN s_valid_data_cntr = "11" ELSE '0';
   
--------------------------------------------------------------------------------
---                                                                          ---
--- In this section the line-counter is defined                              ---
---                                                                          ---
--------------------------------------------------------------------------------

   make_line_counter : PROCESS( PixelClk )
   BEGIN
      IF (rising_edge(PixelClk)) THEN
         IF (s_reset = '1' OR s_Frame_End_pxlclk = '1') THEN
            s_line_counter <= (OTHERS => '0');
         ELSIF (s_Line_End_pxlclk = '1') THEN
            s_line_counter <= s_line_counter+1;
         END IF;
      END IF;
   END PROCESS make_line_counter;
   
   make_nr_of_lines_1 : PROCESS( PixelClk )
   BEGIN
      IF (rising_edge(PixelClk)) THEN
         IF (s_reset = '1') THEN s_nr_of_lines <= (OTHERS => '0');
         ELSIF (s_Frame_End_pxlclk = '1') THEN
            s_nr_of_lines <= std_logic_vector(s_line_counter);
         END IF;
      END IF;
   END PROCESS make_nr_of_lines_1;
   
   make_nr_of_lines_2 : PROCESS( Clock )
   BEGIN
      IF (rising_edge(Clock)) THEN
         IF (s_reset = '1') THEN nr_of_lines <= (OTHERS => '0');
         ELSIF (s_Frame_End_clk50m = '1') THEN
            nr_of_lines <= s_nr_of_lines;
         END IF;
      END IF;
   END PROCESS make_nr_of_lines_2;

--------------------------------------------------------------------------------
---                                                                          ---
--- In this section the pixel-byte-counter is defined                        ---
---                                                                          ---
--------------------------------------------------------------------------------
   make_pixel_byte_counter : PROCESS( PixelClk )
   BEGIN
      IF (rising_edge(PixelClk)) THEN
         IF (s_reset = '1' OR s_Line_End_pxlclk = '1') THEN
            s_pixel_byte_counter <= (OTHERS => '0');
         ELSIF (HSync = '1') THEN
            s_pixel_byte_counter <= s_pixel_byte_counter + 1;
         END IF;
      END IF;
   END PROCESS make_pixel_byte_counter;
   
   make_pixel_byte_value : PROCESS( PixelClk )
   BEGIN
      IF (rising_edge(PixelClk)) THEN
         IF (s_reset = '1' ) THEN s_pixel_byte_value <= (OTHERS=> '0');
         ELSIF (s_Line_End_pxlclk = '1') THEN
            s_pixel_byte_value <= std_logic_vector(s_pixel_byte_counter);
         END IF;
      END IF;
   END PROCESS make_pixel_byte_value;
   
   make_nr_of_bytes_each_line : PROCESS( Clock )
   BEGIN
      IF (rising_edge(Clock)) THEN
         IF (s_reset = '1') THEN nr_of_bytes_each_line <= (OTHERS => '0');
         ELSIF (s_Line_End_clk50m = '1') THEN
            nr_of_bytes_each_line <= s_pixel_byte_value;
         END IF;
      END IF;
   END PROCESS make_nr_of_bytes_each_line;

--------------------------------------------------------------------------------
---                                                                          ---
--- In this section the frame rate counter is defined                        ---
---                                                                          ---
--------------------------------------------------------------------------------
   s_Frame_count_next <= (OTHERS => '0') 
                            WHEN s_reset = '1' OR s_second_tick = '1' ELSE
                         s_Frame_count_reg+1
                            WHEN s_Frame_End_clk50m = '1' ELSE
                         s_Frame_count_reg;
   
   make_frame_counter : PROCESS( Clock )
   BEGIN
      IF (rising_edge(Clock)) THEN
         s_Frame_count_reg <= s_Frame_count_next;
      END IF;
   END PROCESS make_frame_counter;
                            
   make_frame_rate_reg : PROCESS( Clock )
   BEGIN
      IF (rising_edge(Clock)) THEN
         IF (s_reset = '1') THEN s_Frame_rate_reg <= (OTHERS => '0');
         ELSIF (s_second_tick = '1') THEN
            s_Frame_rate_reg <= std_logic_vector(s_Frame_count_reg);
         END IF;
      END IF;
   END PROCESS make_frame_rate_reg;
   
   make_valid_data_cntr : PROCESS( Clock )
   BEGIN
      IF (rising_edge(Clock)) THEN
         IF (s_reset = '1') THEN s_valid_data_cntr <= "00";
         ELSIF (s_valid_data_cntr/= "11" AND
                s_second_tick = '1') THEN
            s_valid_data_cntr <= s_valid_data_cntr + 1;
         END IF;
      END IF;
   END PROCESS make_valid_data_cntr;

--------------------------------------------------------------------------------
---                                                                          ---
--- In this section some control signals are defined                         ---
---                                                                          ---
--------------------------------------------------------------------------------
   s_reset   <= Reset OR NOT(CamResetBar);

--------------------------------------------------------------------------------
---                                                                          ---
--- In this section the second counter is defined                            ---
---                                                                          ---
--------------------------------------------------------------------------------

   s_second_tick <= '1' WHEN s_second_counter_reg = to_unsigned(0,27) ELSE '0';
   s_second_counter_next <= to_unsigned(49999999,27)
                               WHEN s_second_tick = '1' ELSE
                            s_second_counter_reg-1;
   
   make_second_counter : PROCESS( Clock )
   BEGIN
      IF (rising_edge(Clock)) THEN
         IF (s_reset = '1') THEN s_second_counter_reg <= to_unsigned(49999999,27);
                            ELSE s_second_counter_reg <= s_second_counter_next;
         END IF;
      END IF;
   END PROCESS make_second_counter;

--------------------------------------------------------------------------------
---                                                                          ---
--- In this section the line and frame end signals are determined in both    ---
--- the pixelclock domain as well as in the 50MHz domain                     ---
---                                                                          ---
--------------------------------------------------------------------------------

   make_delayed_regs : PROCESS( PixelClk )
   BEGIN
      IF (rising_edge(PixelClk)) THEN
         s_Vsync_delay_reg <= VSync;
         s_Hsync_delay_reg <= HSync;
      END IF;
   END PROCESS make_delayed_regs;
   
   make_end_regs : PROCESS( PixelClk )
   BEGIN
      IF (rising_edge(PixelClk)) THEN
         IF (s_reset = '1') THEN s_Line_End_pxlclk  <= '0';
                                 s_Frame_End_pxlclk <= '0';
                            ELSE
            s_Line_End_pxlclk  <= s_Hsync_delay_reg AND NOT(HSync);
            s_Frame_End_pxlclk <= s_Vsync_delay_reg AND NOT(VSync);
         END IF;
      END IF;
   END PROCESS make_end_regs;
   
   sync_line : synchro_flop
      PORT MAP ( clock_in    => PixelClk,
                 clock_out   => Clock,
                 reset       => s_reset,
                 tick_in     => s_Line_End_pxlclk,
                 tick_out    => s_Line_End_clk50m);
   frame_sync : synchro_flop
      PORT MAP ( clock_in    => PixelClk,
                 clock_out   => Clock,
                 reset       => s_reset,
                 tick_in     => s_Frame_End_pxlclk,
                 tick_out    => s_Frame_End_clk50m);

   
END MSE;
