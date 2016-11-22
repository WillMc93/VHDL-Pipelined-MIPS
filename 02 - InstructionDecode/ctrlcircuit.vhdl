library IEEE;
use IEEE.std_logic_1164.all;

-- Control Circuits
entity CtrlCircuit is
	generic (OP: integer := 4); -- length of OPCode
	port (
		-- input port
		Instr: in std_logic_vector (OP - 1 downto 0);

		-- output port
		RegDest: out std_logic := '0'; -- start at 0
		ALUSrc: out std_logic := '0';
		MemToReg: out std_logic := '0';
		RegWrite: out std_logic := '0';
		MemRead: out std_logic := '0';
		MemWrite: out std_logic := '0';
		Branch: out std_logic := '0';
		BranchType: out std_logic := '0';
		JumpOP: out std_logic_vector (2 downto 0):= (others => '0'); -- easier to manage
		ALUOP: out std_logic_vector (2 downto 0) := (others => '0') -- easier to manage
	);
end entity CtrlCircuit;

architecture RTL of CtrlCircuit is
begin
	process (Instr)
	begin
		if Instr = "0000" then -- R-tyepes
				RegDest <= '1';
				ALUSrc <= '0';
				MemToReg <= '1';
				RegWrite <= '1';
				MemRead <= '0';
				MemWrite <= '0';
				Branch <= '0';
				BranchType <= '0';
				JumpOP <= "000";
				ALUOP <= "000";

		elsif Instr = "0001" or Instr = "0010" then -- addi/subi
				RegDest <= '0';
				ALUSrc <= '1';
				MemToReg <= '1';
				RegWrite <= '1';
				MemRead <= '0';
				MemWrite <= '0';
				Branch <= '0';
				BranchType <= '0';
				JumpOP <= "000";
				if Instr = "0001" then
					ALUOP <= "001";
				else
					ALUOP <= "010";
				end if;

			elsif Instr = "0100" then -- lw
				RegDest <= '0';
				ALUSrc <= '1';
				MemToReg <= '0';
				RegWrite <= '1';
				MemRead <= '1';
				MemWrite <= '0';
				Branch <= '0';
				BranchType <= '0';
				JumpOP <= "000";
				ALUOP <= "001";

			elsif Instr = "0101" then -- sw
				RegDest <= '0';
				ALUSrc <= '1';
				MemToReg <= 'X';
				RegWrite <= 'X';
				MemRead <= '0';
				MemWrite <= '1';
				Branch <= '0';
				BranchType <= '0';
				JumpOP <= "000";
				ALUOP <= "001";

			elsif Instr = "1000" or Instr = "1001" then --bne/beq
				RegDest <= 'X';
				ALUSrc <= '0';
				MemToReg <= 'X';
				RegWrite <= '0';
				MemRead <= 'X';
				MemWrite <= '0';
				Branch <= '1';
				if Instr = "1000" then
					BranchType <= '0';
				else
					BranchType <= '1';
				end if;
				JumpOP <= "000";
				ALUOP <= "010";

			elsif Instr = "1100" then -- J
				RegDest <= 'X';
				ALUSrc <= 'X';
				MemToReg <= 'X';
				RegWrite <= '0';
				MemRead <= 'X';
				MemWrite <= '0';
				Branch <= '0';
				BranchType <= '0';
				JumpOP <= "100";
				ALUOP <= "000";

			elsif Instr = "1101" then-- JAL
				RegDest <= 'X';
				ALUSrc <= 'X';
				MemToReg <= 'X';
				RegWrite <= '0';
				MemRead <= 'X';
				MemWrite <= '0';
				Branch <= '0';
				BranchType <= '0';
				JumpOP <= "010";
				ALUOP <= "000";

			elsif Instr = "1110" then -- JR
				RegDest <= 'X';
				ALUSrc <= 'X';
				MemToReg <= 'X';
				RegWrite <= '0';
				MemRead <= 'X';
				MemWrite <= '0';
				Branch <= '0';
				BranchType <= '0';
				JumpOP <= "001";
				ALUOP <= "000";

			else
				RegDest <= '0';
				ALUSrc <= '0';
				MemToReg <= '0';
				RegWrite <= '0';
				MemRead <= '0';
				MemWrite <= '0';
				Branch <= '0';
				BranchType <= '0';
				JumpOP <= "000";
				ALUOP <= "000";
		end if;
	end process;
end architecture RTL;
