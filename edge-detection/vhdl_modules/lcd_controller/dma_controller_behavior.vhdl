ARCHITECTURE MSE OF dma_controller_lcd IS

   TYPE MEM_TYPE IS ARRAY( 255 DOWNTO 0 ) OF std_logic_vector( 31 DOWNTO 0 );
   SIGNAL fifo_memory        : MEM_TYPE;
   SIGNAL fifo_write_address : unsigned( 8 DOWNTO 0 );
   SIGNAL fifo_read_address  : unsigned( 8 DOWNTO 0 );
   SIGNAL s_read_reg         : std_logic;
   SIGNAL s_read_next        : std_logic;
   SIGNAL s_burst_count_reg  : std_logic_vector( 7 DOWNTO 0 );
   SIGNAL s_burst_count_next : std_logic_vector( 7 DOWNTO 0 );
   SIGNAL s_empty_next       : std_logic;
   SIGNAL s_we_fifo          : std_logic;
   SIGNAL s_to_receive_reg   : unsigned( 8 DOWNTO 0 );
   
BEGIN

--------------------------------------------------------------------------------
---                                                                          ---
--- In this section the avalon master signals are defined                    ---
---                                                                          ---
--------------------------------------------------------------------------------

   make_master_address : PROCESS( Clock )
   BEGIN
      IF (rising_edge(Clock)) THEN
         IF (Reset = '1') THEN master_address <= (OTHERS => '0');
         ELSIF (Start = '1') THEN master_address <= StartAddress&"00";
         END IF;
      END IF;
   END PROCESS make_master_address;
   
   master_read <= s_read_reg;
   s_read_next <= '1' WHEN Start = '1' ELSE
                  '0' WHEN master_wait_request = '0' ELSE
                  s_read_reg;
   
   make_read_reg : PROCESS( Clock )
   BEGIN
      IF (rising_edge(Clock)) THEN
         IF (Reset = '1') THEN s_read_reg <= '0';
                          ELSE s_read_reg <= s_read_next;
         END IF;
      END IF;
   END PROCESS make_read_reg;
   
   master_burst_count <= s_burst_count_reg;
   s_burst_count_next <= BurstSize WHEN Start = '1' ELSE
                         X"00" WHEN master_wait_request = '0' ELSE
                         s_burst_count_reg;

   make_burst_count_reg : PROCESS( Clock )
   BEGIN
      IF (rising_edge(Clock)) THEN
         IF (Reset = '1') THEN s_burst_count_reg <= X"00";
                          ELSE s_burst_count_reg <= s_burst_count_next;
         END IF;
      END IF;
   END PROCESS make_burst_count_reg;

--------------------------------------------------------------------------------
---                                                                          ---
--- In this section the fifo status signals are defined                      ---
---                                                                          ---
--------------------------------------------------------------------------------
   busy  <= NOT(s_to_receive_reg(8));
   empty <= '0' WHEN fifo_write_address > fifo_read_address ELSE '1';

--------------------------------------------------------------------------------
---                                                                          ---
--- In this section the data fifo is defined                                 ---
---                                                                          ---
--------------------------------------------------------------------------------
   make_to_receive_reg : PROCESS( clock )
   BEGIN
      IF (rising_edge(clock)) THEN
         IF (Reset = '1') THEN s_to_receive_reg <= (OTHERS => '1');
         ELSIF (Start = '1') THEN
            s_to_receive_reg(7 DOWNTO 0) <= unsigned(BurstSize)-1;
            s_to_receive_reg(8) <= '0';
         ELSIF (s_we_fifo = '1') THEN
            s_to_receive_reg <= s_to_receive_reg-1;
         END IF;
      END IF;
   END PROCESS make_to_receive_reg;
   
   s_we_fifo <= master_read_data_valid AND NOT(s_to_receive_reg(8));

   fifo_mem_process : PROCESS( Clock )
   BEGIN
      IF (rising_edge(Clock)) THEN
         IF (s_we_fifo = '1') THEN
            fifo_memory(to_integer(fifo_write_address(7 DOWNTO 0))) <= master_read_data;
         END IF;
         DataOut <= fifo_memory(to_integer(fifo_read_address(7 DOWNTO 0)));
      END IF;
   END PROCESS fifo_mem_process;

   make_write_address : PROCESS( Clock )
   BEGIN
      IF (rising_edge(Clock)) THEN
         IF (Reset = '1') THEN
            fifo_write_address <= (OTHERS => '1');
         ELSIF (Start = '1') THEN
            fifo_write_address <= (OTHERS => '0');
         ELSIF (master_read_data_valid = '1' AND
                fifo_write_address(8) = '0') THEN
            fifo_write_address <= fifo_write_address + 1;
         END IF;
      END IF;
   END PROCESS make_write_address;
   
   make_read_address : PROCESS( Clock )
   BEGIN
      IF (rising_edge(Clock)) THEN
         IF (Reset = '1') THEN
            fifo_read_address <= (OTHERS => '1');
         ELSIF (Start = '1') THEN
            fifo_read_address <= (OTHERS => '0');
         ELSIF (pop = '1' AND
                fifo_read_address(8) = '0') THEN
            fifo_read_address <= fifo_read_address + 1;
         END IF;
      END IF;
   END PROCESS make_read_address;

END MSE;
