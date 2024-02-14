library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Eater_6502_Top is
    port (
        -- 27MHz external clock
        i_Ext_Clk : in std_logic;

        -- Address bus
        o_Address : out std_logic_vector(15 downto 0);

        -- Data bus
        io_Data : inout std_logic_vector(7 downto 0);

        -- Control signals
        o_RW : out std_logic;
        i_SO_n : in std_logic;
        i_READY : in std_logic;
        i_NMI : in std_logic;
        i_IRQ : in std_logic;
        i_RESET_n : in std_logic;

        -- Output clock
        o_Clk : out std_logic;
        o_Led_1 : out std_logic;
        o_Led_2 : out std_logic
    );
end entity Eater_6502_Top;

architecture rtl of Eater_6502_Top is
    signal r_Address : unsigned(15 downto 0) := (others => '0');
    signal r_Data : unsigned(7 downto 0) := (others => '0');
    signal r_RW : std_logic := '0';
    signal w_Clk : std_logic;
    signal r_Led_1 : std_logic := '0';
begin

    -- Frequency divider to generate a slow clock (10Hz)
    -- rPLL : entity work.Gowin_rPLL
    -- port map(
    --     clkout => w_Clk,
    --     clkin => i_Ext_Clk
    -- );
    FreqDiv : entity work.Frequency_Divider
        generic map(
            DIVIDER => 27_000_000 / 20
        )
        port map(
            i_Clk => i_Ext_Clk,
            o_Clk => w_Clk
        );
    -- Process to generate the address bus
    process (w_Clk, i_RESET_n)
    begin
        -- Reset board with button
        if i_RESET_n = '0' then
            r_Address <= (others => '0');
            r_Data <= (others => '0');

        elsif rising_edge(w_Clk) then
            -- Advance addresses and data
            r_Address <= r_Address + 1;
            r_Data <= r_Data + 1;
            r_Led_1 <= not r_Led_1;
        end if;
    end process;

    o_Address <= std_logic_vector(r_Address);
    io_Data <= std_logic_vector(r_Data) when r_RW = '0' else
        (others => 'Z');
    o_RW <= r_RW;
    o_Clk <= w_Clk;
    o_Led_1 <= r_Led_1;
    o_Led_2 <= not r_Led_1;

end rtl;