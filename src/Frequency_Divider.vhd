library ieee;
use ieee.std_logic_1164.all;

entity Frequency_Divider is
    generic (
        DIVIDER : integer := 2
    );
    port (
        i_Clk : in std_logic;
        o_Clk : out std_logic
    );
end entity Frequency_Divider;

architecture rtl of Frequency_Divider is
    signal r_Clk : std_logic := '0';
    signal r_Counter : integer range 0 to DIVIDER - 1 := 0;
begin
    process (i_Clk)
    begin
        if rising_edge(i_Clk) then
            if r_Counter = DIVIDER - 1 then
                r_Counter <= 0;
                r_Clk <= not r_Clk;
            else
                r_Counter <= r_Counter + 1;
            end if;
        end if;
    end process;
    o_Clk <= r_Clk;
end architecture rtl;