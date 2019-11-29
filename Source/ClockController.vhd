library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity ClockController is
	Port ( 
		CLK : in std_logic;
		TimeIn : in std_logic_vector (23 downto 0);
		SetTime : in std_logic;
		CurrentTime : out std_logic_vector (23 downto 0)
	);
end ClockController;

architecture Behavioral of ClockController is
	type TClockMode is (RunningTime, SettingTime);
	signal CurrentMode: TClockMode := RunningTime;
	 
	signal IncrementedSeconds: std_logic_vector(7 downto 0) := (others => '0');
	
	signal Seconds: std_logic_vector(7 downto 0) := (others => '0');
	signal Minutes: std_logic_vector(7 downto 0) := (others => '0');
	signal Hours: std_logic_vector(7 downto 0) := (others => '0');
begin
	IncrementSeconds: process (CLK)
	begin
		if rising_edge(CLK) and CurrentMode = RunningTime then
			IncrementedSeconds <= Seconds + 1;
		end if;
	end process;
	

	Main: process (IncrementedSeconds, SetTime)
		variable TMPSeconds : std_logic_vector(7 downto 0);
		variable TMPMinutes : std_logic_vector(7 downto 0);
		variable TMPHours : std_logic_vector(7 downto 0);
	begin
		if rising_edge(SetTime) then
			CurrentMode <= SettingTime;
			Seconds <= TimeIn(7 downto 0);
			Minutes <= TimeIn(15 downto 8);
			Hours <= TimeIn(23 downto 16);
			CurrentMode <= RunningTime;
		else
			TMPSeconds := IncrementedSeconds;
			TMPMinutes := Minutes;
			TMPHours := Hours;
			if TMPSeconds = "00111100" then
				TMPSeconds := "00000000";
				TMPMinutes := TMPMinutes + 1;
			end if;
			
			if TMPMinutes = "00111100" then
				TMPMinutes := "00000000";
				TMPHours := TMPHours + 1;
			end if;
			
			if TMPHours = "00001100" then
				TMPHours := "00000000";
			end if;
			
			Seconds <= TMPSeconds;
			Minutes <= TMPMinutes;
			Hours <= TMPHours;
		end if;
	end process;
	
	CurrentTime <= Hours & Minutes & Seconds;
end Behavioral;

