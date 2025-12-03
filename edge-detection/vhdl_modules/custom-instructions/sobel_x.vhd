library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sobel_x is
port(
    signal dataa: in std_logic_vector(31 downto 0); -- [top_right, top_left, middle_right, middle_left]
    signal datab: in std_logic_vector(31 downto 0); -- [unused, unused, bottom_right, bottom_left]
    signal result: out std_logic_vector(31 downto 0) -- x_result in bits 15 downto 0
);
end entity sobel_x;

architecture sobel_x_arch of sobel_x is
    signal top_left, top_right: signed(8 downto 0);
    signal middle_left, middle_right: signed(9 downto 0);
    signal bottom_left, bottom_right: signed(8 downto 0);
    signal x_result: signed(15 downto 0);
begin
    top_left <= signed('0' & dataa(7 downto 0));
    top_right <= signed('0' & dataa(23 downto 16));
    middle_left <= signed("00" & dataa(15 downto 8));
    middle_right <= signed("00" & dataa(31 downto 24));
    bottom_left <= signed('0' & datab(7 downto 0));
    bottom_right <= signed('0' & datab(15 downto 8));
    
    -- x_result = -top_left + top_right - (middle_left << 1) + (middle_right << 1) - bottom_left + bottom_right
    x_result <= resize(-top_left, 16) + resize(top_right, 16) - 
                resize(middle_left & '0', 16) + resize(middle_right & '0', 16) - 
                resize(bottom_left, 16) + resize(bottom_right, 16);
    
    result(15 downto 0) <= std_logic_vector(x_result);
end architecture sobel_x_arch;

