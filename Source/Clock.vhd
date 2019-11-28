library ieee;
use ieee.std_logic_1164.all;

entity Clock is
	port (
		Stop, Reset, Increment, ToggleMode, CLK: std_logic;
		DigitSelect: in std_logic_vector(1 downto 0);
		DisplayData: out std_logic_vector(6 downto 0);
		DisplayControl: out std_logic_vector(7 downto 0)
	);
end Clock;

architecture structural of Clock is
	component FDIV is
		generic (Threshold: integer);
		port (
			CLK: in std_logic;
			DividedCLK: out std_logic
		);
	end component;

	component SevSegDriver is
		port (
			CLK: in std_logic;
			D1, D2, D3, D4, D5, D6, D7, D8: in std_logic_vector(3 downto 0);
			Data: out std_logic_vector(3 downto 0);
			Control: out std_logic_vector(7 downto 0)
		);
	end component;
	
	component ClockFSM is
		port (
			CLK, Reset, Stop, ToggleMode, Increment: in std_logic;
			DigitSelect: in std_logic_vector(1 downto 0);
			HoursHigh, HoursLow, MinutesHigh, MinutesLow, 
			    SecondsHigh, SecondsLow, ExtraDigit2, ExtraDigit1: out std_logic_vector(3 downto 0)
		);
	end component;

	constant DriverFDivThreshold: integer := 25000;
	constant FSMFDivThreshold: integer := 10000000;

	signal DriverCLK, nDriverCLK, FSMCLK, nFSMCLK: std_logic;

	signal HoursHigh, HoursLow, MinutesHigh, MinutesLow, 
		SecondsHigh, SecondsLow, ExtraDigit2, ExtraDigit1: std_logic_vector(3 downto 0);
begin
	DriverFDiv: FDIV
		generic map (Threshold => DriverFDivThreshold)
		port map (CLK => CLK, DividedCLK => DriverCLK);
	nDriverCLK <= not DriverCLK;
	
	FSMFDiv: FDIV
		generic map (Threshold => FSMFDivThreshold)
		port map (CLK => CLK, DividedCLK => FSMCLK);
	nFSMCLK <= not FSMCLK;

	Driver: SevSegDriver port map (
			CLK => nDriverCLK,
			D1 => ExtraDigit1,
			D2 => ExtraDigit2,
			D3 => SecondsLow,
			D4 => SecondsHigh,
			D5 => MinutesLow,
			D6 => MinutesHigh,
			D7 => HoursLow,
			D8 => HoursHigh,
			Data => DisplayData,
			Control => DisplayControl
		);

	FSM: ClockFSM port map (
		CLK => nFSMCLK,
		Reset => Reset,
		Stop => Stop,
		ToggleMode => ToggleMode,
		Increment => Increment,
		DigitSelect => DigitSelect,
		ExtraDigit1 => ExtraDigit1,
		ExtraDigit2 => ExtraDigit2,
		SecondsLow => SecondsLow,
		SecondsHigh => SecondsHigh,
		MinutesLow => MinutesLow,
		MinutesHigh => MinutesHigh,
		HoursLow => HoursLow,
		HoursHigh => HoursHigh
	);
end structural;

