----------------------------------------------------------------------------------
-- Create Date: 07.04.2026 21:44:25
-- Design Name: Electronic Voting Machine (EVM)
-- Module Name: EVM - Behavioral
-- Project Name: Electronic Voting Machine
-- Target Devices: ZedBoard
-- Tool Versions: Xilinx Vivado 2025.2
--
-- Description:
-- This design implements a simple Electronic Voting Machine (EVM) using VHDL.
-- The system allows voting for four candidates using push buttons and displays 
-- the vote count on LEDs.
--
-- Key Features:
-- 1. Clock Division:
--    - A separate clock divider module (clock_1hzsync) is instantiated to 
--      generate a slow clock (~1 Hz) from the input system clock.
--    - This slow clock is used to reliably sample button inputs.
--
-- 2. Voting Mode (mode = '0'):
--    - Four buttons (btn[3:0]) represent four candidates (A, B, C, D).
--    - On each valid button press (edge detected using previous state),
--      the corresponding candidate's vote count is incremented.
--
-- 3. Result Mode (mode = '1'):
--    - The vote count of a selected candidate is displayed on LEDs.
--    - Selection is done using the same button inputs.
--
-- 4. Reset Functionality:
--    - When reset = '1', all vote counters and stored button states are cleared.
--    - Ensures the system returns to initial state.
--
-- 5. Edge Detection:
--    - Previous button state (btn_prev) is stored to detect new presses
--      and avoid multiple counts due to button hold.
--
-- Inputs:
--    clk   : System clock input (e.g., 50 MHz)
--    reset : Active-high reset signal
--    mode  : Mode select (0 = Voting, 1 = Result display)
--    btn   : 4-bit input representing candidate selection
--
-- Outputs:
--    leds  : 8-bit output displaying vote count
--
-- Dependencies:
--    - clock_1hzsync (Clock Divider Module)
--
-- Revision:
-- Revision 0.02 - Added clock divider instantiation and reset functionality
--
-- Additional Comments:
-- - This design uses a derived slow clock; in advanced FPGA design,
--   a clock enable approach is recommended instead.
-- - Button debouncing is not included and may be required for hardware reliability.
--
-- Designed By : Vaibhav Gupta (25583009)
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity EVM is
    Port (
        clk     : in  STD_LOGIC;  
        reset   : in  STD_LOGIC;  -- NEW reset input
        mode    : in  STD_LOGIC;  
        btn     : in  STD_LOGIC_VECTOR(3 downto 0);
        leds    : out STD_LOGIC_VECTOR(7 downto 0)
    );
end EVM;

architecture Behavioral of EVM is

    -- Component declaration of clock divider
    component clock_1hzsync
        Port (
            clk    : in  STD_LOGIC;
            clkout : out STD_LOGIC
        );
    end component;

    -- Signals
    signal slow_clk : STD_LOGIC;

    signal voteA, voteB, voteC, voteD : unsigned(7 downto 0) := (others => '0');
    signal btn_prev : STD_LOGIC_VECTOR(3 downto 0) := (others => '0');

begin

    ------------------------------------------------------------------
    -- Instantiate Clock Divider
    ------------------------------------------------------------------
    clk_div_inst : clock_1hzsync
        port map (
            clk    => clk,
            clkout => slow_clk
        );

    ------------------------------------------------------------------
    -- Voting Logic with Reset
    ------------------------------------------------------------------
    process(slow_clk)
    begin
        if rising_edge(slow_clk) then

            -- RESET CONDITION
            if reset = '1' then
                voteA <= (others => '0');
                voteB <= (others => '0');
                voteC <= (others => '0');
                voteD <= (others => '0');
                btn_prev <= (others => '0');

            elsif mode = '0' then  -- Voting mode

                if btn = "0001" and btn_prev /= "0001" then
                    voteA <= voteA + 1;

                elsif btn = "0010" and btn_prev /= "0010" then
                    voteB <= voteB + 1;

                elsif btn = "0100" and btn_prev /= "0100" then
                    voteC <= voteC + 1;

                elsif btn = "1000" and btn_prev /= "1000" then
                    voteD <= voteD + 1;

                end if;

                btn_prev <= btn;

            end if;
        end if;
    end process;

    ------------------------------------------------------------------
    -- Display Logic
    ------------------------------------------------------------------
    process(mode, btn, voteA, voteB, voteC, voteD)
    begin
        if mode = '1' then
            case btn is
                when "0001" => leds <= std_logic_vector(voteA);
                when "0010" => leds <= std_logic_vector(voteB);
                when "0100" => leds <= std_logic_vector(voteC);
                when "1000" => leds <= std_logic_vector(voteD);
                when others => leds <= (others => '0');
            end case;
        else
            leds <= (others => '0');
        end if;
    end process;

end Behavioral;