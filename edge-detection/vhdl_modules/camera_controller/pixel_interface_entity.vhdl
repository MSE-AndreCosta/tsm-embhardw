LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY pixel_interface IS
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
END pixel_interface;
