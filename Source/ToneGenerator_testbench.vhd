LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY ToneGenerator_testbench IS
END ToneGenerator_testbench;
 
ARCHITECTURE behavior OF ToneGenerator_testbench IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT ToneGenerator
    PORT(
         Tone: in integer range 0 to 255;
			Duration: in integer;
			Enable : IN std_logic;
         CLK : IN  std_logic;
         RST : IN  std_logic;
         Finished : OUT  std_logic;
         Audio : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal Tone: integer range 0 to 255 := 0;
	signal Duration: integer := 0;
	signal Enable : std_logic := '0';
   signal CLK : std_logic := '0';
   signal RST : std_logic := '0';

 	--Outputs
   signal Finished : std_logic;
   signal Audio : std_logic;

   -- Clock period definitions
   constant CLK_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: ToneGenerator PORT MAP (
          Tone => Tone,
          Duration => Duration, --ms
			 Enable => Enable,
          CLK => CLK,
          RST => RST,
          Finished => Finished,
          Audio => Audio
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

      Tone <= 74;
		Duration <= 3;
		Enable <= '1';
		
		Tone <= 200;
		Duration <= 6;
		
      wait;
   end process;

END;
