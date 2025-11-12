LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY i2c_start_stop IS
   PORT ( clock        : IN  std_logic;
          reset        : IN  std_logic;
          tick         : IN  std_logic;
          activate     : IN  std_logic;
          idle_state   : OUT std_logic;
          active_state : OUT std_logic;
          SDA          : OUT std_logic;
          SCL          : OUT std_logic);
END i2c_start_stop;

