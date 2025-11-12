ARCHITECTURE MSE OF SendReceiveInterface IS

   TYPE CONTROLSTATETYPE IS (IDLE,CLOCKDATAOUT,WRITELOW1,WRITELOW2,
                             INITREAD,WAITREADLOW,READCLOCK,READHI1,READHI2,
                             READHI3,READHI4);
   TYPE RESETSTATETYPE IS (NOOP,ACTIVATERESET,WAITRESET,
                           ACTIVATERECOVER,WAITRECOVER);
   
   SIGNAL s_current_state , s_next_state  : CONTROLSTATETYPE;
   SIGNAL s_IM0_current , s_IM0_next      : std_logic;
   SIGNAL s_data_out_reg, s_data_out_next : std_logic_vector( 15 DOWNTO 0 );
   SIGNAL s_read_del_reg, s_read_del_next : unsigned( 4 DOWNTO 0 );
   SIGNAL s_read_del_zero                 : std_logic;
   SIGNAL s_received_data_next            : std_logic_vector( 15 DOWNTO 0 );
   SIGNAL s_tri_bus_reg,s_tri_bus_next    : std_logic;
   SIGNAL s_current_reset,s_next_reset    : RESETSTATETYPE;
   SIGNAL s_reset_counter_reg             : unsigned( 23 DOWNTO 0 );
   SIGNAL s_reset_counter_next            : unsigned( 23 DOWNTO 0 );
   SIGNAL s_reset_counter_zero            : std_logic;
   SIGNAL s_chip_select_bar_next          : std_logic;
   SIGNAL s_reset_bar_next                : std_logic;

BEGIN

--------------------------------------------------------------------------------
---                                                                          ---
--- In this section all the external LCD-panel signals are assigned          ---
---                                                                          ---
--------------------------------------------------------------------------------

   ---*** ChipSelectBar ***---
   s_chip_select_bar_next <= '1' WHEN Reset = '1' OR
                                      s_current_reset /= NOOP ELSE '0';
   make_chip_select : PROCESS( Clock )
   BEGIN
      IF (rising_edge(Clock)) THEN
         ChipSelectBar <= s_chip_select_bar_next;
      END IF;
   END PROCESS make_chip_select;
   
   ---*** DataCommandBar ***---
   make_data_command_bar : PROCESS( Clock )
   BEGIN
      IF (rising_edge(Clock)) THEN
         IF (Reset = '1') THEN DataCommandBar <= '0';
         ELSIF (StartSendReceive = '1') THEN 
            DataCommandBar <= CommandBarData;
         END IF;
      END IF;
   END PROCESS make_data_command_bar;
   
   ---*** WriteBar ***---
   make_write_bar : PROCESS( Clock )
   BEGIN
      IF (rising_edge(Clock)) THEN
         IF (s_current_state = WRITELOW1 OR
             s_current_state = WRITELOW2) THEN
            WriteBar <= '0';
                                          ELSE
            WriteBar <= '1';
         END IF;
      END IF;
   END PROCESS make_write_bar;
   
   ---*** ReadBar ***---
   make_read_bar : PROCESS( Clock )
   BEGIN
      IF (rising_edge(Clock)) THEN
         IF (s_current_state = WAITREADLOW) THEN
            ReadBar <= '0';
                                            ELSE
            ReadBar <= '1';
         END IF;
      END IF;
   END PROCESS make_read_bar;
   
   ---*** ResetBar ***---
   s_reset_bar_next <= '0' WHEN s_current_reset = WAITRESET ELSE '1';
   make_reset_bar : PROCESS( Clock )
   BEGIN
      IF (rising_edge(Clock)) THEN
         ResetBar <= s_reset_bar_next;
      END IF;
   END PROCESS make_reset_bar;
   
   ---*** IM0 ***---
   IM0 <= s_IM0_current;
   s_IM0_next <= EightBitSixteenBitBar 
                    WHEN StartSendReceive = '1' ELSE
                 s_IM0_current;
   
   make_IM0_current : PROCESS( Clock )
   BEGIN
      IF (rising_edge(Clock)) THEN
         IF (Reset = '1') THEN s_IM0_current <= '0';
                          ELSE s_IM0_current <= s_IM0_next;
         END IF;
      END IF;
   END PROCESS make_IM0_current;
   
   ---*** DataBus ***---
   s_data_out_next <= s_data_out_reg WHEN StartSendReceive = '0' OR
                                          WriteReadBar = '0' ELSE
                      DataToSend(7 DOWNTO 0)&X"00" WHEN EightBitSixteenBitBar = '1' ELSE
                      DataToSend;
                      
   make_data_out_reg : PROCESS( Clock )
   BEGIN
      IF (rising_edge(Clock)) THEN
         IF (Reset = '1') THEN s_data_out_reg <= (OTHERS => '0');
                          ELSE s_data_out_reg <= s_data_out_next;
         END IF;
      END IF;
   END PROCESS make_data_out_reg;
   
   s_tri_bus_next <= '1' WHEN s_current_state = INITREAD OR
                              s_current_state = WAITREADLOW OR
                              s_current_state = READHI1 OR
                              s_current_state = READHI2 OR
                              s_current_state = READHI3 OR
                              s_current_state = READHI4 ELSE '0';

   make_tri_bus_reg : PROCESS( Clock )
   BEGIN
      IF (rising_edge(Clock)) THEN
         s_tri_bus_reg <= s_tri_bus_next;
      END IF;
   END PROCESS make_tri_bus_reg;
   
   DataBus <= s_data_out_reg WHEN s_tri_bus_reg = '0' ELSE (OTHERS => 'Z');
   
--------------------------------------------------------------------------------
---                                                                          ---
--- In this section The reset state machine is defined                       ---
---                                                                          ---
--------------------------------------------------------------------------------
   s_reset_counter_next <= to_unsigned(1199,24) 
                              WHEN s_current_reset = ACTIVATERESET ELSE
                           to_unsigned(11999999,24)
                              WHEN s_current_reset = ACTIVATERECOVER ELSE
                           s_reset_counter_reg-1
                              WHEN s_reset_counter_zero = '0' ELSE
                           s_reset_counter_reg;
   s_reset_counter_zero <= '1' WHEN s_reset_counter_reg = 
                                    to_unsigned(0,24) ELSE '0';
   
   make_reset_counter : PROCESS( Clock )
   BEGIN
      IF (rising_edge(Clock)) THEN
         s_reset_counter_reg <= s_reset_counter_next;
      END IF;
   END PROCESS make_reset_counter;
   
   make_reset_state_next : PROCESS( s_current_reset , s_reset_counter_zero ,
                                    ResetDisplay )
   BEGIN
      CASE( s_current_reset ) IS
         WHEN NOOP                  => IF (ResetDisplay = '1') THEN
                                          s_next_reset <= ACTIVATERESET;
                                                               ELSE
                                          s_next_reset <= NOOP;
                                       END IF;
         WHEN ACTIVATERESET         => IF (s_current_state /= IDLE) THEN
                                          s_next_reset <= ACTIVATERESET;
                                                                    ELSE
                                          s_next_reset <= WAITRESET;
                                       END IF;
         WHEN WAITRESET             => IF (s_reset_counter_zero = '1') THEN
                                          s_next_reset <= ACTIVATERECOVER;
                                                                       ELSE
                                          s_next_reset <= WAITRESET;
                                       END IF;
         WHEN ACTIVATERECOVER       => s_next_reset <= WAITRECOVER;
         WHEN WAITRECOVER           => IF (s_reset_counter_zero = '1') THEN
                                          s_next_reset <= NOOP;
                                                                       ELSE
                                          s_next_reset <= WAITRECOVER;
                                       END IF;
         WHEN OTHERS                => s_next_reset <= NOOP;
      END CASE;
   END PROCESS make_reset_state_next;
   
   make_reset_state : PROCESS( Clock )
   BEGIN
      IF (rising_edge(Clock)) THEN
         IF (Reset = '1') THEN s_current_reset <= ACTIVATERESET;
                          ELSE s_current_reset <= s_next_reset;
         END IF;
      END IF;
   END PROCESS make_reset_state;

--------------------------------------------------------------------------------
---                                                                          ---
--- In this section The controlling state machine is defined                 ---
---                                                                          ---
--------------------------------------------------------------------------------
   busy <= '0' WHEN s_current_state = IDLE AND
                    s_current_reset = NOOP ELSE '1';

   update_logic : PROCESS( s_current_state, StartSendReceive,
                           WriteReadBar , s_read_del_zero )
   BEGIN
      CASE (s_current_state) IS
         WHEN IDLE         => IF (StartSendReceive = '1' AND
                                  s_current_reset = NOOP) THEN
                                 IF (WriteReadBar = '1') THEN
                                    s_next_state <= CLOCKDATAOUT;
                                                         ELSE
                                    s_next_state <= INITREAD;
                                 END IF;
                                                          ELSE
                                 s_next_state <= IDLE;
                              END IF;
         WHEN CLOCKDATAOUT => s_next_state <= WRITELOW1;
         WHEN WRITELOW1    => s_next_state <= WRITELOW2;
         WHEN INITREAD     => s_next_state <= WAITREADLOW;
         WHEN WAITREADLOW  => IF (s_read_del_zero = '1') THEN
                                 s_next_state <= READHI1;
                                                         ELSE
                                 s_next_state <= WAITREADLOW;
                              END IF;
         WHEN READHI1      => s_next_state <= READHI2;
         WHEN READHI2      => s_next_state <= READHI3;
         WHEN READHI3      => s_next_state <= READHI4;
         WHEN OTHERS       => s_next_state <= IDLE;
      END CASE;
   END PROCESS update_logic;

   state_mem : PROCESS( Clock )
   BEGIN
      IF (rising_edge(Clock)) THEN
         IF (Reset = '1') THEN s_current_state <= IDLE;
                          ELSE s_current_state <= s_next_state;
         END IF;
      END IF;
   END PROCESS state_mem;
   
   s_read_del_zero <= '1' WHEN s_read_del_reg = to_unsigned(0,5) ELSE '0';
   s_read_del_next <= to_unsigned(17,5) WHEN s_current_state = INITREAD ELSE
                      s_read_del_reg-1 WHEN s_read_del_zero = '0' ELSE
                      s_read_del_reg;

   make_read_del_reg : PROCESS( Clock )
   BEGIN
      IF (rising_edge(Clock)) THEN
         IF (Reset = '1') THEN s_read_del_reg <= (OTHERS => '0');
                          ELSE s_read_del_reg <= s_read_del_next;
         END IF;
      END IF;
   END PROCESS make_read_del_reg;
   
--------------------------------------------------------------------------------
---                                                                          ---
--- In this section The output register is defined                           ---
---                                                                          ---
--------------------------------------------------------------------------------
   s_received_data_next <= X"00"&DataBus(15 DOWNTO 8) 
                              WHEN EightBitSixteenBitBar = '1' ELSE
                           DataBus;
   make_data_received : PROCESS( Clock )
   BEGIN
      IF (rising_edge(Clock)) THEN
         IF (Reset = '1') THEN DataReceived <= (OTHERS => '0');
         ELSIF (s_current_state = READHI1) THEN
            DataReceived <= s_received_data_next;
         END IF;
      END IF;
   END PROCESS make_data_received;

END MSE;
