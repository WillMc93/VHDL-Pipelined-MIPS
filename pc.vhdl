library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity PC is
	generic (ADDR: integer := 10);
	port (
		CLK: in std_logic;
		RST: in std_logic;

		PC_in: in std_logic_vector(ADDR - 1 downto 0);
		PCSrc: in std_logic;
		--JAL: in std_logic;
		--JR: in std_logic;

		PC1_out: out std_logic_vector(ADDR - 1 downto 0);
		PC_out: out std_logic_vector(ADDR - 1 downto 0)
	);
end entity PC;

architecture counter of PC is
	signal PC_next: std_logic_vector(ADDR - 1 downto 0) := (others => '0');
	--signal rA: std_logic_vector(ADDR - 1 downto 0) := (others => '0');
begin
	process (CLK)
	begin
		if rising_edge(CLK) then -- doesn't cover for error states
			if RST = '1' then
				PC_next <= (others => '0');
				--rA <= (others => '0');
				PC_out <= (others => '0');
				PC1_out <= std_logic_vector(unsigned(PC_next) + 1);
			elsif PCSrc = '1' then
				--if JAL = '1' then
				--	rA <= PC_next;
				--end if;
				PC_out <= PC_in;
				PC1_out <= std_logic_vector(unsigned(PC_in) + 1);
				PC_next <= std_logic_vector(unsigned(PC_in) + 1);
				
			--elsif JR = '1' then
			--	PC_out <= rA;
			--	PC1_out <= std_logic_vector(unsigned(rA) + 1);
			--	PC_next <= std_logic_vector(unsigned(rA) + 1);
			else
				PC_out <= PC_next;
				PC1_out <= std_logic_vector(unsigned(PC_next) + 1);
				PC_next <= std_logic_vector(unsigned(PC_next) + 1);
			end if;
		end if;
	end process;
end architecture counter;
