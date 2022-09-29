library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity testbench is

end testbench;

architecture tb of testbench is

component genImm32 is
    port(
        instr :     in std_logic_vector(31 downto 0);
        imm32 :     out signed(31 downto 0)
    );
end component;

signal instr_in : std_logic_vector(31 downto 0);
signal imm32_out : signed(31 downto 0);

begin

DUT : genImm32 port map(instr_in, imm32_out);

process
begin

instr_in <= X"000002B3";
wait for 1 ns;
assert(imm32_out=X"00000000") report "Fail 0x000002B3" severity error;

instr_in <= X"01002283";
wait for 1 ns;
assert(imm32_out=X"00000010") report "Fail 0x01002283" severity error;

instr_in <= X"F9C00313";
wait for 1 ns;
assert(imm32_out=X"FFFFFF9C") report "Fail 0xF9C00313" severity error;

instr_in <= X"FFF2C293";
wait for 1 ns;
assert(imm32_out=X"FFFFFFFF") report "Fail 0xFFF2C293" severity error;

instr_in <= X"16200313";
wait for 1 ns;
assert(imm32_out=X"00000162") report "Fail 0x16200313" severity error;

instr_in <= X"01800067";
wait for 1 ns;
assert(imm32_out=X"00000018") report "Fail 0x01800067" severity error;

instr_in <= X"00002437";
wait for 1 ns;
assert(imm32_out=X"00002000") report "Fail 0x00002437" severity error;

instr_in <= X"02542E23";
wait for 1 ns;
assert(imm32_out=X"0000003C") report "Fail 0x02542E23" severity error;

instr_in <= X"FE5290E3";
wait for 1 ns;
assert(imm32_out=X"FFFFFFE0") report "Fail 0xFE5290E3" severity error;

instr_in <= X"00C000EF";
wait for 1 ns;
assert(imm32_out=X"0000000C") report "Fail 0x00C000EF" severity error;
wait;
end process;
end tb;