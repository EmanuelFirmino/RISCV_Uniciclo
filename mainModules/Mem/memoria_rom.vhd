LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
USE std.textio.ALL;

ENTITY mem_rom IS
    PORT (
        address : IN STD_LOGIC_VECTOR;
        dataout : OUT STD_LOGIC_VECTOR);
END ENTITY mem_rom;

ARCHITECTURE RTL OF mem_rom IS

    TYPE rom_type IS ARRAY (0 TO (2 ** address'length) - 1) OF STD_LOGIC_VECTOR(dataout'RANGE);

    IMPURE FUNCTION init_rom_hex RETURN rom_type IS
        FILE text_file : text OPEN read_mode IS "rom_data.txt";
        VARIABLE text_line : line;
        VARIABLE rom_content : rom_type;
    BEGIN
        FOR i IN 0 TO (2 ** address'length) - 1 LOOP
            readline(text_file, text_line);
            hread(text_line, rom_content(i));
        END LOOP;
        RETURN rom_content;
    END FUNCTION;

    SIGNAL rom : rom_type := init_rom_hex;
    SIGNAL read_address : STD_LOGIC_VECTOR(address'RANGE);

BEGIN
    PROCESS (address)
    BEGIN
        read_address <= address;
        dataout <= rom(to_integer(unsigned(read_address)));
    END PROCESS;
END ARCHITECTURE RTL;
