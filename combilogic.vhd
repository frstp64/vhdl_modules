----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:01:55 10/07/2015 
-- Design Name: 
-- Module Name:    combilogic - Behavioral 
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

entity combilogic is
    Port ( load : in  STD_LOGIC;
           selection : in  STD_LOGIC_VECTOR (1 downto 0);
           inputs : in  STD_LOGIC_VECTOR (4 downto 0);
           output : out  STD_LOGIC);
end combilogic;

architecture Behavioral of combilogic is

signal selVec: STD_LOGIC_VECTOR (2 downto 0);

begin

selVec(2) <= load;
 selVec(1 downto 0) <= selection;

with selVec select
  output <= inputs(0) when "000",
            inputs(1) when "001",
            inputs(2) when "010",
            inputs(3) when "011",
            inputs(4) when others;
				-- ce dernier cas est notre load

end Behavioral;

