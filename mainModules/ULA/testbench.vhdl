library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity testbench is
end testbench;

architecture tb of testbench is

    component ULA is
        port (
            opcode : in std_logic_vector(3 downto 0);
            A, B : in std_logic_vector(31 downto 0);
            Z   : out std_logic_vector(31 downto 0);
            zero : out std_logic
        );
    end component;

    signal opcode_s : std_logic_vector(3 downto 0); 
    signal A_s, B_s, Z_s : std_logic_vector(31 downto 0);
    signal zero_s : std_logic;

    begin

    DUT : ULA port map (opcode_s, A_s, B_s, Z_s, zero_s);

    process
    begin
    
    opcode_s <= "0000";
    A_s <= X"00000002";
    B_s <= X"00000002";
    wait for 1 ns;
    assert(Z_s=X"00000004") report "Fail ADD" severity error;

    opcode_s <= "0001";
    A_s <= X"00000002";
    B_s <= X"00000002";
    wait for 1 ns;
    assert(Z_s=X"00000000") report "Fail SUB" severity error;

    opcode_s <= "0010";
    A_s <= X"000000FF";
    B_s <= X"0000FFFF";
    wait for 1 ns;
    assert(Z_s=X"000000FF") report "Fail AND" severity error;

    opcode_s <= "0011";
    A_s <= X"0000FFFF";
    B_s <= X"000000FF";
    wait for 1 ns;
    assert(Z_s=X"0000FFFF") report "Fail OR" severity error;

    opcode_s <= "0100";
    A_s <= X"00000001";
    B_s <= X"FFFFFFFF";
    wait for 1 ns;
    assert(Z_s=X"FFFFFFFE") report "Fail XOR" severity error;

    opcode_s <= "0101";
    A_s <= X"00000001";
    B_s <= X"00000003";
    wait for 1 ns;
    assert(Z_s=X"00000008") report "Fail SHIFT_LEFT" severity error;

    opcode_s <= "0110";
    A_s <= X"00000010";
    B_s <= X"00000004";
    wait for 1 ns;
    assert(Z_s=X"0000001") report "Fail SHIFT_RIGHT Unsig" severity error;

    opcode_s <= "0111";
    A_s <= X"00000010";
    B_s <= X"00000004";
    wait for 1 ns;
    assert(Z_s=X"00000001") report "Fail SHIFT_RIGHT sig" severity error;

    opcode_s <= "1000";
    A_s <= X"00000001";
    B_s <= X"00000002";
    wait for 1 ns;
    assert(Z_s=X"00000001") report "Fail LESS THAN Unsig" severity error;

    opcode_s <= "1001";
    A_s <= X"00000001";
    B_s <= X"00000002";
    wait for 1 ns;
    assert(Z_s=X"00000001") report "Fail LESS THAN sig" severity error;

    opcode_s <= "1010";
    A_s <= X"00000004";
    B_s <= X"00000002";
    wait for 1 ns;
    assert(Z_s=X"00000001") report "Fail GREATER THAN Unsig" severity error;

    opcode_s <= "1011";
    A_s <= X"00000004";
    B_s <= X"00000002";
    wait for 1 ns;
    assert(Z_s=X"00000001") report "Fail GREATER THAN sig" severity error;

    opcode_s <= "1100";
    A_s <= X"00000002";
    B_s <= X"00000002";
    wait for 1 ns;
    assert(Z_s=X"00000001") report "Fail EQUAL" severity error;

    opcode_s <= "1101";
    A_s <= X"00000001";
    B_s <= X"00000000";
    wait for 1 ns;
    assert(Z_s=X"00000001") report "Fail NOT EQUAL" severity error;
    wait;
    end process;
end tb;    