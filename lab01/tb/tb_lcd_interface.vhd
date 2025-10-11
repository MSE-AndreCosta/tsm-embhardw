library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_lcd_interface is
end tb_lcd_interface;

architecture test of tb_lcd_interface is
  constant N : natural := 16;
  
  signal clk : std_logic := '0';
  signal nreset : std_logic := '1';
  signal address : std_logic_vector(2 downto 0) := (others => '0');
  signal chipselect : std_logic := '0';
  signal read : std_logic := '0';
  signal write : std_logic := '0';
  signal readdata : std_logic_vector(N-1 downto 0);
  signal writedata : std_logic_vector(N-1 downto 0) := (others => '0');
  signal waitrequest : std_logic;
  
  signal lcd_data : std_logic_vector(N-1 downto 0);
  signal lcd_ncd : std_logic;
  signal lcd_nwr : std_logic;
  signal lcd_nrd : std_logic;

  component lcd_interface
    generic(N : natural := 16);
    port(
      clk : in std_logic;
      address : in std_logic_vector(2 downto 0);
      chipselect : in std_logic;
      nreset : in std_logic;
      read : in std_logic;
      write : in std_logic;
      readdata : out std_logic_vector(N-1 downto 0);
      writedata : in std_logic_vector(N-1 downto 0);
      waitrequest : out std_logic;
      lcd_data : inout std_logic_vector(N-1 downto 0);
      lcd_ncd : out std_logic;
      lcd_nwr : out std_logic;
      lcd_nrd : out std_logic
    );
  end component;

begin
  DUT: lcd_interface
    generic map(N => N)
    port map(
      clk => clk,
      nreset => nreset,
      address => address,
      chipselect => chipselect,
      read => read,
      write => write,
      readdata => readdata,
      writedata => writedata,
      waitrequest => waitrequest,
      lcd_data => lcd_data,
      lcd_ncd => lcd_ncd,
      lcd_nwr => lcd_nwr,
      lcd_nrd => lcd_nrd
    );

end test;
