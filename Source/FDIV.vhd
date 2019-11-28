library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity FDIV is
    generic (Threshold: integer);
    port (
        CLK: in std_logic;
		DividedCLK: out std_logic
    );	  
end FDIV;

architecture behavioral of FDIV is
    signal Ticks: integer := 0;
    signal Result: std_logic := '0';
begin
    Main: process (CLK)
    begin
        if rising_edge(CLK) then 
            Ticks <= Ticks + 1;
            if Ticks < Threshold then 
                Result <= '0';
            else 
                Result <= '1';
                Ticks <= 0; 
            end if;
        end if;
    end process;

    DividedCLK <= Result;
end behavioral;
