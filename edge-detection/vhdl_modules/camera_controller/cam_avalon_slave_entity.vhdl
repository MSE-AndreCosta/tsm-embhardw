LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY cam_simple IS
   PORT ( -- Here the internal interface is defined
          Clock                 : IN  std_logic;
          Reset                 : IN  std_logic;
          
          -- Here the avalon slave interface is defined
          slave_address         : IN  std_logic_vector( 1 DOWNTO 0 );
          slave_cs              : IN  std_logic;
          slave_we              : IN  std_logic;
          slave_write_data      : IN  std_logic_vector(31 DOWNTO 0 );
          slave_read_data       : OUT std_logic_vector(31 DOWNTO 0 );
          
          -- Here the camera interface is defined
          PixelClk              : IN  std_logic;
          HSync                 : IN  std_logic;
          VSync                 : IN  std_logic;
          DataIn                : IN  std_logic_vector( 9 DOWNTO 0 );
          ResetBar              : OUT std_logic;
          PowerDown             : OUT std_logic);
END cam_simple;

     -------- register model -----------
     -- 00 Nr. of bytes each line (read only)
     -- 01 Nr. of lines each frame (read only)
     -- 10 Nr. of frames each second (read only)
     -- 11 Control register
     --    bit 0 => Reset bit (1 -> reset, 0 -> no reset)
     --    bit 1 => Power down bit (0 -> normal operation, 1 -> Pwr down)
     --    bit 2 => Profiling data valid bit (read only)
