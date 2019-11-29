LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY FDIV_tb IS
END FDIV_tb;
 
ARCHITECTURE behavior OF FDIV_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT FDIV
    PORT(
         Threshold : IN  std_logic_vector(31 downto 0);
         CLK : IN  std_logic;
         DividedCLK : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal Threshold : std_logic_vector(31 downto 0) := (others => '0');
   signal CLK : std_logic := '0';

 	--Outputs
   signal DividedCLK : std_logic;

   -- Clock period definitions
   constant CLK_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: FDIV PORT MAP (
          Threshold => Threshold,
          CLK => CLK,
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
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for CLK_period*10;

      Threshold <= conv_std_logic_vector(5, 32);
		wait for 5 ms;
		
		Threshold <= conv_std_logic_vector(10, 32);
		wait for 5 ms;
		
		Threshold <= conv_std_logic_vector(15, 32);
		wait for 5 ms;

      wait;
   end process;

END;
