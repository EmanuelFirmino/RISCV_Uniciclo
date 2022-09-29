library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity genImm32 is
    port (
        instr :     in std_logic_vector(31 downto 0);
        imm32 :     out signed(31 downto 0)
        );
end genImm32;

architecture rtl of genImm32 is
signal x : std_logic_vector(31 downto 0);
begin
    x <= instr;
    with x(6 downto 0) select
        imm32 <= signed(x(31 downto 12) & "000000000000") when "0110111",
                 resize(signed(x(31 downto 20)), 32) when "0010011" | "0000011" | "1100111",
                 resize(signed(x(31 downto 25) & x(11 downto 7)), 32) when "0100011",
                 resize(signed(x(31) & x(7) & x(30 downto 25) & x(11 downto 8) & "0"), 32) when "1100011",
                 resize(signed(x(31) & x(19 downto 12) & x(20) & x(30 downto 21) & "0"), 32) when "1101111",
                 resize("0", 32) when others;
end rtl;