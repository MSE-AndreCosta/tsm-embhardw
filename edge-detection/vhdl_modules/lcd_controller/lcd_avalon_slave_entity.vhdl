LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY lcd_avalon_slave IS
   PORT ( -- Here the internal interface is defined
          Clock                 : IN  std_logic;
          Reset                 : IN  std_logic;
          
          -- Here the avalon slave interface is defined
          slave_address         : IN  std_logic_vector( 1 DOWNTO 0 );
          slave_cs              : IN  std_logic;
          slave_we              : IN  std_logic;
          slave_rd              : IN  std_logic;
          slave_write_data      : IN  std_logic_vector(31 DOWNTO 0 );
          slave_read_data       : OUT std_logic_vector(31 DOWNTO 0 );
          slave_wait_request    : OUT std_logic;
          

          -- Here the external LCD-panel signals are defined
          ChipSelectBar         : OUT std_logic;
          DataCommandBar        : OUT std_logic;
          WriteBar              : OUT std_logic;
          ReadBar               : OUT std_logic;
          ResetBar              : OUT std_logic;
          IM0                   : OUT std_logic;
          DataBus               : INOUT std_logic_vector( 15 DOWNTO 0 ));
END lcd_avalon_slave;

     -------- register model -----------
     -- 00  write: Write a command to LCD
     --     read :  Read a command from LCD
     -- 01  write: Write data to LCD
     --     read : Read data from LCD
     -- 10  r/w  : Control register
     --            bit 0  => Select 0 => Sixteen bit transfer
     --                      Select 1 => Eight bit transfer
     --            bit 1  => Busy flag (read only)
     --                      Reset LCD Display (write only)
     --            others => 0
