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
	signal Alarm: std_logic := '0';
	signal SavedAlarmTime: std_logic_vector(23 downto 0) := (others => '0');
begin
	SetAlarm: process (CurrentTime)
	begin
		if CurrentTime = SavedAlarmTime then
			Alarm <= '1';
		end if;
	end process;

	SetTimeAlarm: process (SetTime)
	begin
		if rising_edge(SetTime) then
			SavedAlarmTime <= AlarmTime;
		end if;
	end process;
	
	ResetAlarm: process (AlarmReset)
	begin
		if rising_edge(AlarmReset) then
			Alarm <= '0';
		end if;
	end process;
end Behavioral;

