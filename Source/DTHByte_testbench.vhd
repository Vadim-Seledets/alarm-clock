LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY DTHByte_testbench IS
END DTHByte_testbench;
 
ARCHITECTURE behavior OF DTHByte_testbench IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT DTHByte
    PORT(
         Dec : IN  std_logic_vector(7 downto 0);
         Hexadecimal : OUT  std_logic_vector(7 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal Dec : std_logic_vector(7 downto 0) := (others => '0');

 	--Outputs
   signal Hexadecimal : std_logic_vector(7 downto 0);
	signal error : std_logic := '0';
	
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: DTHByte PORT MAP (
          Dec => Dec,
          Hexadecimal => Hexadecimal
        );

   stim_proc: process
   begin			
      wait for clk_period;
		
		Dec <= "00000000";		
      wait for clk_period;
		if Hexadecimal /= "00000000" then 
			error <= '1';
		end if;
		
		Dec <= "00000011";		
      wait for clk_period;
		if Hexadecimal /= "00000011" then 
			error <= '1';
		end if;
		
		Dec <= "00000110";		
      wait for clk_period;
		if Hexadecimal /= "00000110" then 
			error <= '1';
		end if;
		
		Dec <= "00110100";		
      wait for clk_period;
		if Hexadecimal /= "01010010" then 
			error <= '1';
		end if;
		
		Dec <= "00010100";		
      wait for clk_period;
		if Hexadecimal /= "00100000" then 
			error <= '1';
		end if;
		
		Dec <= "00111011";		
      wait for clk_period;
		if Hexadecimal /= "01011001" then 
			error <= '1';
		end if;
		
		Dec <= "00100100";
		wait for clk_period;
		if Hexadecimal /= "00110110" then 
			error <= '1';
		end if;
      wait;
   end process;

END;
