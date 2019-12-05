library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity FrequencyDividerByOddNumbers is
	generic (
		divide_by: integer := 3
	);
	port (
		CLK: in std_logic;
		RST: in std_logic;
		CE: in std_logic;
		DividedCLK: out std_logic
	);
end FrequencyDividerByOddNumbers;

architecture Behavioral of FrequencyDividerByOddNumbers is
	signal s_reg: std_logic_vector(divide_by - 1 downto 0);
begin
	Main: process(CLK, RST, CE)
	begin
		if RST = '1' then
			s_reg <= (others => '0');
		elsif CE = '1' then
			if rising_edge(CLK) then
				if s_reg = 0 then
					s_reg <= '1' & s_reg(divide_by - 2 downto 0);
				else
					s_reg <= '0' & s_reg(divide_by - 1 downto 1);
				end if;
			end if;
		end if;
	end process;
	
	DividedCLK <= s_reg(0);
end Behavioral;

