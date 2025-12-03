library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sobel_y is
port(
    signal dataa: in std_logic_vector(31 downto 0); -- [unused, top_right, top_middle, top_left]
    signal datab: in std_logic_vector(31 downto 0); -- [unused, bottom_right, bottom_middle, bottom_left]
    signal result: out std_logic_vector(31 downto 0)
);
end entity sobel_y;

architecture sobel_y_arch of sobel_y is
    signal top_left, top_middle, top_right: signed(9 downto 0);
    signal bottom_left, bottom_middle, bottom_right: signed(9 downto 0);
    signal y_result: signed(15 downto 0);
begin
    top_left <= signed("00" & dataa(7 downto 0));
    top_middle <= signed("00" & dataa(15 downto 8));
    top_right <= signed("00" & dataa(23 downto 16));
    bottom_left <= signed("00" & datab(7 downto 0));
    bottom_middle <= signed("00" & datab(15 downto 8));
    bottom_right <= signed("00" & datab(23 downto 16));
    
    -- y_result = top_left + (top_middle << 1) + top_right - bottom_left - (bottom_middle << 1) - bottom_right
    y_result <= resize(top_left, 16) + resize(top_middle & '0', 16) + resize(top_right, 16) - 
                resize(bottom_left, 16) - resize(bottom_middle & '0', 16) - resize(bottom_right, 16);
    
    result(15 downto 0) <= std_logic_vector(y_result);
end architecture sobel_y_arch;
