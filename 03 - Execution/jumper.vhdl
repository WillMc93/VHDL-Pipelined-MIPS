library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Jumper is
	generic(ADDR: integer := 10; WORD: integer := 16);
	port (
		RST: in std_logic;

		Branch: in std_logic;
		BranchType: in std_logic;
		Jump: in std_logic;
		JAL_in: in std_logic;
		JR_in: in std_logic;

		PC: in std_logic_vector(ADDR - 1 downto 0);
		Data1: in std_logic_vector(WORD - 1 downto 0);
		Data2: in std_logic_vector(WORD - 1 downto 0);
		Immed: in std_logic_vector(ADDR - 1 downto 0);

		PC_out: out std_logic_vector(ADDR - 1 downto 0);
		PCSrc: out std_logic
	);
end entity Jumper;

architecture jmp of Jumper is
	signal rA: std_logic_vector(ADDR - 1 downto 0):= (others => '0');
begin
	process(RST, Branch, Jump, JAL_in, JR_in)
		variable PC_next: std_logic_vector(ADDR - 1 downto 0);
	begin
		if RST = '1' then
			PC_out <= (others => '0');
			PCSrc <= '0';
		else
			PC_next := std_logic_vector(unsigned(PC) + 1); -- PC + 1
			PC_next := std_logic_vector(signed(PC_next) + signed(Immed)); -- PC+1 + Immeditate
			if Jump = '1' then
				PC_out <= PC_next;
				PCSrc <= '1';

			elsif JAL_in = '1' then -- errors possible with this guy
				rA <= std_logic_vector(signed(PC_next) - signed(Immed)); -- set rA to PC + 1 
				PC_out <= PC_next;
				PCSrc <= '1';
				

			elsif JR_in = '1' then
				PC_out <= rA;
				PCSrc <= '1';

			elsif Branch = '1' then
				if (BranchType = '1') and (Data1 = Data2) then
					PC_out <= PC_next;
					PCSrc <= '1';
				elsif (BranchType = '0') and (Data1 /= Data2) then
					PC_out <= PC_next;
					PCSrc <= '1';
				else
					PCSrc <= '0';
				end if;

			else
				PCSrc <= '0';
			end if;

		end if;
	end process;
end architecture jmp;
