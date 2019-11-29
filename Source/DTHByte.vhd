library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity DTHByte is
    Port ( Hec : in  STD_LOGIC_VECTOR (7 downto 0);
           Hexadecimal : out  STD_LOGIC_VECTOR (7 downto 0));
end DTHByte;

architecture Behavioral of DTHByte is

	function cvString (N, L: Natural) return String
	-- Accepts a number N to convert into a string of length L.  If the resulting
	-- string is too small, you get the least-significant digits of N in the
	-- returned string.
	is
	  variable Temp: Natural := N;
	  variable Result: String(1 to L) := (others => ' ');
	begin
	  for i in Result'reverse_range loop
		 Result(i) := Character'Val((Temp mod 10) + Character'Pos('0'));
		 Temp := Temp/10;
		 exit when Temp = 0;
	  end loop;
	  return Result;
	end cvString;

begin

	IncrementSeconds: process (Hec)
		variable tempStr : string(1 to 2) := "00";
		variable digitFirst : std_logic_vector(3 downto 0):= "0000";
		variable digitSecond : std_logic_vector(3 downto 0):= "0000";
	begin
		tempStr := cvString(conv_integer(Hec), 2);
		digitFirst := conv_std_logic_vector(character'pos(tempStr(1)), digitFirst'length);
		digitSecond := conv_std_logic_vector(character'pos(tempStr(2)), digitSecond'length);
		Hexadecimal <= digitFirst & digitSecond;
	end process;
end Behavioral;

