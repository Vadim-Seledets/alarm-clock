library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

entity AlarmClock is
	Port (
		CLK: in std_logic;
		Up, Down, Left, Right: in std_logic; -- Buttons
		Reset: in std_logic; -- Switch
		TargetToSetTime: in std_logic; -- Switch -- 0 - to Timer; 1 - to Alarm
		EditEnable: in std_logic; -- Switch
		Audio: out std_logic;
		AlarmLed: out std_logic;
		DisplayData: out std_logic_vector(6 downto 0);
		DisplayControl: out std_logic_vector(5 downto 0)
	);
end AlarmClock;

architecture Behavioral of AlarmClock is
	component FDIV is
		port (
			Threshold: in std_logic_vector(31 downto 0);
			CLK: in std_logic;
			DividedCLK: out std_logic
		);
	end component;
	
	component InputDriver is
		port(
			Enable : in std_logic;
			CLK : in std_logic;
			
			Up : in std_logic;
			Down : in std_logic;
			Left : in std_logic;
			Right : in std_logic;
			
			CurrentTime : in std_logic_vector(23 downto 0);
			UpdatedTime : out std_logic_vector(23 downto 0)
		);
	end component;
	
	component FSMClockUnit is
		Port (
			CLK: in std_logic;
			TimeIn: in std_logic_vector(23 downto 0);
			TargetToSet: in std_logic; -- 0 - to Timer; 1 - to Alarm
			SetTime: in std_logic;
			AlarmReset: in std_logic;
			CurrentTime: out std_logic_vector(23 downto 0);
			Alarm: out std_logic
		);
	end component;

	component DecToHexadecimal is
		Port ( 
			Dec : in  std_logic_vector (23 downto 0);
			Hexadecimal : out  std_logic_vector (23 downto 0)
		);
	end component;
	
	component SevenSegmentDisplay is
		 Port (
			CLK: in std_logic;
			Data: in std_logic_vector(23 downto 0);
			DecodedData: out std_logic_vector(6 downto 0);
			Control: out std_logic_vector(5 downto 0)
		);
	end component;
	
	component AudioDriver is
		Port (
			PlayEnable: in std_logic;
			CLK: in std_logic;
			RST: in std_logic;
			Audio: out std_logic
		);
	end component;
	
	constant REAL_TIME_CLOCK_THREASHOLD: std_logic_vector(31 downto 0) := conv_std_logic_vector(100000000, 32);
	constant INPUT_CLOCK_THREASHOLD: std_logic_vector(31 downto 0) := conv_std_logic_vector(10000000, 32);
	constant SEVEN_SEGMENT_DISPLAY_CLOCK_THREASHOLD: std_logic_vector(31 downto 0) := conv_std_logic_vector(25000, 32);
	
	-- Clocks
	signal InputClock : std_logic;
	signal RealTimeClock : std_logic;
	signal SevenSegmentDisplayClock : std_logic;
	
	-- Stored value
	signal CurrentAlarmTime : std_logic_vector(23 downto 0);
	signal CurrentClockTime : std_logic_vector(23 downto 0);
	
	-- Temp value
	signal Alarm : std_logic;
	signal CurrentTime : std_logic_vector(23 downto 0);
	signal TempDisplayData : std_logic_vector(23 downto 0);
	signal TimeToSet : std_logic_vector(23 downto 0);
	signal Hexadecimal : std_logic_vector(23 downto 0);
	
begin
	CurrentTime <= CurrentClockTime when TargetToSetTime = '0' else CurrentAlarmTime;
	CurrentAlarmTime <= TimeToSet when EditEnable = '1' and TargetToSetTime = '1' else CurrentAlarmTime;
	TempDisplayData <= CurrentClockTime when EditEnable = '0' or TargetToSetTime = '0' else CurrentAlarmTime;
	AlarmLed <= Alarm;
	
	REAL_TIME_CLOCK_DIVIDER: FDIV
		port map (
			Threshold => REAL_TIME_CLOCK_THREASHOLD, 
			CLK => CLK, 
			DividedCLK => RealTimeClock
		);
	
	INPUT_CLOCK_DIVIDER: FDIV
		port map (
			Threshold => INPUT_CLOCK_THREASHOLD, 
			CLK => CLK, 
			DividedCLK => InputClock
		);

	SEVEN_SEGMENT_DISPLAY_CLOCK_DIVIDER: FDIV
		port map (
			Threshold => SEVEN_SEGMENT_DISPLAY_CLOCK_THREASHOLD, 
			CLK => CLK, 
			DividedCLK => SevenSegmentDisplayClock
		);

	INPUT_DRIVER: InputDriver
		port map (
			Enable => EditEnable,
			CLK => InputClock,
			Up => Up, 
			Down => Down, 
			Left => Left, 
			Right => Right, 
			CurrentTime => CurrentTime, 
			UpdatedTime => TimeToSet
		);
	
	FSM_CLOCK_UNIT: FSMClockUnit
		port map (
			CLK => RealTimeClock, 
			TimeIn => TimeToSet,
			TargetToSet => TargetToSetTime, 
			SetTime => EditEnable, 
			AlarmReset => Reset, 
			CurrentTime => CurrentClockTime, 
			Alarm => Alarm
		);
		
	DEC_TO_HEXADECIMAL: DecToHexadecimal
		port map (
			Dec => TempDisplayData, 
			Hexadecimal => Hexadecimal
		);
	
	SEVEN_SEGMENT_DISPLAY: SevenSegmentDisplay
		port map (
			CLK => SevenSegmentDisplayClock, 
			Data => Hexadecimal, 
			DecodedData => DisplayData, 
			Control => DisplayControl
		);
		
	AUDIO_DRIVER: AudioDriver
		port map (
			CLK => CLK,
			PlayEnable => Alarm,
			RST => Reset,
			Audio => Audio
		);
	
end Behavioral;

