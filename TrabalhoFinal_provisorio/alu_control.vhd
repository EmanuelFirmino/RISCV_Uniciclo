library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.riscv_pkg.all;

entity alu_control is
    port (
        alu_op  : in std_logic_vector(1 downto 0);
        funct3  : in std_logic_vector(2 downto 0);
        funct7  : in std_logic;
        alu_ctr : out std_logic_vector(3 downto 0));
end alu_control;

architecture behavioral of alu_control is
begin
    process(alu_op, funct7, funct3)
    begin
        case alu_op is
            when ALU_CTR_LW_SW_LUI_AUIPC => -- lw/sw
                alu_ctr <= ULA_ADD;
            when ALU_CTR_BRANCH => -- branchs
                case funct3 is
                    when iBEQ3 =>
                        alu_ctr <= ULA_SEQ;
                    when iBNE3 =>
                        alu_ctr <= ULA_SNE;
                    when iBLT3 =>
                        alu_ctr <= ULA_SLT;
                    when iBGE3 =>
                        alu_ctr <= ULA_SGE;
                    when iBLTU3 =>
                        alu_ctr <= ULA_SLTU;
                    when iBGEU3 =>
                        alu_ctr <= ULA_SGEU;
                    when others => null;
                end case;
            when ALU_CTR_ARI_LOG_SHI_COMP | ALU_CTR_IMEDIATE => -- Arithmetic/Logic/Shift/Compare
                case funct3 is
                    when iADDSUB3 =>
                        if (alu_op = ALU_CTR_IMEDIATE) then alu_ctr <= ULA_ADD;
                        elsif (funct7 = '1') then alu_ctr <= ULA_SUB; else alu_ctr <= ULA_ADD; end if;
                    when iSLL3 =>
                        alu_ctr <= ULA_SLL;
                    when iSLT3 =>
                        alu_ctr <= ULA_SLT;
                    when iSLTU3 =>
                        alu_ctr <= ULA_SLTU;
                    when iXOR3 =>
                        alu_ctr <= ULA_XOR;
                    when iSRLSRA3 =>
                        if (funct7 = '1') then alu_ctr <= ULA_SRA; else alu_ctr <= ULA_SRL; end if;
                    when iOR3 =>
                        alu_ctr <= ULA_OR;
                    when iAND3 =>
                        alu_ctr <= ULA_AND;
                    when others => null;
                end case;
            when others => null;
        end case;
    end process;
end architecture behavioral;

