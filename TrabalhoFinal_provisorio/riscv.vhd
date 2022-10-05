library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.riscv_pkg.all;

entity riscv is
    port (
        clk	: in std_logic;
        rst	: in std_logic := '0';
        data  	: out std_logic_vector(WORD_SIZE - 1 downto 0));
end riscv;

architecture rtl of riscv is
-- Sinais
    signal pcin         : std_logic_vector(WORD_SIZE - 1 downto 0) := (others => '0');	-- Entrada do PC
    signal pcout        : std_logic_vector(WORD_SIZE - 1 downto 0) := (others => '0');	-- Saida do PC
    signal nextpc       : std_logic_vector(WORD_SIZE - 1 downto 0);	-- Proximo pc (pc+4)
    signal pccond       : std_logic_vector(WORD_SIZE - 1 downto 0);
    signal pcbranch     : std_logic_vector(WORD_SIZE - 1 downto 0);
    signal regdata      : std_logic_vector(WORD_SIZE - 1 downto 0);
    signal rd_data      : std_logic_vector(WORD_SIZE - 1 downto 0);
    signal jump_adder_in: std_logic_vector(WORD_SIZE - 1 downto 0);
    signal dmout        : std_logic_vector(WORD_SIZE - 1 downto 0);
    signal regA         : std_logic_vector(WORD_SIZE - 1 downto 0);
    signal regB         : std_logic_vector(WORD_SIZE - 1 downto 0);
    signal aluA         : std_logic_vector(WORD_SIZE - 1 downto 0);
    signal aluB         : std_logic_vector(WORD_SIZE - 1 downto 0);
    signal alu_result   : std_logic_vector(WORD_SIZE - 1 downto 0);
    signal instr        : std_logic_vector(WORD_SIZE - 1 downto 0);
    signal imm32        : std_logic_vector(WORD_SIZE - 1 downto 0);

    signal alu_ctr      : std_logic_vector(3 downto 0);
    signal alu_op       : std_logic_vector(1 downto 0);

    signal reg_dst      : std_logic;
    signal is_branch    : std_logic;
    signal is_jump      : std_logic;
    signal mem_reg      : std_logic;
    signal mem_write    : std_logic;
    signal alu_src      : std_logic;
    signal reg_write    : std_logic;
    signal mem_read     : std_logic;
    signal mem_to_reg   : std_logic;
    signal jalr         : std_logic;
    signal auipc_lui    : std_logic_vector(1 downto 0);
    signal branch       : std_logic;

    alias func3_field   : std_logic_vector(02 downto 0) is instr(14 downto 12);
    alias func7_field   : std_logic_vector(06 downto 0) is instr(31 downto 25);
    alias rs1_field     : std_logic_vector(04 downto 0) is instr(19 downto 15);
    alias rs2_field     : std_logic_vector(04 downto 0) is instr(24 downto 20);
    alias rd_field      : std_logic_vector(04 downto 0) is instr(11 downto 07);
    alias opcode_field  : std_logic_vector(06 downto 0) is instr(06 downto 00);
    alias imem_address  : std_logic_vector(MEM_ADDR - 1 downto 0) is pcout(11 downto 02);
    alias dmadd         : std_logic_vector(MEM_ADDR - 1 downto 0) is alu_result(11 downto 02);
    alias func7_5_field : std_logic is instr(30);

begin

    data <= pcout;

    pc_i: pc port map (clk, '1', rst, pcin, pcout);

    somar4comPC_i: somador port map (pcout, INC_PC, nextpc);

    memoria_instrucoes_i: memInstr port map (imem_address, instr);

    controle_i: controle port map (
        opcode_field,
	is_jump,
	jalr,
        is_branch,
        mem_read,
        mem_to_reg,
	alu_op,
        mem_write,
        alu_src,
        reg_write,
        auipc_lui
    );

    rd_mux_i:  mux2 port map (regdata, nextpc, is_jump, rd_data);

    xreg_i: xreg port map (
        clk,
        reg_write,
        rs1_field,
        rs2_field,
        rd_field,
        rd_data,
        regA,
        regB
    );

    genImm32_i: genImm32 port map (instr, imm32);

    mux3_i: mux3 port map (pcout, ZERO32, regA, auipc_lui, aluA);

    jump_mux2_i:  mux2 port map (pcout, regA, jalr, jump_adder_in);

    ula_mux_i:  mux2 port map (regB, imm32, alu_src, aluB);

    controle_ula_i: controle_ula port map (alu_op, func3_field, func7_5_field, alu_ctr);

    ula_i: ula port map (alu_ctr, aluA, aluB, alu_result);

    somador_jump_i: somador port map (jump_adder_in, imm32, pccond);

    branch <= (is_branch and alu_result(0)) or is_jump;

    memoria_dados_i: data_mem port map (dmadd, clk, regB, mem_write, mem_read, dmout);

    memoria_reg_mux_i: mux2 port map (alu_result, dmout, mem_to_reg, regdata);

    incrementa_pc_I: mux2 port map (nextpc, pccond, branch, pcin);

end architecture rtl;
