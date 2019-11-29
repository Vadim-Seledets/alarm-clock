LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY AudioDriver_testbench IS
END AudioDriver_testbench;
 
ARCHITECTURE behavior OF AudioDriver_testbench IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT AudioDriver
    PORT(
         PlayEnable : IN  std_logic;
         CLK : IN  std_logic;
         RST : IN  std_logic;
         MUSIC : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal PlayEnable : std_logic := '0';
   signal CLK : std_logic := '0';
   signal RST : std_logic := '0';

 	--Outputs
   signal MUSIC : std_logic;

   -- Clock period definitions
   constant CLK_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: AudioDriver PORT MAP (
          PlayEnable => PlayEnable,
          CLK => CLK,
          RST => RST,
          MUSIC => MUSIC
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

      PlayEnable <= '1';
		wait for 100 ms;
		PlayEnable <= '0';
		
      wait;
   end process;

END;
