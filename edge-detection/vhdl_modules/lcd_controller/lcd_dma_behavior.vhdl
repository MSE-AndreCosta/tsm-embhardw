ARCHITECTURE MSE OF lcd_dma IS

   TYPE LCD_READ_TYPE IS (IDLE,WAITBUSY,INITREAD,WAITREAD,RELEASE);

   COMPONENT SendReceiveInterface IS
      PORT ( -- Here the internal interface is defined
             Clock            : IN  std_logic;
             Reset                 : IN  std_logic;
             ResetDisplay          : IN  std_logic;
             StartSendReceive      : IN  std_logic;
             CommandBarData        : IN  std_logic;
             EightBitSixteenBitBar : IN  std_logic;
             WriteReadBar          : IN  std_logic;
             DataToSend            : IN  std_logic_vector( 15 DOWNTO 0 );
             DataReceived          : OUT std_logic_vector( 15 DOWNTO 0 );
             busy                  : OUT std_logic;
             -- Here the external LCD-panel signals are defined
             ChipSelectBar         : OUT std_logic;
             DataCommandBar        : OUT std_logic;
             WriteBar              : OUT std_logic;
             ReadBar               : OUT std_logic;
             ResetBar              : OUT std_logic;
             IM0                   : OUT std_logic;
             DataBus               : INOUT std_logic_vector( 15 DOWNTO 0 ));
   END COMPONENT;
   
   COMPONENT dma_controller_lcd IS
      PORT ( -- Here the internal interface is defined
             Clock                  : IN  std_logic;
             Reset                       : IN  std_logic;
             Start                       : IN  std_logic;
             StartAddress                : IN  std_logic_vector(31 DOWNTO 2);
             BurstSize                   : IN  std_logic_vector( 7 DOWNTO 0);
             busy                        : OUT std_logic;
             empty                       : OUT std_logic;
             pop                         : IN  std_logic;
             DataOut                     : OUT std_logic_vector(31 DOWNTO 0);
             -- master avalon interface
             master_address              : OUT std_logic_vector(31 DOWNTO 0 );
             master_read                 : OUT std_logic;
             master_burst_count          : OUT std_logic_vector( 7 DOWNTO 0 );
             master_read_data            : IN  std_logic_vector(31 DOWNTO 0 );
             master_read_data_valid      : IN  std_logic;
             master_wait_request         : IN  std_logic);
   END COMPONENT;
   
   COMPONENT pixel_formatter IS
      PORT ( -- Here the internal interface is defined
             Clock                  : IN  std_logic;
             Reset                       : IN  std_logic;
             StartTransfer               : IN  std_logic;
             busy                        : OUT std_logic;
             GenerateIRQ                 : OUT std_logic;
             -- Here the register interface is defined
             ImageSize                   : IN  std_logic_vector(19 DOWNTO 0);
             ImagePointer                : IN  std_logic_vector(31 DOWNTO 2);
             ImageXSize                  : IN  std_logic_vector(11 DOWNTO 0);
             EightSixteenBar             : IN  std_logic;
             RGB888RGB565Bar             : IN  std_logic;
             GrayscaleColorBar           : IN  std_logic;
             -- Here the DMA-interface signals are defined
             StartDMA                    : OUT std_logic;
             DMAAddress                  : OUT std_logic_vector(31 DOWNTO 2);
             DMABusy                     : IN  std_logic;
             DMAFifoEmpty                : IN  std_logic;
             DMAFifoPop                  : OUT std_logic;
             DMAFifoDataIn               : IN  std_logic_vector(31 DOWNTO 0);
             -- Here the LCD-interface signals are defined
             LCDStartSendReceive         : OUT std_logic;
             LCDCommandBarData           : OUT std_logic;
             LCDWriteReadBar             : OUT std_logic;
             LCDDataToSend               : OUT std_logic_vector( 15 DOWNTO 0 );
             LCDBusy                     : IN  std_logic);
   END COMPONENT;
   
   SIGNAL s_WriteReadBar        : std_logic;
   SIGNAL s_StartSendReceive    : std_logic;
   SIGNAL s_CommandBarData      : std_logic;
   SIGNAL s_busy                : std_logic;
   SIGNAL s_control_reg         : std_logic_vector( 5 DOWNTO 0 );
   SIGNAL s_control_next        : std_logic_vector( 5 DOWNTO 0 );
   SIGNAL s_LCD_data_out        : std_logic_vector(15 DOWNTO 0 );
   SIGNAL s_LCD_data_in         : std_logic_vector(15 DOWNTO 0 );
   SIGNAL s_current_state       : LCD_READ_TYPE;
   SIGNAL s_next_state          : LCD_READ_TYPE;
   SIGNAL s_reset_display       : std_logic;
   SIGNAL s_picture_pointer_reg : std_logic_vector( 31 DOWNTO 2 );
   SIGNAL s_we_picture_pointer  : std_logic;
   SIGNAL s_picture_size_reg    : std_logic_vector( 31 DOWNTO 0 );
   SIGNAL s_we_picture_size     : std_logic;
   SIGNAL s_DMA_Start           : std_logic;
   SIGNAL s_DMA_StartAddress    : std_logic_vector(31 DOWNTO 2);
   SIGNAL s_DMA_busy            : std_logic;
   SIGNAL s_DMAe_busy           : std_logic;
   SIGNAL s_DMA_empty           : std_logic;
   SIGNAL s_DMA_pop             : std_logic;
   SIGNAL s_DMA_DataOut         : std_logic_vector(31 DOWNTO 0);
   SIGNAL s_start_DMA_cmd       : std_logic;
   SIGNAL s_start_DMA           : std_logic;
   SIGNAL s_pixel_start         : std_logic;
   SIGNAL s_pixel_data          : std_logic_vector( 15 DOWNTO 0 );
   SIGNAL s_pixel_cbd           : std_logic;
   SIGNAL s_pixel_wrb           : std_logic;
   SIGNAL s_gen_irq             : std_logic;
   SIGNAL s_irq_next            : std_logic;
   SIGNAL s_irq_reg             : std_logic;
   SIGNAL s_pixel_each_line_lcd : std_logic_vector( 8 DOWNTO 0 );
   SIGNAL s_we_pixel_ell        : std_logic;
   SIGNAL s_burst_size          : std_logic_vector( 7 DOWNTO 0 );
   SIGNAL s_ImageXSize_reg      : std_logic_vector(11 DOWNTO 0 );
   SIGNAL s_we_ImageXSize       : std_logic;

BEGIN
--------------------------------------------------------------------------------
---                                                                          ---
--- In this section the avalon slave signals are defined                     ---
---                                                                          ---
--------------------------------------------------------------------------------
   make_read_data : PROCESS( slave_address , s_control_reg , s_busy ,
                             s_picture_pointer_reg , s_picture_size_reg ,
                             s_pixel_each_line_lcd )
   BEGIN
      CASE (slave_address) IS
         WHEN "010"  => slave_read_data <= X"000000"&"0"&s_irq_reg&
                           s_control_reg(5 DOWNTO 3)&s_DMA_busy&s_busy&s_control_reg(0);
         WHEN "000" |
              "001"  => slave_read_data <= s_LCD_data_out&s_LCD_data_out;
         WHEN "011"  => slave_read_data <= s_picture_pointer_reg&"00";
         WHEN "100"  => slave_read_data <= s_picture_size_reg;
         WHEN "101"  => slave_read_data <= X"00000"&"000"&s_pixel_each_line_lcd;
         WHEN "110"  => slave_read_data <= X"00000"&s_ImageXSize_reg;
         WHEN OTHERS => slave_read_data <= (OTHERS => '0');
      END CASE;
   END PROCESS make_read_data;
    
    slave_wait_request <= '1' WHEN (slave_cs = '1' AND
                                    slave_address(2 DOWNTO 1) = "00" AND
                                    ((slave_we = '1' AND
                                      (s_busy = '1' OR
                                       s_DMA_busy = '1')) OR
                                     (slave_rd = '1' AND
                                      s_current_state /= RELEASE))) OR
                                    (s_start_DMA_cmd = '1' AND
                                     s_DMA_busy = '1') ELSE '0';

--------------------------------------------------------------------------------
---                                                                          ---
--- In this section the irq is handled                                       ---
---                                                                          ---
--------------------------------------------------------------------------------
   end_of_transaction_irq <= s_irq_reg;
   s_irq_next <= '1' WHEN s_gen_irq = '1' AND
                          s_control_reg(5) = '1' ELSE
                 '0' WHEN slave_cs = '1' AND
                          slave_address = "010" AND
                          slave_we = '1' AND
                          slave_write_data(9) = '1' ELSE
                 s_irq_reg;
   
   make_irq_reg : PROCESS( Clock )
   BEGIN
      IF (rising_edge(Clock)) THEN
         IF (Reset = '1') THEN s_irq_reg <= '0';
                          ELSE s_irq_reg <= s_irq_next;
         END IF;
      END IF;
   END PROCESS make_irq_reg;
   

--------------------------------------------------------------------------------
---                                                                          ---
--- In this section the LCD-read state machine is defined                    ---
---                                                                          ---
--------------------------------------------------------------------------------

   make_next_state : PROCESS( s_current_state , slave_cs , slave_address ,
                              slave_rd , s_busy , s_DMA_busy )
   BEGIN
      CASE (s_current_state) IS
         WHEN IDLE         => IF (slave_cs = '1' AND
                                  slave_address(2 DOWNTO 1) = "00" AND
                                  slave_rd = '1') THEN
                                 s_next_state <= WAITBUSY;
                                                  ELSE
                                 s_next_state <= IDLE;
                              END IF;
         WHEN WAITBUSY     => IF (s_busy = '1' OR
                                  s_DMA_busy = '1') THEN
                                 s_next_state <= WAITBUSY;
                                                ELSE
                                 s_next_state <= INITREAD;
                              END IF;
         WHEN INITREAD     => s_next_state <= WAITREAD;
         WHEN WAITREAD     => IF (s_busy = '1') THEN
                                 s_next_state <= WAITREAD;
                                                ELSE
                                 s_next_state <= RELEASE;
                              END IF;
         WHEN OTHERS       => s_next_state <= IDLE;
      END CASE;
   END PROCESS make_next_state;
   
   make_current_state : PROCESS( Clock )
   BEGIN
      IF (rising_edge(Clock)) THEN
         IF (Reset = '1') THEN s_current_state <= IDLE;
                          ELSE s_current_state <= s_next_state;
         END IF;
      END IF;
   END PROCESS make_current_state;

--------------------------------------------------------------------------------
---                                                                          ---
--- In this section the control register is defined                          ---
---                                                                          ---
--------------------------------------------------------------------------------
   s_control_next <= slave_write_data( 5 DOWNTO 0 ) WHEN slave_we = '1' AND
                                                         slave_cs = '1' AND
                                                         slave_address = "010" ELSE 
                     s_control_reg;
   s_we_pixel_ell  <= '1' WHEN slave_we = '1' AND
                               slave_cs = '1' AND
                               slave_address = "101" ELSE '0';
   s_we_ImageXSize <= '1' WHEN slave_we = '1' AND
                               slave_cs = '1' AND
                               slave_address = "110" ELSE '0';
   
   make_control_reg : PROCESS( Clock )
   BEGIN
      IF (rising_edge(Clock)) THEN
         IF (Reset = '1') THEN s_control_reg <= (OTHERS => '0');
                          ELSE s_control_reg <= s_control_next;
         END IF;
      END IF;
   END PROCESS make_control_reg;
   
   make_pointer_reg : PROCESS( Clock )
   BEGIN
      IF (rising_edge(Clock)) THEN
         IF (Reset = '1') THEN s_picture_pointer_reg <= (OTHERS => '0');
         ELSIF (s_we_picture_pointer = '1') THEN
            s_picture_pointer_reg <= slave_write_data( 31 DOWNTO 2 );
         END IF;
      END IF;
   END PROCESS make_pointer_reg;

   make_size_reg : PROCESS( Clock )
   BEGIN
      IF (rising_edge(Clock)) THEN
         IF (Reset = '1') THEN s_picture_size_reg <= (OTHERS => '0');
         ELSIF (s_we_picture_size = '1') THEN
            s_picture_size_reg <= slave_write_data;
         END IF;
      END IF;
   END PROCESS make_size_reg;
   
   make_pixel_each_line_lcd : PROCESS( Clock )
   BEGIN
      IF (rising_edge(Clock)) THEN
         IF (Reset = '1') THEN s_pixel_each_line_lcd <= (OTHERS => '0');
         ELSIF (s_we_pixel_ell = '1') THEN
            s_pixel_each_line_lcd <= slave_write_data( 8 DOWNTO 0);
         END IF;
      END IF;
   END PROCESS make_pixel_each_line_lcd;
   
   make_ImageXSize_reg : PROCESS( Clock )
   BEGIN
      IF (rising_edge(Clock)) THEN
         IF (Reset = '1') THEN s_ImageXSize_reg <= (OTHERS => '0');
         ELSIF (s_we_ImageXSize = '1') THEN 
            s_ImageXSize_reg <= slave_write_data(11 DOWNTO 0);
         END IF;
      END IF;
   END PROCESS make_ImageXSize_reg;

--------------------------------------------------------------------------------
---                                                                          ---
--- In this section all control signals are defined                          ---
---                                                                          ---
--------------------------------------------------------------------------------
   s_burst_size       <= s_pixel_each_line_lcd( 8 DOWNTO 1 ) 
                            WHEN s_control_reg(4) = '0' ELSE
                         "0"&s_pixel_each_line_lcd( 8 DOWNTO 2 );
   s_WriteReadBar     <= slave_we WHEN s_pixel_start = '0' ELSE
                         s_pixel_wrb;
   
   s_CommandBarData   <= slave_address(0) WHEN s_pixel_start = '0' ELSE
                         s_pixel_cbd;
   
   s_StartSendReceive <= '1' WHEN (slave_we = '1' AND
                                   slave_cs = '1' AND
                                   slave_address(2 DOWNTO 1) = "00" AND
                                   s_busy = '0') OR
                                  (s_current_state = INITREAD) OR
                                  (s_pixel_start = '1') ELSE '0';
   s_reset_display    <= '1' WHEN slave_we = '1' AND
                                  slave_cs = '1' AND
                                  slave_address = "010" AND
                                  slave_write_data(1) = '1' ELSE '0';
   s_we_picture_pointer <= '1' WHEN slave_we = '1' AND
                                    slave_cs = '1' AND
                                    slave_address = "011" ELSE '0';
   s_we_picture_size    <= '1' WHEN slave_we = '1' AND
                                    slave_cs = '1' AND
                                    slave_address = "100" ELSE '0';
   s_start_DMA_cmd      <= '1' WHEN slave_we = '1' AND
                                    slave_cs = '1' AND
                                    slave_address = "010" AND
                                    slave_write_data(8) = '1' ELSE '0';
   s_start_DMA          <= '1' WHEN s_start_DMA_cmd = '1' AND
                                    s_DMA_busy = '0' ELSE '0';

   s_LCD_data_in        <= slave_write_data(15 DOWNTO 0 ) 
                              WHEN s_pixel_start = '0' ELSE
                           s_pixel_data;
--------------------------------------------------------------------------------
---                                                                          ---
--- In this section all components are connected                             ---
---                                                                          ---
--------------------------------------------------------------------------------

   interface : SendReceiveInterface
      PORT MAP ( Clock                 => Clock,
                 Reset                 => Reset,
                 ResetDisplay          => s_reset_display,
                 StartSendReceive      => s_StartSendReceive,
                 CommandBarData        => s_CommandBarData,
                 EightBitSixteenBitBar => s_control_reg(0),
                 WriteReadBar          => s_WriteReadBar,
                 DataToSend            => s_LCD_data_in,
                 DataReceived          => s_LCD_data_out,
                 busy                  => s_busy,
                 -- Here the external LCD-panel signals are defined
                 ChipSelectBar         => ChipSelectBar        ,
                 DataCommandBar        => DataCommandBar       ,
                 WriteBar              => WriteBar             ,
                 ReadBar               => ReadBar              ,
                 ResetBar              => ResetBar             ,
                 IM0                   => IM0                  ,
                 DataBus               => DataBus              );
   dma : dma_controller_lcd
      PORT MAP ( Clock                       => Clock,
                 Reset                       => Reset,
                 Start                       => s_DMA_Start,
                 StartAddress                => s_DMA_StartAddress,
                 BurstSize                   => s_burst_size,
                 busy                        => s_DMAe_busy,
                 empty                       => s_DMA_empty,
                 pop                         => s_DMA_pop,
                 DataOut                     => s_DMA_DataOut,
                 -- master avalon interface
                 master_address              => master_address             ,
                 master_read                 => master_read                ,
                 master_burst_count          => master_burst_count         ,
                 master_read_data            => master_read_data           ,
                 master_read_data_valid      => master_read_data_valid     ,
                 master_wait_request         => master_wait_request        );

   formatter : pixel_formatter
      PORT MAP ( Clock                       => Clock,
                 Reset                       => Reset,
                 StartTransfer               => s_start_DMA,
                 Busy                        => s_DMA_busy,
                 GenerateIRQ                 => s_gen_irq,
                 -- Here the register interface is defined
                 ImageSize                   => s_picture_size_reg(19 DOWNTO 0),
                 ImagePointer                => s_picture_pointer_reg,
                 ImageXSize                  => s_ImageXSize_reg,
                 EightSixteenBar             => s_control_reg(0),
                 RGB888RGB565Bar             => s_control_reg(3),
                 GrayscaleColorBar           => s_control_reg(4),
                 -- Here the DMA-interface signals are defined
                 StartDMA                    => s_DMA_Start,
                 DMAAddress                  => s_DMA_StartAddress,
                 DMABusy                     => s_DMAe_busy,
                 DMAFifoEmpty                => s_DMA_empty,
                 DMAFifoPop                  => s_DMA_pop,
                 DMAFifoDataIn               => s_DMA_DataOut,
                 -- Here the LCD-interface signals are defined
                 LCDStartSendReceive         => s_pixel_start,
                 LCDCommandBarData           => s_pixel_cbd,
                 LCDWriteReadBar             => s_pixel_wrb,
                 LCDDataToSend               => s_pixel_data,
                 LCDBusy                     => s_busy);

END MSE;
