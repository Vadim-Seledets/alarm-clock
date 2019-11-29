library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

entity PWM is
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
end PWM;

architecture Behavioral of PWM is
	signal s_width: std_logic_vector(N - 1 downto 0) := (others => '0');
	signal s_pwm_counter: std_logic_vector(N - 1 downto 0) := (others => '0');
	signal s_pulse: std_logic_vector(N - 1 downto 0) := (others => '0');
	signal s_change_state: std_logic := '0';
begin
	s_change_state <= '0' when s_pwm_counter < s_width else '1';  -- use to strobe new word

	p_state_out : process(CLK, FULL_RESET)
	begin
		if (FULL_RESET = '1') then
			s_width <= (others => '0');
			s_pulse <= (others => '0');
			s_pwm_counter <= (others => '0');
			PWM_SIGNAL <= '0';
		elsif (rising_edge(CLK)) then
			s_width <= WIDTH;
			if (RESTART = '1') then
				s_pulse <= PULSE;
				s_pwm_counter <= conv_std_logic_vector(0, N);
				PWM_SIGNAL <= '0';
			else
				if (s_pwm_counter = 0) and (s_pulse /= s_width) then
					PWM_SIGNAL <= '0';
				elsif (s_pwm_counter <= s_pulse) then
					PWM_SIGNAL <= '1';
				else
					PWM_SIGNAL <= '0';
				end if;
      
				if (s_change_state = '1') then
					s_pulse <= PULSE;
				end if;
      
				if (s_pwm_counter = s_width) then
					s_pwm_counter <= conv_std_logic_vector(0, N);
				else
					s_pwm_counter <= s_pwm_counter + 1;
				end if;
			end if;
		end if;
	end process;
end Behavioral;
