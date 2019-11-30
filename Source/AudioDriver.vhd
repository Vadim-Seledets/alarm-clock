library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.MATH_REAL.ALL;

entity AudioDriver is
	port (
		PlayEnable: in std_logic;
		CLK: in std_logic;
		RST: in std_logic;
		Audio: out std_logic
	);
end AudioDriver;

architecture Behavioral of AudioDriver is
	
	component ROM_Melody is
		generic (
			word_size: integer := 8;
			rom_size: integer := 8
		);
		port (
			ADDR: in std_logic_vector(natural(log2(real(rom_size))) - 1 downto 0);
			Dout: out std_logic_vector(word_size - 1 downto 0)
		);
	end component;
	
	component ToneGenerator is 		
		port (
			Tone: in integer range 0 to 255;
			Duration: in integer;
			Enable: in std_logic;
			CLK: in std_logic;
			RST: in std_logic;
			Finished: out std_logic;
			Audio: out std_logic
		);
	end component;

	subtype TPureTone is integer range 0 to 20000;
	type TPureTones is array (0 to 7) of TPureTone;
	subtype TTone is integer range 0 to 255; -- Max value is a value which we can store to a register
	type TTones is array (0 to 7) of TTone;
	type TToneName is (Do, Re, Mi, Fa, So, La, Si, TDo);
	
	function ToneNameToInteger(tone_name: IN TToneName) return integer is
		variable result: integer range 0 to 7 := 1;
	begin
		if tone_name = Do then
			result := 0;
		elsif tone_name = Re then
			result := 1;
		elsif tone_name = Mi then
			result := 2;
		elsif tone_name = Fa then
			result := 3;
		elsif tone_name = So then
			result := 4;
		elsif tone_name = La then
			result := 5;
		elsif tone_name = Si then
			result := 6;
		elsif tone_name = TDo then
			result := 7;
		end if;
		return result;
	end function;
	
	constant pwm_frequency: integer := 10000000;
	constant N: integer := 128;
	constant PureTones: TPureTones := (523, 587, 659, 698, 784, 880, 988, 1047);
	constant Tones: TTones := (
		pwm_frequency / PureTones(0) / N, -- Do
		pwm_frequency / PureTones(1) / N, -- Re
		pwm_frequency / PureTones(2) / N, -- Mi
		pwm_frequency / PureTones(3) / N, -- Fa
		pwm_frequency / PureTones(4) / N, -- So
		pwm_frequency / PureTones(5) / N, -- La
		pwm_frequency / PureTones(6) / N, -- Si
		pwm_frequency / PureTones(7) / N  -- TDo
	);
	
	signal s_tone: integer range 0 to 255 := 0;
	
	-- ROM With Melody
	signal s_address: std_logic_vector(2 downto 0) := (others => '0');
	signal s_data: std_logic_vector(7 downto 0) := (others => '0');
	
	signal s_is_loop_tone: std_logic := '0';
	signal s_reset: std_logic := '0';
	signal s_duration: integer := 4;
	signal s_finished: std_logic := '0';
begin
	s_reset <= RST or s_is_loop_tone;
	s_tone <= Tones(conv_integer(s_data(7 downto 4)));
	
	ROM_WITH_MELODY: ROM_Melody port map (s_address, s_data);
	
	TONE_GENERATOR: ToneGenerator port map (
		Tone => s_tone,
		Duration => conv_integer(s_data(3 downto 0)),
		Enable => PlayEnable,
		CLK => CLK,
		RST => s_reset,
		Finished => s_finished,
		Audio => Audio
	);
	
	NextTone: process(CLK, RST)
	begin
		if RST = '1' then
			s_address <= (others => '0');
		elsif rising_edge(CLK) then
			if s_finished = '1' then
				s_address <= s_address + 1;
				s_is_loop_tone <= '1';
			else
				s_is_loop_tone <= '0';
			end if;
		end if;
	end process;
end Behavioral;
