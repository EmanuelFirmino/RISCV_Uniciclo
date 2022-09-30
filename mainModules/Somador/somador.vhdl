library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

entity somador is	
	port(
		A, B: in std_logic_vector(31 downto 0);
		Cin: in	 std_logic_vector(0 downto 0);
		C: out std_logic_vector(31 downto 0);
		Cout: out  std_logic_vector(0 downto 0));
end somador;

architecture rtl of somador is
	signal A_s, B_s, C_s: std_logic_vector(31 downto 0);
	signal Cin_s, Cout_s: std_logic_vector(0 downto 0);
	signal SUM: std_logic_vector(32 downto 0);
begin	
	A_s <= A;
	B_s <= B;
	Cin_s <= Cin; 
	Cout <= Cout_s;
	C <= C_s;
	
	Cout_s <= SUM(32 downto 32);
	C_s <= SUM(31 downto 0);
	
	SUM <= unsigned('0' & A_s) + unsigned('0' & B_s) + unsigned(X"00000000" & Cin_s);
end rtl;
