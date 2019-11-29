library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.MATH_REAL.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ROM is
	generic (
		word_size: integer := 8;
		rom_size: integer := 128
	);
	port (
		ADDR: in std_logic_vector(natural(log2(real(rom_size))) - 1 downto 0);
		Dout: out std_logic_vector(word_size - 1 downto 0)
	);
end ROM;

architecture Behavioral of ROM is
type ROM_type is array(0 to rom_size - 1) of std_logic_vector(word_size - 1 downto 0);
constant ROM_values: ROM_type := (
	x"7F", x"85", x"8B", x"91", x"97", x"9D", x"A3", x"A9", x"AF", x"B5",
	x"BA", x"C0", x"C5", x"CA", x"CF", x"D4", x"D8", x"DD", x"E1", x"E5",
	x"E8", x"EB", x"EF", x"F1", x"F4", x"F6", x"F8", x"FA", x"FB", x"FC",
	x"FD", x"FD", x"FD", x"FD", x"FD", x"FC", x"FB", x"FA", x"F8", x"F6",
	x"F4", x"F1", x"EF", x"EB", x"E8", x"E5", x"E1", x"DD", x"D8", x"D4",
	x"CF", x"CA", x"C5", x"C0", x"BA", x"B5", x"AF", x"A9", x"A3", x"9D",
	x"97", x"91", x"8B", x"85", x"7F", x"78", x"72", x"6C", x"66", x"60",
	x"5A", x"54", x"4E", x"48", x"43", x"3D", x"38", x"33", x"2E", x"29",
	x"25", x"20", x"1C", x"19", x"15", x"12", x"0F", x"0C", x"09", x"07",
	x"05", x"03", x"02", x"01", x"00", x"00", x"00", x"00", x"00", x"01",
	x"02", x"03", x"05", x"07", x"09", x"0C", x"0E", x"12", x"15", x"18",
	x"1C", x"20", x"25", x"29", x"2E", x"33", x"38", x"3D", x"43", x"48",
	x"4E", x"54", x"5A", x"60", x"66", x"6C", x"72", x"78"
);
begin
	Main : process(ADDR)
   begin
		Dout <= ROM_values(conv_integer(unsigned(ADDR)));
   end process;
end Behavioral;
