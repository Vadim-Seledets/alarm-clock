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

entity AudioDriver is
	port (
		PlayEnable: in std_logic;
		CLK: in std_logic;
		RST: in std_logic;
		MUSIC: out std_logic
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
		WIDTH: in std_logic_vector(N - 1 downto 0);
		PULSE: in std_logic_vector(N - 1 downto 0);
		PWM_SIGNAL: out std_logic
	);
end component;

component ROM is
	generic (
		word_size: integer := 8;
		rom_size: integer := 128
	);
	port (
		ADDR: in std_logic_vector(natural(log2(real(rom_size))) - 1 downto 0);
		Dout: out std_logic_vector(word_size - 1 downto 0)
	);
end component;

	constant PWM_CLK_THRESHOLD: integer := 10; -- PWM frequency = 10 MHz
	constant SIGNAL_CLK_THRESHOLD: integer := 150; -- Fsig = Fpwm / f / N, N = 128
	constant PWM_WIDTH: integer := 255;

	signal s_clk: std_logic := '0';
	signal s_pwm_clk: std_logic := '0';
	signal s_signal_clk: std_logic := '0';
	signal s_address: std_logic_vector(6 downto 0) := (others => '0');
	signal s_data: std_logic_vector(7 downto 0) := (others => '0');
	
begin
	s_clk <= CLK when PlayEnable = '1' else '0';
	
	PWM_FREQ_DIVIDER_U: FDIV
		generic map (Threshold => PWM_CLK_THRESHOLD)
		port map (CLK => s_clk, DividedCLK => s_pwm_clk);
	SIGNAL_FREQ_DIVIDER: FDIV
		generic map (Threshold => SIGNAL_CLK_THRESHOLD)
		port map (CLK => s_pwm_clk, DividedCLK => s_signal_clk);
	ROM_U: ROM port map (s_address, s_data);
	PWM_U: PWM port map (
		CLK => s_pwm_clk,
		FULL_RESET => RST,
		RESTART => RST,
		WIDTH => conv_std_logic_vector(PWM_WIDTH, 8),
		PULSE => s_data,
		PWM_SIGNAL => MUSIC
	);
	
	ChangeSineValue: process(RST, s_signal_clk)
	begin
		if RST = '1' then
			s_address <= (others => '0');
		elsif rising_edge(s_signal_clk) then
			s_address <= s_address + 1;
		end if;
	end process;
end Behavioral;

