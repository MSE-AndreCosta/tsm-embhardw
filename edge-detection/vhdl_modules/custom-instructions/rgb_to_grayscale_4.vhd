-- VHDL Custom Instruction Template File for Internal Register Logic
library ieee;
use ieee.std_logic_1164.all;

entity rgb_to_grayscale_4 is
port(
	signal dataa: in std_logic_vector(31 downto 0);-- Operand A (always required)
	signal datab: in std_logic_vector(31 downto 0);-- Operand B
	signal result: out std_logic_vector(31 downto 0)-- result (always required)
);
end entity rgb_to_grayscale_4;

architecture rgb_to_grayscale_4 of rgb_to_grayscale_4 is
begin

	result <= datab(26 downto 21) & "00" &
			       datab(10 downto 5) & "00" &
			       dataa(26 downto 21) & "00" &
			       dataa(10 downto 5) & "00";

end architecture rgb_to_grayscale_4;
