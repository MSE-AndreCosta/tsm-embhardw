-- VHDL Custom Instruction Template File for Internal Register Logic
library ieee;
use ieee.std_logic_1164.all;

entity rgb_to_grayscale_2 is
port(
	signal dataa: in std_logic_vector(31 downto 0);-- Operand A (always required)
	signal result: out std_logic_vector(31 downto 0)-- result (always required)
);
end entity rgb_to_grayscale_2;

architecture rgb_to_grayscale_2 of rgb_to_grayscale_2 is
begin

	result(15 downto 0 )<= dataa(26 downto 21) & "00" &
			       dataa(10 downto 5) & "00";

end architecture rgb_to_grayscale_2;
