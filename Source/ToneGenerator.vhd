library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.MATH_REAL.ALL;
use Work.AudioDriverTypes.all;

entity ToneGenerator is
	port (
		Tone: in TTone;
		Duration: in TDuration;
		Load: in std_logic;
		Enable: in std_logic;
		CLK: in std_logic;
		RST: in std_logic;
		Finished: out std_logic;
		Audio: out std_logic
	);
end ToneGenerator;

architecture Behavioral of ToneGenerator is

	component FDIV is
		generic (
			size: integer := 32
		);
		port (
			Threshold: in std_logic_vector(size - 1 downto 0);
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
	
	constant TONE_SLV_SIZE: integer := 8;
	constant DURATION_SLV_SIZE: integer := 10;
	constant DURATION_CLK_SLV_SIZE: integer := 13;
	constant PWM_CLK_SLV_SIZE: integer := 4;
	
	constant DURATION_CLK_THREASHOLD: std_logic_vector(DURATION_CLK_SLV_SIZE - 1 downto 0) := conv_std_logic_vector(10000, DURATION_CLK_SLV_SIZE);
	constant PWM_CLK_THRESHOLD: std_logic_vector(PWM_CLK_SLV_SIZE - 1 downto 0) := conv_std_logic_vector(10, PWM_CLK_SLV_SIZE); -- PWM frequency = 10 MHz
	constant PWM_WIDTH: std_logic_vector(7 downto 0) := (others => '1');
	
	-- Clocks
	signal s_clk: std_logic := '0';
	signal s_pwm_clk: std_logic := '0';
	signal s_signal_clk: std_logic := '0';
	signal s_duration_clk: std_logic := '0';
	
	-- PWM Options
	signal s_width: std_logic_vector(7 downto 0) := (others => '0');
	signal s_pulse: std_logic_vector(7 downto 0) := (others => '0');
	
	-- Sine generation
	signal s_address: std_logic_vector(6 downto 0) := (others => '0');
	signal s_data: std_logic_vector(7 downto 0) := (others => '0');
	
	-- Audio options
	signal s_tone_slv: std_logic_vector(TONE_SLV_SIZE - 1 downto 0) := (others => '0');
	signal s_duration_slv: std_logic_vector(DURATION_SLV_SIZE - 1 downto 0) := (others => '0');
	signal s_finished: std_logic := '0';
	signal s_audio: std_logic := '0';
begin
	s_clk <= CLK when Enable = '1' else '0';
	
	DURATION_FREQ_DIVIDER: FDIV
		generic map (size => DURATION_CLK_SLV_SIZE)
		port map (Threshold => DURATION_CLK_THREASHOLD, CLK => s_clk, DividedCLK => s_duration_clk);
	
	PWM_FREQ_DIVIDER: FDIV
		generic map (size => PWM_CLK_SLV_SIZE)
		port map (Threshold => PWM_CLK_THRESHOLD, CLK => s_clk, DividedCLK => s_pwm_clk);
		
	SIGNAL_FREQ_DIVIDER: FDIV
		generic map (size => TONE_SLV_SIZE)
		port map (Threshold => s_tone_slv, CLK => s_pwm_clk, DividedCLK => s_signal_clk);
		
	ROM_U: ROM port map (s_address, s_data);
	
	PWM_U: PWM port map (
		CLK => s_pwm_clk,
		FULL_RESET => RST,
		RESTART => RST,
		WIDTH => PWM_WIDTH,
		PULSE => s_data,
		PWM_SIGNAL => s_audio
	);
	
	LoadSound: process(CLK, RST, LOAD, Tone, Duration)
	begin
		if RST = '1' then
			s_tone_slv <= (others => '0');
			s_duration_slv <= (others => '0');
		elsif LOAD = '1' then
			if rising_edge(CLK) then
				s_tone_slv <= conv_std_logic_vector(Tone, TONE_SLV_SIZE);
				s_duration_slv <= conv_std_logic_vector(Duration, DURATION_SLV_SIZE);
			end if;
		end if;
	end process;
	
	ChangeSineValue: process(RST, s_signal_clk)
	begin
		if RST = '1' then
			s_address <= (others => '0');
		elsif rising_edge(s_signal_clk) then
			s_address <= s_address + 1;
		end if;
	end process;
	
	WaitFor: process(RST, LOAD, s_duration_clk)
		variable ticks: std_logic_vector(DURATION_SLV_SIZE - 1 downto 0) := (others => '0');
	begin
		if RST = '1' or LOAD = '1' then
			s_finished <= '0';
			ticks := (others => '0');
		elsif rising_edge(s_duration_clk) then
			if ticks <= s_duration_slv then
				ticks := ticks + 1;
			else
				s_finished <= '1';
			end if;
		end if;
	end process;
	
	Finished <= s_finished;
	Audio <= s_audio and (not s_finished);
end Behavioral;

