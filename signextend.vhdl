library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity SignExtend is
	generic (WORD: integer :=  16; IMMED: integer := 6);
	port (
		CLK: in std_logic;
		
		Immediate_in: in std_logic_vector(IMMED - 1 downto 0);
		Immediate_out: out std_logic_vector(WORD - 1 downto 0)
	);
end SignExtend;

architecture extend of SignExtend is
begin
	process (CLK)
	begin
		if rising_edge(CLK) then 
			Immediate_out <= (others => '0');
			Immediate_out(WORD - 1) <= Immediate_in(IMMED - 1);
			Immediate_out(IMMED - 2 downto 0) <= Immediate_in(IMMED - 2 downto 0);
		end if;
	end process;
end architecture extend;
