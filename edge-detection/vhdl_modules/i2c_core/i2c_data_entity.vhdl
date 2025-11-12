LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY i2c_data IS
PORT ( clock      : IN  std_logic;
       reset      : IN  std_logic;
       tick       : IN  std_logic;
       data_in    : IN  std_logic_vector( 7 DOWNTO 0 );
       start      : IN  std_logic;
       ack_bit    : IN  std_logic;
       data_out   : OUT std_logic_vector( 7 DOWNTO 0 );
       idle       : OUT std_logic;
       SDA_out    : OUT std_logic;
       SDA_in     : IN  std_logic;
       SCL        : OUT std_logic;
       ACK_ERROR  : OUT std_logic );
END i2c_data;

