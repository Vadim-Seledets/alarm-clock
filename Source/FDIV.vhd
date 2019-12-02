library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity FDIV is
    generic (
        size: integer
    );
    port (
        Threshold: std_logic_vector(size - 1 downto 0);
        CLK: in std_logic;
        DividedCLK: out std_logic
    );
end FDIV;

architecture behavioral of FDIV is    
    signal s_ticks: std_logic_vector(size - 1 downto 0) := (others => '0');
    signal s_result: std_logic := '0';
begin
    Main: process (CLK)
    begin
        if rising_edge(CLK) then 
            s_ticks <= s_ticks + 1;
            if s_ticks < Threshold then 
                s_result <= '0';
            else 
                s_result <= '1';
                s_ticks <= (others => '0');
            end if;
        end if;
    end process;

    DividedCLK <= s_result;
end behavioral;
