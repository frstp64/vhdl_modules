----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    21:10:21 10/28/2015 
-- Design Name: 
-- Module Name:    alarm - Behavioral 
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

entity alarm is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           alarmbutton : in  STD_LOGIC;
			  alarmeactive : out STD_LOGIC;
           leds : out  STD_LOGIC_VECTOR (7 downto 0));
end alarm;

architecture Behavioral of alarm is

component compteurx4 is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           clkdout : out  STD_LOGIC_VECTOR (39 downto 0));
end component;

type alarmeetats is (ok,
                     clignote0, clignote1);
signal etatalarme: alarmeetats;
signal clkd: std_logic_vector(39 downto 0);

-- ### Constantes pour l'horloge
-- pour vraie vie
constant DIVFACTOR4: integer:= 29;
-- pour simulation
--constant DIVFACTOR4: integer:= 3;

begin

horloge: compteurx4 port map(reset => reset,
									  clk => clk,
									  clkdout => clkd);


process (clk, reset)
begin
  if (reset = '0') then
    etatalarme <= ok;
	 leds <= (others => '0');
	 alarmeactive <= '0';
	 
  elsif(rising_edge(clk)) then
    case etatalarme is
	 
	 
	 when ok =>
	 leds <= (others => '0');
	 alarmeactive <= '0';
	 
	 if (alarmbutton = '1') then
		etatalarme <= clignote1;
	 end if;
	 
	 
	 when clignote0 =>
	   leds <= "00000000";
		alarmeactive <= '1';
		
	   if (clkd(DIVFACTOR4) = '1') then
		  etatalarme <= clignote1;
	   end if;
		
		
	 when clignote1 =>
	   leds <= "11111111";
	   alarmeactive <= '1';
		
		if (clkd(DIVFACTOR4) = '0') then
		  etatalarme <= clignote0;
	   end if;


	 end case;
  end if;
end process;

end Behavioral;

