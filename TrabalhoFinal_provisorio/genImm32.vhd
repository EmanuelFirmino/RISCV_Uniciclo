library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.riscv_pkg.all;

entity genImm32 is
    port (
        instr: in std_logic_vector(WORD_SIZE-1 downto 0);
        imm32: out std_logic_vector(WORD_SIZE-1 downto 0));
end entity genImm32;

architecture arch of genImm32 is
begin
    process(instr)
    begin
        case '0'&instr(6 downto 0) is
            when x"33" => 
                imm32 <= (others => '0');
            when x"03" | x"13" | x"67" => 
                imm32 <= std_logic_vector(resize(signed(instr(31 downto 20)), 32));
            when x"23" => 
                imm32 <= std_logic_vector(resize(signed(instr(31 downto 25) & instr(11 downto 7)), 32));
            when x"63" => 
                imm32 <= std_logic_vector(resize(signed(instr(31) & instr(7) & instr(30 downto 25) & instr(11 downto 8) & '0'), 32));
            when x"37" => 
                imm32 <= std_logic_vector(resize(signed(instr(31) & instr(19 downto 12) & instr(20) & instr(30 downto 21) & '0'), 32));
            when x"6F" => 
                imm32 <= std_logic_vector(resize(signed(instr(31 downto 12)), 32));
            when others =>
                null;
        end case;
    end process;
end architecture arch;
