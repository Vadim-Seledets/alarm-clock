library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

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
	
	signal SetTimeClock: std_logic := 0;
	signal SetTimeAlarm: std_logic := 0;
	
	signal SavedCurrentTime: std_logic_vector (23 downto 0);
begin

	SetTime: process (SetTime)
	begin
		if SetTime = '1' then
			if TargetToSet = '0' then
				SetTimeClock <= '1';
			else
				SetTimeAlarm <= '1';
			end if;
		else
			SetTimeClock <= '0';
			SetTimeAlarm <= '0';
		end if;
	end process;
	
	ClockController: ClockController port map (
		CLK => CLK,
		TimeIn => TimeIn,
		SetTime => SetTimeClock,
		CurrentTime => SavedCurrentTime
	);
	
	AlarmController: AlarmController port map (
		CurrentTime => SavedCurrentTime,
		AlarmTime => TimeIn,
		SetTime => SetTimeAlarm,
		AlarmReset => AlarmReset,
		Alarm => Alarm
	);
	
	CurrentTime <= SavedCurrentTime;
end Behavioral;

