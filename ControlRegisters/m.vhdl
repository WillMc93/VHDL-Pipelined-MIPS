library IEEE;
use ieee.std_logic_1164.all;

entity M is
	port (
		CLK: in std_logic;
	    RST: in std_logic;

	    -- inputs
	    MemWrite_in: in std_logic;
	    MemRead_in: in std_logic;

	    -- outputs
	    MemWrite_out: out std_logic;
		MemRead_out: out std_logic
	);
end entity M;

architecture reg of M is
begin
	process (CLK) is
	begin
    	if rising_edge(CLK) then
			if RST = '1' then
        		MemRead_out <= '0';
        		MemWrite_out <= '0';

			else
        		MemRead_out <= MemRead_in;
        		MemWrite_out <= MemWrite_in;
      		end if;
		end if;
	end process;
end architecture reg;
