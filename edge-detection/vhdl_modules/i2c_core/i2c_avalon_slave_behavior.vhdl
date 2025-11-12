ARCHITECTURE simple OF i2c_core IS

   COMPONENT i2c_autodetect
      PORT ( clock         : IN  std_logic;
             reset         : IN  std_logic;
             start         : IN  std_logic;
             ack_errors    : IN  std_logic_vector( 2 DOWNTO 0 );
             i2c_busy      : IN  std_logic;
             start_i2cc    : OUT std_logic;
             i2c_did       : OUT std_logic_vector( 7 DOWNTO 0 );
             nr_of_devices : OUT std_logic_vector( 7 DOWNTO 0 );
             device_addr   : IN  std_logic_vector( 7 DOWNTO 0 );
             device_id     : OUT std_logic_vector( 7 DOWNTO 0 );
             busy          : OUT std_logic);
   END COMPONENT;
   
   COMPONENT i2c_cntrl
      PORT ( clock      : IN  std_logic;
             reset      : IN  std_logic;
             start      : IN  std_logic;
             device_id  : IN  std_logic_vector( 7 DOWNTO 0 );
             address    : IN  std_logic_vector(15 DOWNTO 0 );
             data       : IN  std_logic_vector(15 DOWNTO 0 );
             prescale   : IN  std_logic_vector( 7 DOWNTO 0 );
             data_out   : OUT std_logic_vector(31 DOWNTO 0 );
             two_phase  : IN  std_logic;
             four_data  : IN  std_logic;
             short_tran : IN  std_logic;
             SDA_out    : OUT std_logic;
             SDA_in     : IN  std_logic;
             SCL        : OUT std_logic;
             busy       : OUT std_logic;
             ACK_ERRORs : OUT std_logic_vector( 2 DOWNTO 0 ));
   END COMPONENT;
   
   SIGNAL s_start_auto_detection       : std_logic;
   SIGNAL s_ack_errors                 : std_logic_vector( 2 DOWNTO 0 );
   SIGNAL s_i2c_core_busy              : std_logic;
   SIGNAL s_start_i2c_core             : std_logic;
   SIGNAL s_start_auto_i2c_core        : std_logic;
   SIGNAL s_auto_did                   : std_logic_vector( 7 DOWNTO 0 );
   SIGNAL s_did_reg                    : std_logic_vector( 7 DOWNTO 0 );
   SIGNAL s_i2c_did                    : std_logic_vector( 7 DOWNTO 0 );
   SIGNAL s_auto_busy                  : std_logic;
   SIGNAL s_i2c_addr                   : std_logic_vector(15 DOWNTO 0 );
   SIGNAL s_addr_reg                   : std_logic_vector(15 DOWNTO 0 );
   SIGNAL s_data_reg                   : std_logic_vector(15 DOWNTO 0 );
   SIGNAL s_control_reg                : std_logic_vector(15 DOWNTO 0 );
   SIGNAL s_i2c_data_out               : std_logic_vector(31 DOWNTO 0 );
   SIGNAL s_i2c_2_phase                : std_logic;
   SIGNAL s_sda_in                     : std_logic;
   SIGNAL s_sda_out                    : std_logic;
   SIGNAL s_scl_out                    : std_logic;
   SIGNAL s_auto_did_out               : std_logic_vector( 7 DOWNTO 0 );
   SIGNAL s_auto_nr_devices            : std_logic_vector( 7 DOWNTO 0 );
   SIGNAL s_i2c_irq_reg                : std_logic;
   SIGNAL s_i2c_irq_enable_reg         : std_logic;
   SIGNAL s_i2c_core_busy_reg          : std_logic;

BEGIN
   -- Here the outputs are defined
   SDA  <= '0' WHEN s_sda_out = '0' ELSE 'Z';
   SCL  <= '0' WHEN s_scl_out = '0' ELSE 'Z';
   IRQ  <= s_i2c_irq_reg;
   
   make_slave_read_data : PROCESS( slave_address , s_auto_did_out ,
                                   s_auto_nr_devices, s_ack_errors,
                                   s_i2c_data_out,s_auto_busy,s_i2c_core_busy,
                                   s_i2c_irq_reg,
                                   s_i2c_irq_enable_reg)
   BEGIN
      CASE (slave_address) IS
          WHEN  "00"  => slave_read_data <= X"000000"&s_auto_did_out;
          WHEN  "01"  => slave_read_data <= X"000000"&s_auto_nr_devices;
          WHEN  "10"  => slave_read_data <= s_i2c_data_out;
          WHEN OTHERS => slave_read_data <= X"00000"&
                                            "0"&
                                            s_i2c_irq_enable_reg&
                                            "0"&
                                            s_i2c_irq_reg&
                                            "000"&
                                            s_ack_errors&s_auto_busy&s_i2c_core_busy;
      END CASE;
   END PROCESS make_slave_read_data;
   
   -- Here the irq handling is defined
   make_i2c_irq_enable_reg : PROCESS( clock )
   BEGIN
      IF (rising_edge(clock)) THEN
         IF (reset = '1') THEN s_i2c_irq_enable_reg <= '0';
         ELSIF (slave_address = "11" AND
                slave_cs = '1' AND
                slave_we = '1' AND
                slave_byte_enables(2) = '1') THEN
            s_i2c_irq_enable_reg <= slave_write_data(16);
         END IF;
      END IF;
   END PROCESS make_i2c_irq_enable_reg;
   
   make_i2c_irq_reg : PROCESS( clock )
   BEGIN
      IF (rising_edge(clock)) THEN
         IF (reset = '1' OR
             (slave_address = "11" AND
              slave_cs = '1' AND
              slave_we = '1' AND
              slave_byte_enables(0) = '1' AND
              slave_write_data(3) = '1')) THEN s_i2c_irq_reg <= '0';
         ELSIF (s_i2c_core_busy_reg = '1' AND
                s_i2c_core_busy = '0' AND
                s_i2c_irq_enable_reg = '1') THEN s_i2c_irq_reg <= '1';
         END IF;
      END IF;
   END PROCESS make_i2c_irq_reg;
   
   make_i2c_core_busy_reg : PROCESS( clock )
   BEGIN
      IF (rising_edge(clock)) THEN
         s_i2c_core_busy_reg <= s_i2c_core_busy;
      END IF;
   END PROCESS make_i2c_core_busy_reg;
   
   -- Here the control signals are defined
   s_start_auto_detection <= '1' WHEN slave_address = "11" AND
                                      slave_cs = '1' AND
                                      slave_we = '1' AND
                                      slave_byte_enables(0) = '1' AND
                                      slave_write_data(2) = '1' ELSE '0';
   s_start_i2c_core       <= '1' WHEN s_start_auto_i2c_core = '1' OR
                                      (slave_address = "11" AND
                                       slave_cs = '1' AND
                                       slave_we = '1' AND
                                       slave_byte_enables(0) = '1' AND
                                       slave_write_data(1) = '1') ELSE '0';
   s_i2c_did              <= s_auto_did WHEN s_auto_busy = '1' ELSE s_did_reg;
   s_i2c_addr             <= s_addr_reg WHEN s_auto_busy = '0' ELSE X"0000";
   s_i2c_2_phase          <= s_auto_busy OR s_control_reg(0);
   s_sda_in               <= SDA;
   
   -- Here all internal registers are defined
   make_did_reg : PROCESS( clock )
   BEGIN
      IF (rising_edge(clock)) THEN
         IF (reset = '1') THEN s_did_reg <= (OTHERS => '0');
         ELSIF (slave_address = "00" AND
                slave_cs = '1' AND
                slave_we = '1') THEN
            s_did_reg <= slave_write_data( 7 DOWNTO 0 );
         END IF;
      END IF;
   END PROCESS make_did_reg;

   make_addr_reg : PROCESS( clock )
   BEGIN
      IF (rising_edge(clock)) THEN
         IF (reset = '1') THEN s_addr_reg <= (OTHERS => '0');
         ELSIF (slave_address = "01" AND
                slave_cs = '1' AND
                slave_we = '1') THEN
            s_addr_reg <= slave_write_data(15 DOWNTO 0 );
         END IF;
      END IF;
   END PROCESS make_addr_reg;

   make_data_reg : PROCESS( clock )
   BEGIN
      IF (rising_edge(clock)) THEN
         IF (reset = '1') THEN s_data_reg <= (OTHERS => '0');
         ELSIF (slave_address = "10" AND
                slave_cs = '1' AND
                slave_we = '1') THEN
            s_data_reg <= slave_write_data(15 DOWNTO 0 );
         END IF;
      END IF;
   END PROCESS make_data_reg;

   make_control_reg : PROCESS( clock )
   BEGIN
      IF (rising_edge(clock)) THEN
         IF (reset = '1') THEN s_control_reg <= (OTHERS => '0');
         ELSIF (slave_address = "11" AND
                slave_cs = '1' AND
                slave_we = '1') THEN
            IF (slave_byte_enables(0) = '1') THEN
                s_control_reg( 7 DOWNTO 0 ) <= slave_write_data( 7 DOWNTO 0 );
            END IF;
            IF (slave_byte_enables(1) = '1') THEN
                s_control_reg(15 DOWNTO 8 ) <= slave_write_data(15 DOWNTO 8 );
            END IF;
         END IF;
      END IF;
   END PROCESS make_control_reg;

   -- Here the components are mapped
   autodetection : i2c_autodetect
      PORT MAP ( clock         => clock,
                 reset         => reset,
                 start         => s_start_auto_detection,
                 ack_errors    => s_ack_errors,
                 i2c_busy      => s_i2c_core_busy,
                 start_i2cc    => s_start_auto_i2c_core,
                 i2c_did       => s_auto_did,
                 nr_of_devices => s_auto_nr_devices,
                 device_addr   => s_did_reg,
                 device_id     => s_auto_did_out,
                 busy          => s_auto_busy);
   core : i2c_cntrl
      PORT MAP ( clock      => clock,
                 reset      => reset,
                 start      => s_start_i2c_core,
                 device_id  => s_i2c_did,
                 address    => s_i2c_addr,
                 data       => s_data_reg,
                 prescale   => s_control_reg( 15 DOWNTO 8 ),
                 data_out   => s_i2c_data_out,
                 two_phase  => s_i2c_2_phase,
                 four_data  => s_control_reg(5),
                 short_tran => s_control_reg(6),
                 SDA_out    => s_sda_out,
                 SDA_in     => s_sda_in,
                 SCL        => s_scl_out,
                 busy       => s_i2c_core_busy,
                 ACK_ERRORs => s_ack_errors);


END simple;
