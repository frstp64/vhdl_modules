----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:13:00 10/07/2015 
-- Design Name: 
-- Module Name:    adder7bits - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity adder7bits is
    Port ( reset : in  STD_LOGIC;
           en : in  STD_LOGIC;
			  clk: in STD_LOGIC;
           output : out  STD_LOGIC_VECTOR (7 downto 0));
end adder7bits;

architecture Behavioral of adder7bits is

component fulladder is
    Port ( a : in  STD_LOGIC;
           b : in  STD_LOGIC;
           cin : in  STD_LOGIC;
           s : out  STD_LOGIC;
           cout : out  STD_LOGIC);
end component;

component register8bits is
    Port ( Dvec : in  STD_LOGIC_VECTOR (7 downto 0);
           Qvec : out  STD_LOGIC_VECTOR (7 downto 0);
           clk : in  STD_LOGIC;
           en: in  STD_LOGIC;
           reset : in  STD_LOGIC);
end component;

signal sumresult, memoryoutput: STD_LOGIC_VECTOR ( 7 downto 0);
signal carryresult: STD_LOGIC_VECTOR ( 7 downto 0);


begin
  
  -- There is a 8 bit register after the adder to make it synchronous, not to be confused with Wonderwall.
  registerwall: register8bits port map ( Dvec => sumresult, Qvec => memoryoutput, clk => clk, en => en, reset => reset);
  add0: fulladder port map (a => memoryoutput(0), b => '1', cin => carryresult(0), cout => carryresult(1), s => sumresult(0));
  add1: fulladder port map (a => memoryoutput(1), b => '0', cin => carryresult(1), cout => carryresult(2), s => sumresult(1));
  add2: fulladder port map (a => memoryoutput(2), b => '0', cin => carryresult(2), cout => carryresult(3), s => sumresult(2));
  add3: fulladder port map (a => memoryoutput(3), b => '0', cin => carryresult(3), cout => carryresult(4), s => sumresult(3));
  add4: fulladder port map (a => memoryoutput(4), b => '0', cin => carryresult(4), cout => carryresult(5), s => sumresult(4));
  add5: fulladder port map (a => memoryoutput(5), b => '0', cin => carryresult(5), cout => carryresult(6), s => sumresult(5));
  add6: fulladder port map (a => memoryoutput(6), b => '0', cin => carryresult(6), cout => carryresult(7), s => sumresult(6));

sumresult(7) <= carryresult(7); -- the carry out of the added of the most significant bit.
carryresult(0) <= '0';

output <= memoryoutput;
end Behavioral;

