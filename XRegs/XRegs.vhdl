library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity XRegs is
    generic (WSIZE : natural := 32);
    port (
        clk, wren       : in std_logic;
        rs1, rs2, rd    : in std_logic_vector(4 downto 0);
        data            : in std_logic_vector(WSIZE-1 downto 0);
        ro1, ro2        : out std_logic_vector(WSIZE-1 downto 0));
end XRegs;


architecture rtl of XRegs is

type xregs is array(31 downto 0) of std_logic_vector (31 downto 0);

signal xregs_sig : xregs;
signal read : integer;

begin
    process(clk)
    begin

    if (wren='1') then
        if (clk'event and clk='1') then
            
            ro1 <= xregs_sig(conv_integer(rs1));
            ro2 <= xregs_sig(conv_integer(rs2));

            read <= conv_integer(rd);

            if (read /= 0) then
                xregs_sig(conv_integer(rd)) <= data;
            end if;
        end if;
    end if;

    end process;

end rtl;