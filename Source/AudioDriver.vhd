library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity AudioDriver is
	port (
		PlayEnable: in std_logic;
		CLK: in std_logic
	);
end AudioDriver;

architecture Behavioral of AudioDriver is

component FDIV is
	generic (Threshold: integer);
	port (
		CLK: in std_logic;
		DividedCLK: out std_logic
	);
end component;

component PWM is
	generic (
		N: integer := 8
	);
	port (
		CLK: in std_logic;
		FULL_RESET: in std_logic;
		RESTART: in std_logic;
		PERIOD: in std_logic_vector(N - 1 downto 0);
		PULSE: in std_logic_vector(N - 1 downto 0);
		PWM_SIGNAL: out std_logic
	);
end component;

component ROM is
	generic (
		word_size: integer := 8;
		rom_size: integer := 4
	);
	port (
		ADDR: in std_logic_vector(natural(log2(real(rom_size))) - 1 downto 0);
		Dout: out std_logic_vector(word_size - 1 downto 0)
	);
end component;

signal DividedCLK: std_logic := '0';

signal SIGNAL_CLK: integer := 0;

begin
	FREQ_DIVIDER: FDIV
		generic map (Threshold => DriverFDivThreshold)
		port map (CLK => CLK, DividedCLK => DividedCLK);
end Behavioral;

