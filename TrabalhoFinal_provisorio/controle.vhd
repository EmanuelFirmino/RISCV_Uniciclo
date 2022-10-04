library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.riscv_pkg.all;

entity controle is
    port (
        opcode      : in std_logic_vector(6 downto 0);
        alu_op      : out std_logic_vector(1 downto 0);
        is_branch   : out std_logic;
        mem_read    : out std_logic;
        mem_to_reg  : out std_logic;
        mem_write   : out std_logic;
        alu_src     : out std_logic;
        reg_write   : out std_logic;
        auipc_lui   : out std_logic_vector(1 downto 0);
        is_jump     : out std_logic;
        jalr        : out std_logic);
end controle;

architecture behavioral of controle is
begin
    process(opcode)
    begin
        case opcode is
            when iRType | iIType => -- Arithmetic and Logical
                if (opcode = iRType) then 
                    alu_src  <= '0';
                    alu_op   <= ALU_CTR_ARI_LOG_SHI_COMP;
                else
                    alu_src  <= '1'; 
                    alu_op   <= ALU_CTR_IMEDIATE;
                end if;
                mem_to_reg  <= '0';
                reg_write   <= '1';
                mem_read    <= '0';
                mem_write   <= '0';
                is_branch   <= '0';
                auipc_lui   <= MUX_SEL_REG1;
                is_jump     <= '0';
                jalr        <= '0';
            when iILType => -- lw
                alu_src     <= '1';
                mem_to_reg  <= '1';
                reg_write   <= '1';
                mem_read    <= '1';
                mem_write   <= '0';
                is_branch   <= '0';
                alu_op      <= ALU_CTR_LW_SW_LUI_AUIPC;
                auipc_lui   <= MUX_SEL_REG1;
                is_jump     <= '0';
                jalr        <= '0';
            when iSType => -- sw
                alu_src     <= '1';
                mem_to_reg  <= '0';
                reg_write   <= '0';
                mem_read    <= '0';
                mem_write   <= '1';
                is_branch   <= '0';
                alu_op      <= ALU_CTR_LW_SW_LUI_AUIPC;
                auipc_lui   <= MUX_SEL_REG1;
                is_jump     <= '0';
                jalr        <= '0';
            when iBType => -- Branch
                alu_src     <= '0';
                mem_to_reg  <= '0';
                reg_write   <= '0';
                mem_read    <= '0';
                mem_write   <= '0';
                is_branch   <= '1';
                alu_op      <= ALU_CTR_BRANCH;
                auipc_lui   <= MUX_SEL_REG1;
                is_jump     <= '0';
                jalr        <= '0';
            when iLUI | iAUIPC=>
                if (opcode = iLUI) then
                    auipc_lui   <= MUX_SEL_LUI;
                else
                    auipc_lui   <= MUX_SEL_AUIPC;
                end if;
                alu_src     <= '1';
                mem_to_reg  <= '0';
                reg_write   <= '1';
                mem_read    <= '0';
                mem_write   <= '0';
                is_branch   <= '0';
                alu_op      <= ALU_CTR_LW_SW_LUI_AUIPC;
                is_jump     <= '0';
                jalr        <= '0';
            when iJALR =>
                alu_src     <= '1';
                mem_to_reg  <= '0';
                reg_write   <= '1';
                mem_read    <= '0';
                mem_write   <= '0';
                is_branch   <= '1';
                alu_op      <= ALU_CTR_LW_SW_LUI_AUIPC;
                auipc_lui   <= MUX_SEL_REG1;
                is_jump     <= '1';
                jalr        <= '1';
            when iJAL =>
                alu_src     <= '1';
                mem_to_reg  <= '0';
                reg_write   <= '1';
                mem_read    <= '0';
                mem_write   <= '0';
                is_branch   <= '1';
                alu_op      <= ALU_CTR_LW_SW_LUI_AUIPC;
                auipc_lui   <= MUX_SEL_AUIPC;
                is_jump     <= '1';
                jalr        <= '0';
            when others => null;
        end case ;
    end process;
end architecture behavioral;
