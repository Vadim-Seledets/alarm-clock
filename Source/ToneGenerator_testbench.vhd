LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use Work.AudioDriverTypes.all;
 
ENTITY ToneGenerator_testbench IS
END ToneGenerator_testbench;
 
ARCHITECTURE behavior OF ToneGenerator_testbench IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT ToneGenerator
    PORT(
         Tone: in TTone;
			Duration: in TDuration;
			Load: in std_logic;
			Enable : IN std_logic;
         CLK : IN  std_logic;
         RST : IN  std_logic;
         Finished : OUT  std_logic;
         Audio : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal Tone: TTone;
	signal Duration: TDuration;
	signal Load: std_logic := '0';
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
			 Load => Load,
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
		Duration <= 100;
		wait for 100 ns;
		
		Load <= '1';
		wait for 20 ns;
		Load <= '0';
		Enable <= '1';
		
      wait;
   end process;

END;
