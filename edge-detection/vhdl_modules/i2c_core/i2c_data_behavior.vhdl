ARCHITECTURE simple OF i2c_data IS

SIGNAL s_current_state , s_next_state : std_logic_vector( 5 DOWNTO 0 );
SIGNAL s_shift_reg                    : std_logic_vector( 9 DOWNTO 0 );
SIGNAL s_sample_SDA_in                : std_logic;
SIGNAL s_data_in_reg                  : std_logic_vector( 8 DOWNTO 0 );

BEGIN
   idle      <= '1' WHEN s_current_state = "111101" ELSE '0';
   SCL       <= s_current_state(1);
   SDA_out   <= s_shift_reg(9);
   data_out  <= s_data_in_reg(8 DOWNTO 1);
   ACK_ERROR <= s_data_in_reg(0);
   
-- Here the control signals are defined
   s_sample_SDA_in <= tick WHEN s_current_state(1 DOWNTO 0) = "10" ELSE '0';
   
-- Here the data shift register is defined
   make_shift_reg : PROCESS( clock , reset , tick , data_in , start )
   BEGIN
      IF (rising_edge(clock)) THEN
         IF (reset = '1') THEN s_shift_reg <= (OTHERS => '0');
         ELSIF (start = '1') THEN s_shift_reg <= "0"&data_in&ack_bit;
         ELSIF (tick = '1' AND s_current_state(1 DOWNTO 0) = "00") THEN
            s_shift_reg <= s_shift_reg( 8 DOWNTO 0)&"0";
         END IF;
      END IF;
   END PROCESS make_shift_reg;
   
   make_data_in_reg : PROCESS( clock , SDA_in , s_sample_SDA_in , reset )
   BEGIN
      IF (rising_edge(clock)) THEN
         IF (reset = '1') THEN s_data_in_reg <= (OTHERS => '0');
         ELSIF (s_sample_SDA_in = '1') THEN
            s_data_in_reg <= s_data_in_reg( 7 DOWNTO 0 )&SDA_in;
         END IF;
      END IF;
   END PROCESS make_data_in_reg;

-- Here the state machine is defined
   s_next_state <= "000000" WHEN start = '1' ELSE
                   "111101" WHEN reset = '1' OR
                                 (s_current_state = "100100" AND tick = '1') OR
                                 s_current_state = "111101" ELSE
                   s_current_state WHEN tick = '0' ELSE
                   std_logic_vector(unsigned(s_current_state)+1);
                   
   make_dffs : PROCESS( clock )
   BEGIN
      IF (rising_edge(clock)) THEN
         s_current_state <= s_next_state;
      END IF;
   END PROCESS make_dffs;
   
END simple;

