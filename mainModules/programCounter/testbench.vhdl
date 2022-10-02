library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity testbench is
end testbench;

architecture tb of testbench is

signal p_s, q_s : std_logic_vector(31 downto 0);
signal reset_s, clk_s : std_logic;

component pc is	
	port(
		p : in std_logic_vector(31 downto 0);
		reset, clk: in std_logic;
		q: out std_logic_vector(31 downto 0)
	);
end component;

begin
	 DUT  : pc port map (p => p_s, reset => reset_s, clk => clk_s, q => q_s);
			
		process
		begin
			
			p_s <= X"00000000";
			
			for i in 0 to 31 loop
				clk_s <= '0';
				wait for 5 ps;
				clk_s <= '1';
				wait for 5 ps;
				p_s <= std_logic_vector(signed(p_s) + 1);
			end loop;
		end process;
end tb;
