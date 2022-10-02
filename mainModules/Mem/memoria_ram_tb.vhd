LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY mem_ram_tb IS
END ENTITY mem_ram_tb;

ARCHITECTURE DUT OF mem_ram_tb IS

    COMPONENT mem_ram IS
        PORT (
            clock : IN STD_LOGIC;
            we : IN STD_LOGIC;
            address : IN STD_LOGIC_VECTOR;
            datain : IN STD_LOGIC_VECTOR;
            dataout : OUT STD_LOGIC_VECTOR);
    END COMPONENT mem_ram;

    SIGNAL clock_in : STD_LOGIC;
    SIGNAL we_in : STD_LOGIC;
    SIGNAL address_in : STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL data_in : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL data_out : STD_LOGIC_VECTOR(31 DOWNTO 0);

BEGIN
    mem_ram_out : mem_ram PORT MAP(clock_in, we_in, address_in, data_in, data_out);
    clkgen : PROCESS BEGIN
        clock_in <= '0';
        WAIT FOR 5 ns;
        clock_in <= '1';
        WAIT FOR 5 ns;
    END PROCESS clkgen;
    drive : PROCESS BEGIN
        we_in <= '1';
        FOR i IN 0 TO 9 LOOP
            address_in <= STD_LOGIC_VECTOR(to_unsigned(i, 8));
            data_in <= STD_LOGIC_VECTOR(to_unsigned(i, 30)) & "00";
            WAIT FOR 10 ns;
        END LOOP;
        we_in <= '0';
        FOR i IN 0 TO 9 LOOP
            address_in <= STD_LOGIC_VECTOR(to_unsigned(i, 8));
            WAIT FOR 10 ns;
        END LOOP;
        ASSERT false REPORT "Test done." SEVERITY note;
        WAIT;
    END PROCESS drive;
END ARCHITECTURE DUT;