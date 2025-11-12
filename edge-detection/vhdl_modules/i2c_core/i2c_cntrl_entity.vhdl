LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY i2c_cntrl IS
   PORT ( clock      : IN  std_logic; -- Assumed a 50MHz clock
          reset      : IN  std_logic;
          start      : IN  std_logic;
          device_id  : IN  std_logic_vector( 7 DOWNTO 0 );
          address    : IN  std_logic_vector(15 DOWNTO 0 );
          data       : IN  std_logic_vector(15 DOWNTO 0 );
          prescale   : IN  std_logic_vector( 7 DOWNTO 0 );
          data_out   : OUT std_logic_vector(31 DOWNTO 0 );
          two_phase  : IN  std_logic;
          four_data  : IN  std_logic;
          short_tran : IN  std_logic;
          SDA_out    : OUT std_logic;
          SDA_in     : IN  std_logic;
          SCL        : OUT std_logic;
          busy       : OUT std_logic;
          ACK_ERRORs : OUT std_logic_vector( 2 DOWNTO 0 ));
END i2c_cntrl;

