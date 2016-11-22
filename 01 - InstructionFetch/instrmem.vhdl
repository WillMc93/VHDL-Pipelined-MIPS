library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity InstrMem is
	generic(WORD: integer := 16; ADDR: integer := 10);
	port (
		PC_in: in std_logic_vector(ADDR - 1 downto 0);

		Instr_out: out std_logic_vector(WORD - 1 downto 0)
	);
end entity InstrMem;

architecture instruct of InstrMem is
	type memory is array (0 to 1024) of std_logic_vector(WORD - 1 downto 0);
	signal mem: memory;
begin
	process (PC_in)
		variable addr: integer;
	begin
		addr := to_integer(unsigned(PC_in));
			case addr is
				--  PC					OOOOSSSTTTDDDFFF
				when 0 => Instr_out <= "0000000000000000";  -- intentionally left blank
				when 1 => Instr_out <= "0001000111001010"; -- set register $7 to 10
				when 2 => Instr_out <= "0001000001000001"; -- set register $1 to 1
				when 6 => Instr_out <= "1001111001001000"; -- beq $7, $1, (PC+1+8)
				when 7 => Instr_out <= "0001001001000001"; -- increment $1 by 1
				when 11 => Instr_out <= "1100000000111010";	-- jump back to right before the beq
				when 15 => Instr_out <= "1100000000110001"; -- do it again j -15
				when others => Instr_out <= (others => '0');
			end case;
	end process;
end architecture instruct;
