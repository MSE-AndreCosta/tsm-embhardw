library ieee;
use ieee.std_logic_1164.all;

entity parallelport is
	generic(
		N: natural := 32
	);
	port(
		-- avalon interfaces signals
		clk : in std_logic;
		nreset : in std_logic;
		address : in std_logic_vector (2 downto 0);
		chipselect : in std_logic;
		read : in std_logic;
		write : in std_logic;
		readdata: out std_logic_vector (N - 1 downto 0);
		writedata : in std_logic_vector (N - 1 downto 0);
		-- parallel port external interface

		parport : inout std_logic_vector (N - 1 downto 0)
	);
end parallelport;

architecture comp of parallelport is
	signal iregdir : std_logic_vector (N - 1 downto 0);
	signal iregport: std_logic_vector (N - 1 downto 0);
	signal iregpin : std_logic_vector (N - 1 downto 0);
	signal reset: std_logic;
begin

	reset <= not nreset;
	register_write: process(clk,reset) begin
		if reset = '1' then
			iregdir <= (others => '0');
		elsif rising_edge(clk) then
			if chipselect = '1' and write = '1' then
				case address(2 downto 0) is
					when "000" => iregdir <= writedata;
					when "010" => iregport <= writedata;
					when "011" => iregport <= iregport or writedata;
					when "100" => iregport <= iregport and not writedata;
					when others => null;
				end case;
			end if;
		end if;
	end process;

	register_read: process(Clk)
	begin
		if rising_edge(Clk) then
			readdata <= (others => '0');
			if chipselect = '1' and read = '1' then
				case address(2 downto 0) is
					when "000" => readdata <= iregdir;
					when "001" => readdata <= iregpin;
					when "010" => readdata <= iregport;
					when others => null;
				end case;
			end if;
		end if;
	end process;

	pport: process(iregdir, iregport)
	begin
		for i in 0 to N - 1 loop
			if iregdir(i) = '1' then
				parport(i) <= iregport(i);
			else
				parport(i) <= 'Z';
			end if;
		end loop;
	end process;

	-- parallel port input value
	iregpin <= parport;
end comp;
