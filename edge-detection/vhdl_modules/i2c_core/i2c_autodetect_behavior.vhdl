ARCHITECTURE simple OF i2c_autodetect IS

   TYPE STATE_TYPE IS (IDLE,START_I2C,WAIT_I2C,UPDATE,NEXT_DID);
   TYPE RAM_TYPE IS ARRAY(255 DOWNTO 0) OF std_logic_vector(6 DOWNTO 0);
   
   SIGNAL s_did_counter_reg            : std_logic_vector( 6 DOWNTO 0 );
   SIGNAL s_current_state,s_next_state : STATE_TYPE;
   SIGNAL s_device_count_reg           : std_logic_vector( 7 DOWNTO 0 );
   SIGNAL s_device_found               : std_logic;
   SIGNAL ram                          : RAM_TYPE;
   SIGNAL s_ram_address                : std_logic_vector( 7 DOWNTO 0 );
   SIGNAL s_ram_read_address           : std_logic_vector( 7 DOWNTO 0 );
   
BEGIN
   -- Here the outputs are defined
   busy          <= '0' WHEN s_current_state = IDLE ELSE '1';
   i2c_did       <= s_did_counter_reg&"0";
   start_i2cc    <= '1' WHEN s_current_state = START_I2C ELSE '0';
   nr_of_devices <= s_device_count_reg;
   
   -- Assign control signals
   s_device_found <= '1' WHEN s_current_state = UPDATE AND
                              ack_errors = "000" ELSE '0';
   s_ram_address  <= device_addr WHEN s_current_state = IDLE ELSE
                     s_device_count_reg;
   
   -- Make device counter
   make_dev_count : PROCESS( clock , reset , start ,s_device_found )
   BEGIN
      IF (rising_edge(clock)) THEN
         IF (reset = '1' OR start = '1') THEN
            s_device_count_reg <= (OTHERS => '0');
         ELSIF (s_device_found = '1') THEN
            s_device_count_reg <= std_logic_vector(unsigned(s_device_count_reg)+1);
         END IF;
      END IF;
   END PROCESS make_dev_count;
                             
   
   -- Make the did counter
   make_did : PROCESS( reset , start , clock , s_current_state )
   BEGIN
      IF (rising_edge(clock)) THEN
         IF (reset = '1' OR start = '1') THEN
            s_did_counter_reg <= (OTHERS => '0');
         ELSIF (s_current_state = NEXT_DID) THEN
            s_did_counter_reg <= std_logic_vector(unsigned(s_did_counter_reg)+1);
         END IF;
      END IF;
   END PROCESS make_did;
   
   -- Here the memory is defined
   ramproc : PROCESS( clock )
   BEGIN
      IF (rising_edge(clock)) THEN
         IF (s_device_found = '1') THEN
            ram(to_integer(unsigned(s_ram_address))) <= s_did_counter_reg;
         END IF;
         s_ram_read_address <= s_ram_address;
      END IF;
   END PROCESS ramproc;
   
   device_id(7 DOWNTO 1) <= ram(to_integer(unsigned(s_ram_read_address)));
   device_id(0)          <= '0';
   
   -- Here the state machine is defined
   make_next_state : PROCESS( s_current_state , i2c_busy , s_did_counter_reg ,
                              start )
   BEGIN
      CASE (s_current_state) IS
         WHEN IDLE      => IF (start = '1') THEN s_next_state <= START_I2C;
                                            ELSE s_next_state <= IDLE;
                           END IF;
         WHEN START_I2C => s_next_state <= WAIT_I2C;
         WHEN WAIT_I2C  => IF (i2c_busy = '1') THEN s_next_state <= WAIT_I2C;
                                               ELSE s_next_state <= UPDATE;
                           END IF;
         WHEN UPDATE    => s_next_state <= NEXT_DID;
         WHEN NEXT_DID  => IF (s_did_counter_reg = "1111111") THEN 
                              s_next_state <= IDLE;
                                                              ELSE
                              s_next_state <= START_I2C;
                           END IF;
         WHEN OTHERS    => s_next_state <= IDLE;
      END CASE;
   END PROCESS make_next_state;
   
   make_state_reg : PROCESS( clock , reset , s_next_state )
   BEGIN
      IF (rising_edge(clock)) THEN
         IF (reset = '1') THEN s_current_state <= IDLE;
                          ELSE s_current_state <= s_next_state;
         END IF;
      END IF;
   END PROCESS make_state_reg;
END simple;
