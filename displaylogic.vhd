----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    02:02:45 10/29/2015 
-- Design Name: 
-- Module Name:    displaylogic - Behavioral 
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

entity displaylogic is
    Port ( leds : in  STD_LOGIC_VECTOR (7 downto 0);
           sortie : out  STD_LOGIC_VECTOR (7 downto 0));
end displaylogic;

architecture Behavioral of displaylogic is

signal thexor, etagezero: std_logic;
signal thexormuxed, etagezeromuxed, sortiedecale: std_logic_vector(7 downto 0);
begin

thexor <= (((leds(7) xor leds(6)) xor (leds(5) xor leds(4))) xor ((leds(3) xor leds(2)) xor (leds(1) xor leds(0))));

thexormuxed <= (others => thexor);

sortiedecale <= (7 => '0',
                 6 => leds(7),
					  5 => leds(6),
					  4 => leds(5),
					  3 => leds(4),
					  2 => leds(3),
					  1 => leds(2),
					  0 => leds(1));
					  
etagezero <= leds(0);

etagezeromuxed <= (others => etagezero);

sortie <= ((not thexormuxed) and leds) or
             ((thexormuxed) and ((etagezeromuxed and "00001000") or
				  ((not etagezeromuxed) and sortiedecale)));

end Behavioral;

