-- ALU2 encapsulates the ALU with its control circuits
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ALU is
	generic (WORD: integer := 16; ALUOP: integer := 3);
	port (
		CLK: in std_logic;

		Data1: in std_logic_vector(WORD - 1 downto 0);
		Data2: in std_logic_vector(WORD - 1 downto 0);
		Immed: in std_logic_vector(WORD - 1 downto 0);

		ALUSrc: in std_logic;
		Func: in std_logic_vector(ALUOP - 1 downto 0);
		ALUOP_in: in std_logic_vector(ALUOP - 1 downto 0); 

		result: out std_logic_vector(WORD - 1 downto 0);
		ZERO: out std_logic
	);
end entity ALU;

architecture arith of ALU is
		--signal tResult: std_logic_vector(WORD - 1 downto 0);
	begin
		process (CLK)
		variable tResult: std_logic_vector(WORD - 1 downto 0) := (others => '0');
		variable tFunc: std_logic_vector(ALUOP - 1 downto 0);
		variable A: std_logic_vector(WORD - 1 downto 0);
		variable B: std_logic_vector(WORD - 1 downto 0);
		variable X: std_logic_vector(WORD - 1 downto 0);
		--variable ones: std_logic_vector(WORD - 1 downto 0) := (others => '1');
		begin
			if rising_edge(CLK) then 
				--tResult := (others => '0');
				-- determine the operation
				if ALUOP_in = "000" then -- if R-type
					tFunc := Func;
				else
					tFunc := ALUOP_in; -- if not R-type
				end if;

				-- determine A and B
				A := Data1;
				if ALUSrc = '1' then
					B := Immed;
				else
					B := Data2;
				end if;

				-- do the operation
				if tFunc = "001" then -- add/addi
					tResult := std_logic_vector(signed(A) + signed(B));
				elsif tFunc = "010" then -- sub/subi
					tResult := std_logic_vector(signed(A) - signed(B));
				elsif tFunc = "100" then -- and
					tResult := A AND B;
				elsif tFunc = "101" then -- or
					tResult := A OR B;
				elsif tFunc = "110" then -- nor
					tResult := A NOR B;
				elsif tFunc = "111" and signed(A) < signed(B) then -- set-less-than
					tResult := (others => '0');
					tResult(0) := '1';
				else -- if not one of the others, do nothing
					--tResult := (others => '1');
				end if;
				ZERO <= '1';
				result <= tResult;
			end if;
		end process;
		--result <= tResult;
  end architecture arith;
