library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity InstrMem is
	generic(WORD: integer := 16; ADDR: integer := 10);
	port (
		CLK: in std_logic;
		PC_in: in std_logic_vector(ADDR - 1 downto 0);

		Instr_out: out std_logic_vector(WORD - 1 downto 0)
	);
end entity InstrMem;

architecture instruct of InstrMem is
	type memory is array (0 to 1024) of std_logic_vector(WORD - 1 downto 0);
	signal mem: memory;
begin
	process (CLK)
		variable addr: integer;
	begin
		addr := to_integer(unsigned(PC_in));
		if rising_edge(CLK) then
			case addr is
									--	OOOOSSSTTTDDDFFF	
				when 0 => Instr_out <= "0000000000000000";  -- intentionally left blank
				when 1 => Instr_out <= "0001000111001010"; -- set register $7 to 10
				when 2 => Instr_out <= "0001000001000001"; -- set register $1 to 1
				when 8 => Instr_out <= "1001111001010101"; -- beq $7, $1, 21
				when 9 => Instr_out <= "0000001001001001"; -- increment $1
				when 15 => Instr_out <= "1100000000110111";	-- jump back to right before the beq
				when 21 => Instr_out <= "1100000000101011"; -- do it again
				when others => Instr_out <= (others => '0');
			end case;
		end if;
	end process;
end architecture instruct;
