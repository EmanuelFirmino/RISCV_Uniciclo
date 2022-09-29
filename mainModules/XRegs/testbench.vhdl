library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity testbench is

end testbench;

architecture tb of testbench is

component XRegs is 
    generic (WSIZE : natural := 32);
    port (
        clk, wren       : in std_logic;
        rs1, rs2, rd    : in std_logic_vector(4 downto 0);
        data            : in std_logic_vector(WSIZE-1 downto 0);
        ro1, ro2        : out std_logic_vector(WSIZE-1 downto 0)
    );
end component;

signal clk_sig, wren_sig : std_logic;
signal rs1_sig, rs2_sig, rd_sig : std_logic_vector(4 downto 0);
signal ro1_sig, ro2_sig, data_sig : std_logic_vector(31 downto 0);


begin

DUT : XRegs port map(clk_sig, wren_sig, rs1_sig, rs2_sig, rd_sig, data_sig, ro1_sig, ro2_sig);

process
begin

for i in 31 downto 0 loop
    clk_sig <= '1';
    wren_sig <= '1';
    data_sig <= X"FF00FFCC";
    wait for 5 ns;
end loop;
wait;

end process;
end tb;