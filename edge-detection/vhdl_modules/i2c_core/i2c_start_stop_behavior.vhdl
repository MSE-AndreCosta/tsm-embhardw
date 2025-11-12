ARCHITECTURE simple OF i2c_start_stop IS

TYPE STATE_TYPE IS (IDLE,START1,START2,START3,START4,
                    ACTIVE,STOP1,STOP2,STOP3,STOP4,
                    STOP5,STOP6);

SIGNAL s_current_state , s_next_state : STATE_TYPE;

BEGIN
   idle_state   <= '1' WHEN s_current_state = IDLE ELSE '0';
   active_state <= '1' WHEN s_current_state = ACTIVE ELSE '0';
   SCL    <= '0' WHEN s_current_state = ACTIVE OR
                      s_current_state = STOP1 OR
                      s_current_state = STOP2 ELSE '1';
   SDA    <= '0' WHEN s_current_state = START3 OR
                      s_current_state = START4 OR
                      s_current_state = ACTIVE OR
                      s_current_state = STOP1 OR
                      s_current_state = STOP2 OR
                      s_current_state = STOP3 OR
                      s_current_state = STOP4 ELSE '1';
   
   -- make state machine
   make_next_state : PROCESS( s_current_state , tick , activate , 
                              reset )
   BEGIN
      IF (reset = '1') THEN s_next_state <= IDLE;
      ELSIF (activate = '1' AND s_current_state = ACTIVE) THEN
         s_next_state <= STOP1;
      ELSIF (activate = '1' AND s_current_state = IDLE) THEN
         s_next_state <= START1;
      ELSIF (tick = '0') THEN s_next_state <= s_current_state;
                         ELSE
         CASE (s_current_state) IS
            WHEN STOP1  => s_next_state <= STOP2;
            WHEN STOP2  => s_next_state <= STOP3;
            WHEN STOP3  => s_next_state <= STOP4;
            WHEN STOP4  => s_next_state <= STOP5;
            WHEN STOP5  => s_next_state <= STOP6;
            WHEN STOP6  => s_next_state <= IDLE;
            WHEN START1 => s_next_state <= START2;
            WHEN START2 => s_next_state <= START3;
            WHEN START3 => s_next_state <= START4;
            WHEN START4 => s_next_state <= ACTIVE;
            WHEN OTHERS => s_next_state <= s_current_state;
         END CASE;
      END IF;
   END PROCESS make_next_state;
   
   make_state_reg : PROCESS( clock )
   BEGIN
      IF (rising_edge(clock)) THEN
         s_current_state <= s_next_state;
      END IF;
   END PROCESS make_state_reg;
END simple;

