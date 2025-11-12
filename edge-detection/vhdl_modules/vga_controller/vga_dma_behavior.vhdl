ARCHITECTURE MSE OF vga_dma IS

   COMPONENT vga_dma_cntrl IS
      PORT ( clock              : IN  std_logic;
             PixelClock         : IN  std_logic;
             Reset              : IN  std_logic;
             MemoryPointer      : IN  std_logic_vector( 31 DOWNTO 2 );
             NextLine           : IN  std_logic;
             NextFrame          : IN  std_logic;
             GrayScale          : IN  std_logic;
             PixelIndex         : IN  std_logic_vector(  9 DOWNTO 0 );
             NrOfPixelsEachLine : IN  std_logic_vector( 10 DOWNTO 0 );
             RGB565Data         : OUT std_logic_vector( 15 DOWNTO 0 );
             -- Here the Avalon Master Interface is defined
             master_address     : OUT std_logic_vector( 31 DOWNTO 0 );
             master_read        : OUT std_logic;
             master_burstcount  : OUT std_logic_vector(  9 DOWNTO 0 );
             master_waitrequest : IN  std_logic;
             master_data_valid  : IN  std_logic;
             master_read_data   : IN  std_logic_vector( 31 DOWNTO 0 ));
   END COMPONENT;
   
   COMPONENT vga_controller IS
      GENERIC( H_VISABLE_AREA        : INTEGER;
               H_Front_Porch         : INTEGER;
               H_Sync_Pulse          : INTEGER;
               H_Back_Porch          : INTEGER;
               H_Sync_active_value   : std_logic;
               V_VISABLE_AREA        : INTEGER;
               V_Front_Porch         : INTEGER;
               V_Sync_Pulse          : INTEGER;
               V_Back_Porch          : INTEGER;
               V_Sync_active_value   : std_logic;
               vhsync_delay_elements : INTEGER);
      PORT ( pixel_clock        : IN  std_logic;
             reset              : IN  std_logic;
             rgb565in           : IN  std_logic_vector(15 DOWNTO 0 );
             swaprb             : IN  std_logic;
             next_line          : OUT std_logic;
             PixelIndex         : OUT std_logic_vector(  9 DOWNTO 0 );
             next_frame         : OUT std_logic;
             testscreen         : IN  std_logic;
             FlipX              : IN  std_logic;
             QuarterScreen      : IN  std_logic;
             NrOfPixelsEachLine : OUT std_logic_vector( 10 DOWNTO 0 );
             red                : OUT std_logic_vector( 9 DOWNTO 0 );
             green              : OUT std_logic_vector( 9 DOWNTO 0 );
             blue               : OUT std_logic_vector( 9 DOWNTO 0 );
             hsync              : OUT std_logic;
             vsync              : OUT std_logic);
   END COMPONENT;

   SIGNAL s_reset_reg          : std_logic;
   SIGNAL s_memory_pointer_reg : std_logic_vector( 31 DOWNTO 2 );
   SIGNAL s_we_mem_pointer     : std_logic;
   SIGNAL s_we_swap_rb         : std_logic;
   SIGNAL s_swap_rb_reg        : std_logic;
   SIGNAL s_rgb565             : std_logic_vector( 15 DOWNTO 0 );
   SIGNAL s_next_line          : std_logic;
   SIGNAL s_next_frame         : std_logic;
   SIGNAL s_test_screen_reg    : std_logic;
   SIGNAL s_NrOfPixelsEachLine : std_logic_vector( 10 DOWNTO 0 );
   SIGNAL s_PixelIndex         : std_logic_vector(  9 DOWNTO 0 );
   SIGNAL s_FlipX_reg          : std_logic;
   SIGNAL s_QuarterScreen_reg  : std_logic;
   SIGNAL s_grayscale_reg      : std_logic;

BEGIN
   s_we_mem_pointer <= '1' WHEN slave_address = '0' AND
                                slave_cs = '1' AND
                                slave_we = '1' ELSE '0';
   s_we_swap_rb     <= '1' WHEN slave_address = '1' AND
                                slave_cs = '1' AND
                                slave_we = '1' ELSE '0';

   make_reset_reg : PROCESS( Clock )
   BEGIN
      IF (rising_edge(Clock)) THEN
         IF (Reset = '1') THEN s_reset_reg <= '1';
         ELSIF (s_we_mem_pointer = '1') THEN s_reset_reg <= '0';
         END IF;
      END IF;
   END PROCESS make_reset_reg;
   
   make_memory_pointer_reg : PROCESS( Clock )
   BEGIN
      IF (rising_edge(Clock)) THEN
         IF (reset = '1') THEN s_memory_pointer_reg <= (OTHERS => '0');
         ELSIF (s_we_mem_pointer = '1') THEN
            s_memory_pointer_reg <= slave_write_data( 31 DOWNTO 2 );
         END IF;
      END IF;
   END PROCESS make_memory_pointer_reg;
   
   make_swap_rb_reg : PROCESS( Clock )
   BEGIN
      IF (rising_edge(Clock)) THEN
         IF (Reset = '1') THEN s_swap_rb_reg       <= '0';
                               s_test_screen_reg   <= '0';
                               s_FlipX_reg         <= '0';
                               s_QuarterScreen_reg <= '0';
                               s_grayscale_reg     <= '0';
         ELSIF (s_we_swap_rb = '1') THEN
            s_swap_rb_reg       <= slave_write_data(0);
            s_test_screen_reg   <= slave_write_data(1);
            s_FlipX_reg         <= slave_write_data(2);
            s_QuarterScreen_reg <= slave_write_data(3);
            s_grayscale_reg     <= slave_write_data(4);
         END IF;
      END IF;
   END PROCESS make_swap_rb_reg;
   
   dma : vga_dma_cntrl
      PORT MAP ( clock              => Clock,
                 PixelClock         => PixelClock,
                 Reset              => s_reset_reg,
                 MemoryPointer      => s_memory_pointer_reg,
                 NextLine           => s_next_line,
                 NextFrame          => s_next_frame,
                 GrayScale          => s_grayscale_reg,
                 PixelIndex         => s_PixelIndex,
                 NrOfPixelsEachLine => s_NrOfPixelsEachLine,
                 RGB565Data         => s_rgb565,
                 -- Here the Avalon Master Interface is defined
                 master_address     => master_address    ,
                 master_read        => master_read       ,
                 master_burstcount  => master_burstcount ,
                 master_waitrequest => master_waitrequest,
                 master_data_valid  => master_data_valid ,
                 master_read_data   => master_read_data  );
   
   vga : vga_controller
      GENERIC MAP ( H_VISABLE_AREA        => 1024,
                    H_Front_Porch         => 24,
                    H_Sync_Pulse          => 136,
                    H_Back_Porch          => 144,
                    H_Sync_active_value   => '1',
                    V_VISABLE_AREA        => 768,
                    V_Front_Porch         => 3,
                    V_Sync_Pulse          => 6,
                    V_Back_Porch          => 29,
                    V_Sync_active_value   => '1',
                    vhsync_delay_elements => 8)
      PORT MAP ( pixel_clock        => PixelClock,
                 reset              => s_reset_reg,
                 rgb565in           => s_rgb565,
                 swaprb             => s_swap_rb_reg,
                 next_line          => s_next_line,
                 next_frame         => s_next_frame,
                 PixelIndex         => s_PixelIndex,
                 testscreen         => s_test_screen_reg,
                 FlipX              => s_FlipX_reg,
                 QuarterScreen      => s_QuarterScreen_reg,
                 NrOfPixelsEachLine => s_NrOfPixelsEachLine,
                 red                => red  ,
                 green              => green,
                 blue               => blue ,
                 hsync              => hsync,
                 vsync              => vsync);

END MSE;
