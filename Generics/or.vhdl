library IEEE;
use IEEE.std_logic_1164.all;

entity ORgate is
	port (
		A, B, C: in std_logic;
		O: out std_logic
	);
end entity ORgate;

architecture op of ORgate is
begin
	O <= A or B or C;
end architecture op;
