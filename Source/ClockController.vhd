library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ClockController is
	Port ( 
		CLK : in std_logic;
		TimeIn : in std_logic_vector (23 downto 0);
		SetTime : in std_logic;
		CurrentTime : out std_logic_vector (23 downto 0)
	);
end ClockController;

architecture Behavioral of ClockController is
	type TClockMode is (RunningTimer, SettingTimer);
	signal CurrentMode: TClockMode;

	signal Seconds: std_logic_vector(7 downto 0) := (others => '0');
	signal Minutes: std_logic_vector(7 downto 0) := (others => '0');
	signal Hours: std_logic_vector(7 downto 0) := (others => '0');
begin
	SecondIncrement: process (CLK)
	begin
	  if rising_edge(CLK) and CurrentMode = RunningTimer then
			Seconds <= Seconds + 1;
	  end if;
	end process;

	SecondsOver: process (Seconds)
	begin
		if Seconds = "00111100" then
			Seconds <= "00000000";
			Minutes <= Minutes + 1;
		end if;
	end process;

	MinutesOver: process (Minutes)
	begin
		if Minutes = "00111100" then
			Minutes <= "00000000";
			Hours <= Hours + 1;
		end if;
	end process;

	HoursOver: process (Hours)
	begin
		if Hours = "00001100" then
			Hours <= "00000000";
		end if;
	end process;
	
	SetTime: process (SetTime)
	begin
		if rising_edge(SetTime)then
			CurrentMode <= SettingTimer;
			Seconds <= TimeIn(7 downto 0);
			Minutes <= TimeIn(15 downto 8);
			Hours <= TimeIn(23 downto 16);
			CurrentMode <= RunningTimer;
		end if;
	end process;
    
	CurrentTime <= Hours & Minutes & Seconds;
end Behavioral;

