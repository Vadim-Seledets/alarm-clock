LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use ieee.numeric_std.all;

ENTITY ClockController_Tests IS
END ClockController_Tests;
 
ARCHITECTURE behavior OF ClockController_Tests IS 
    COMPONENT ClockController
    PORT(
         CLK : IN  std_logic;
         TimeIn : IN  std_logic_vector(23 downto 0);
         SetTime : IN  std_logic;
         CurrentTime : OUT  std_logic_vector(23 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal CLK : std_logic := '0';
   signal TimeIn : std_logic_vector(23 downto 0) := (others => '0');
   signal SetTime : std_logic := '0';

 	--Outputs
   signal CurrentTime : std_logic_vector(23 downto 0);
	
	signal Seconds: integer;
	signal Minutes: integer;
	signal Hours: integer;

   -- Clock period definitions
   constant CLK_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: ClockController PORT MAP (
          CLK => CLK,
          TimeIn => TimeIn,
          SetTime => SetTime,
          CurrentTime => CurrentTime
        );
   -- Clock process definitions
   CLK_process :process
   begin
		CLK <= '0';
		wait for CLK_period/2;
		CLK <= '1';
		wait for CLK_period/2;
   end process;
	
	Seconds <= to_integer(unsigned(CurrentTime(7 downto 0)));
	Minutes <= to_integer(unsigned(CurrentTime(15 downto 8)));
	Hours <= to_integer(unsigned(CurrentTime(23 downto 16)));

END;
