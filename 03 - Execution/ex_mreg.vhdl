library IEEE;
use ieee.std_logic_1164.all;

entity Ex_MReg is
  generic(WORD: integer := 16; REG: integer := 3);
  port (
    CLK: in std_logic;
    RST: in std_logic;

    -- inputs
    ALUresult_in: in std_logic_vector(WORD - 1 downto 0); -- careful
	Data2_in: in std_logic_vector(WORD - 1 downto 0);
	--Rt_in: in std_logic_vector(WORD - 1 downto 0); -- contents of Rt
    DestAddr_in: in std_logic_vector(REG - 1 downto 0);

    -- outputs
    ALUresult_out: out std_logic_vector(WORD - 1 downto 0);
	Data2_out: out std_logic_vector(WORD - 1 downto 0);
--    Rt_out: out std_logic_vector(WORD - 1 downto 0);
    DestAddr_out: out std_logic_vector(REG - 1 downto 0)
  );
end entity Ex_MReg;

architecture reg of Ex_MReg is
begin
  process (CLK) is
  begin
    if rising_edge(CLK) then
      if RST = '1' then
		ALUresult_out <= (others => '0');
		Data2_out <= (others => '0');
--        Rt_out <= (others => '0');
        DestAddr_out <= (others => '0');
      else
        ALUresult_out <= ALUResult_in;
		Data2_out <= Data2_in;
--        Rt_out <= Rt_in;
        DestAddr_out <= DestAddr_in;
      end if;
    end if;
  end process;
end architecture reg;
