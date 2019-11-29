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

entity ToneGenerator is
	port (
		Tone: in integer;
		Duration: in integer;
		Enable: in std_logic;
		CLK: in std_logic;
		RST: in std_logic;
		Finished: out std_logic;
		Audio: out std_logic
	);
end ToneGenerator;

architecture Behavioral of ToneGenerator is

	component FDIV is
		port (
			Threshold: in std_logic_vector(31 downto 0);
			CLK: in std_logic;
			DividedCLK: out std_logic
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
	
	constant DURATION_CLK_THREASHOLD: std_logic_vector(31 downto 0) := conv_std_logic_vector(10000, 32);
	constant PWM_WIDTH: integer := 255;
	
	constant PWM_CLK_THRESHOLD: std_logic_vector(31 downto 0) := conv_std_logic_vector(10, 32); -- PWM frequency = 10 MHz
	
	signal s_clk: std_logic := '0';
	signal s_pwm_clk: std_logic := '0';
	signal s_signal_clk: std_logic := '0';
	signal s_duration_clk: std_logic := '0';
	
	-- PWM Options
	signal s_width: std_logic_vector(7 downto 0) := (others => '0');
	signal s_pulse: std_logic_vector(7 downto 0) := (others => '0');
	signal s_tone: std_logic_vector(31 downto 0) := (others => '0');
	
	-- Sine generation
	signal s_address: std_logic_vector(6 downto 0) := (others => '0');
	signal s_data: std_logic_vector(7 downto 0) := (others => '0');
	
	-- Duration
	signal s_duration_count: std_logic_vector(31 downto 0) := (others => '0');
	signal s_finished: std_logic := '0';
	
	signal s_audio: std_logic := '0';
begin
	s_clk <= CLK when Enable = '1' and s_finished = '0' else '0';
	s_width <= conv_std_logic_vector(PWM_WIDTH, 8);
	s_tone <= conv_std_logic_vector(Tone, 32);
	
	DURATION_FREQ_DIVIDER: FDIV
		port map (Threshold => DURATION_CLK_THREASHOLD, CLK => s_clk, DividedCLK => s_duration_clk);
	
	PWM_FREQ_DIVIDER: FDIV
		port map (Threshold => PWM_CLK_THRESHOLD, CLK => s_clk, DividedCLK => s_pwm_clk);
		
	SIGNAL_FREQ_DIVIDER: FDIV
		port map (Threshold => s_tone, CLK => s_pwm_clk, DividedCLK => s_signal_clk);
		
	ROM_U: ROM port map (s_address, s_data);
	
	PWM_U: PWM port map (
		CLK => s_pwm_clk,
		FULL_RESET => RST,
		RESTART => RST,
		WIDTH => s_width,
		PULSE => s_data,
		PWM_SIGNAL => s_audio
	);
	
	ChangeSineValue: process(RST, s_signal_clk)
	begin
		if RST = '1' then
			s_address <= (others => '0');
		elsif rising_edge(s_signal_clk) then
			s_address <= s_address + 1;
		end if;
	end process;
	
	WaitFor: process(RST, s_duration_clk)
	begin
		if RST = '1' then
			s_finished <= '0';
			s_duration_count <= (others => '0');
		elsif rising_edge(s_duration_clk) then
			if s_duration_count <= Duration then
				s_duration_count <= s_duration_count + 1;
			else
				s_finished <= '1';
			end if;
		end if;
	end process;
	
	Finished <= s_finished;
	Audio <= s_audio and (not s_finished);
end Behavioral;

