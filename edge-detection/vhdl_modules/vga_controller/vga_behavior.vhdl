ARCHITECTURE testbench OF vga_controller IS

  COMPONENT delay_line IS
     GENERIC ( nr_of_elements : INTEGER := 2;     -- must be at least 2!
               reset_value    : std_logic := '0' ); 
     PORT ( clock     : IN  std_logic;
            reset     : IN  std_logic;
            value_in  : IN  std_logic;
            value_out : OUT std_logic );
  END COMPONENT;

  TYPE HSTATE IS (HFRONT,HSYN,HBACK,HACTIVE);
  TYPE VSTATE IS (VFRONT,VSYN,VBACK,VACTIVE);
  
  SIGNAL horizontal_state_machine : HSTATE;
  SIGNAL horizontal_state_next    : HSTATE;
  SIGNAL vertical_state_machine   : VSTATE;
  SIGNAL vertical_state_next      : VSTATE;
  SIGNAL s_pixel_down_counter_reg : std_logic_vector( 11 DOWNTO 0 );
  SIGNAL s_pixel_down_counter_next: std_logic_vector( 11 DOWNTO 0 );
  SIGNAL s_next_h_seg             : std_logic;
  SIGNAL s_next_line              : std_logic;
  SIGNAL s_line_down_counter_reg  : std_logic_vector( 11 DOWNTO 0 );
  SIGNAL s_line_down_counter_next : std_logic_vector( 11 DOWNTO 0 );
  SIGNAL s_next_v_seg             : std_logic;
  SIGNAL s_red                    : std_logic_vector( 4 DOWNTO 0 );
  SIGNAL s_green                  : std_logic_vector( 5 DOWNTO 0 );
  SIGNAL s_blue                   : std_logic_vector( 4 DOWNTO 0 );
  SIGNAL s_next_pixel             : std_logic;
  SIGNAL s_next_pixel_reg         : std_logic;
  SIGNAL s_hsync_next             : std_logic;
  SIGNAL s_vsync_next             : std_logic;
  SIGNAL s_PixelIndex             : unsigned( 9 DOWNTO 0 );
  SIGNAL s_nr_of_pixels           : std_logic_vector( 10 DOWNTO 0 );
  
BEGIN
   ----------------------------------------------
   --- Here the color conversion is performed ---
   ----------------------------------------------
   s_red    <= s_pixel_down_counter_reg(8 DOWNTO 4) WHEN testscreen = '1' ELSE
               rgb565in(15 DOWNTO 11) WHEN swaprb = '1' ELSE
               rgb565in( 4 DOWNTO  0);
   s_green  <= s_line_down_counter_reg(8 DOWNTO 3) WHEN testscreen = '1' ELSE
               rgb565in(10 DOWNTO  5);
   s_blue   <= s_pixel_down_counter_reg(8 DOWNTO 4) XOR
               s_line_down_counter_reg(8 DOWNTO 4) WHEN testscreen = '1' ELSE
               rgb565in(15 DOWNTO 11) WHEN swaprb = '0' ELSE
               rgb565in( 4 DOWNTO  0);
   s_next_pixel <= '1' WHEN horizontal_state_machine = HACTIVE AND
                            vertical_state_machine = VACTIVE ELSE '0';

   ----------------------------------------------
   --- Here we define the output signals      ---
   ----------------------------------------------
   s_nr_of_pixels     <= std_logic_vector(to_unsigned(H_VISABLE_AREA,11));
   NrOfPixelsEachLine <= s_nr_of_pixels WHEN QuarterScreen = '0' ELSE
                         "0"&s_nr_of_pixels(10 DOWNTO 1);
   
   make_control : PROCESS( pixel_clock )
   BEGIN
      IF (rising_edge(pixel_clock)) THEN
         IF (horizontal_state_next = HBACK AND
             horizontal_state_machine = HSYN AND
             vertical_state_machine = VACTIVE AND
             (QuarterScreen = '0' OR
              s_line_down_counter_reg(0) = '1')) THEN next_line <= '1';
                                                 ELSE next_line <= '0';
         END IF;
         IF (vertical_state_next = VBACK AND
             vertical_state_machine = VSYN AND
             s_next_line = '1') THEN next_frame <= '1';
                                ELSE next_frame <= '0';
         END IF;
      END IF;
   END PROCESS make_control;
   
   make_syncs : PROCESS( pixel_clock )
   BEGIN
      IF (rising_edge(pixel_clock)) THEN
         IF (reset = '1' OR
             horizontal_state_machine /= HSYN) THEN
            s_hsync_next <= NOT(H_Sync_active_value);
                                                ELSE
            s_hsync_next <= H_Sync_active_value;
         END IF;
         IF (reset = '1' OR
             vertical_state_machine /= VSYN) THEN
            s_vsync_next <= NOT(V_Sync_active_value);
                                              ELSE
            s_vsync_next <= V_Sync_active_value;
         END IF;
      END IF;
   END PROCESS make_syncs;
   
   make_rgb : PROCESS( pixel_clock )
   BEGIN
      IF (rising_edge(pixel_clock)) THEN
         IF (s_next_pixel_reg='1') THEN
            red   <= s_red&"00000";
            green <= s_green&"0000";
            blue  <= s_blue&"00000";
                               ELSE
            red   <= (OTHERS => '0');
            green <= (OTHERS => '0');
            blue  <= (OTHERS => '0');
         END IF;
         s_next_pixel_reg <= s_next_pixel;
      END IF;
   END PROCESS make_rgb;
   
   -- we insert 2 delay lines on the hsync and vsync signals to
   -- compensate for DAC delays
   hsync_del : delay_line
     GENERIC MAP ( nr_of_elements => vhsync_delay_elements,
                   reset_value    => NOT(H_Sync_active_value) )
     PORT MAP ( clock     => pixel_clock,
                reset     => reset,
                value_in  => s_hsync_next,
                value_out => hsync );

   vsync_del : delay_line
     GENERIC MAP ( nr_of_elements => vhsync_delay_elements,
                   reset_value    => NOT(V_Sync_active_value) )
     PORT MAP ( clock     => pixel_clock,
                reset     => reset,
                value_in  => s_vsync_next,
                value_out => vsync );

   
   ------------------------------------------------
   --- Here the horizontal counting is realized ---
   ------------------------------------------------
   s_next_h_seg <= '1' WHEN s_pixel_down_counter_reg = X"000" ELSE '0';
   s_next_line  <= '1' WHEN s_next_h_seg = '1' AND
                            horizontal_state_machine = HACTIVE ELSE '0';
   
   make_pixel_index : PROCESS( QuarterScreen , FlipX )
      VARIABLE v_select : std_logic_vector( 1 DOWNTO 0 );
   BEGIN
      v_select := FlipX&QuarterScreen;
      CASE (v_select) IS
         WHEN  "00"  => PixelIndex <= std_logic_vector(s_PixelIndex);
         WHEN  "01"  => PixelIndex <= "0"&std_logic_vector(s_PixelIndex( 9 DOWNTO 1 ));
         WHEN  "10"  => PixelIndex <= s_pixel_down_counter_reg(9 DOWNTO 0);
         WHEN OTHERS => PixelIndex <= "0"&s_pixel_down_counter_reg(9 DOWNTO 1);
      END CASE;
   END PROCESS make_pixel_index;

   make_PixelIndex : PROCESS( pixel_clock )
   BEGIN
      IF (rising_edge(pixel_clock)) THEN
         IF (reset = '1' OR
             s_next_h_seg = '1') THEN s_PixelIndex <= (OTHERS => '0');
                                 ELSE
            s_PixelIndex <= s_PixelIndex + 1;
         END IF;
      END IF;
   END PROCESS make_PixelIndex;
   
   make_pixel_down_counter_next : PROCESS( s_next_h_seg ,
                                           horizontal_state_machine ,
                                           s_pixel_down_counter_reg )
   BEGIN
      IF (s_next_h_seg = '0') THEN
         s_pixel_down_counter_next <= std_logic_vector(
                                         unsigned(s_pixel_down_counter_reg)-1);
                             ELSE
         CASE (horizontal_state_machine) IS
            WHEN HFRONT    => s_pixel_down_counter_next <=
                                 std_logic_vector(to_unsigned(H_Sync_Pulse,12)-1);
            WHEN HSYN      => s_pixel_down_counter_next <=
                                 std_logic_vector(to_unsigned(H_Back_Porch,12)-1);
            WHEN HBACK     => s_pixel_down_counter_next <=
                                 std_logic_vector(to_unsigned(H_VISABLE_AREA,12)-1);
            WHEN OTHERS    => s_pixel_down_counter_next <=
                                 std_logic_vector(to_unsigned(H_Front_Porch,12)-1);
         END CASE;
      END IF;
   END PROCESS make_pixel_down_counter_next;
   
   make_pixel_counter : PROCESS( pixel_clock )
   BEGIN
      IF (rising_edge(pixel_clock)) THEN
         IF (reset = '1') THEN
            s_pixel_down_counter_reg <= std_logic_vector(to_unsigned(H_Front_Porch,12)-1);
                          ELSE
            s_pixel_down_counter_reg <= s_pixel_down_counter_next;
         END IF;
      END IF;
   END PROCESS make_pixel_counter;
   
   make_horizontal_state_next : PROCESS( s_next_h_seg , horizontal_state_machine )
   BEGIN
      IF (s_next_h_seg = '0') THEN horizontal_state_next <= horizontal_state_machine;
                              ELSE
         CASE (horizontal_state_machine) IS
            WHEN HFRONT    => horizontal_state_next <= HSYN;
            WHEN HSYN      => horizontal_state_next <= HBACK;
            WHEN HBACK     => horizontal_state_next <= HACTIVE;
            WHEN OTHERS    => horizontal_state_next <= HFRONT;
         END CASE;
      END IF;
   END PROCESS make_horizontal_state_next;
   
   make_horizontal_state_machine : PROCESS( pixel_clock )
   BEGIN
      IF (rising_edge(pixel_clock)) THEN
         IF (reset = '1') THEN horizontal_state_machine <= HFRONT;
                          ELSE 
            horizontal_state_machine <= horizontal_state_next;
         END IF;
      END IF;
   END PROCESS make_horizontal_state_machine;

   ------------------------------------------------
   --- Here the vertical counting is realized   ---
   ------------------------------------------------
   s_next_v_seg <= '1' WHEN s_line_down_counter_reg = X"000" ELSE '0';
   
   make_line_down_counter_next : PROCESS( s_next_v_seg ,
                                          vertical_state_machine ,
                                          s_line_down_counter_reg )
   BEGIN
      IF (s_next_v_seg = '0') THEN
         s_line_down_counter_next <= std_logic_vector(
                                        unsigned(s_line_down_counter_reg)-1);
                              ELSE
         CASE (vertical_state_machine) IS
            WHEN VFRONT    => s_line_down_counter_next <=
                                 std_logic_vector(to_unsigned(V_Sync_Pulse,12)-1);
            WHEN VSYN      => s_line_down_counter_next <=
                                 std_logic_vector(to_unsigned(V_Back_Porch,12)-1);
            WHEN VBACK     => s_line_down_counter_next <=
                                 std_logic_vector(to_unsigned(V_VISABLE_AREA,12)-1);
            WHEN OTHERS    => s_line_down_counter_next <=
                                 std_logic_vector(to_unsigned(V_Front_Porch,12)-1);
         END CASE;
      END IF;
   END PROCESS make_line_down_counter_next;
   
   make_line_counter : PROCESS( pixel_clock )
   BEGIN
      IF (rising_edge(pixel_clock)) THEN
         IF (reset = '1') THEN
            s_line_down_counter_reg <= std_logic_vector(to_unsigned(V_Front_Porch,12)-1);
         ELSIF (s_next_line = '1') THEN
            s_line_down_counter_reg <= s_line_down_counter_next;
         END IF;
      END IF;
   END PROCESS make_line_counter;
   
   make_vertical_state_next : PROCESS( s_next_v_seg , vertical_state_machine )
   BEGIN
      IF (s_next_v_seg = '0') THEN vertical_state_next <= vertical_state_machine;
                              ELSE
         CASE (vertical_state_machine) IS
            WHEN VFRONT    => vertical_state_next <= VSYN;
            WHEN VSYN      => vertical_state_next <= VBACK;
            WHEN VBACK     => vertical_state_next <= VACTIVE;
            WHEN OTHERS    => vertical_state_next <= VFRONT;
         END CASE;
      END IF;
   END PROCESS make_vertical_state_next;
   
   make_vertical_state_machine : PROCESS( pixel_clock )
   BEGIN
      IF (rising_edge(pixel_clock)) THEN
         IF (reset = '1') THEN vertical_state_machine <= VFRONT;
         ELSIF (s_next_line = '1') THEN 
            vertical_state_machine <= vertical_state_next;
         END IF;
      END IF;
   END PROCESS make_vertical_state_machine;
END testbench;
