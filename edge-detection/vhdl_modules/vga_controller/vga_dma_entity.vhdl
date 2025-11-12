LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY vga_dma IS
   PORT ( Clock                       : IN  std_logic;
          PixelClock                  : IN  std_logic;
          Reset                       : IN  std_logic;
          
          -- Here the avalon slave interface is defined
          slave_address               : IN  std_logic;
          slave_cs                    : IN  std_logic;
          slave_we                    : IN  std_logic;
          slave_write_data            : IN  std_logic_vector(31 DOWNTO 0 );

          -- Here the Avalon Master Interface is defined
          master_address              : OUT std_logic_vector( 31 DOWNTO 0 );
          master_read                 : OUT std_logic;
          master_burstcount           : OUT std_logic_vector(  9 DOWNTO 0 );
          master_waitrequest          : IN  std_logic;
          master_data_valid           : IN  std_logic;
          master_read_data            : IN  std_logic_vector( 31 DOWNTO 0 );
          
          -- Here the vga interface is defined
          red                         : OUT std_logic_vector( 9 DOWNTO 0 );
          green                       : OUT std_logic_vector( 9 DOWNTO 0 );
          blue                        : OUT std_logic_vector( 9 DOWNTO 0 );
          hsync                       : OUT std_logic;
          vsync                       : OUT std_logic);
END vga_dma;
          
     -------- register model -----------
     -- 0 Write Only: Memory pointer (if written the core starts
     --                               automatically) 
     -- 1 Write Only: bit 0 -> Swap RB bit
     --               bit 2 -> TestScreen(1) Normal (0)
     --               bit 3 -> FlipX(1) Normal (0)
     --               bit 4 -> QuarterScreen(1) Normal (0)
     --               bit 5 -> Grayscale(1) Normal(0)

