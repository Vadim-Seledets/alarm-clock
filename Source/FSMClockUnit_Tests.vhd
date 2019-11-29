LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
ENTITY FSMClockUnit_Tests IS
END FSMClockUnit_Tests;
 
ARCHITECTURE behavior OF FSMClockUnit_Tests IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT FSMClockUnit
    PORT(
         CLK : IN  std_logic;
         TimeIn : IN  std_logic_vector(23 downto 0);
         TargetToSet : IN  std_logic;
         SetTime : IN  std_logic;
         AlarmReset : IN  std_logic;
         CurrentTime : OUT  std_logic_vector(23 downto 0);
         Alarm : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal CLK : std_logic := '0';
   signal TimeIn : std_logic_vector(23 downto 0) := (others => '0');
   signal TargetToSet : std_logic := '0';
   signal SetTime : std_logic := '0';
   signal AlarmReset : std_logic := '0';

 	--Outputs
   signal CurrentTime : std_logic_vector(23 downto 0);
   signal Alarm : std_logic;

   -- Clock period definitions
   constant CLK_period : time := 10 ns;
	
   constant AlSeconds : std_logic_vector(7 downto 0) := "00010100";
   constant AlMinutes : std_logic_vector(7 downto 0) := "00001010";
   constant AlHours : std_logic_vector(7 downto 0) := "00000010";
	
	constant TSeconds : std_logic_vector(7 downto 0) := "00000000";
   constant TMinutes : std_logic_vector(7 downto 0) := "00001001";
   constant THours : std_logic_vector(7 downto 0) := "00000010";

BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: FSMClockUnit PORT MAP (
          CLK => CLK,
          TimeIn => TimeIn,
          TargetToSet => TargetToSet,
          SetTime => SetTime,
          AlarmReset => AlarmReset,
          CurrentTime => CurrentTime,
          Alarm => Alarm
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
      wait for CLK_period;
		
		TimeIn <= AlHours & AlMinutes & AlSeconds;
		TargetToSet <= '1';
		SetTime <= '1';
		
		wait for CLK_period;
		
		TimeIn <= THours & TMinutes & TSeconds;
		TargetToSet <= '0';
		
		wait for CLK_period;
		
		SetTime <= '0';
      wait;
   end process;

END;
