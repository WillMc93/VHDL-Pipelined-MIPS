library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity DataMem is
	generic(ADDR: integer := 10; WORD: integer := 16);
	port (
		CLK: in std_logic;
		ADDR_in: in std_logic_vector(WORD - 1 downto 0);
		Data_in: in std_logic_vector(WORD - 1 downto 0);
		MemWrite_in: in std_logic;
		MemRead_in: in std_logic;

		Data_out: out std_logic_vector(WORD - 1 downto 0)
	);
end entity DataMem;

architecture sw_lw of DataMem is
	type memory is array (0 to 1024) of std_logic_vector(WORD - 1 downto 0);
	signal mem: memory;
begin
	process (CLK)
		variable address: integer;
	begin
		address := to_integer(unsigned(ADDR_in(ADDR - 1 downto 0)));
		if rising_edge(CLK) then
			if MemWrite_in = '1' then
				mem(address) <= Data_in;
			elsif MemRead_in = '1' then
				Data_out <= mem(address);
			end if;
		end if;
	end process;
end architecture sw_lw;
