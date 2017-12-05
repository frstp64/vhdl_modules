----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    22:56:09 09/22/2015 
-- Design Name: 
-- Module Name:    clock_divider - Behavioral 
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

entity clock_divider is
 Port ( clk: in STD_LOGIC;
        reset: in STD_LOGIC;
		  led_out1 : out  STD_LOGIC;
        led_out2 : out  STD_LOGIC);
end clock_divider;

architecture Behavioral of clock_divider is

signal clk1 : STD_LOGIC :='0';
signal clk2 : STD_LOGIC :='0';

begin

clock1: process (clk, reset)
begin
  if (reset = '0') then
    clk1 <= '0';
  elsif (clk'event and clk='1') then
    clk1 <= not clk1;
  end if;
end process clock1;

clock2: process (clk1, reset)
begin
  if (reset = '0') then
    clk2 <= '0';
  elsif (clk1'event and clk1='1') then
    clk2 <= not clk2;
  end if;
end process clock2;

led_out1 <= clk1;
led_out2 <= clk2;
end Behavioral;

