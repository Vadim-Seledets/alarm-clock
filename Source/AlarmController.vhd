library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity AlarmController is
	Port ( 
		CurrentTime : in std_logic_vector (23 downto 0);
		AlarmTime : in std_logic_vector (23 downto 0);
		SetTime : in std_logic;
		AlarmReset: in std_logic;
		Alarm : out std_logic
	);
end AlarmController;

architecture Behavioral of AlarmController is
	signal SetedTime: std_logic := '0';
	signal TAlarm: std_logic := '0';
	signal SavedAlarmTime: std_logic_vector(23 downto 0) := (others => '0');
begin
	SetAlarm: process (CurrentTime, AlarmReset)
	begin
		if AlarmReset = '1' then
			TAlarm <= '0';
		else
			if SetedTime = '1' and CurrentTime = SavedAlarmTime then
				TAlarm <= '1';
			end if;
		end if;
	end process;

	SetTimeAlarm: process (SetTime)
	begin
		if rising_edge(SetTime) then
			SavedAlarmTime <= AlarmTime;
			SetedTime <= '1';
		end if;
	end process;
	
	Alarm <= TAlarm;
end Behavioral;

