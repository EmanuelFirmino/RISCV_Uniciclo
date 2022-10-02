LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY mem_rom_tb IS
END ENTITY mem_rom_tb;

ARCHITECTURE DUT OF mem_rom_tb IS

    COMPONENT mem_rom IS
        PORT (
            address : IN STD_LOGIC_VECTOR;
            dataout : OUT STD_LOGIC_VECTOR);
    END COMPONENT mem_rom;

    SIGNAL address_in : STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL data_out : STD_LOGIC_VECTOR(31 DOWNTO 0);

BEGIN
    mem_rom_out : mem_rom PORT MAP(address_in, data_out);
    PROCESS
    BEGIN
        FOR i IN 0 TO 255 LOOP
            address_in <= STD_LOGIC_VECTOR(to_unsigned(i, 8));
            WAIT FOR 10 ns;
        END LOOP;
        ASSERT false REPORT "Test done." SEVERITY note;
        WAIT;
    END PROCESS;
END ARCHITECTURE DUT;
