ARCHITECTURE MSE OF cam_dma_ctrl IS
  
   TYPE DMASTATETYPE IS (IDLE,WAITIMAGE,STREAM);
   TYPE AVALONSTATETYPE IS (NOOP,INITBURST,BURST);
   
   SIGNAL s_reset                           : std_logic;
   SIGNAL s_streaming_mode_next             : std_logic;
   SIGNAL s_streaming_mode_reg              : std_logic;
   SIGNAL s_dma_state_next                  : DMASTATETYPE;
   SIGNAL s_dma_current_state               : DMASTATETYPE;
   SIGNAL s_streaming_active                : std_logic;
   SIGNAL s_current_memory_pointer          : std_logic_vector( 32 DOWNTO 2 );
   SIGNAL s_pointer_select_reg              : unsigned( 1 DOWNTO 0 );
   SIGNAL s_pointer_select_next             : unsigned( 1 DOWNTO 0 );
   SIGNAL s_burst_count_next                : unsigned( 9 DOWNTO 0 );
   SIGNAL s_burst_count_reg                 : unsigned( 9 DOWNTO 0 );
   SIGNAL s_we_avalon                       : std_logic;
   SIGNAL s_avalon_state_next               : AVALONSTATETYPE;
   SIGNAL s_avalon_current_state            : AVALONSTATETYPE;
   SIGNAL s_start_dma_transfer              : std_logic;
   SIGNAL s_load_address_reg                : std_logic;
   SIGNAL s_load_address_next               : std_logic;
   SIGNAL s_avalon_bus_address_next         : unsigned( 31 DOWNTO 2 );
   SIGNAL s_avalon_bus_address_reg          : unsigned( 31 DOWNTO 2 );
   SIGNAL s_avalon_bus_address_valid_reg    : std_logic;

BEGIN

--------------------------------------------------------------------------------
---                                                                          ---
--- In this section the output signals are defined                           ---
---                                                                          ---
--------------------------------------------------------------------------------
   CoreBusy        <= '0' WHEN s_dma_current_state = IDLE ELSE '1';
   GenIrq          <= '1' WHEN s_dma_current_state = STREAM AND
                               NextFrame = '1' ELSE '0';
   InStreamingMode <= s_streaming_mode_reg;
   PixelIFReset    <= '0' WHEN s_dma_current_state = STREAM ELSE '1';
   Pop             <= s_we_avalon;
   
   makeCurrentImagePointer : PROCESS( Clock )
   BEGIN
      IF (rising_edge(Clock)) THEN
         IF (s_reset = '1') THEN CurrentImagePointer <= (OTHERS => '0');
         ELSIF (s_dma_current_state = STREAM AND
                NextFrame = '1') THEN
            CurrentImagePointer <= s_current_memory_pointer;
         END IF;
      END IF;
   END PROCESS makeCurrentImagePointer;

--------------------------------------------------------------------------------
---                                                                          ---
--- In this section some control signals are defined                         ---
---                                                                          ---
--------------------------------------------------------------------------------
   s_reset              <= Reset OR NOT(CamRstBar);
   s_streaming_active   <= '1' WHEN s_dma_current_state = STREAM ELSE '0';
   s_start_dma_transfer <= '1' WHEN s_dma_current_state = STREAM AND
                                    NextLine = '1' AND
                                    s_avalon_bus_address_valid_reg = '1' ELSE '0';
   s_load_address_next  <= '1' WHEN NextFrame = '1' AND
                                    (s_dma_current_state = WAITIMAGE OR
                                     s_dma_current_state = STREAM) ELSE '0';
   
   make_load_address_reg : PROCESS( Clock )
   BEGIN
      IF (rising_edge(Clock)) THEN
         s_load_address_reg <= s_load_address_next;
      END IF;
   END PROCESS make_load_address_reg;

--------------------------------------------------------------------------------
---                                                                          ---
--- In this section the memory pointer management is defined                 ---
---                                                                          ---
--------------------------------------------------------------------------------
   make_current_memory_pointer : PROCESS( s_pointer_select_reg ,
                                          MemoryPointer1, MemoryPointer2,
                                          MemoryPointer3, MemoryPointer4)
   BEGIN
      CASE (s_pointer_select_reg) IS
         WHEN  "00"  => s_current_memory_pointer <= MemoryPointer1;
         WHEN  "01"  => s_current_memory_pointer <= MemoryPointer2;
         WHEN  "10"  => s_current_memory_pointer <= MemoryPointer3;
         WHEN OTHERS => s_current_memory_pointer <= MemoryPointer4;
      END CASE;
   END PROCESS make_current_memory_pointer;
   
   s_pointer_select_next <= "00" WHEN s_dma_current_state = IDLE OR
                                      (s_dma_current_state = STREAM AND
                                       s_pointer_select_reg = "01" AND
                                       NextFrame = '1' AND
                                       quad_buffering = '0') ELSE
                            s_pointer_select_reg+1
                               WHEN (s_dma_current_state = STREAM AND
                                     NextFrame = '1') ELSE
                            s_pointer_select_reg;
   
   make_pointer_select_reg : PROCESS( Clock )
   BEGIN
      IF (rising_edge(Clock)) THEN
         IF (s_reset = '1') THEN s_pointer_select_reg <= "00";
                            ELSE s_pointer_select_reg <= s_pointer_select_next;
         END IF;
      END IF;
   END PROCESS make_pointer_select_reg;
   

--------------------------------------------------------------------------------
---                                                                          ---
--- In this section the overal state machine is defined                      ---
---                                                                          ---
--------------------------------------------------------------------------------
   make_next_dma_state : PROCESS( s_dma_current_state , startsingleimage ,
                                  startstreaming , NextFrame )
   BEGIN
      CASE (s_dma_current_state) IS
         WHEN IDLE            => IF (startstreaming = '1' OR
                                     startsingleimage = '1') THEN
                                    s_dma_state_next <= WAITIMAGE;
                                                             ELSE
                                    s_dma_state_next <= IDLE;
                                 END IF;
         WHEN WAITIMAGE       => IF (NextFrame = '1') THEN
                                    s_dma_state_next <= STREAM;
                                                      ELSE
                                    s_dma_state_next <= WAITIMAGE;
                                 END IF;
         WHEN STREAM          => IF (NextFrame = '1') THEN
                                    IF (s_streaming_mode_reg = '1') THEN
                                       s_dma_state_next <= STREAM;
                                                                    ELSE
                                       s_dma_state_next <= IDLE;
                                    END IF;
                                                       ELSE
                                    s_dma_state_next <= STREAM;
                                 END IF;
      END CASE;
   END PROCESS make_next_dma_state;
   
   make_dma_state_reg : PROCESS( Clock )
   BEGIN
      IF (rising_edge(Clock)) THEN
         IF (s_reset = '1') THEN s_dma_current_state <= IDLE;
                            ELSE s_dma_current_state <= s_dma_state_next;
         END IF;
      END IF;
   END PROCESS make_dma_state_reg;
   
   s_streaming_mode_next <= '1' WHEN s_dma_current_state = IDLE AND
                                     startstreaming = '1' ELSE
                            '0' WHEN s_dma_current_state = IDLE OR
                                     stopstreaming = '1' ELSE
                            s_streaming_mode_reg;
   
   make_streaming_mode_reg : PROCESS( Clock )
   BEGIN
      IF (rising_edge(Clock)) THEN
         IF (s_reset = '1') THEN s_streaming_mode_reg <= '0';
                            ELSE s_streaming_mode_reg <= s_streaming_mode_next;
         END IF;
      END IF;
   END PROCESS make_streaming_mode_reg;

--------------------------------------------------------------------------------
---                                                                          ---
--- In this section the avalon burst control is defined                      ---
---                                                                          ---
--------------------------------------------------------------------------------
   s_burst_count_next <= unsigned(NrOfWords)-2 
                            WHEN s_avalon_current_state = INITBURST ELSE
                         s_burst_count_reg-1
                            WHEN s_we_avalon = '1' ELSE
                         s_burst_count_reg;
   
   make_burst_count_reg : PROCESS( Clock )
   BEGIN
      IF (rising_edge(Clock)) THEN
         IF (s_reset = '1') THEN s_burst_count_reg <= (OTHERS => '1');
                            ELSE s_burst_count_reg <= s_burst_count_next;
         END IF;
      END IF;
   END PROCESS make_burst_count_reg;
   
   s_we_avalon <= '1' WHEN s_avalon_current_state = INITBURST OR
                           (s_avalon_current_state = BURST AND
                            master_wait_req = '0' AND
                            s_burst_count_reg(9) = '0') ELSE '0';

--------------------------------------------------------------------------------
---                                                                          ---
--- In this section the avalon state machine is defined                      ---
---                                                                          ---
--------------------------------------------------------------------------------
   make_avalon_state_next : PROCESS( s_avalon_current_state , 
                                     s_start_dma_transfer, s_burst_count_reg )
   BEGIN
      CASE (s_avalon_current_state) IS
         WHEN NOOP      => IF (s_start_dma_transfer = '1') THEN
                              s_avalon_state_next <= INITBURST;
                                                           ELSE
                              s_avalon_state_next <= NOOP;
                           END IF;
         WHEN INITBURST => s_avalon_state_next <= BURST;
         WHEN BURST     => IF (s_burst_count_reg(9) = '1') THEN
                              s_avalon_state_next <= NOOP;
                                                           ELSE
                              s_avalon_state_next <= BURST;
                           END IF;
      END CASE;
   END PROCESS make_avalon_state_next;
   
   make_avalon_current_state : PROCESS( Clock )
   BEGIN
      IF (rising_edge(Clock)) THEN
         IF (s_reset = '1') THEN s_avalon_current_state <= NOOP;
                            ELSE s_avalon_current_state <= s_avalon_state_next;
         END IF;
      END IF;
   END PROCESS make_avalon_current_state;

--------------------------------------------------------------------------------
---                                                                          ---
--- In this section the avalon bus address management is defined             ---
---                                                                          ---
--------------------------------------------------------------------------------
   s_avalon_bus_address_next <= unsigned(s_current_memory_pointer(31 DOWNTO 2))
                                   WHEN s_load_address_reg = '1' ELSE
                                s_avalon_bus_address_reg+1
                                   WHEN s_we_avalon = '1' ELSE
                                s_avalon_bus_address_reg;
                                
   make_avalon_bus_address_reg : PROCESS( Clock )
   BEGIN
      IF (rising_edge(Clock)) THEN
         IF (s_reset = '1') THEN s_avalon_bus_address_reg <= (OTHERS => '0');
                            ELSE 
            s_avalon_bus_address_reg <= s_avalon_bus_address_next;
         END IF;
      END IF;
   END PROCESS make_avalon_bus_address_reg;
   
   make_avalon_bus_address_valid_reg : PROCESS( Clock )
   BEGIN
      IF (rising_edge(Clock)) THEN
         IF (s_reset = '1') THEN s_avalon_bus_address_valid_reg <= '0';
         ELSIF (s_load_address_reg = '1') THEN
            s_avalon_bus_address_valid_reg <= s_current_memory_pointer(32);
         END IF;
      END IF;
   END PROCESS make_avalon_bus_address_valid_reg;


--------------------------------------------------------------------------------
---                                                                          ---
--- In this section the avalon master signals are defined                    ---
---                                                                          ---
--------------------------------------------------------------------------------
   make_master_address : PROCESS( Clock )
   BEGIN
      IF (rising_edge(Clock)) THEN
         IF (s_avalon_current_state = INITBURST) THEN
            master_address <= std_logic_vector(s_avalon_bus_address_reg)&"00";
         ELSIF (s_reset = '1' OR
                master_wait_req = '0') THEN
            master_address <= (OTHERS => '0');
         END IF;
      END IF;
   END PROCESS make_master_address;
   
   make_master_we : PROCESS( Clock )
   BEGIN
      IF (rising_edge(Clock)) THEN
         IF (s_we_avalon = '1') THEN master_we <= '1';
         ELSIF (s_reset = '1' OR
                master_wait_req = '0') THEN master_we <= '0';
         END IF;
      END IF;
   END PROCESS make_master_we;
   
   make_master_write_data : PROCESS( Clock )
   BEGIN
      IF (rising_edge(Clock)) THEN
         IF (s_reset = '1') THEN master_write_data <= (OTHERS => '0');
         ELSIF (s_we_avalon = '1') THEN master_write_data <= PixelData;
         END IF;
      END IF;
   END PROCESS make_master_write_data;
   
   make_master_burst_count : PROCESS( Clock )
   BEGIN
      IF (rising_edge(Clock)) THEN
         IF (s_avalon_current_state = INITBURST) THEN
            master_burst_count <= NrOfWords;
         ELSIF (s_reset = '1' OR
                master_wait_req = '0') THEN
            master_burst_count <= (OTHERS => '0');
         END IF;
      END IF;
   END PROCESS make_master_burst_count;
END MSE;
