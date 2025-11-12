LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY dma_controller_lcd IS
   PORT ( -- Here the internal interface is defined
          Clock                       : IN  std_logic;
          Reset                       : IN  std_logic;
          Start                       : IN  std_logic;
          StartAddress                : IN  std_logic_vector(31 DOWNTO 2);
          BurstSize                   : IN  std_logic_vector( 7 DOWNTO 0);
          busy                        : OUT std_logic;
          empty                       : OUT std_logic;
          pop                         : IN  std_logic;
          DataOut                     : OUT std_logic_vector(31 DOWNTO 0);
          
          -- master avalon interface
          master_address              : OUT std_logic_vector(31 DOWNTO 0 );
          master_read                 : OUT std_logic;
          master_burst_count          : OUT std_logic_vector( 7 DOWNTO 0 );
          master_read_data            : IN  std_logic_vector(31 DOWNTO 0 );
          master_read_data_valid      : IN  std_logic;
          master_wait_request         : IN  std_logic);
END dma_controller_lcd;
          
