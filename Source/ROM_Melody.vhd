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

entity ROM_Melody is
	generic (
		word_size: integer := 8;
		rom_size: integer := 8
	);
	port (
		ADDR: in std_logic_vector(natural(log2(real(rom_size))) - 1 downto 0);
		Dout: out std_logic_vector(word_size - 1 downto 0)
	);
end ROM_Melody;

architecture Behavioral of ROM_Melody is
	type ROM_type is array(0 to rom_size - 1) of std_logic_vector(word_size - 1 downto 0);
	constant ROM_values: ROM_type := (
		x"0F", x"1F", x"2F", x"3F", x"4F", x"5F", x"6F", x"7F"
	);
begin
	Main : process(ADDR)
   begin
		Dout <= ROM_values(conv_integer(unsigned(ADDR)));
   end process;
end Behavioral;
