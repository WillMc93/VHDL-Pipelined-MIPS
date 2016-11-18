library IEEE;
use IEEE.std_logic_1164.all;

entity genMux is
	generic (length: integer);
	port (
		I0, I1: in std_logic_vector(length - 1 downto 0);
		Sel: in std_logic;

		Outp: out std_logic_vector(length - 1 downto 0)
	);
end entity genMux;

architecture mux of genMux is
begin
	with Sel select Outp <=
		I0 when '0',
		I1 when '1',
		(others => '0') when others;
end architecture mux;
