library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity testbench is
end testbench;

architecture tb of testbench is

component mux is
	port (
		A, B	:	in std_logic_vector(31 downto 0);
		M	:	in std_logic;
		N	:	out std_logic_vector(31 downto 0)
	);
end component;

signal A_s, B_s, N_s	:	std_logic_vector(31 downto 0);
signal M_s		:	std_logic;


begin
	DUT : mux port map (A => A_s, B => B_s, M => M_s, N => N_s);

	process
	begin
		A_s <= X"0000ABCD";
		B_s <= X"0000DCBA";

		M_s <= '0';
		wait for 5 ps;
		M_s <= '1';
		wait for 5 ps;

	end process;
end tb;

		
