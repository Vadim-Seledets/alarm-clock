library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity FSMClockUnit is
	port (
		CLK: in std_logic;
		TimeIn: in std_logic_vector(23 downto 0);
		TargetToSet: in std_logic;
		SetTime: in std_logic;
		AlarmReset: in std_logic;
		CurrentTime: out std_logic_vector(23 downto 0);
		Alarm: out std_logic
	);
end FSMClockUnit;

architecture Behavioral of FSMClockUnit is

begin


end Behavioral;

