ARCHITECTURE MSE OF pixel_formatter IS

   TYPE CONTROLSTATETYPE IS (IDLE,WAITLCDBUSY,SENDCOMMAND,WAITCOMMAND,
                             WAITEMPTY,SENDSHORT1,WAITSHORT1,
                             SENDSHORT2,WAITSHORT2,POP,CHECKBUSY,
                             STARTDMATRANS,WAITDMABUSY,GENIRQ,
                             SENDGRAY1,WAITGRAY1,SENDGRAY2,WAITGRAY2,
                             SENDGRAY3,WAITGRAY3,SENDGRAY4,WAITGRAY4);
   SIGNAL s_current_state , s_next_state : CONTROLSTATETYPE;
   SIGNAL s_current_address_reg          : unsigned(31 DOWNTO 2);
   SIGNAL s_current_address_next         : unsigned(31 DOWNTO 2);
   SIGNAL s_address_increment            : unsigned(31 DOWNTO 2);
   SIGNAL s_pixel_counter_reg            : unsigned(20 DOWNTO 0);
   SIGNAL s_pixel_counter_next           : unsigned(20 DOWNTO 0);

BEGIN
--------------------------------------------------------------------------------
---                                                                          ---
--- In this section the pixel counter is defined                             ---
---                                                                          ---
--------------------------------------------------------------------------------
   Busy        <= '0' WHEN s_current_state = IDLE ELSE '1';
   GenerateIrq <= '1' WHEN s_current_state = GENIRQ ELSE '0';
   
--------------------------------------------------------------------------------
---                                                                          ---
--- In this section the pixel counter is defined                             ---
---                                                                          ---
--------------------------------------------------------------------------------
   s_pixel_counter_next <= unsigned("0"&ImageSize)-1 WHEN StartTransfer = '1' ELSE
                           s_pixel_counter_reg-1
                              WHEN s_current_state = SENDSHORT1 OR
                                   s_current_state = SENDSHORT2 OR
                                   s_current_state = SENDGRAY1 OR
                                   s_current_state = SENDGRAY2 OR
                                   s_current_state = SENDGRAY3 OR
                                   s_current_state = SENDGRAY4 ELSE
                           s_pixel_counter_reg;
   
   make_pixel_counter : PROCESS( Clock )
   BEGIN
      IF (rising_edge(Clock)) THEN
         IF (Reset = '1') THEN s_pixel_counter_reg <= (OTHERS => '0');
                          ELSE s_pixel_counter_reg <= s_pixel_counter_next;
         END IF;
      END IF;
   END PROCESS make_pixel_counter;

--------------------------------------------------------------------------------
---                                                                          ---
--- In this section the LCD-control signals are defined                      ---
---                                                                          ---
--------------------------------------------------------------------------------
   LCDStartSendReceive <= '1' WHEN s_current_state = SENDCOMMAND OR
                                   s_current_state = SENDSHORT1 OR
                                   s_current_state = SENDSHORT2 OR
                                   s_current_state = SENDGRAY1 OR
                                   s_current_state = SENDGRAY2 OR
                                   s_current_state = SENDGRAY3 OR
                                   s_current_state = SENDGRAY4 ELSE '0';
   LCDCommandBarData   <= '0' WHEN s_current_state = SENDCOMMAND OR
                                   s_current_state = IDLE ELSE '1';
   LCDWriteReadBar     <= '0' WHEN s_current_state = IDLE ELSE '1';
   
   make_lcd_data : PROCESS( s_current_state , DMAFifoDataIn )
   BEGIN
      CASE (s_current_state) IS
         WHEN SENDCOMMAND        => LCDDataToSend <= X"002C";
         WHEN SENDSHORT1         => LCDDataToSend <= DMAFifoDataIn(15 DOWNTO  0);
         WHEN SENDSHORT2         => LCDDataToSend <= DMAFifoDataIn(31 DOWNTO 16);
         WHEN SENDGRAY1          => LCDDataToSend <= DMAFifoDataIn(7 DOWNTO 3)&
                                                     DMAFifoDataIn(7 DOWNTO 2)&
                                                     DMAFifoDataIn(7 DOWNTO 3);
         WHEN SENDGRAY2          => LCDDataToSend <= DMAFifoDataIn(15 DOWNTO 11)&
                                                     DMAFifoDataIn(15 DOWNTO 10)&
                                                     DMAFifoDataIn(15 DOWNTO 11);
         WHEN SENDGRAY3          => LCDDataToSend <= DMAFifoDataIn(23 DOWNTO 19)&
                                                     DMAFifoDataIn(23 DOWNTO 18)&
                                                     DMAFifoDataIn(23 DOWNTO 19);
         WHEN SENDGRAY4          => LCDDataToSend <= DMAFifoDataIn(31 DOWNTO 27)&
                                                     DMAFifoDataIn(31 DOWNTO 26)&
                                                     DMAFifoDataIn(31 DOWNTO 27);
         WHEN OTHERS             => LCDDataToSend <= X"0000";
      END CASE;
   END PROCESS make_lcd_data;

--------------------------------------------------------------------------------
---                                                                          ---
--- In this section the DMA-control signals are defined                      ---
---                                                                          ---
--------------------------------------------------------------------------------
   StartDMA    <= '1' WHEN s_current_state = SENDCOMMAND OR
                           s_current_state = STARTDMATRANS ELSE '0';
   DMAFifoPop  <= '1' WHEN s_current_state = POP ELSE '0';
   DMAAddress  <= std_logic_vector(s_current_address_reg);
   s_address_increment <= unsigned(X"0000"&"000"&ImageXSize(11 DOWNTO 1))
                             WHEN GrayscaleColorBar = '0' ELSE
                          unsigned(X"00000"&ImageXSize(11 DOWNTO 2)); 
   
   s_current_address_next <= unsigned(ImagePointer) WHEN StartTransfer = '1' ELSE
                             s_current_address_reg+s_address_increment
                                WHEN s_current_state = SENDCOMMAND OR
                                     s_current_state = STARTDMATRANS ELSE
                             s_current_address_reg;
   
   make_current_address : PROCESS( Clock )
   BEGIN
      IF (rising_edge(Clock)) THEN
         IF (Reset = '1') THEN s_current_address_reg <= (OTHERS => '0');
                          ELSE s_current_address_reg <= s_current_address_next;
         END IF;
      END IF;
   END PROCESS make_current_address;

--------------------------------------------------------------------------------
---                                                                          ---
--- In this section the state machine is defined                             ---
---                                                                          ---
--------------------------------------------------------------------------------

   make_next_state : PROCESS( s_current_state , StartTransfer , LCDBusy ,
                              DMAFifoEmpty, GrayscaleColorBar, RGB888RGB565Bar,
                              EightSixteenBar, DMABusy)
      VARIABLE v_config : std_logic_vector( 2 DOWNTO 0 );
   BEGIN
      v_config := GrayscaleColorBar&RGB888RGB565Bar&EightSixteenBar;
      CASE (s_current_state) IS
         WHEN IDLE         => IF (StartTransfer = '1') THEN
                                 s_next_state <= WAITLCDBUSY;
                                                       ELSE
                                 s_next_state <= IDLE;
                              END IF;
         WHEN WAITLCDBUSY  => IF (LCDBusy = '1') THEN
                                 s_next_state <= WAITLCDBUSY;
                                                 ELSE
                                 s_next_state <= SENDCOMMAND;
                              END IF;
         WHEN SENDCOMMAND  => s_next_state <= WAITCOMMAND;
         WHEN WAITCOMMAND  => IF (LCDBusy = '1') THEN
                                 s_next_state <= WAITCOMMAND;
                                                 ELSE
                                 s_next_state <= WAITEMPTY;
                              END IF;
         WHEN WAITEMPTY    => IF (DMAFifoEmpty = '1') THEN
                                 s_next_state <= WAITEMPTY;
                                                      ELSE
                                 CASE (v_config) IS
                                    WHEN "000"  => s_next_state <= SENDSHORT1;
                                    WHEN "100" |
                                         "110"  => s_next_state <= SENDGRAY1;
                                    WHEN OTHERS => s_next_state <= IDLE;
                                 END CASE;
                              END IF;
         WHEN SENDSHORT1   => s_next_state <= WAITSHORT1;
         WHEN WAITSHORT1   => IF (LCDBusy = '1') THEN 
                                 s_next_state <= WAITSHORT1;
                              ELSIF (s_pixel_counter_reg(20) = '1') THEN
                                 s_next_state <= WAITDMABUSY;
                                                                    ELSE
                                 s_next_state <= SENDSHORT2;
                              END IF;
         WHEN SENDSHORT2   => s_next_state <= WAITSHORT2;
         WHEN WAITSHORT2   => IF (LCDBusy = '1') THEN 
                                 s_next_state <= WAITSHORT2;
                              ELSIF (s_pixel_counter_reg(20) = '1') THEN
                                 s_next_state <= WAITDMABUSY;
                                                                    ELSE
                                 s_next_state <= POP;
                              END IF;
         WHEN SENDGRAY1    => s_next_state <= WAITGRAY1;
         WHEN WAITGRAY1    => IF (LCDBusy = '1') THEN 
                                 s_next_state <= WAITGRAY1;
                              ELSIF (s_pixel_counter_reg(20) = '1') THEN
                                 s_next_state <= WAITDMABUSY;
                                                                    ELSE
                                 s_next_state <= SENDGRAY2;
                              END IF;
         WHEN SENDGRAY2    => s_next_state <= WAITGRAY2;
         WHEN WAITGRAY2    => IF (LCDBusy = '1') THEN 
                                 s_next_state <= WAITGRAY2;
                              ELSIF (s_pixel_counter_reg(20) = '1') THEN
                                 s_next_state <= WAITDMABUSY;
                                                                    ELSE
                                 s_next_state <= SENDGRAY3;
                              END IF;
         WHEN SENDGRAY3    => s_next_state <= WAITGRAY3;
         WHEN WAITGRAY3    => IF (LCDBusy = '1') THEN 
                                 s_next_state <= WAITGRAY3;
                              ELSIF (s_pixel_counter_reg(20) = '1') THEN
                                 s_next_state <= WAITDMABUSY;
                                                                    ELSE
                                 s_next_state <= SENDGRAY4;
                              END IF;
         WHEN SENDGRAY4    => s_next_state <= WAITGRAY4;
         WHEN WAITGRAY4    => IF (LCDBusy = '1') THEN 
                                 s_next_state <= WAITGRAY4;
                              ELSIF (s_pixel_counter_reg(20) = '1') THEN
                                 s_next_state <= WAITDMABUSY;
                                                                    ELSE
                                 s_next_state <= POP;
                              END IF;
         WHEN POP          => s_next_state <= CHECKBUSY;
         WHEN CHECKBUSY    => IF (DMAFifoEmpty = '1' AND
                                  DMABusy = '0') THEN
                                 s_next_state <= STARTDMATRANS;
                                                 ELSE
                                 s_next_state <= WAITEMPTY;
                              END IF;
         WHEN STARTDMATRANS=> s_next_state <= WAITEMPTY;
         WHEN WAITDMABUSY  => IF (DMABusy = '1') THEN
                                 s_next_state <= WAITDMABUSY;
                                                 ELSE
                                 s_next_state <= GENIRQ;
                              END IF;
         WHEN OTHERS       => s_next_state <= IDLE;
      END CASE;
   END PROCESS make_next_state;
   
   make_state_reg : PROCESS( Clock )
   BEGIN
      IF (rising_edge(Clock)) THEN
         IF (Reset = '1') THEN s_current_state <= IDLE;
                          ELSE s_current_state <= s_next_state;
         END IF;
      END IF;
   END PROCESS make_state_reg;
END MSE;
