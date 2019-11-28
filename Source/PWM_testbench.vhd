LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY PWM_testbench IS
END PWM_testbench;
 
ARCHITECTURE behavior OF PWM_testbench IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT PWM
    PORT(
         CLK : IN  std_logic;
         FULL_RESET : IN  std_logic;
         RESTART : IN  std_logic;
         PERIOD : IN  std_logic_vector(7 downto 0);
         PULSE : IN  std_logic_vector(7 downto 0);
         PWM_SIGNAL : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal CLK : std_logic := '0';
   signal FULL_RESET : std_logic := '0';
   signal RESTART : std_logic := '0';
   signal PERIOD : std_logic_vector(7 downto 0) := (others => '0');
   signal PULSE : std_logic_vector(7 downto 0) := (others => '0');

 	--Outputs
   signal PWM_SIGNAL : std_logic;

   -- Clock period definitions
   constant CLK_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: PWM PORT MAP (
          CLK => CLK,
          FULL_RESET => FULL_RESET,
          RESTART => RESTART,
          PERIOD => PERIOD,
          PULSE => PULSE,
          PWM_SIGNAL => PWM_SIGNAL
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
      FULL_RESET <= '1';
      wait for 100 ns;	
		FULL_RESET <= '0';
      wait for CLK_period*10;

      PERIOD <= conv_std_logic_vector(100, 8);
		PULSE <= conv_std_logic_vector(20, 8);

      wait;
   end process;

END;
