LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY mem_ram_rv IS
    PORT (
        clock : IN STD_LOGIC;
        we : IN STD_LOGIC;
        address : IN STD_LOGIC_VECTOR;
        datain : IN STD_LOGIC_VECTOR;
        dataout : OUT STD_LOGIC_VECTOR
    );
END ENTITY mem_ram_rv;
ARCHITECTURE RTL OF mem_ram_rv IS
    TYPE mem_ram_type IS ARRAY (0 TO (2 ** address'length) - 1) OF STD_LOGIC_VECTOR(datain'RANGE);
    SIGNAL mem_ram : mem_ram_type;
    SIGNAL read_address : STD_LOGIC_VECTOR(address'RANGE);
BEGIN
    PROCESS (clock)
    BEGIN
        IF rising_edge(clock) THEN
            IF we = '1' THEN
                mem_ram(to_integer(unsigned(address))) <= datain;
            END IF;
            read_address <= address;
        END IF;
    END PROCESS;
    dataout <= mem_ram(to_integer(unsigned(read_address)));

END ARCHITECTURE RTL;