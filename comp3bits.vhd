----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:24:11 10/13/2015 
-- Design Name: 
-- Module Name:    comp3bits - Behavioral 
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

entity comp3bits is
    Port ( a : in  STD_LOGIC_VECTOR (2 downto 0);
           b : in  STD_LOGIC_VECTOR (2 downto 0);
           isequal : out  STD_LOGIC;
           issmaller : out  STD_LOGIC);
end comp3bits;

architecture Behavioral of comp3bits is

component fulladder is
    Port ( a : in  STD_LOGIC;
           b : in  STD_LOGIC;
           cin : in  STD_LOGIC;
           s : out  STD_LOGIC;
           cout : out  STD_LOGIC);
end component;

signal invb: std_logic_vector (3 downto 0);

-- a  et b sur 4 bits
signal afour: std_logic_vector (3 downto 0);
signal bfour: std_logic_vector (3 downto 0);
signal resultat: std_logic_vector (3 downto 0);

-- b en complement 2
signal btc: std_logic_vector (3 downto 0);
signal plusonecarry: std_logic_vector (2 downto 0);
signal diffcarry: std_logic_vector (2 downto 0);

begin

afour(3) <= '0';
afour(2 downto 0) <= a;
bfour(3) <= '0';
bfour(2 downto 0) <= b;

--### Soustraction est égal à a + complement 2 de b ###

--calcul du complement 2 de b.
invb <= not bfour;
addcomp0: fulladder port map (a => invb(0), b => '1', cin => '0', cout => plusonecarry(0), s => btc(0));
addcomp1: fulladder port map (a => invb(1), b => '0', cin => plusonecarry(0), cout => plusonecarry(1), s => btc(1));
addcomp2: fulladder port map (a => invb(2), b => '0', cin => plusonecarry(1), cout => plusonecarry(2), s => btc(2));
addcomp3: fulladder port map (a => invb(3), b => '0', cin => plusonecarry(2), cout => open, s => btc(3));

-- somme de a avec le complement 2 de b, donne le resultat de la soustraction.
addsub0: fulladder port map (a => afour(0), b => btc(0), cin => '0', cout => diffcarry(0), s => resultat(0));
addsub1: fulladder port map (a => afour(1), b => btc(1), cin => diffcarry(0), cout => diffcarry(1), s => resultat(1));
addsub2: fulladder port map (a => afour(2), b => btc(2), cin => diffcarry(1), cout => diffcarry(2), s => resultat(2));
addsub3: fulladder port map (a => afour(3), b => btc(3), cin => diffcarry(2), cout => open, s => resultat(3));

-- si le bit de signe est zero, a est plus petit que b. Sinon, plus petit ou egal.
issmaller <= resultat(3);

-- si tout les bits sont zeros alors les deux nombres sonts egaux.
isequal <= not resultat(0) and not resultat(1) and not resultat(2) and not resultat(3);

end Behavioral;

