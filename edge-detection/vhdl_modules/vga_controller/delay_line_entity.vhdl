LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY delay_line IS
   GENERIC ( nr_of_elements : INTEGER := 2;     -- must be at least 2!
             reset_value    : std_logic := '0'); 
   PORT ( clock     : IN  std_logic;
          reset     : IN  std_logic;
          value_in  : IN  std_logic;
          value_out : OUT std_logic );
END delay_line;
