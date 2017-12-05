----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:22:34 09/23/2015 
-- Design Name: 
-- Module Name:    adder_3bits - Behavioral 
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

entity adder_3bits_juste_additionneur is
    Port ( enable : in  STD_LOGIC;
			  clk: in STD_LOGIC;
			  reset: inout STD_LOGIC;
			  add1: in STD_LOGIC_VECTOR (2 downto 0);
			  add2: in STD_LOGIC_VECTOR (2 downto 0);
           led_out : out STD_LOGIC_VECTOR (3 downto 0));
end adder_3bits_juste_additionneur;

architecture Behavioral of adder_3bits_juste_additionneur is
signal memoires: STD_LOGIC_VECTOR (3 downto 0);
signal resultatsomme : STD_LOGIC_VECTOR (3 downto 0);
signal carrysomme : STD_LOGIC_VECTOR (4 downto 0):= (others=>'0'); -- carry des trois sommes

begin

-- Additionneur, celui-ci peut être effectuée de manière purement combinatoire car sa sortie
-- n'est pas utilisée dans le process lorsque cela est désiré.
resultatsomme(0) <= add1(0) xor add2(0) xor carrysomme(0);
resultatsomme(1) <= add1(1) xor add2(1) xor carrysomme(1);
resultatsomme(2) <= add1(2) xor add2(2) xor carrysomme(2);
carrysomme(0) <= '0';
carrysomme(1) <= (add1(0) and carrysomme(0)) or (add2(0) and carrysomme(0)) or (add1(0) and add2(0)); 
carrysomme(2) <= (add1(1) and carrysomme(1)) or (add2(1) and carrysomme(1)) or (add1(1) and add2(1)); 
carrysomme(3) <= (add1(2) and carrysomme(2)) or (add2(2) and carrysomme(2)) or (add1(2) and add2(2)); 

-- le résultat de l'additionneur est synchronisé.
additionneursynchroniser: process (clk, reset, enable)
  begin
    -- Activation du reset (actif-bas)
    if (reset = '0') then
      memoires <= (others=> '0');
    
	 -- Sinon, si on est sur un front montant
    elsif (clk'event and clk = '1') then
	   --si enable est a 1, on prend la somme, sinon on garde la valeur présente.
      memoires(0) <= (resultatsomme(0) and enable) or (memoires(0) and not enable);
      memoires(1) <= (resultatsomme(1) and enable) or (memoires(1) and not enable);
      memoires(2) <= (resultatsomme(2) and enable) or (memoires(2) and not enable);
      memoires(3) <= (carrysomme(3) and enable) or (memoires(3) and not enable);
    end if;
  end process additionneursynchroniser;
  
led_out(0) <= memoires(0);
led_out(1) <= memoires(1);
led_out(2) <= memoires(2);
led_out(3) <= memoires(3);
end Behavioral;

