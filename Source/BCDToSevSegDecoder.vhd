library ieee;
use ieee.std_logic_1164.all;

entity BCDToSevSegDecoder is
    port (
		Encoded: in std_logic_vector(3 downto 0);
		Decoded: out std_logic_vector(6 downto 0)
	);
end BCDToSevSegDecoder;

architecture behavioral of BCDToSevSegDecoder is
	constant Dig0: std_logic_vector(6 downto 0) := "0000001";
	constant Dig1: std_logic_vector(6 downto 0) := "1001111";
	constant Dig2: std_logic_vector(6 downto 0) := "0010010";
	constant Dig3: std_logic_vector(6 downto 0) := "0000110";
	constant Dig4: std_logic_vector(6 downto 0) := "1001100";
	constant Dig5: std_logic_vector(6 downto 0) := "0100100";
	constant Dig6: std_logic_vector(6 downto 0) := "0100000";
	constant Dig7: std_logic_vector(6 downto 0) := "0001111";
	constant Dig8: std_logic_vector(6 downto 0) := "0000000";
	constant Dig9: std_logic_vector(6 downto 0) := "0000100";
	constant CharHyphen: std_logic_vector(6 downto 0) := "1000000";
begin
	with Encoded select Decoded <=
		Dig0 when "0000",
		Dig1 when "0001",
		Dig2 when "0010",
		Dig3 when "0011",
		Dig4 when "0100",
		Dig5 when "0101",
		Dig6 when "0110",
		Dig7 when "0111",
		Dig8 when "1000",
		Dig9 when "1001",
		CharHyphen when others;
end behavioral;
