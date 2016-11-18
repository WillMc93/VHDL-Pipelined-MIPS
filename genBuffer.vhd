library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity genBuffer is
	generic(length: integer);
	port (
		CLK: in std_logic;
		inp: in std_logic_vector(length - 1 downto 0);
		outp: out std_logic_vector(length - 1 downto 0)
	);
end genBuffer;


architecture buffet of genBuffer is
begin
	process(CLK)
	begin
		if rising_edge(CLK) then
			outp <= inp;
		end if;
	end process;
end buffet;
