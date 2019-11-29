library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity InputDriver is
	PORT(
		Enable : in std_logic;
		
		Up : in std_logic;
		Down : in std_logic;
		Left : in std_logic;
		Right : in std_logic;
		
		CurrentTime : in std_logic_vector(23 downto 0);
		UpdatedTime : out std_logic_vector(23 downto 0)
	);
end InputDriver;

architecture Behavioral of InputDriver is
	type TSelectedPeriod is (HoursPeriod, MinutesPeriod, SecondsPeriod);
	signal CurrentPeriod: TSelectedPeriod := SecondsPeriod;
	
	signal Seconds: std_logic_vector(7 downto 0) := (others => '0');
	signal Minutes: std_logic_vector(7 downto 0) := (others => '0');
	signal Hours: std_logic_vector(7 downto 0) := (others => '0');
	
	signal SecondsUpdated: std_logic_vector(7 downto 0) := (others => '0');
	signal MinutesUpdated: std_logic_vector(7 downto 0) := (others => '0');
	signal HoursUpdated: std_logic_vector(7 downto 0) := (others => '0');
	
begin
	SelectPeriod: process (Left, Right)
	variable TempPeriod : TSelectedPeriod := CurrentPeriod;
	begin
		if Enable = '1' then
			if rising_edge(Left) then
				case TempPeriod is
					when SecondsPeriod => TempPeriod := MinutesPeriod;
					when MinutesPeriod => TempPeriod := HoursPeriod;
					when HoursPeriod   => TempPeriod := SecondsPeriod;
					when others 	    => TempPeriod := SecondsPeriod;
				end case;
			end if;
			if rising_edge(Right) then
				case TempPeriod is
					when SecondsPeriod => TempPeriod := HoursPeriod;
					when MinutesPeriod => TempPeriod := SecondsPeriod;
					when HoursPeriod   => TempPeriod := MinutesPeriod;
					when others 	    => TempPeriod := SecondsPeriod;
				end case;
			end if;
			
			CurrentPeriod <= TempPeriod;
		end if;
	end process;
	
	ChangeValue: process (Up, Down)
		variable TMPSeconds : std_logic_vector(7 downto 0);
		variable TMPMinutes : std_logic_vector(7 downto 0);
		variable TMPHours : std_logic_vector(7 downto 0);
	begin
		if Enable = '1' then
			TMPSeconds := Seconds;
			TMPMinutes := Minutes;
			TMPHours := Hours;
			
			if rising_edge(Up) then
				case CurrentPeriod is
					when SecondsPeriod => TMPSeconds := TMPSeconds + 1;
					when MinutesPeriod => TMPMinutes := TMPMinutes + 1;
					when HoursPeriod   => TMPHours := TMPHours + 1;
					when others 	    => TMPSeconds := TMPSeconds + 1;
				end case;	
			end if;
			
			if rising_edge(Down) then
				case CurrentPeriod is
					when SecondsPeriod => TMPSeconds := TMPSeconds - 1;
					when MinutesPeriod => TMPMinutes := TMPMinutes - 1;
					when HoursPeriod   => TMPHours := TMPHours - 1;
					when others 	    => TMPSeconds := TMPSeconds - 1;
				end case;	
			end if;
			
			if TMPSeconds = "00111100" then 
				TMPSeconds := (others => '0');
			elsif TMPSeconds = "11111111" then 
				TMPSeconds := "00111011";
			end if;
			
			if TMPMinutes = "00111100" then 
				TMPMinutes := (others => '0');
			elsif TMPMinutes = "11111111" then 
				TMPMinutes := "00111011";
			end if;
			
			if TMPHours = "00001100" then 
				TMPHours := (others => '0');
			elsif TMPHours = "11111111" then 
				TMPHours := "00010111";
			end if;
			
			SecondsUpdated <= TMPSeconds;
			MinutesUpdated <= TMPMinutes;
			HoursUpdated <= TMPHours;
		end if;
	end process;
	
	ChangeVassslue: process (Enable, SecondsUpdated, MinutesUpdated, HoursUpdated)
	begin
		if rising_edge(Enable) then
			Seconds <= CurrentTime(7 downto 0);
			Minutes <= CurrentTime(15 downto 8);
			Hours <= CurrentTime(23 downto 16);
		else
			Seconds <= SecondsUpdated;
			Minutes <= MinutesUpdated;
			Hours <= HoursUpdated;
		end if;
	end process;
	
	UpdatedTime <= Hours & Minutes & Seconds;

end Behavioral;