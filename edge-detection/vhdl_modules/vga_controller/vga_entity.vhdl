LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY vga_controller IS
   GENERIC( H_VISABLE_AREA        : INTEGER := 800;
            H_Front_Porch         : INTEGER := 56;
            H_Sync_Pulse          : INTEGER := 120;
            H_Back_Porch          : INTEGER := 64;
            H_Sync_active_value   : std_logic := '1';
            V_VISABLE_AREA        : INTEGER := 600;
            V_Front_Porch         : INTEGER := 37;
            V_Sync_Pulse          : INTEGER := 6;
            V_Back_Porch          : INTEGER := 23;
            V_Sync_active_value   : std_logic := '1';
            vhsync_delay_elements : INTEGER := 8);
   PORT ( pixel_clock        : IN  std_logic;
          reset              : IN  std_logic;
          
          rgb565in           : IN  std_logic_vector(15 DOWNTO 0 );
          swaprb             : IN  std_logic;
          next_line          : OUT std_logic;
          next_frame         : OUT std_logic;
          NrOfPixelsEachLine : OUT std_logic_vector( 10 DOWNTO 0 );
          PixelIndex         : OUT std_logic_vector(  9 DOWNTO 0 );
          testscreen         : IN  std_logic;
          QuarterScreen      : IN  std_logic;
          FlipX              : IN  std_logic;
          
          red                : OUT std_logic_vector( 9 DOWNTO 0 );
          green              : OUT std_logic_vector( 9 DOWNTO 0 );
          blue               : OUT std_logic_vector( 9 DOWNTO 0 );
          hsync              : OUT std_logic;
          vsync              : OUT std_logic);
END vga_controller;
