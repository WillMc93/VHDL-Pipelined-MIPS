library IEEE;
use IEEE.std_logic_1164.all;

entity genMux is
	generic (length: integer := 16);
	port (
		CLK: in std_logic;
		I0, I1: in std_logic_vector(length - 1 downto 0);
		Sel: in std_logic;

		Outp: out std_logic_vector(length - 1 downto 0)
	);
end entity genMux;

architecture mux of genMux is
begin
	process(CLK, I0, I1, Sel)
	begin
		case Sel is
			when '0' => Outp <= I0;
			when '1' => Outp <= I1;
			when others => Outp <= I0;
		end case;
	end process;
end architecture mux;
