library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity SignExtend is
	generic (WORD: integer :=  16; IMMED: integer := 6);
	port (
		Immediate_in: in std_logic_vector(IMMED - 1 downto 0);
		Immediate_out: out std_logic_vector(WORD - 1 downto 0)
	);
end SignExtend;

architecture extend of SignExtend is
begin
	process(Immediate_in)
	begin
		Immediate_out <= (others => Immediate_in(IMMED - 1)); -- copy LSB everywhere
		Immediate_out (IMMED - 1 downto 0) <= Immediate_in; -- copy the bits we actually want
	end process;
end architecture extend;
