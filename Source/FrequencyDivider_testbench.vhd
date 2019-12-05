LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY FrequencyDivider_testbench IS
END FrequencyDivider_testbench;
 
ARCHITECTURE behavior OF FrequencyDivider_testbench IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT FrequencyDivider
    PORT(
         CLK : IN  std_logic;
         RST : IN  std_logic;
         CE : IN  std_logic;
         K : IN  std_logic_vector(1 downto 0);
         DividedCLK : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal CLK : std_logic := '0';
   signal RST : std_logic := '0';
   signal CE : std_logic := '0';
   signal K : std_logic_vector(1 downto 0) := (others => '0');

 	--Outputs
   signal DividedCLK : std_logic;

   -- Clock period definitions
   constant CLK_period : time := 10 ns;

BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: FrequencyDivider PORT MAP (
          CLK => CLK,
          RST => RST,
          CE => CE,
          K => K,
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

		K <= "01";
      CE <= '1';

      wait;
   end process;

END;
