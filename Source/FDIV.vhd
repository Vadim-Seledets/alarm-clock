library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity FDIV is
	port (
		Threshold: std_logic_vector(31 downto 0);
      CLK: in std_logic;
		DividedCLK: out std_logic
	);
end FDIV;

architecture behavioral of FDIV is	
	signal Ticks: std_logic_vector(31 downto 0) := (others => '0');
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
                Ticks <= (others => '0');
            end if;
        end if;
    end process;

    DividedCLK <= Result;
end behavioral;
