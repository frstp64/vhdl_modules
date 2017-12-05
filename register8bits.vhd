----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:34:52 10/07/2015 
-- Design Name: 
-- Module Name:    register8bits - Behavioral 
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

entity register8bits is
    Port ( Dvec : in  STD_LOGIC_VECTOR (7 downto 0);
           Qvec : out  STD_LOGIC_VECTOR (7 downto 0);
           clk : in  STD_LOGIC;
           en : in  STD_LOGIC;
           reset : in  STD_LOGIC);
end register8bits;

architecture Behavioral of register8bits is

  component bitregister1 is
    port (d, en, reset, clk: in std_logic;
	       q: out std_logic);
  end component;
begin

bit0: bitregister1 port map(d => Dvec(0), en => en, reset => reset, clk => clk, q => Qvec(0));
bit1: bitregister1 port map(d => Dvec(1), en => en, reset => reset, clk => clk, q => Qvec(1));
bit2: bitregister1 port map(d => Dvec(2), en => en, reset => reset, clk => clk, q => Qvec(2));
bit3: bitregister1 port map(d => Dvec(3), en => en, reset => reset, clk => clk, q => Qvec(3));
bit4: bitregister1 port map(d => Dvec(4), en => en, reset => reset, clk => clk, q => Qvec(4));
bit5: bitregister1 port map(d => Dvec(5), en => en, reset => reset, clk => clk, q => Qvec(5));
bit6: bitregister1 port map(d => Dvec(6), en => en, reset => reset, clk => clk, q => Qvec(6));
bit7: bitregister1 port map(d => Dvec(7), en => en, reset => reset, clk => clk, q => Qvec(7));


end Behavioral;

