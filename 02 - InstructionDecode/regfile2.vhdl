library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity RegFile is
	generic (WORD: integer := 16; REG : integer := 3);
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
		data2: out std_logic_vector(WORD - 1 downto 0); -- register 2 data
		
		-- outputs for debug
		r1: out std_logic_vector(WORD - 1 downto 0);
		r2: out std_logic_vector(WORD - 1 downto 0);
		r3: out std_logic_vector(WORD - 1 downto 0);
		r4: out std_logic_vector(WORD - 1 downto 0);
		r5: out std_logic_vector(WORD - 1 downto 0);
		r6: out std_logic_vector(WORD - 1 downto 0);
		r7: out std_logic_vector(WORD - 1 downto 0)
	);
end entity RegFile;

architecture reg of RegFile is
type memory is array (0 to 7) of std_logic_vector(WORD - 1 downto 0); -- declare registers
signal mem : memory; -- But why does it have to be that way? Why are we still using this crap?
begin
	mem(0) <= (others => '0');

	writing: process(CLK, RST)
	begin
		if RST = '1' then
			for i in 0 to 7 loop
				mem(i) <= (others => '0');
			end loop;
		elsif rising_edge(CLK) then
			if RegWrite = '1' then
				mem(to_integer(unsigned(writeAddr))) <= writeData;
			end if;
		end if;
		
		-- update debug outputs
		r1 <= mem(1);
		r2 <= mem(2);
		r3 <= mem(3);
		r4 <= mem(4);
		r5 <= mem(5);
		r6 <= mem(6);
		r7 <= mem(7);
		
	end process;
	
	reading: process(read1, read2)
		variable intRead1, intRead2: integer;
	begin							
		intRead1 := to_integer(unsigned(read1));
		intRead2 := to_integer(unsigned(read2));
		
		case intRead1 is
			when 0 => data1 <= (others => '0');
			when others => data1 <= mem(intRead1);
		end case;  
		
		case intRead2 is
			when 0 => data2 <= (others => '0');
			when others => data2 <= mem(intRead2);
		end case;
		
	end process;

end architecture reg;
