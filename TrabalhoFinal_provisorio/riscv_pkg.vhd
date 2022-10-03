library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package riscv_pkg is

    constant WORD_SIZE 	: natural := 32;
    constant MEM_ADDR	: integer := 10;
    constant BREG_IDX 	: natural := 5;
    constant MEM_SIZE	: integer := 1024;
    constant ZERO32     : std_logic_vector(WORD_SIZE - 1 downto 0) := (others => '0');
    constant ONE32      : std_logic_vector(WORD_SIZE-1 downto 0) := (WORD_SIZE-1 downto 1 => '0') & '1';
    constant INC_PC		: std_logic_vector(WORD_SIZE - 1 downto 0) := (2 => '1', others => '0');

    -- Opcodes do RV32I
    constant iRType     : std_logic_vector(6 downto 0) := "0110011";
    constant iILType	: std_logic_vector(6 downto 0) := "0000011";
    constant iSType		: std_logic_vector(6 downto 0) := "0100011";
    constant iBType		: std_logic_vector(6 downto 0) := "1100011";
    constant iIType		: std_logic_vector(6 downto 0) := "0010011";
    constant iLUI		: std_logic_vector(6 downto 0) := "0110111";
    constant iAUIPC		: std_logic_vector(6 downto 0) := "0010111";
    constant iJALR		: std_logic_vector(6 downto 0) := "1100111";
    constant iJAL		: std_logic_vector(6 downto 0) := "1101111";

    -- ALU Control Operations
    constant ALU_CTR_LW_SW_LUI_AUIPC    : std_logic_vector(1 downto 0) := "00";
    constant ALU_CTR_BRANCH             : std_logic_vector(1 downto 0) := "01";
    constant ALU_CTR_ARI_LOG_SHI_COMP   : std_logic_vector(1 downto 0) := "10";
    constant ALU_CTR_IMEDIATE           : std_logic_vector(1 downto 0) := "11";

    -- Campo funct3
    -- Arithmetic
    constant iADDSUB3	: std_logic_vector(2 downto 0) := "000"; -- ADD, ADDi, SUB
    -- Compare
    constant iSLT3      : std_logic_vector(2 downto 0) := "010"; -- SLT, SLTi
    constant iSLTU3     : std_logic_vector(2 downto 0) := "011"; -- SLTU, SLTUi
    -- Logical
    constant iAND3		: std_logic_vector(2 downto 0) := "111"; -- AND, ANDi
    constant iOR3		: std_logic_vector(2 downto 0) := "110"; -- OR, ORi
    constant iXOR3		: std_logic_vector(2 downto 0) := "100"; -- XOR, XORi
    -- Shifts
    constant iSLL3		: std_logic_vector(2 downto 0) := "001"; -- SLLi
    constant iSRLSRA3   : std_logic_vector(2 downto 0) := "101"; -- SRLi, SRAi
    -- Branchs
    constant iBEQ3		: std_logic_vector(2 downto 0) := "000";
    constant iBNE3		: std_logic_vector(2 downto 0) := "001";
    constant iBLT3		: std_logic_vector(2 downto 0) := "100";
    constant iBLTU3		: std_logic_vector(2 downto 0) := "110";
    constant iBGE3		: std_logic_vector(2 downto 0) := "101";
    constant iBGEU3		: std_logic_vector(2 downto 0) := "111";
    -- Load
    constant iLW3		: std_logic_vector(2 downto 0) := "000";
    -- Store
    constant iSW3		: std_logic_vector(2 downto 0) := "010";

    -- Mux LUI / AUIPC / REG1
    constant MUX_SEL_AUIPC	: std_logic_vector(1 downto 0) := "00";
    constant MUX_SEL_LUI	: std_logic_vector(1 downto 0) := "01";
    constant MUX_SEL_REG1	: std_logic_vector(1 downto 0) := "10";

    -- Controle ULA
    constant ULA_ADD	: std_logic_vector(3 downto 0) := "0000";
    constant ULA_SUB	: std_logic_vector(3 downto 0) := "0001";
    constant ULA_AND	: std_logic_vector(3 downto 0) := "0010";
    constant ULA_OR		: std_logic_vector(3 downto 0) := "0011";
    constant ULA_XOR	: std_logic_vector(3 downto 0) := "0100";
    constant ULA_SLL	: std_logic_vector(3 downto 0) := "0101";
    constant ULA_SRL	: std_logic_vector(3 downto 0) := "0110";
    constant ULA_SRA	: std_logic_vector(3 downto 0) := "0111";
    constant ULA_SLT    : std_logic_vector(3 downto 0) := "1000";
    constant ULA_SLTU	: std_logic_vector(3 downto 0) := "1001";
    constant ULA_SGE	: std_logic_vector(3 downto 0) := "1010";
    constant ULA_SGEU	: std_logic_vector(3 downto 0) := "1011";
    constant ULA_SEQ	: std_logic_vector(3 downto 0) := "1100";
    constant ULA_SNE	: std_logic_vector(3 downto 0) := "1101";


    component rv_uniciclo is
        port (
            clk		: in  std_logic;
            rst	    	: in  std_logic;
            data  	: out std_logic_vector(WORD_SIZE - 1 downto 0));
    end component;

    component reg is
        generic (
            SIZE : natural := WORD_SIZE);
        port (
            clk		: in  std_logic;
            wren	: in  std_logic;
            rst		: in  std_logic;
            d_in	: in  std_logic_vector(WORD_SIZE - 1 downto 0);
            d_out	: out std_logic_vector(WORD_SIZE - 1 downto 0));
    end component;

    component mux2to1 is
        generic (
            SIZE : natural := WORD_SIZE);
        port (
            A, B  : in  std_logic_vector(SIZE - 1 downto 0);
            sel		        : in  std_logic;
            m_out		    : out std_logic_vector(SIZE - 1 downto 0));
    end component;

    component mux3to1 is
        generic (
            SIZE : natural := WORD_SIZE);
        port (
            A,
            B,
            C  : in std_logic_vector(SIZE - 1 downto 0);
            sel		: in std_logic_vector(1 downto 0);
            m_out	: out std_logic_vector(SIZE - 1 downto 0));
    end component;

    component somador is
        generic (
            SIZE : natural := WORD_SIZE);
        port (
            a	    : in  std_logic_vector (SIZE - 1 downto 0);
            b	    : in  std_logic_vector (SIZE - 1 downto 0);
            sum     : out std_logic_vector (SIZE - 1 downto 0));
    end component;

    component memInstr is
        generic (
            SIZE : natural := WORD_SIZE;
            WADDR : natural := MEM_ADDR);
        port (
            ADDRESS : in  std_logic_vector (WADDR - 1 downto 0);
            Q 	    : out std_logic_vector(SIZE - 1 downto 0));
    end component;

    component ula is
	generic (WORD_SIZE : natural := 32);
    	port (
        	opcode : in std_logic_vector(3 downto 0);
        	A, B : in std_logic_vector(WORD_SIZE-1 downto 0);
        	Z   : out std_logic_vector(WORD_SIZE-1 downto 0));
    end component;

    component xreg is
        generic (
            SIZE : natural := WORD_SIZE;
            ADDR : natural := BREG_IDX
        );
        port (
            clk, wren       : in std_logic;
            rs1, rs2, rd    : in std_logic_vector(ADDR-1 downto 0);
            data_in         : in std_logic_vector(SIZE-1 downto 0);
            A, B            : out std_logic_vector(SIZE-1 downto 0));
    end component;

    component alu_control is
        port (
            alu_op	: in  std_logic_vector(1 downto 0);
            funct3	: in  std_logic_vector(2 downto 0);
            funct7	: in  std_logic;
            alu_ctr	: out std_logic_vector(3 downto 0));
    end component;

    component control is
        port (
            opcode      : in  std_logic_vector(6 downto 0);
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
    end component;

    component genImm32 is
    port (
        instr: in std_logic_vector(WORD_SIZE-1 downto 0);
        imm32: out std_logic_vector(WORD_SIZE-1 downto 0));
    end component;

    component data_mem is
        generic (
            SIZE : natural := WORD_SIZE;
            WADDR : natural := MEM_ADDR);
        port (
            address	    : in std_logic_vector (WADDR - 1 downto 0);
            clk	        : in std_logic;
            data	    : in std_logic_vector (SIZE - 1 downto 0);
            wren	    : in std_logic;
            mem_read    : in std_logic;
            q		    : out std_logic_vector (SIZE - 1 downto 0));
    end component;

    component clk_div is
        port (
            clk	  : in std_logic;
            clk64 : out std_logic);
    end component;

end riscv_pkg;

package body riscv_pkg is
end riscv_pkg;