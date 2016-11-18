library IEEE;
use ieee.std_logic_1164.all;

entity ID_EXReg is
	generic (WORD: integer := 16; REG: integer := 3);
	port (
		CLK: in std_logic;
		RST: in std_logic;

		----------------
		-- inputs
		----------------
		-- addresses
		PC1_in: in std_logic_vector(WORD - 1 downto 0);
		RtAddr_in: in std_logic_vector(REG - 1 downto 0);
		RdAddr_in: in std_logic_vector(REG - 1 downto 0);

		-- register contents
		Data1_in: in std_logic_vector(WORD - 1 downto 0);
		Data2_in: in std_logic_vector(WORD - 1 downto 0);
		Immediate_in: in std_logic_vector(WORD - 1 downto 0);

		----------------
		-- outputs
		----------------
		--addresses
		PC1_out: out std_logic_vector(WORD - 1 downto 0);
		RtAddr_out: out std_logic_vector(REG - 1 downto 0);
		RdAddr_out: out std_logic_vector(REG - 1 downto 0);

		-- contents
		Data1_out: out std_logic_vector(WORD - 1 downto 0);
		Data2_out: out std_logic_vector(WORD - 1 downto 0);
		Immediate_out: out std_logic_vector(WORD - 1 downto 0)
	);
end entity ID_EXReg;

architecture reg of ID_EXReg is
begin
	process (CLK) is
	begin
		if rising_edge(CLK) then
			if RST = '1' then
				PC1_out <= (others => '0');
				RtAddr_out <= (others => '0');
				RdAddr_out <= (others => '0');
				
				Data1_out <= (others => '0');
				Data2_out <= (others => '0');
				Immediate_out <= (others => '0');
			else 
				RtAddr_out <= RtAddr_in;
				RdAddr_out <= RdAddr_in;
				PC1_out <= PC1_in;
								
				Data1_out <= Data1_in;
				Data2_out <= Data2_in;
				Immediate_out <= Immediate_in;
			end if;
		end if;
	end process;
end architecture reg;
