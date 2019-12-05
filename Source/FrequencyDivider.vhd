library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity FrequencyDivider is
	generic (
		n: integer := 2
	);
	port (
		CLK: in std_logic;
		RST: in std_logic;
		CE: in std_logic;
		K: in std_logic_vector(n - 1 downto 0);
		DividedCLK: out std_logic
	);
end FrequencyDivider;

architecture Behavioral of FrequencyDivider is
	signal s_counter: std_logic_vector(2**n - 1 downto 0);
--	signal s_flipflop: std_logic;
begin
	Count: process(CLK, RST, CE)
	begin
		if RST = '1' then
			s_counter <= (others => '0');
		elsif CE = '1' then
			if falling_edge(CLK) then
				s_counter <= s_counter + 1;
			end if;
		end if;
	end process; 
	
	DividedCLK <= s_counter(conv_integer(K));
end Behavioral;
