library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity RegFile is
	generic (WORD: integer := 16; REG: integer := 3);
  	port (
    	CLK: in std_logic; -- CLOCK
    	RST: in std_logic; -- RESET

    	-- inputs
    	read1: in std_logic_vector(REG - 1 downto 0); -- register 1 address
    	read2: in std_logic_vector(REG - 1 downto 0); -- register 2 address
    	writeAddr: in std_logic_vector(REG - 1 downto 0); -- write register address
    	writeData: in std_logic_vector(WORD - 1 downto 0); -- data to be written
    	RegWrite: in std_logic; -- regWrite control

    	-- outputs
    	data1: out std_logic_vector(WORD - 1 downto 0); -- register 1 data
    	data2: out std_logic_vector(WORD - 1 downto 0) -- register 2 data
  	);
end entity RegFile;

architecture reg of RegFile is
type memory is array (0 to 7) of std_logic_vector(WORD - 1 downto 0); -- declare registers
signal mem : memory; -- But why does it have to be that way? Why are we still using this crap?
begin
	mem(0) <= (others => '0');
	process (CLK) is
		variable tRD1, tRD2, tWR: integer; -- variable for read1, read2, and writeReg, respectively
	begin
		tRD1 := to_integer(unsigned(read1));
		tRD2 := to_integer(unsigned(read2));
		tWR := to_integer(unsigned(writeAddr));
		if rising_edge(CLK) then
			if RST = '1' then
				for i in 0 to 7 loop
					mem(i) <= (others => '0');
				end loop;
			end if;
			
			if tWR /= 0 then
					if RegWrite = '1' then
						mem(tWR) <= writeData;
					end if;
			end if;

			if tRD1 = 0 then data1 <= (others => '0'); -- if addressing $r0 give $r0
				else data1 <= mem(tRD1); -- else read that data
			end if;

			if tRD2 = 0 then data2 <= (others => '0');
				else data2 <= mem(tRD2);
			end if;

		end if;
	end process;
end architecture reg;
