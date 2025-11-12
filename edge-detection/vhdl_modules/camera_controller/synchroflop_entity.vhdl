LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY synchro_flop IS
   PORT ( clock_in    : IN  std_logic;
          clock_out   : IN  std_logic;
          reset       : IN  std_logic;
          tick_in     : IN  std_logic;
          tick_out    : OUT std_logic);
END synchro_flop;

