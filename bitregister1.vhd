----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    08:28:37 10/07/2015 
-- Design Name: 
-- Module Name:    bitregister1 - Behavioral 
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

entity bitregister1 is
    Port ( D : in  STD_LOGIC;
           Clk : in  STD_LOGIC;
           RESET : in  STD_LOGIC;
           En : in  STD_LOGIC;
           Q : out  STD_LOGIC);
end bitregister1;

architecture Behavioral of bitregister1 is

begin

process(clk, reset)
begin
-- Asynchronous reset, active low
if (reset = '0') then
  q <= '0';
elsif (rising_edge(clk) and en = '1') then
  q <= d;
end if;
end process;

end Behavioral;

