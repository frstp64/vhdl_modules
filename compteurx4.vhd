----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:43:30 10/25/2015 
-- Design Name: 
-- Module Name:    compteurx4 - Behavioral 
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

entity compteurx4 is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           clkdout : out  STD_LOGIC_VECTOR (39 downto 0));
end compteurx4;

architecture Behavioral of compteurx4 is

component adder7bits is
    Port ( reset : in  STD_LOGIC;
           en : in  STD_LOGIC;
			  clk: in STD_LOGIC;
           output : out  STD_LOGIC_VECTOR (7 downto 0));
end component;

signal clkd : std_logic_vector(39 downto 0);
signal clkd0, clkd1, clkd2, clkd3, clkd4 : std_logic_vector(7 downto 0);
begin

horloge0: adder7bits port map(reset => reset,
                             en => '1',
									  clk => clk,
									  output => clkd0);
horloge1: adder7bits port map(reset => reset,
                             en => '1',
									  clk => clkd(7),
									  output => clkd1);
horloge2: adder7bits port map(reset => reset,
                             en => '1',
									  clk => clkd(15),
									  output => clkd2);
horloge3: adder7bits port map(reset => reset,
                             en => '1',
									  clk => clkd(23),
									  output => clkd3);			  
horloge4: adder7bits port map(reset => reset,
                             en => '1',
									  clk => clkd(31),
									  output => clkd4);
clkd(7 downto 0) <= clkd0;

clkd(15 downto 8) <= clkd1;

clkd(23 downto 16) <= clkd2;

clkd(31 downto 24) <= clkd3;

clkd(39 downto 32) <= clkd4;

clkdout <= clkd;

end Behavioral;

