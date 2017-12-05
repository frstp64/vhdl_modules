----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:08:24 11/02/2015 
-- Design Name: 
-- Module Name:    UARTReceiver - Behavioral 
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
use IEEE.STD_LOGIC_unsigned.all;
use IEEE.NUMERIC_STD.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity UARTReceiver is
    Port ( clk : in STD_LOGIC;
	        reset : in STD_LOGIC;
	        tx : in  STD_LOGIC;
			  error : out STD_LOGIC;
			  dataready: out STD_LOGIC;
           byteout : out  STD_LOGIC_VECTOR (7 downto 0));
end UARTReceiver;

architecture Behavioral of UARTReceiver is

-- 9600 hz, alors 104.17 us, alors 10417* 0.01 us
constant debit: integer := 10417;
constant demidebit: integer := 5209;
constant databitsnumber: integer := 8;

type ReceiverState is (idle, startbit, databits, stopbit, cleanexecute);
signal etatUART: ReceiverState;

signal enableHorloge: std_logic;
signal Horloge: std_logic_vector (28 downto 0);
signal registeredDataBits: std_logic_vector (3 downto 0);
signal mydataBits: std_logic_vector(databitsnumber-1 downto 0);
signal milieuAtteint: std_logic;
signal errorflag: std_logic;

begin

-- horloge qui se redémarre à zéro lorsque désactivée
-- celle-ci se reset lorsqu'égale à la valeur de débit désirée.
-- un signal permet d'observer l'atteint du milieu du bit
process(clk, reset)
begin
  if (reset = '0') then
    horloge <= (others => '0');
	 milieuAtteint <= '0';
  elsif (rising_edge(clk)) then
    if (enableHorloge = '1') then
		if (horloge = demidebit) then
	     milieuAtteint <= '1'; -- impulsion signifiant le milieu de bit
		  horloge <= horloge + 1;
	   elsif (horloge = debit) then -- si on atteint le max on reset
	     horloge <= (others => '0');
		else -- le reste du temps on incrémente
		  milieuAtteint <= '0';
		  horloge <= horloge + 1;
		end if;
	 elsif (enableHorloge = '0') then
	   horloge <= (others => '0');
	 end if;
  end if;
end process;

process(clk, reset)
begin
if (reset = '0') then
  etatUART <= idle;
  errorFlag <= '0';
  byteout <= (others => '0');
  mydatabits <= (others => '0');
  enableHorloge <= '0';
  registeredDataBits <= (others => '0');
elsif (rising_edge(clk)) then
  case etatUART is
  
  
    when idle =>
	   dataready <= '0';
		-- si descend vers 0, alors début communication
	   if (tx = '0') then
		  enableHorloge <= '1';
	     etatUART <= startbit;
	   end if;
	 
	 
	 when startbit =>
	   registeredDataBits <= (others => '0');
		--vérification si le bit est encore à zéro tout le long
		--du start bit possible
		
		if (milieuAtteint = '1') then
		  if (tx = '0') then
		    etatUART <= databits;
		  elsif (tx = '1') then
		    etatUART <= idle;
		  end if;
		end if;
	 
	 
	 when databits =>
	   -- enregistrement des bits de données
		if (milieuAtteint = '1') then
		  registeredDataBits <= registeredDataBits + 1;
		  mydatabits <= tx & mydatabits(databitsnumber-1 downto 1);
		end if;
		
		if (registeredDataBits = 8) then
		  etatUART <= stopbit;
		end if;
		
		
	 when stopbit =>
		if (milieuAtteint = '1') then
		  if (tx = '0') then
		    errorflag <= '1';
			 etatUART <= cleanexecute;
		  elsif (tx = '1') then
		    etatUART <= cleanexecute;
		  end if;
		end if;
		  
		  
	 when cleanexecute =>
	   byteout <= mydatabits;
		dataready <= '1';
		mydatabits <= (others => '0');
	   etatUART <= idle;
		enableHorloge <= '0';
		registeredDataBits <= (others => '0');
		
		
  end case;
end if;

error <= errorFlag;

end process;

end Behavioral;

