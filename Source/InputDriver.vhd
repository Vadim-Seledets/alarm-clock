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
	
	signal Seconds1: std_logic_vector(7 downto 0) := (others => '0');
	signal Minutes1: std_logic_vector(7 downto 0) := (others => '0');
	signal Hours1: std_logic_vector(7 downto 0) := (others => '0');
	
begin
	SelectPeriod: process (Enable, Left, Right)
	variable TempPeriod : TSelectedPeriod;
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
	
	ChangeValue: process (Enable, Up, Down)
		variable TempTime : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
		variable TMPSeconds : std_logic_vector(7 downto 0);
		variable TMPMinutes : std_logic_vector(7 downto 0);
		variable TMPHours : std_logic_vector(7 downto 0);
	begin
		if rising_edge(Enable) then
			Seconds <= CurrentTime(7 downto 0);
			Minutes <= CurrentTime(15 downto 8);
			Hours <= CurrentTime(23 downto 16);
		end if;
		
		if Enable = '1' then
			
			case CurrentPeriod is
				when SecondsPeriod => TempTime := Seconds;
				when MinutesPeriod => TempTime := Minutes;
				when HoursPeriod   => TempTime := Hours;
				when others 	    => TempTime := Seconds;
			end case;
				
			if rising_edge(Up) then
				TempTime := TempTime + 1;
			end if;
			
			if rising_edge(Down) then
				TempTime := TempTime - 1;
			end if;
			
			if TempTime = "00111100" or (TempTime = "00001100" and CurrentPeriod = HoursPeriod) then 
				TempTime := (others => '0');
			elsif TempTime = "11111111" then 
				TempTime := "00010111" when CurrentPeriod = HoursPeriod else "00111011";
			end if;
			
			case CurrentPeriod is
				when SecondsPeriod => Seconds <= TempTime;
				when MinutesPeriod => Minutes <= TempTime;
				when HoursPeriod   => Hours <= TempTime;
				when others 	    => Seconds <= TempTime;
			end case;		
		end if;
	end process;
	
	UpdatedTime <= Hours & Minutes & Seconds;

end Behavioral;

