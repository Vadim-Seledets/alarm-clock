library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity DecToHexadecimal is
    Port ( Hec : in  STD_LOGIC_VECTOR (23 downto 0);
           Hexadecimal : out  STD_LOGIC_VECTOR (23 downto 0));
end DecToHexadecimal;

architecture Behavioral of DecToHexadecimal is

	Component DTHByte is
	Port (
		Hec : in  std_logic_vector (7 downto 0);
		Hexadecimal : out  std_logic_vector (7 downto 0)
	);
	end component;
	
	signal SecondsConverted: std_logic_vector(7 downto 0) := (others => '0');
	signal MinutesConverted: std_logic_vector(7 downto 0) := (others => '0');
	signal HoursConverted: std_logic_vector(7 downto 0) := (others => '0');
begin
	SecondsConvert: DTHByte port map (
		Hec => Hec(7 downto 0),
		Hexadecimal => SecondsConverted
	);
	
	MinutesConvert: DTHByte port map (
		Hec => Hec(15 downto 8),
		Hexadecimal => MinutesConverted
	);
	
	HoursConvert: DTHByte port map (
		Hec => Hec(23 downto 16),
		Hexadecimal => HoursConverted
	);
	
	Hexadecimal <= HoursConverted & MinutesConverted & HoursConverted;
end Behavioral;

