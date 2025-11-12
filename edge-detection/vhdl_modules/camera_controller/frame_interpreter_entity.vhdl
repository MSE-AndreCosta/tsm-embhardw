LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY frame_interpreter IS
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
END frame_interpreter;
