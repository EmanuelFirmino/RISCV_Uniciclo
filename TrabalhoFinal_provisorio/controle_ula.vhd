library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.riscv_pkg.all;

entity controle_ula is
    port (
        alu_op  : in std_logic_vector(1 downto 0);
        funct3  : in std_logic_vector(2 downto 0);
        funct7  : in std_logic;
        alu_ctr : out std_logic_vector(3 downto 0));
end controle_ula;

architecture behavioral of controle_ula is
begin
    process(alu_op, funct7, funct3)
    begin
        case alu_op is
            when ALU_CTR_LW_SW_LUI_AUIPC => -- Memória
                alu_ctr <= ULA_ADD;
            when ALU_CTR_BRANCH => -- Branchs
                case funct3 is
                    when iBEQ3 =>
                        alu_ctr <= ULA_SEQ;
                    when iBNE3 =>
                        alu_ctr <= ULA_SNE;
                    when others => null;
                end case;
            when ALU_CTR_ARI_LOG_SHI_COMP | ALU_CTR_IMEDIATE => -- Aritmético/Shift/Comparação
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
                    when iSRLSRA3 =>
                        if (funct7 = '1') then alu_ctr <= ULA_SRA; else alu_ctr <= ULA_SRL; end if;
            
                    when others => null;
                end case;
            when others => null;
        end case;
    end process;
end architecture behavioral;
