ARCHITECTURE MSE OF cam_simple IS

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
   
   SIGNAL s_control_reg           : std_logic_vector( 1 DOWNTO 0);
   SIGNAL s_control_next          : std_logic_vector( 1 DOWNTO 0);
   SIGNAL s_nr_of_bytes_each_line : std_logic_vector(15 DOWNTO 0);
   SIGNAL s_nr_of_lines           : std_logic_vector(15 DOWNTO 0);
   SIGNAL s_frame_rate            : std_logic_vector( 7 DOWNTO 0);
   SIGNAL s_profiling_valid       : std_logic;

BEGIN
--------------------------------------------------------------------------------
---                                                                          ---
--- In this section the outputs are defined                                  ---
---                                                                          ---
--------------------------------------------------------------------------------
   ResetBar  <= s_control_reg(0);
   PowerDown <= s_control_reg(1);
   
   make_read_data : PROCESS( slave_address , s_nr_of_bytes_each_line ,
                             s_nr_of_lines , s_control_reg ,
                             s_profiling_valid )
   BEGIN
      CASE (slave_address) IS
         WHEN "00"   => slave_read_data <= X"0000"&s_nr_of_bytes_each_line;
         WHEN "01"   => slave_read_data <= X"0000"&s_nr_of_lines;
         WHEN "10"   => slave_read_data <= X"000000"&s_frame_rate;
         WHEN OTHERS => slave_read_data <= X"0000000"&'0'&s_profiling_valid&
                                           s_control_reg;
      END CASE;
   END PROCESS make_read_data;

--------------------------------------------------------------------------------
---                                                                          ---
--- In this section the control reg is defined                               ---
---                                                                          ---
--------------------------------------------------------------------------------
   s_control_next(0) <= '0' WHEN Reset = '1' ELSE
                        NOT(slave_write_data(0)) 
                            WHEN slave_we = '1' AND
                                 slave_cs = '1' AND
                                 slave_address = "11" ELSE
                        s_control_reg(0);
   s_control_next(1) <= '1' WHEN Reset = '1' ELSE
                        slave_write_data(1) 
                            WHEN slave_we = '1' AND
                                 slave_cs = '1' AND
                                 slave_address = "11" ELSE
                        s_control_reg(1);
   
   make_control_reg : PROCESS( Clock      )
   BEGIN
      IF (rising_edge(Clock     )) THEN
         s_control_reg <= s_control_next;
      END IF;
   END PROCESS make_control_reg;
   
--------------------------------------------------------------------------------
---                                                                          ---
--- In this section the profiling module is defined                          ---
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
                 NextFrame              => OPEN,
                 NextLinePxlClk         => OPEN,
                 NextLine               => OPEN);

END MSE;
