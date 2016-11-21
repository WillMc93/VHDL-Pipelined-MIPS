library IEEE;
use ieee.std_logic_1164.all;

entity EX is
	generic (ALUOP: integer; JUMPOP: integer);
	port (
		CLK: in std_logic;
    	RST: in std_logic;

    	-- inputs
		ALUSrc_in: in std_logic;
		RegDest_in: in std_logic;
		ALUOP_in: in std_logic_vector(ALUOP - 1 downto 0);
		JumpOP_in: in std_logic_vector(JUMPOP - 1 downto 0);
		Branch_in: in std_logic;
		BranchType_in: in std_logic;

		-- outputs
		ALUSrc_out: out std_logic;
		RegDest_out: out std_logic;
		ALUOP_out: out std_logic_vector(ALUOP - 1 downto 0);
		JumpOP_out: out std_logic_vector(JUMPOP - 1 downto 0);
		Branch_out: out std_logic;
		BranchType_out: out std_logic
  	);
end entity EX;

architecture execute of EX is
begin
	process (CLK) is
		begin
			if rising_edge(CLK) then
				if RST = '1' then
					ALUSrc_out <= '0';
					RegDest_out <= '0';
					ALUOP_out <= (others => '0');
					JumpOP_out <= (others => '0');
					Branch_out <= '0';
					BranchType_out <= '0';
				else
					ALUSrc_out <= ALUSrc_in;
					RegDest_out <= RegDest_in;
					ALUOP_out <= ALUOP_in;
					JumpOP_out <= JumpOP_in;
					Branch_out <= Branch_in;
					BranchType_out <= BranchType_in;
      			end if;
    		end if;
		end process;
end architecture execute;
