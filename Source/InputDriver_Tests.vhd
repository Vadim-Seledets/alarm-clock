LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
 
ENTITY InputDriver_Tests IS
END InputDriver_Tests;
 
ARCHITECTURE behavior OF InputDriver_Tests IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT InputDriver
    PORT(
         Enable : IN  std_logic;
         Up : IN  std_logic;
         Down : IN  std_logic;
         Left : IN  std_logic;
         Right : IN  std_logic;
         CurrentTime : IN  std_logic_vector(23 downto 0);
         UpdatedTime : OUT  std_logic_vector(23 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal Enable : std_logic := '0';
   signal Up : std_logic := '0';
   signal Down : std_logic := '0';
   signal Left : std_logic := '0';
   signal Right : std_logic := '0';
   signal CurrentTime : std_logic_vector(23 downto 0) := (others => '0');

 	--Outputs
   signal UpdatedTime : std_logic_vector(23 downto 0);
	
   signal error : std_logic := '0';
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
 
   constant period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: InputDriver PORT MAP (
          Enable => Enable,
          Up => Up,
          Down => Down,
          Left => Left,
          Right => Right,
          CurrentTime => CurrentTime,
          UpdatedTime => UpdatedTime
        );

   -- Stimulus process
   stim_proc: process
   begin		
      wait for period;
		CurrentTime <= "000000010000000100000001";
		wait for period;
		
		Enable <= '1';
		wait for period;
				
		if UpdatedTime /= "000000010000000100000001" then 
			error <= '1';
		end if;
		
		Up <= '1';
		wait for period;
		Up <= '0';
		wait for period;	
		if UpdatedTime /= "000000010000000100000010" then 
			error <= '1';
		end if;
			
		Up <= '1';
		wait for period;
		Up <= '0';
		wait for period;	

		if UpdatedTime /= "000000010000000100000011" then 
			error <= '1';
		end if;
		
		Up <= '1';
		wait for period;
		Up <= '0';
		wait for period;
		
		if UpdatedTime /= "000000010000000100000100" then 
			error <= '1';
		end if;
		
		Down <= '1';
		wait for period;
		Down <= '0';
		wait for period;
		
		if UpdatedTime /= "000000010000000100000011" then 
			error <= '1';
		end if;
		
		Down <= '1';
		wait for period;
		Down <= '0';
		wait for period;
		
		if UpdatedTime /= "000000010000000100000010" then 
			error <= '1';
		end if;
		
		Up <= '1';
		wait for period;
		Down <= '1';
		wait for period;
		Up <= '0';
		wait for period;
		Down <= '0';
		wait for period;
		
		if UpdatedTime /= "000000010000000100000010" then 
			error <= '1';
		end if;
		
		Left <= '1';
		wait for period;
		Left <= '0';
		wait for period;
		
		Down <= '1';
		wait for period;
		Down <= '0';
		wait for period;
		
		if UpdatedTime /= "000000010000000000000010" then 
			error <= '1';
		end if;
		
		Down <= '1';
		wait for period;
		Down <= '0';
		wait for period;
		
		if UpdatedTime /= "000000010011101100000010" then 
			error <= '1';
		end if;
		
		Up <= '1';
		wait for period;
		Up <= '0';
		wait for period;
		
		if UpdatedTime /= "000000010000000000000010" then 
			error <= '1';
		end if;
		
		Up <= '1';
		wait for period;
		Up <= '0';
		wait for period;
		
		if UpdatedTime /= "000000010000000100000010" then 
			error <= '1';
		end if;
		
		Left <= '1';
		wait for period;
		Left <= '0';
		wait for period;
		
		Up <= '1';
		wait for period;
		Up <= '0';
		wait for period;
		
		if UpdatedTime /= "000000100000000100000010" then 
			error <= '1';
		end if;
		
		Left <= '1';
		wait for period;
		Left <= '0';
		wait for period;
		
		Up <= '1';
		wait for period;
		Up <= '0';
		wait for period;
		
		if UpdatedTime /= "000000100000000100000011" then 
			error <= '1';
		end if;
		
		Right <= '1';
		wait for period;
		Right <= '0';
		wait for period;
		
		Up <= '1';
		wait for period;
		Up <= '0';
		wait for period;
		
		if UpdatedTime /= "000000110000000100000011" then 
			error <= '1';
		end if;
		
		wait for period;
		
		wait for period;
		
		wait for period;
		
      wait;
   end process;

END;
