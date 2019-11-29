library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity FSMClockUnit is
	Port (
		CLK: in std_logic;
		TimeIn: in std_logic_vector(23 downto 0);
		TargetToSet: in std_logic; -- 0 - to Timer; 1 - to Alarm
		SetTime: in std_logic;
		AlarmReset: in std_logic;
		CurrentTime: out std_logic_vector(23 downto 0);
		Alarm: out std_logic
	);
end FSMClockUnit;

architecture Behavioral of FSMClockUnit is

	Component ClockController is
		Port (
			CLK : in std_logic;
			TimeIn : in std_logic_vector (23 downto 0);
			SetTime : in std_logic;
			CurrentTime : out std_logic_vector (23 downto 0)
		);
	end component;
	
	Component AlarmController is
		Port (
			CurrentTime : in std_logic_vector (23 downto 0);
			AlarmTime : in std_logic_vector (23 downto 0);
			SetTime : in std_logic;
			AlarmReset: in std_logic;
			Alarm : out std_logic
		);
	end component;
	
	signal SetTimeClock: std_logic := '0';
	signal SetTimeAlarm: std_logic := '0';
	
	signal SavedCurrentTime: std_logic_vector (23 downto 0);
begin

	SetTimeAlarm <= SetTime and TargetToSet;
	SetTimeClock <= SetTime and not TargetToSet;
	
	ClockControllerC: ClockController port map (
		CLK => CLK,
		TimeIn => TimeIn,
		SetTime => SetTimeClock,
		CurrentTime => SavedCurrentTime
	);
	
	AlarmControllerC: AlarmController port map (
		CurrentTime => SavedCurrentTime,
		AlarmTime => TimeIn,
		SetTime => SetTimeAlarm,
		AlarmReset => AlarmReset,
		Alarm => Alarm
	);
	
	CurrentTime <= SavedCurrentTime;
end Behavioral;

