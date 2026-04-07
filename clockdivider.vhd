----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07.04.2026 21:50:26
-- Design Name: 
-- Module Name: clockdivider - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity clock_1hzsync is
    Port (
        clk    : in  STD_LOGIC;
        clkout : out STD_LOGIC
    );
end clock_1hzsync;

architecture Behavioral of clock_1hzsync is
    signal count  : unsigned(25 downto 0) := (others => '0');
    signal clkout_reg : STD_LOGIC := '0';
begin

    process(clk)
    begin
        if rising_edge(clk) then
            if count = to_unsigned(49999999, 26) then
                count <= (others => '0');
                clkout_reg <= not clkout_reg;
            else
                count <= count + 1;
            end if;
        end if;
    end process;

    clkout <= clkout_reg;

end Behavioral;
