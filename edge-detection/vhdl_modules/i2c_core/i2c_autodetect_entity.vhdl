LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY i2c_autodetect IS
   PORT ( clock         : IN  std_logic;
          reset         : IN  std_logic;
          start         : IN  std_logic;
          
          ack_errors    : IN  std_logic_vector( 2 DOWNTO 0 );
          i2c_busy      : IN  std_logic;
          start_i2cc    : OUT std_logic;
          i2c_did       : OUT std_logic_vector( 7 DOWNTO 0 );
          
          nr_of_devices : OUT std_logic_vector( 7 DOWNTO 0 );
          device_addr   : IN  std_logic_vector( 7 DOWNTO 0 );
          device_id     : OUT std_logic_vector( 7 DOWNTO 0 );
          
          busy          : OUT std_logic);
END i2c_autodetect;

