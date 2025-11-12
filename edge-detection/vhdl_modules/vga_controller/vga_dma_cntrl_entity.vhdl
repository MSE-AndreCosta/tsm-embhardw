LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY vga_dma_cntrl IS
   PORT ( clock              : IN  std_logic;
          PixelClock         : IN  std_logic;
          Reset              : IN  std_logic;
          
          MemoryPointer      : IN  std_logic_vector( 31 DOWNTO 2 );
          NextLine           : IN  std_logic;
          NextFrame          : IN  std_logic;
          GrayScale          : IN  std_logic;
          PixelIndex         : IN  std_logic_vector(  9 DOWNTO 0 );
          NrOfPixelsEachLine : IN  std_logic_vector( 10 DOWNTO 0 );
          RGB565Data         : OUT std_logic_vector( 15 DOWNTO 0 );
          
          -- Here the Avalon Master Interface is defined
          master_address     : OUT std_logic_vector( 31 DOWNTO 0 );
          master_read        : OUT std_logic;
          master_burstcount  : OUT std_logic_vector(  9 DOWNTO 0 );
          master_waitrequest : IN  std_logic;
          master_data_valid  : IN  std_logic;
          master_read_data   : IN  std_logic_vector( 31 DOWNTO 0 ));
END vga_dma_cntrl;
