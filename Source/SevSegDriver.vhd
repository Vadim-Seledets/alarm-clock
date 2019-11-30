library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity SevSegDriver is
    port (
		CLK: in std_logic;
		D1, D2, D3, D4, D5, D6, D7, D8: in std_logic_vector(3 downto 0);
		Data: out std_logic_vector(6 downto 0);
		Control: out std_logic_vector(7 downto 0)
	);
end SevSegDriver;

architecture behavioral of SevSegDriver is
	component BCDToSevSegDecoder is
		port (
			Encoded: in std_logic_vector(3 downto 0);
			Decoded: out std_logic_vector(6 downto 0)
		);
	end component;

	signal DigitIndex: std_logic_vector(2 downto 0) := "000";
	signal DataBinary: std_logic_vector(3 downto 0);
begin
	IncrementDigitIndex: process (CLK)
	begin
		if rising_edge(CLK) then
			DigitIndex <= DigitIndex + 1;
			if (DigitIndex = "111") then
				DigitIndex <= "000";
			end if;
		end if;
	end process;

	with DigitIndex select DataBinary <=
		D8 when "000",
		D7 when "001",
		D6 when "010",
		D5 when "011",
		D4 when "100",
		D3 when "101",
		D2 when "110",
		D1 when others;

	Decoder: BCDToSevSegDecoder port map (Encoded => DataBinary, Decoded => Data);

	with DigitIndex select Control <=
		"01111111" when "000",
		"10111111" when "001",
		"11011111" when "010",
		"11101111" when "011",
		"11110111" when "100",
		"11111011" when "101",
		"11111101" when "110",
		"11111110" when others;
end behavioral;