----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:24:43 10/13/2015 
-- Design Name: 
-- Module Name:    onehotbinary - Behavioral 
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

entity onehotbinary is
    Port ( onehot : in  STD_LOGIC_VECTOR (7 downto 0);
           binary : out  STD_LOGIC_VECTOR (3 downto 0));
end onehotbinary;

architecture Behavioral of onehotbinary is

begin

with onehot select
  binary <= "0001" when "00000001",
            "0010" when "00000010",
            "0011" when "00000100",
            "0100" when "00001000",
            "0101" when "00010000",
            "0110" when "00100000",
            "0111" when "01000000",
            "1000" when "10000000",
            "0000" when others; -- cas quand il y a juste des zeros

end Behavioral;

