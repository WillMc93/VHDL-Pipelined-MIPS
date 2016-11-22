library IEEE;
use IEEE.std_logic_1164.all;

entity IF_IDReg is
	generic(WORD: integer := 16); -- define WORD length
	port (
		CLK: in std_logic;
		RST: in std_logic;
		PC_in: in std_logic_vector(WORD - 1 downto 0);
		Instr_in: in std_logic_vector(WORD - 1 downto 0);

		PC_out: out std_logic_vector(WORD - 1 downto 0);
		Instr_out: out std_logic_vector(WORD - 1 downto 0)
	);
end entity IF_IDReg;

architecture run of IF_IDReg is
begin
	process(CLK)
	begin
		if rising_edge(CLK) then
			if RST = '1' then -- synchronous reset
				PC_out <= (others => '0');
				Instr_out <= (others => '0');
			else
				PC_out <= PC_in;
				Instr_out <= Instr_in;
			end if;
		end if;
	end process;
end architecture run;
