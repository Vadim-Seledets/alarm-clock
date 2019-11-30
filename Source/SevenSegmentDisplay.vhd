library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity SevenSegmentDisplay is
    port (
		CLK: in std_logic;
		Data: in std_logic_vector(23 downto 0);
		DecodedData: out std_logic_vector(6 downto 0);
		Control: out std_logic_vector(5 downto 0)
	);
end SevenSegmentDisplay;

architecture behavioral of SevenSegmentDisplay is
	component BCDToSevSegDecoder is
		port (
			Encoded: in std_logic_vector(3 downto 0);
			Decoded: out std_logic_vector(6 downto 0)
		);
	end component;

	signal DigitIndex: std_logic_vector(2 downto 0) := "000";
	signal DataBinary: std_logic_vector(3 downto 0);
begin
	Decoder: BCDToSevSegDecoder port map (Encoded => DataBinary, Decoded => DecodedData);
	
	IncrementDigitIndex: process (CLK)
	begin
		if rising_edge(CLK) then
			DigitIndex <= DigitIndex + 1;
			if (DigitIndex = "110") then
				DigitIndex <= "000";
			end if;
		end if;
	end process;

	with DigitIndex select DataBinary <=
		Data(23 downto 20) when "000",
		Data(19 downto 16) when "001",
		Data(15 downto 12) when "010",
		Data(11 downto 8) when "011",
		Data(7 downto 4) when "100",
		Data(3 downto 0) when "101",
		"0000" when others;

	with DigitIndex select Control <=
		"011111" when "000",
		"101111" when "001",
		"110111" when "010",
		"111011" when "011",
		"111101" when "100",
		"111110" when "101",
		"111111" when others;
end behavioral;

