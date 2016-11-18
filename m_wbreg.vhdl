library IEEE;
use ieee.std_logic_1164.all;

entity M_WBReg is
  generic (WORD: integer := 16; REG: integer := 3);
  port (
    CLK: in std_logic;
    RST: in std_logic;

    -- inputs
	Data_in: in std_logic_vector(WORD - 1 downto 0);
	ALUResult_in: in std_logic_vector(WORD - 1 downto 0);
	RegWriteAddr_in: in std_logic_vector(REG - 1 downto 0);

    -- outputs
    Data_out: out std_logic_vector(WORD - 1 downto 0);
	ALUResult_out: out std_logic_vector(WORD - 1 downto 0);
	RegWriteAddr_out: out std_logic_vector(REg - 1 downto 0)
  );
end entity M_WBReg;

architecture reg of M_WBReg is
begin
  process (CLK) is
  begin
    if rising_edge(CLK) then
      if RST = '1' then
        Data_out <= (others => '0');
		ALUResult_out <= (others => '0');
        RegWriteAddr_out <= (others => '0');
      else
        Data_out <= Data_in;
		ALUResult_out <= ALUResult_in;
		RegWriteAddr_out <= RegWriteAddr_in;
      end if;
    end if;
  end process;
end architecture reg;
