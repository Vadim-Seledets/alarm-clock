LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY FREQ_DIVIDER_testbench IS
END FREQ_DIVIDER_testbench;
 
ARCHITECTURE behavior OF FREQ_DIVIDER_testbench IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT ClockDivider
	 GENERIC (size: integer := 24);
    PORT(
         CLK : in std_logic;
			CLR : in std_logic;
			Threshold : in std_logic_vector(size - 1 downto 0);
			DividedCLK : out std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal Threshold : std_logic_vector(31 downto 0) := (others => '0');
	signal CLR : std_logic := '0';
   signal CLK : std_logic := '0';

 	--Outputs
   signal DividedCLK : std_logic;

   -- Clock period definitions
   constant CLK_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: ClockDivider PORT MAP (
          CLK => CLK,
			 CLR => CLR,
			 Threshold => Threshold,
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
      CLR <= '1';
      wait for 100 ns;	
		CLR <= '0';
      
		Threshold <= conv_std_logic_vector(3, 32);
		
      wait;
   end process;

END;
