LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
ENTITY DTHByte_Tests IS
END DTHByte_Tests;
 
ARCHITECTURE behavior OF DTHByte_Tests IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT DTHByte
    PORT(
         Hec : IN  std_logic_vector(7 downto 0);
         Hexadecimal : OUT  std_logic_vector(7 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal Hec : std_logic_vector(7 downto 0) := (others => '0');

 	--Outputs
   signal Hexadecimal : std_logic_vector(7 downto 0);
   signal error : std_logic := '0';
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
 
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: DTHByte PORT MAP (
          Hec => Hec,
          Hexadecimal => Hexadecimal
        );

   -- Stimulus process
   stim_proc: process
   begin			
      wait for clk_period;
		
		Hec <= "00000000";		
      wait for clk_period;
		if Hexadecimal /= "00000000" then 
			error <= '1';
		end if;
		
		Hec <= "00000011";		
      wait for clk_period;
		if Hexadecimal /= "00000011" then 
			error <= '1';
		end if;
		
		Hec <= "00000110";		
      wait for clk_period;
		if Hexadecimal /= "00000110" then 
			error <= '1';
		end if;
		
		Hec <= "00110100";		
      wait for clk_period;
		if Hexadecimal /= "01010010" then 
			error <= '1';
		end if;
		
		Hec <= "00010100";		
      wait for clk_period;
		if Hexadecimal /= "00100000" then 
			error <= '1';
		end if;
		
		Hec <= "00111011";		
      wait for clk_period;
		if Hexadecimal /= "01011001" then 
			error <= '1';
		end if;
		
		Hec <= "00100100";
		wait for clk_period;
		if Hexadecimal /= "00110110" then 
			error <= '1';
		end if;
      wait;
   end process;

END;
