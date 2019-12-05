LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY FrequencyDividerByOddNumbers_testbench IS
END FrequencyDividerByOddNumbers_testbench;
 
ARCHITECTURE behavior OF FrequencyDividerByOddNumbers_testbench IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT FrequencyDividerByOddNumbers
    PORT(
         CLK : IN  std_logic;
         RST : IN  std_logic;
         CE : IN  std_logic;
         DividedCLK : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal CLK : std_logic := '0';
   signal RST : std_logic := '0';
   signal CE : std_logic := '0';

 	--Outputs
   signal DividedCLK : std_logic;

   -- Clock period definitions
   constant CLK_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: FrequencyDividerByOddNumbers PORT MAP (
          CLK => CLK,
          RST => RST,
          CE => CE,
          DividedCLK => DividedCLK
        );

   -- Clock process definitions
   CLK_process :process
   begin
		CLK <= '0';
		wait for CLK_period/2;
		CLK <= '1';
		wait for CLK_period/2;
   end process;

   -- Stimulus process
   stim_proc: process
   begin		
      RST <= '1';
      wait for 100 ns;	
		RST <= '0';
		
      wait for CLK_period*10;

      CE <= '1';

      wait;
   end process;

END;
