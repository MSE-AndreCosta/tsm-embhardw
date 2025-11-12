ARCHITECTURE simple OF i2c_cntrl IS

COMPONENT i2c_start_stop
   PORT ( clock        : IN  std_logic;
          reset        : IN  std_logic;
          tick         : IN  std_logic;
          activate     : IN  std_logic;
          idle_state   : OUT std_logic;
          active_state : OUT std_logic;
          SDA          : OUT std_logic;
          SCL          : OUT std_logic);
END COMPONENT;

COMPONENT i2c_data
   PORT ( clock      : IN  std_logic;
          reset      : IN  std_logic;
          tick       : IN  std_logic;
          data_in    : IN  std_logic_vector( 7 DOWNTO 0 );
          start      : IN  std_logic;
          ack_bit    : IN  std_logic;
          data_out   : OUT std_logic_vector( 7 DOWNTO 0 );
          idle       : OUT std_logic;
          SDA_out    : OUT std_logic;
          SDA_in     : IN  std_logic;
          SCL        : OUT std_logic;
          ACK_ERROR  : OUT std_logic );
END COMPONENT;

TYPE STATE_TYPE IS ( IDLE,SCND,WSCND,DID,WDID,ADR,WADR,ADR1,WADR1,DAT,WDAT,
                     DAT1,WDAT1,DAT2,WDAT2,DAT3,WDAT3,SSCND,WSSCND );

SIGNAL s_current_state , s_next_state : STATE_TYPE;
SIGNAL s_tick_counter                 : std_logic_vector( 4 DOWNTO 0 );
SIGNAL s_prescale_counter             : std_logic_vector( 7 DOWNTO 0 );
SIGNAL s_tick_pulse                   : std_logic;
SIGNAL s_activate                     : std_logic;
SIGNAL s_idle_state                   : std_logic;
SIGNAL s_active_state                 : std_logic;
SIGNAL s_sda1,s_sda2,s_scl1,s_scl2    : std_logic;
SIGNAL s_data                         : std_logic_vector( 7 DOWNTO 0 );
SIGNAL s_start_dat                    : std_logic;
SIGNAL s_dat_idle                     : std_logic;
SIGNAL s_sda_reg,s_scl_reg            : std_logic;
SIGNAL s_ack_error                    : std_logic;
SIGNAL s_ack_errors_reg               : std_logic_vector( 2 DOWNTO 0 );
SIGNAL s_ack_bit                      : std_logic;
SIGNAL s_i2c_data                     : std_logic_vector( 7 DOWNTO 0 );
SIGNAL s_data_reg_1                   : std_logic_vector( 7 DOWNTO 0 );
SIGNAL s_data_reg_2                   : std_logic_vector( 7 DOWNTO 0 );
SIGNAL s_data_reg_3                   : std_logic_vector( 7 DOWNTO 0 );
SIGNAL s_data_reg_4                   : std_logic_vector( 7 DOWNTO 0 );

BEGIN

-- make sda and scl
   make_reg : PROCESS( clock )
   BEGIN
      IF (rising_edge(clock)) THEN
         s_sda_reg <= s_sda1 OR s_sda2;
         s_scl_reg <= s_scl1 OR s_scl2;
      END IF;
   END PROCESS make_reg;
   
   SDA_out    <= s_sda_reg;
   SCL        <= s_scl_reg;
   ACK_ERRORs <= s_ack_errors_reg;
   data_out   <= s_data_reg_4&s_data_reg_3&s_data_reg_2&s_data_reg_1;

-- Make tick counter
   make_counter : PROCESS( clock , reset )
   BEGIN
      IF (rising_edge(clock)) THEN
         IF (reset = '1') THEN s_tick_counter <= (OTHERS => '1');
         ELSIF (s_prescale_counter = X"00") THEN
            s_tick_counter <= std_logic_vector(unsigned(s_tick_counter)-1);
         END IF;
      END IF;
   END PROCESS make_counter;
   
   make_prescale_counter : PROCESS( clock , reset , prescale )
   BEGIN
      IF (rising_edge(clock)) THEN
         IF (reset = '1') THEN s_prescale_counter <= (OTHERS => '0');
         ELSIF (s_prescale_counter = X"00") THEN
            s_prescale_counter <= prescale;
                                            ELSE
            s_prescale_counter <= std_logic_vector(unsigned(s_prescale_counter)- 1);
         END IF;
      END IF;
   END PROCESS make_prescale_counter;
   
   s_tick_pulse <= '1' WHEN s_tick_counter = "00000" AND
                            s_prescale_counter = X"00" ELSE '0';
   
-- Make state machine
   make_next_state : PROCESS( s_current_state , start , s_active_state,
                              s_idle_state , s_dat_idle , four_data )
   BEGIN
      CASE (s_current_state) IS
         WHEN IDLE      => IF (start = '1') THEN s_next_state <= SCND;
                                            ELSE s_next_state <= IDLE;
                           END IF;
         WHEN SCND      => s_next_state <= WSCND;
         WHEN WSCND     => IF (s_active_state = '1') THEN s_next_state <= DID;
                                                     ELSE s_next_state <= WSCND;
                           END IF;
         WHEN DID       => s_next_state <= WDID;
         WHEN WDID      => IF (s_dat_idle = '1') THEN 
                              IF (short_tran = '1') THEN s_next_state <= ADR1;
                                                    ELSE s_next_state <= ADR;
                              END IF;
                                                 ELSE s_next_state <= WDID;
                           END IF;
         WHEN ADR1      => s_next_state <= WADR1;
         WHEN WADR1     => IF (s_dat_idle = '1') THEN
                              s_next_state <= ADR;
                                                 ELSE
                              s_next_state <= WADR1;
                           END IF;
         WHEN ADR       => s_next_state <= WADR;
         WHEN WADR      => IF (s_dat_idle = '1') THEN 
                              IF (two_phase = '1' OR
                                  (device_id(0) = '1' AND
                                   four_data = '0')) THEN s_next_state <= SSCND;
                              ELSIF (short_tran = '1') THEN s_next_state <= DAT1;
                                                       ELSE s_next_state <= DAT;
                              END IF;
                                                 ELSE s_next_state <= WADR;
                           END IF;
         WHEN DAT1      => s_next_state <= WDAT1;
         WHEN WDAT1     => IF (s_dat_idle = '1') THEN s_next_state <= DAT;
                                                 ELSE s_next_state <= WDAT1;
                           END IF;
         WHEN DAT       => s_next_state <= WDAT;
         WHEN WDAT      => IF (s_dat_idle = '1') THEN 
                              IF (four_data = '1') THEN s_next_state <= DAT2;
                                                   ELSE s_next_state <= SSCND;
                              END IF;
                                                 ELSE s_next_state <= WDAT;
                           END IF;
         WHEN DAT2      => s_next_state <= WDAT2;
         WHEN WDAT2     => IF (s_dat_idle = '1') THEN s_next_state <= DAT3;
                                                 ELSE s_next_state <= WDAT2;
                           END IF;
         WHEN DAT3      => s_next_state <= WDAT3;
         WHEN WDAT3     => IF (s_dat_idle = '1') THEN s_next_state <= SSCND;
                                                 ELSE s_next_state <= WDAT3;
                           END IF;
         WHEN SSCND     => s_next_state <= WSSCND;
         WHEN WSSCND    => IF (s_idle_state = '1') THEN s_next_state <= IDLE;
                                                   ELSE s_next_state <= WSSCND;
                           END IF;
         WHEN OTHERS    => s_next_state <= IDLE;
      END CASE;
   END PROCESS make_next_state;
   
   make_state_reg : PROCESS( clock , reset )
   BEGIN
      IF (rising_edge(clock)) THEN 
         IF (reset = '1') THEN s_current_state <= IDLE;
                          ELSE s_current_state <= s_next_state;
         END IF;
      END IF;
   END PROCESS make_state_reg;
   
-- Make data regs
   data_reg_1 : PROCESS( clock )
   BEGIN
      IF (rising_edge(clock)) THEN
         IF (reset = '1') THEN s_data_reg_1 <= (OTHERS => '0');
         ELSIF (s_current_state = WADR AND
                s_dat_idle = '1' AND
                device_id(0) = '1') THEN s_data_reg_1 <= s_i2c_data;
         END IF;
      END IF;
   END PROCESS data_reg_1;

   data_reg_2 : PROCESS( clock )
   BEGIN
      IF (rising_edge(clock)) THEN
         IF (reset = '1') THEN s_data_reg_2 <= (OTHERS => '0');
         ELSIF (s_current_state = WDAT AND
                s_dat_idle = '1' AND
                device_id(0) = '1') THEN s_data_reg_2 <= s_i2c_data;
         END IF;
      END IF;
   END PROCESS data_reg_2;

   data_reg_3 : PROCESS( clock )
   BEGIN
      IF (rising_edge(clock)) THEN
         IF (reset = '1') THEN s_data_reg_3 <= (OTHERS => '0');
         ELSIF (s_current_state = WDAT2 AND
                s_dat_idle = '1' AND
                device_id(0) = '1') THEN s_data_reg_3 <= s_i2c_data;
         END IF;
      END IF;
   END PROCESS data_reg_3;

   data_reg_4 : PROCESS( clock )
   BEGIN
      IF (rising_edge(clock)) THEN
         IF (reset = '1') THEN s_data_reg_4 <= (OTHERS => '0');
         ELSIF (s_current_state = WDAT3 AND
                s_dat_idle = '1' AND
                device_id(0) = '1') THEN s_data_reg_4 <= s_i2c_data;
         END IF;
      END IF;
   END PROCESS data_reg_4;

-- Map signals
   make_data : PROCESS( s_current_state )
   BEGIN
      CASE (s_current_state) IS
         WHEN ADR       => IF (device_id(0) = '1') THEN
                              s_data <= X"FF";
                                                   ELSE
                              s_data <= address(7 DOWNTO 0);
                           END IF;
         WHEN ADR1      => s_data <= address(15 DOWNTO 8);
         WHEN DAT       => IF (device_id(0) = '1') THEN
                              s_data <= X"FF";
                                                   ELSE
                              s_data <= data(7 DOWNTO 0);
                           END IF;
         WHEN DAT1      => s_data <= data(15 DOWNTO 8);
         WHEN DAT2 |
              DAT3      => s_data <= X"FF";
         WHEN OTHERS    => s_data <= device_id;
      END CASE;
   END PROCESS make_data;
   s_activate <= '1' WHEN s_current_state = SCND OR
                          s_current_state = SSCND ELSE '0';
   s_start_dat<= '1' WHEN s_current_state = DID OR
                          s_current_state = ADR OR
                          s_current_state = ADR1 OR
                          s_current_state = DAT OR
                          s_current_state = DAT1 OR
                          s_current_state = DAT2 OR
                          s_current_state = DAT3 ELSE '0';
   busy       <= '0' WHEN s_current_state = IDLE ELSE '1';
   s_ack_bit  <= '0' WHEN (s_current_state = ADR OR
                           s_current_state = DAT OR
                           s_current_state = DAT2)
                          AND
                          four_data = '1' AND
                          device_id(0) = '1' ELSE '1';
   
-- Define Ack errors
   make_ack_errors : PROCESS( clock , reset , start ,
                              s_current_state , s_ack_error )
   BEGIN
      IF (rising_edge(clock)) THEN
         IF (start = '1' OR
             reset = '1') THEN s_ack_errors_reg <= "000";
                          ELSE
            IF (s_current_state = ADR OR
                s_current_state = ADR1) THEN s_ack_errors_reg(0) <= s_ack_error;
            END IF;
            IF (s_current_state = DAT OR
                (s_current_state = SSCND AND 
                 (two_phase = '1' OR device_id(0) = '1'))) THEN
               s_ack_errors_reg(1) <= s_ack_error;
            END IF;
            IF (s_current_state = SSCND AND 
                two_phase = '0' AND device_id(0) = '0') THEN
               s_ack_errors_reg(2) <= s_ack_error;
            END IF;
         END IF;
      END IF;
   END PROCESS make_ack_errors;
   
-- Map components
   start_stop_gen : i2c_start_stop
      PORT MAP ( clock        => clock,
                 reset        => reset,
                 tick         => s_tick_pulse,
                 activate     => s_activate,
                 idle_state   => s_idle_state,
                 active_state => s_active_state,
                 SDA          => s_sda1,
                 SCL          => s_scl1);

   data_gen : i2c_data
      PORT MAP ( clock      => clock,
                 reset      => reset,
                 tick       => s_tick_pulse,
                 data_in    => s_data,
                 start      => s_start_dat,
                 ack_bit    => s_ack_bit,
                 data_out   => s_i2c_data,
                 idle       => s_dat_idle,
                 SDA_out    => s_sda2,
                 SDA_in     => SDA_in,
                 SCL        => s_scl2,
                 ACK_error  => s_ack_error );
END simple;

