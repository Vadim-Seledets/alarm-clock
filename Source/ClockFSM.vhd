library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
 
entity ClockFSM is
    port (
        CLK, Reset, Stop, ToggleMode, Increment: in std_logic;
        DigitSelect: in std_logic_vector(1 downto 0);
        HoursHigh, HoursLow, MinutesHigh, MinutesLow, 
		    SecondsHigh, SecondsLow, ExtraDigit2, ExtraDigit1: out std_logic_vector(3 downto 0)
    );
end ClockFSM;
 
architecture behavioral of ClockFSM is
    type TClockMode is (Running, Setting);
    signal CurrentMode: TClockMode;

    constant CharHyphen: std_logic_vector(3 downto 0) := "1111";

    signal TempSecondsLow: std_logic_vector(3 downto 0) := "0000";
    signal TempSecondsHigh: std_logic_vector(3 downto 0) := "0000";
    signal TempMinutesLow: std_logic_vector(3 downto 0) := "0000";
    signal TempMinutesHigh: std_logic_vector(3 downto 0) := "0000";
    signal TempHoursLow: std_logic_vector(3 downto 0) := "0000";
    signal TempHoursHigh: std_logic_vector(3 downto 0) := "0000";

    signal D1: std_logic_vector(3 downto 0) := "0000";
    signal D2: std_logic_vector(3 downto 0) := "0000";
    signal D3: std_logic_vector(3 downto 0) := "0000";
    signal D4: std_logic_vector(3 downto 0) := "0000";
    signal D5: std_logic_vector(3 downto 0) := "0000";
    signal D6: std_logic_vector(3 downto 0) := "0000";
    signal D7: std_logic_vector(3 downto 0) := "0000";
    signal D8: std_logic_vector(3 downto 0) := "0000";
begin
    ToggleClockMode: process (ToggleMode)
    begin
        if rising_edge(ToggleMode) then
				if CurrentMode = Running then
					CurrentMode <= Setting;
				else
					CurrentMode <= Running;
				end if;
        end if;
    end process;

    ResetClock: process (Reset)
    begin
        if Reset = '1' then
            TempHoursHigh <= "0000";
            TempHoursLow <= "0000";
            TempMinutesHigh <= "0000";
            TempMinutesLow <= "0000";
            TempSecondsHigh <= "0000";
            TempSecondsLow <= "0000";
        end if;
    end process;

    Mode_Running: process (CLK)
    begin
        if CurrentMode = Running and rising_edge(CLK) then
            if Stop = '0' then
                TempSecondsLow <= TempSecondsLow + 1;
                if TempSecondsLow = "1001" then
                    TempSecondsLow <= "0000";
                    TempSecondsHigh <= TempSecondsHigh + 1;
                    if TempSecondsHigh = "0101" then
                        TempSecondsHigh <= "0000";
                        TempMinutesLow <= TempMinutesLow + 1;
                        if TempMinutesLow = "1001" then
                            TempMinutesLow <= "0000";
                            TempMinutesHigh <= TempMinutesHigh + 1;
                            if TempMinutesHigh = "0101" then
                                TempMinutesHigh <= "0000";
                                TempHoursLow <= TempHoursLow + 1 ;
                                if TempHoursLow = "1001" then
                                    TempHoursLow <= "0000";
                                    TempHoursHigh <= TempHoursHigh + 1;
                                elsif TempHoursHigh > 1 and TempHoursLow > 2 then
                                    TempHoursHigh <= "0000";
                                    TempHoursLow <= "0000";                    
                                end if;
                            end if;
                        end if;
                    end if;
                end if;
            end if;

            D1 <= CharHyphen;
            D2 <= CharHyphen;
            D3 <= TempSecondsLow;
            D4 <= TempSecondsHigh;
            D5 <= TempMinutesLow;
            D6 <= TempMinutesHigh;
            D7 <= TempHoursLow;
            D8 <= TempHoursHigh;
        end if;
    end process;

    Mode_Setting: process (CurrentMode, ToggleMode, Increment)
    begin
        if CurrentMode = Setting then
            D4 <= CharHyphen;
            D3 <= CharHyphen;
            D2 <= CharHyphen;
            D1 <= CharHyphen;

            if rising_edge(Increment) then
                case DigitSelect is
                    when "00" =>
						      D5 <= D5 + 1;
								if D5 = 9 then
									D5 <= "0000";
								end if;
                    when "01" =>
						      D6 <= D6 + 1;
								if D6 = 5 then
									D6 <= "0000";
								end if;
                    when "10" => 
                        D7 <= D7 + 1;
                        if D7 = 9 or (D8 = 2 and D7 = 3) then
                            D7 <= "0000";
                        end if;
                    when "11" =>
						      D8 <= D8 + 1;
								if D8 = 2 then
									D8 <= "0000";
								end if;
                end case;
            end if;

            if rising_edge(ToggleMode) then
                TempMinutesLow <= D5;
                TempMinutesHigh <= D6;
                TempHoursLow <= D7;
                TempHoursHigh <= D8;
            end if;
        end if;
    end process;
    
    ExtraDigit1 <= D1;
    ExtraDigit2 <= D2;
    SecondsLow <= D3;
    SecondsHigh <= D4;
    MinutesLow <= D5;
    MinutesHigh <= D6;
    HoursLow <= D7;
    HoursHigh <= D8;
end behavioral;
