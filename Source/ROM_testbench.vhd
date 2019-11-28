LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY ROM_testbench IS
END ROM_testbench;
 
ARCHITECTURE behavior OF ROM_testbench IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT ROM
    PORT(
         ADDR : IN  std_logic_vector(1 downto 0);
         Dout : OUT  std_logic_vector(7 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal ADDR : std_logic_vector(1 downto 0) := (others => '0');

 	--Outputs
   signal Dout : std_logic_vector(7 downto 0);
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: ROM PORT MAP (
          ADDR => ADDR,
          Dout => Dout
        );

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      ADDR <= "00";
		wait for 50 ns;
		ADDR <= "01";
		wait for 50 ns;
		ADDR <= "10";
		wait for 50 ns;
		ADDR <= "11";

      wait;
   end process;

END;
