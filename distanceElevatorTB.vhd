--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   12:13:24 11/05/2015
-- Design Name:   
-- Module Name:   U:/Documents/LAB3_FREDERIC_ST_PIERRE/EX10/distanceElevatorTB.vhd
-- Project Name:  EX10
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: distanceElevator
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY distanceElevatorTB IS
END distanceElevatorTB;
 
ARCHITECTURE behavior OF distanceElevatorTB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT distanceElevator
    PORT(
         clk : IN  std_logic;
         reset : IN  std_logic;
         tx : IN  std_logic;
         ledsOut : OUT  std_logic_vector(7 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal reset : std_logic := '0';
   signal tx : std_logic := '0';

 	--Outputs
   signal ledsOut : std_logic_vector(7 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
   constant DataPeriod : time := 104.17 us;
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: distanceElevator PORT MAP (
          clk => clk,
          reset => reset,
          tx => tx,
          ledsOut => ledsOut
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
		reset <= '0';
      wait for clk_period;
		reset <= '1';
      wait for 100 us;
		
		tx <= '0'; -- lsb
		wait for DataPeriod;
		tx <= '1';
		wait for DataPeriod;
		tx <= '0';
		wait for DataPeriod;
		tx <= '0';
		wait for DataPeriod;
		tx <= '0';
		wait for DataPeriod;
		tx <= '0';
		wait for DataPeriod;
		tx <= '0';
		wait for DataPeriod;
		tx <= '0'; -- msb

		wait for DataPeriod;
		tx <= '1'; -- stop bit

      wait;
   end process;

END;
