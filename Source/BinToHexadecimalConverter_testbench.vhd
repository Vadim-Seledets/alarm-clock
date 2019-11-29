LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY BinToHexadecimalConverter_testbench IS
END BinToHexadecimalConverter_testbench;
 
ARCHITECTURE behavior OF BinToHexadecimalConverter_testbench IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT BinToHexadecimalConverter
    PORT(
         Din : IN  std_logic_vector(23 downto 0);
         Dout : OUT  std_logic_vector(23 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal Din : std_logic_vector(23 downto 0) := (others => '0');

 	--Outputs
   signal Dout : std_logic_vector(23 downto 0);
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: BinToHexadecimalConverter PORT MAP (
          Din => Din,
          Dout => Dout
        );
		  
   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      Din <= x"070E0C"; --x071513

      wait;
   end process;

END;
