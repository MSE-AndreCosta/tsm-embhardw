ARCHITECTURE MSE OF cam_dma IS

   COMPONENT frame_interpreter IS
      PORT ( -- Here the internal interface is defined
             Clock                  : IN  std_logic;
             Reset                  : IN  std_logic;
             PixelClk               : IN  std_logic;
             HSync                  : IN  std_logic;
             VSync                  : IN  std_logic;
             CamResetBar            : IN  std_logic;
             nr_of_bytes_each_line  : OUT std_logic_vector(15 DOWNTO 0);
             nr_of_lines            : OUT std_logic_vector(15 DOWNTO 0);
             frameRate              : OUT std_logic_vector( 7 DOWNTO 0);
             DataValid              : OUT std_logic;
             NextFrame              : OUT std_logic;
             NextLinePxlClk         : OUT std_logic;
             NextLine               : OUT std_logic);
   END COMPONENT;
   
   COMPONENT pixel_interface IS
      PORT ( Clock                   : IN  std_logic;
             Reset                   : IN  std_logic;
             PixelClk                : IN  std_logic;
             NextLinePxlClk          : IN  std_logic;
             NextLine                : IN  std_logic;
             CamData                 : IN  std_logic_vector( 9 DOWNTO 0 );
             HSync                   : IN  std_logic;
             PixelData               : OUT std_logic_vector( 31 DOWNTO 0 );
             Pop                     : IN  std_logic;
             NrOfWords               : OUT std_logic_vector(  9 DOWNTO 0 ));
   END COMPONENT;
   
   COMPONENT cam_dma_ctrl IS
      PORT ( Clock                    : IN  std_logic;
             Reset                    : IN  std_logic;
             CamRstBar                : IN  std_logic;
             PixelIFReset             : OUT std_logic;
             NextLine                 : IN  std_logic;
             NextFrame                : IN  std_logic;
             PixelData                : IN  std_logic_vector( 31 DOWNTO 0 );
             NrOfWords                : IN  std_logic_vector(  9 DOWNTO 0 );
             Pop                      : OUT std_logic;
             startstreaming           : IN  std_logic;
             stopstreaming            : IN  std_logic;
             startsingleimage         : IN  std_logic;
             quad_buffering           : IN  std_logic;
             MemoryPointer1           : IN  std_logic_vector( 32 DOWNTO 2 );
             MemoryPointer2           : IN  std_logic_vector( 32 DOWNTO 2 );
             MemoryPointer3           : IN  std_logic_vector( 32 DOWNTO 2 );
             MemoryPointer4           : IN  std_logic_vector( 32 DOWNTO 2 );
             CurrentImagePointer      : OUT std_logic_vector( 32 DOWNTO 2 );
             CoreBusy                 : OUT std_logic;
             GenIrq                   : OUT std_logic;
             InStreamingMode          : OUT std_logic;
             -- master avalon interface
             master_address           : OUT std_logic_vector(31 DOWNTO 0 );
             master_we                : OUT std_logic;
             master_write_data        : OUT std_logic_vector(31 DOWNTO 0 );
             master_burst_count       : OUT std_logic_vector( 9 DOWNTO 0 );
             master_wait_req          : IN  std_logic);
   END COMPONENT;
   
   SIGNAL s_control_reg           : std_logic_vector( 1 DOWNTO 0);
   SIGNAL s_control_next          : std_logic_vector( 1 DOWNTO 0);
   SIGNAL s_nr_of_bytes_each_line : std_logic_vector(15 DOWNTO 0);
   SIGNAL s_nr_of_lines           : std_logic_vector(15 DOWNTO 0);
   SIGNAL s_frame_rate            : std_logic_vector( 7 DOWNTO 0);
   SIGNAL s_profiling_valid       : std_logic;
   SIGNAL s_NextLinePxlClk        : std_logic;
   SIGNAL s_NextLine              : std_logic;
   SIGNAL s_PixelIFReset          : std_logic;
   SIGNAL s_NextFrame             : std_logic;
   SIGNAL s_PixelData             : std_logic_vector(31 DOWNTO 0);
   SIGNAL s_NrOfWords             : std_logic_vector( 9 DOWNTO 0);
   SIGNAL s_Pop                   : std_logic;
   SIGNAL s_startstreaming        : std_logic;
   SIGNAL s_stopstreaming         : std_logic;
   SIGNAL s_startsingleimage      : std_logic;
   SIGNAL s_quad_buffering        : std_logic;
   SIGNAL s_MemoryPointer1_reg    : std_logic_vector( 32 DOWNTO 2 );
   SIGNAL s_MemoryPointer2_reg    : std_logic_vector( 32 DOWNTO 2 );
   SIGNAL s_MemoryPointer3_reg    : std_logic_vector( 32 DOWNTO 2 );
   SIGNAL s_MemoryPointer4_reg    : std_logic_vector( 32 DOWNTO 2 );
   SIGNAL s_CurrentImagePointer   : std_logic_vector( 32 DOWNTO 2 );
   SIGNAL s_CoreBusy              : std_logic;
   SIGNAL s_GenIrq                : std_logic;
   SIGNAL s_InStreamingMode       : std_logic;
   SIGNAL s_irq_next              : std_logic;
   SIGNAL s_irq_reg               : std_logic;
   SIGNAL s_irq_clear             : std_logic;
   SIGNAL s_irq_enable_next       : std_logic;
   SIGNAL s_irq_enable_reg        : std_logic;

BEGIN
--------------------------------------------------------------------------------
---                                                                          ---
--- In this section the outputs are defined                                  ---
---                                                                          ---
--------------------------------------------------------------------------------
   ResetBar  <= s_control_reg(0);
   PowerDown <= s_control_reg(1);
   IRQ       <= s_irq_reg AND s_irq_enable_reg;
   
   make_read_data : PROCESS( slave_address, s_nr_of_bytes_each_line,
                             s_nr_of_lines, s_control_reg, s_CurrentImagePointer,
                             s_profiling_valid , s_CoreBusy, s_InStreamingMode,
                             s_irq_enable_reg )
   BEGIN
      CASE (slave_address) IS
         WHEN "000"  => slave_read_data <= X"0000"&s_nr_of_bytes_each_line;
         WHEN "001"  => slave_read_data <= X"0000"&s_nr_of_lines;
         WHEN "010"  => slave_read_data <= X"000000"&s_frame_rate;
         WHEN "011"  => slave_read_data <= X"00000"&"00"&
                                           s_CurrentImagePointer(32)&
                                           "0"&
                                           s_irq_reg&
                                           s_irq_enable_reg&
                                           "0"&
                                           s_InStreamingMode&
                                           s_CoreBusy&
                                           s_profiling_valid&
                                           s_control_reg;
         WHEN OTHERS => slave_read_data <= s_CurrentImagePointer(31 DOWNTO 2)&"00";
      END CASE;
   END PROCESS make_read_data;

--------------------------------------------------------------------------------
---                                                                          ---
--- In this section the irq control is defined                               ---
---                                                                          ---
--------------------------------------------------------------------------------
   s_irq_clear   <= '1' WHEN slave_we = '1' AND
                             slave_cs = '1' AND
                             slave_address = "011" AND
                             slave_write_data(8) = '1' ELSE '0';
   s_irq_next    <= '1' WHEN s_GenIrq = '1' ELSE
                    '0' WHEN s_irq_clear = '1' ELSE
                    s_irq_reg;
                    
   make_irq_reg : PROCESS( Clock      )
   BEGIN
      IF (rising_edge(Clock     )) THEN
         IF (Reset = '1') THEN s_irq_reg <= '0';
                          ELSE s_irq_reg <= s_irq_next;
         END IF;
      END IF;
   END PROCESS make_irq_reg;
   
   s_irq_enable_next <= '1' WHEN slave_we = '1' AND
                                 slave_cs = '1' AND
                                 slave_address = "011" AND
                                 slave_write_data(6) = '1' ELSE
                        '0' WHEN slave_we = '1' AND
                                 slave_cs = '1' AND
                                 slave_address = "011" AND
                                 slave_write_data(7) = '1' ELSE
                        s_irq_enable_reg;
   
   make_irq_enable_reg : PROCESS( Clock      )
   BEGIN
      IF (rising_edge(Clock     )) THEN
         IF (Reset = '1') THEN s_irq_enable_reg <= '0';
                          ELSE s_irq_enable_reg <= s_irq_enable_next;
         END IF;
      END IF;
   END PROCESS make_irq_enable_reg;
--------------------------------------------------------------------------------
---                                                                          ---
--- In this section the control regs are defined                             ---
---                                                                          ---
--------------------------------------------------------------------------------
   s_control_next(0) <= '0' WHEN Reset = '1' ELSE
                        NOT(slave_write_data(0)) 
                            WHEN slave_we = '1' AND
                                 slave_cs = '1' AND
                                 slave_address = "011" ELSE
                        s_control_reg(0);
   s_control_next(1) <= '1' WHEN Reset = '1' ELSE
                        slave_write_data(1) 
                            WHEN slave_we = '1' AND
                                 slave_cs = '1' AND
                                 slave_address = "011" ELSE
                        s_control_reg(1);
   
   make_control_reg : PROCESS( Clock      )
   BEGIN
      IF (rising_edge(Clock     )) THEN
         s_control_reg <= s_control_next;
      END IF;
   END PROCESS make_control_reg;
   
   make_MemoryPointer1_reg : PROCESS( Clock      )
   BEGIN
      IF (rising_edge(Clock     )) THEN
         IF (Reset = '1') THEN s_MemoryPointer1_reg <= (OTHERS => '0');
         ELSIF (slave_we = '1' AND
                slave_cs = '1' AND
                slave_address = "100") THEN
            s_MemoryPointer1_reg <= "1"&slave_write_data(31 DOWNTO 2);
         END IF;
      END IF;
   END PROCESS make_MemoryPointer1_reg;

   make_MemoryPointer2_reg : PROCESS( Clock      )
   BEGIN
      IF (rising_edge(Clock     )) THEN
         IF (Reset = '1') THEN s_MemoryPointer2_reg <= (OTHERS => '0');
         ELSIF (slave_we = '1' AND
                slave_cs = '1' AND
                slave_address = "101") THEN
            s_MemoryPointer2_reg <= "1"&slave_write_data(31 DOWNTO 2);
         END IF;
      END IF;
   END PROCESS make_MemoryPointer2_reg;

   make_MemoryPointer3_reg : PROCESS( Clock      )
   BEGIN
      IF (rising_edge(Clock     )) THEN
         IF (Reset = '1') THEN s_MemoryPointer3_reg <= (OTHERS => '0');
         ELSIF (slave_we = '1' AND
                slave_cs = '1' AND
                slave_address = "110") THEN
            s_MemoryPointer3_reg <= "1"&slave_write_data(31 DOWNTO 2);
         END IF;
      END IF;
   END PROCESS make_MemoryPointer3_reg;

   make_MemoryPointer4_reg : PROCESS( Clock      )
   BEGIN
      IF (rising_edge(Clock     )) THEN
         IF (Reset = '1') THEN s_MemoryPointer4_reg <= (OTHERS => '0');
         ELSIF (slave_we = '1' AND
                slave_cs = '1' AND
                slave_address = "111") THEN
            s_MemoryPointer4_reg <= "1"&slave_write_data(31 DOWNTO 2);
         END IF;
      END IF;
   END PROCESS make_MemoryPointer4_reg;

--------------------------------------------------------------------------------
---                                                                          ---
--- In this section the control signals are defined                          ---
---                                                                          ---
--------------------------------------------------------------------------------
   s_startstreaming  <= '1' WHEN slave_we = '1' AND
                                 slave_cs = '1' AND
                                 slave_address = "011" AND
                                 slave_write_data(4) = '1' ELSE '0';
   s_stopstreaming   <= '1' WHEN slave_we = '1' AND
                                 slave_cs = '1' AND
                                 slave_address = "011" AND
                                 slave_write_data(5) = '1' ELSE '0';
   s_startsingleimage<= '1' WHEN slave_we = '1' AND
                                 slave_cs = '1' AND
                                 slave_address = "011" AND
                                 slave_write_data(3) = '1' ELSE '0';
   s_quad_buffering  <= s_MemoryPointer1_reg(32) AND s_MemoryPointer2_reg(32) AND
                        s_MemoryPointer3_reg(32) AND s_MemoryPointer1_reg(32);

--------------------------------------------------------------------------------
---                                                                          ---
--- In this section the components are mapped                                ---
---                                                                          ---
--------------------------------------------------------------------------------
   profile : frame_interpreter
      PORT MAP ( Clock                  => Clock     ,
                 Reset                  => Reset,
                 PixelClk               => PixelClk,
                 HSync                  => HSync,
                 VSync                  => VSync,
                 CamResetBar            => s_control_reg(0),
                 nr_of_bytes_each_line  => s_nr_of_bytes_each_line,
                 nr_of_lines            => s_nr_of_lines,
                 frameRate              => s_frame_rate,
                 DataValid              => s_profiling_valid,
                 NextFrame              => s_NextFrame,
                 NextLinePxlClk         => s_NextLinePxlClk,
                 NextLine               => s_NextLine);

   pxlif : pixel_interface
      PORT MAP ( Clock          => Clock     ,
                 Reset          => s_PixelIFReset,
                 PixelClk       => PixelClk,
                 NextLinePxlClk => s_NextLinePxlClk,
                 NextLine       => s_NextLine,
                 CamData        => DataIn,
                 HSync          => HSync,
                 PixelData      => s_PixelData,
                 Pop            => s_Pop,
                 NrOfWords      => s_NrOfWords);
   
   dma : cam_dma_ctrl
      PORT MAP ( Clock                    => Clock     ,
                 Reset                    => Reset,
                 CamRstBar                => s_control_reg(0),
                 PixelIFReset             => s_PixelIFReset,
                 NextLine                 => s_NextLine,
                 NextFrame                => s_NextFrame,
                 PixelData                => s_PixelData,
                 NrOfWords                => s_NrOfWords,
                 Pop                      => s_Pop,
                 startstreaming           => s_startstreaming,
                 stopstreaming            => s_stopstreaming,
                 startsingleimage         => s_startsingleimage,
                 quad_buffering           => s_quad_buffering,
                 MemoryPointer1           => s_MemoryPointer1_reg,
                 MemoryPointer2           => s_MemoryPointer2_reg,
                 MemoryPointer3           => s_MemoryPointer3_reg,
                 MemoryPointer4           => s_MemoryPointer4_reg,
                 CurrentImagePointer      => s_CurrentImagePointer,
                 CoreBusy                 => s_CoreBusy,
                 GenIrq                   => s_GenIrq,
                 InStreamingMode          => s_InStreamingMode,
                 -- master avalon interface
                 master_address           => master_address,
                 master_we                => master_we,
                 master_write_data        => master_write_data,
                 master_burst_count       => master_burst_count,
                 master_wait_req          => master_wait_req);

END MSE;
