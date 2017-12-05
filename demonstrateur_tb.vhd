--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   17:01:24 11/02/2015
-- Design Name:   
-- Module Name:   U:/Documents/LAB3_FREDERIC_ST_PIERRE/EX9/demonstrateur_tb.vhd
-- Project Name:  EX9
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: demonstrateur
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
 
ENTITY demonstrateur_tb IS
END demonstrateur_tb;
 
ARCHITECTURE behavior OF demonstrateur_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT demonstrateur
    PORT(
         clk : IN  std_logic;
         reset : IN  std_logic;
         tx : IN  std_logic;
         ledout : OUT  std_logic_vector(7 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal reset : std_logic := '1';
   signal tx : std_logic := '1';

 	--Outputs
   signal ledout : std_logic_vector(7 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
constant debit: integer := 10417;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: demonstrateur PORT MAP (
          clk => clk,
          reset => reset,
          tx => tx,
          ledout => ledout
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process, total = 1260 us
   stim_proc: process
   begin
      reset <= '0';	
      -- reset
      wait for clk_period;
      reset <= '1';
      wait for clk_period * 3;		

      -- envoi de 1001 0110
		tx <= '0';
		wait for clk_period * debit;
		
		tx <= '1';
		wait for clk_period * debit;
		tx <= '0';
		wait for clk_period * debit;
		tx <= '0';
		wait for clk_period * debit;
		tx <= '1';
		wait for clk_period * debit;
		tx <= '0';
		wait for clk_period * debit;
		tx <= '1';
		wait for clk_period * debit;
		tx <= '1';
		wait for clk_period * debit;
		tx <= '0';
		wait for clk_period * debit;
      tx <= '1';
		
		wait for clk_period * debit * 3;
		
		-- test du reset
		
		reset <= '0';
		wait for clk_period;
		reset <= '1';
      wait;
   end process;

END;
