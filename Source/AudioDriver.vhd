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
	
	signal s_tone: integer range 0 to 255 := 0;
	
	-- ROM With Melody
	signal s_address: std_logic_vector(2 downto 0) := (others => '0');
	signal s_data: std_logic_vector(7 downto 0) := (others => '0');
	
	signal s_is_loop_tone: std_logic := '0';
	signal s_reset: std_logic := '0';
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
