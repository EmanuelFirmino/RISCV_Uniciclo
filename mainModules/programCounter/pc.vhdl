library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pc is	
	port(
		p : in std_logic_vector(31 downto 0) := X"00000000";
		reset, clk: in std_logic;
		q: out std_logic_vector(31 downto 0) := X"00000000"
	);
end pc;

architecture rtl of pc is
	signal p_s, q_s: std_logic_vector(31 downto 0);
begin	

	p_s 	<= p;
	q 	<= q_s;
	
	process(clk, reset)
	begin
		if reset = '1'	then
			q_s <= X"00000000";
		else
			if rising_edge(clk) then
				q_s <= p_s;
			end if;
		end if;
	end process;
end rtl;
