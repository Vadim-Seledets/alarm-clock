library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity BinToHexadecimalConverter is
	port (
		Din: in std_logic_vector(23 downto 0);
		Dout: out std_logic_vector(23 downto 0)
	);
end BinToHexadecimalConverter;

architecture Behavioral of BinToHexadecimalConverter is
	signal Seconds: std_logic_vector(7 downto 0) := (others => '0');
	signal Minutes: std_logic_vector(7 downto 0) := (others => '0');
	signal Hours: std_logic_vector(7 downto 0) := (others => '0');
begin
	Seconds <= Din(7 downto 0);
	Minutes <= Din(15 downto 8);
	Hours <= Din(23 downto 16);
	
	Dout <= Din(23 downto 8) & to_hex_string(Seconds);
end Behavioral;

