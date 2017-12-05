----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    01:13:20 10/26/2015 
-- Design Name: 
-- Module Name:    fullaccess - Behavioral 
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

--###### Mot de passe = 100000 ######
entity fullaccess is
    Port ( clk : in  STD_LOGIC;
	        reset : in std_logic;
			  code : in std_logic_vector(5 downto 0);
			  confirmecode : in std_logic;
			  modecomplettermine: in std_logic;
           fullmode : out std_logic_vector (1 downto 0);
			  leds : out std_logic_vector(7 downto 0));
end fullaccess;

architecture Behavioral of fullaccess is

component compteurx4 is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           clkdout : out  STD_LOGIC_VECTOR (39 downto 0));
end component;

type accessetats is (moderestraint, modecomplet, completencours,
                     clignote0, clignote1, clignote2, clignote3,
							clignote4, clignote5, clignote6, clignote7,
							clignote8, clignote9);
signal etatacces: accessetats;
signal clkd: std_logic_vector(39 downto 0);

-- ### Constantes pour l'horloge
-- pour vraie vie
constant DIVFACTOR3: integer:= 28;
-- pour simulation
--constant DIVFACTOR3: integer:= 2;

-- ### Le mode de passe ###
constant MOTDEPASSE: std_logic_vector:= "100000";


begin

horloge: compteurx4 port map(reset => reset,
									  clk => clk,
									  clkdout => clkd);


process (clk, reset)
begin
  if (reset = '0') then
    etatacces <= moderestraint;
	 fullmode <= "11";
	 leds <= (others => '1');
  elsif(rising_edge(clk)) then
    case etatacces is
	 
	 
	 when moderestraint =>
	 leds <= (others => '0');
	 fullmode <= "00";
	 
	 if (confirmecode = '1') then
	   if (code = MOTDEPASSE) then
		  etatacces <= modecomplet;
		else
		  etatacces <= clignote0;
		end if;
	 end if;
	 
	 
	 
	 when modecomplet =>
		leds <= (others => '0');
	   fullmode <= "01";
		
	 if (modecomplettermine = '0') then
	   etatacces <= completencours;
	 end if;
	 
	 when completencours =>
		leds <= (others => '0');
	   fullmode <= "01";
		
	 if (modecomplettermine = '1') then
	   etatacces <= moderestraint;
	 end if;
	 
	 
	 when clignote0 =>
	   leds <= "01010101";
		fullmode <= "11";
		
	   if (clkd(DIVFACTOR3) = '1') then
		  etatacces <= clignote1;
	   end if;
		
		
	 when clignote1 =>
	   leds <= "10101010";
	    
		if (clkd(DIVFACTOR3) = '0') then
		  etatacces <= clignote2;
	   end if;
		
		
	 when clignote2 =>
	   leds <= "01010101";
		
	   if (clkd(DIVFACTOR3) = '1') then
		  etatacces <= clignote3;
	   end if;
	 
	 
	 when clignote3 =>
	   leds <= "10101010";
		
	   if (clkd(DIVFACTOR3) = '0') then
		  etatacces <= clignote4;
	   end if;
		
		
	 when clignote4 =>
	   leds <= "01010101";
	    
		if (clkd(DIVFACTOR3) = '1') then
		  etatacces <= clignote5;
	   end if;
		
		
	 when clignote5 =>
	   leds <= "10101010";
		
	   if (clkd(DIVFACTOR3) = '0') then
		  etatacces <= clignote6;
	   end if;
		
		
	 when clignote6 =>
	   leds <= "01010101";
	    
		if (clkd(DIVFACTOR3) = '1') then
		  etatacces <= clignote7;
	   end if;
		
		
	 when clignote7 =>
	   leds <= "10101010";
		
	   if (clkd(DIVFACTOR3) = '0') then
		  etatacces <= clignote8;
	   end if;
		
		
	 when clignote8 =>
	   leds <= "01010101";
	    
		if (clkd(DIVFACTOR3) = '1') then
		  etatacces <= clignote9;
	   end if;
		
		
	 when clignote9 =>
	   leds <= "10101010";
		
	   if (clkd(DIVFACTOR3) = '0') then
		  etatacces <= moderestraint;
	   end if;
		
	 end case;
  end if;
end process;

end Behavioral;

