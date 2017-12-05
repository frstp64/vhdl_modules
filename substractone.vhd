----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    20:35:40 10/13/2015 
-- Design Name: 
-- Module Name:    substractone - Behavioral 
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

entity substractone is
    Port ( number : in  STD_LOGIC_VECTOR (3 downto 0);
           numminone : out  STD_LOGIC_VECTOR (2 downto 0));
end substractone;

architecture Behavioral of substractone is

component fulladder is
    Port ( a : in  STD_LOGIC;
           b : in  STD_LOGIC;
           cin : in  STD_LOGIC;
           s : out  STD_LOGIC;
           cout : out  STD_LOGIC);
end component;

signal carry, resultat: std_logic_vector (3 downto 0);
begin

-- soustrait 1, et si le nombre est zero, redonner zero

add0: fulladder port map (a => number(0), b => '1', cin => '0', cout => carry(0), s => resultat(0));
add1: fulladder port map (a => number(1), b => '1', cin => carry(0), cout => carry(1), s => resultat(1));
add2: fulladder port map (a => number(2), b => '1', cin => carry(1), cout => carry(2), s => resultat(2));
add3: fulladder port map (a => number(3), b => '1', cin => carry(2), cout => carry(3), s => resultat(3));


-- si le bit de signe est activé c'est qu'on avait zero en entrée, donc on met 7 (111)
numminone(0) <= resultat(0) or resultat(3);
numminone(1) <= resultat(1) or resultat(3);
numminone(2) <= resultat(2) or resultat(3);

end Behavioral;

