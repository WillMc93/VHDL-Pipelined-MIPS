library IEEE;
use ieee.std_logic_1164.all;

entity WB is
	port (
		CLK: in std_logic;
		RST: in std_logic;

		-- inputs
		MemToReg_in: in std_logic;
		RegWrite_in: in std_logic;

		-- outputs
		MemToReg_out: out std_logic;
		RegWrite_out: out std_logic
	);
end entity WB;

architecture reg of WB is
begin
	process (CLK) is
	begin
		if rising_edge(CLK) then
			if RST = '1' then
				RegWrite_out <= '0';
        		MemToReg_out <= '0';
			else
				RegWrite_out <= RegWrite_in;
        		MemToReg_out <= MemToReg_in;
			end if;
		end if;
	end process;
end architecture reg;
