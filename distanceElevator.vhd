----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:12:04 11/05/2015 
-- Design Name: 
-- Module Name:    distanceElevator - Behavioral 
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

entity distanceElevator is
    Port ( clk : in  STD_LOGIC;
	        reset : in STD_LOGIC;
			  alarmebouton: in STD_LOGIC;
			  tx : in STD_LOGIC;
           ledsOut : out  STD_LOGIC_VECTOR (7 downto 0));
end distanceElevator;

architecture Behavioral of distanceElevator is



-- l'ascenceur avec ses machines d'état et tout le tralala
component assemblage is
    Port ( clk : in  STD_LOGIC;
	        reset : in std_logic;
			  resetAlarme : in std_logic; -- ajout pour redemarrer l'alarme separement
			  switchs : in std_logic_vector (5 downto 0);
			  confirmeChoix : in std_logic;
			  alarmbutton : in std_logic;
			  confirmeCode : in std_logic;
           ledsOut : out  STD_LOGIC_VECTOR (7 downto 0));
end component;

-- le module de communication UART fait au numero precedent
component UARTReceiver is
    Port ( clk : in STD_LOGIC;
	        reset : in STD_LOGIC;
	        tx : in  STD_LOGIC;
			  error : out STD_LOGIC;
			  dataready: out STD_LOGIC;
           byteout : out  STD_LOGIC_VECTOR (7 downto 0));
end component;



signal resetSig1, resetSig2, resetAlarmeSig, confirmeChoixSig, alarmbuttonSig, alarmbuttonSig2, confirmeCodeSig: std_logic;
signal switchsSig: std_logic_vector (5 downto 0);
signal errorSig, datareadySig: std_logic;
signal theDataSig: std_logic_vector(7 downto 0);

signal theMDP: std_logic_vector(5 downto 0);

type ProtocoleEtats is (attentData, alarme, resetPartiel, attentDataMDP, choixMDP, choixEtage);
signal etatProtocole: ProtocoleEtats;

signal donneesaccumule: std_logic_vector(2 downto 0);

signal resetSig1Distance, resetSig2Distance: std_logic;

begin

--instanciation de l'ascenceur
theElevator: assemblage port map (clk => clk, reset => resetSig1,
                                  resetAlarme => resetAlarmeSig,
                                  switchs => switchsSig,
											 confirmeChoix => confirmeChoixSig,
											 alarmbutton => alarmbuttonSig2,
											 confirmeCode => confirmeCodeSig,
											 ledsOut => ledsOut);

uartComm: UARTReceiver port map (clk => clk,
                                 reset => resetSig2,
											tx => tx,
											error => errorSig,
											dataready => datareadySig,
											byteout => theDataSig);

-- la machine d'etat qui gere le protocole de communication,
-- gere seulement le choix d'etage dans ce numero
process (clk, reset)
begin
  if (reset = '0') then
    etatProtocole <= attentData;
	 confirmeChoixSig <= '0';
	 switchsSig <= (others => '0');
	 donneesaccumule <= (others => '0');
	 confirmeCodeSig <= '0';
	 alarmbuttonSig <= '0';
	 theMDP <= (others => '0');
	 resetSig1Distance <= '0';
	 resetSig2Distance <= '0';
	 
  elsif (rising_edge(clk)) then
    case etatProtocole is
	 
	 
	 
	 when attentData =>
	   confirmeChoixSig <= '0';
		confirmeCodeSig <= '0';
		donneesaccumule <= (others => '0');
		theMDP <= (others => '0');
		alarmbuttonSig <= '0';
	   resetSig1Distance <= '1';
	   resetSig2Distance <= '1';
		
	   -- on a recu une etage
	   if (dataReadySig = '1') then
		  if (theDataSig(7) = '1') then -- alarme
		    etatProtocole <= alarme;
		  elsif (theDataSig(6) = '1') then -- reset partiel sans reset d'alarme
		    etatProtocole <= resetPartiel;
		  elsif (theDataSig(5) = '1') then -- mode de passe
		    etatProtocole <= attentDataMDP;
		  else
		    etatProtocole <= choixEtage;
		  end if;
		end if;
	 
	 
	 when alarme =>
	   alarmbuttonSig <= '1';
	 
	   -- on retourne inconditionnellement vers l'attente de données
	   etatProtocole <= attentData;
		
		
	 when resetPartiel =>
	   resetSig1Distance <= '0';
	   resetSig2Distance <= '0';
		
	 	-- on retourne inconditionnellement vers l'attente de données
	   etatProtocole <= attentData;
	 
	 
	 -- on attend les 6 paquets de 8 bits et on les accumule dans un registre de mot de passe
	 when attentDataMDP =>
	   
		if (dataReadysig = '1') then
	     donneesaccumule <= donneesaccumule + 1;
		  theMDP <= theMDP + theDataSig(5 downto 0);
		end if;
		
		-- on a toutes les donnees maintenant
		if (donneesaccumule = 6) then
		  etatProtocole <= choixMDP;
		end if;
	 
	 
	 -- on a recu l'information du mdp necessaire et on pousse vers l'ascenseur
	 when choixMDP =>
	   switchsSig <= theMDP;
	   confirmeCodeSig <= '1';
      -- on revient inconditionnellement vers attentData.
      etatProtocole <= attentData;

		
	 -- on a recu les donnees et on choisi une etage
	 when choixEtage =>
	   switchsSig <= theDataSig (5 downto 0); -- seul les 3 bits lsb importent
	   confirmeChoixSig <= '1';
		
		-- on revient inconditionnellement vers attentData.
		etatProtocole <= attentData;
	 
	 
	 
	 end case;
  end if;
end process;

resetSig1 <= resetSig1Distance;
resetSig2 <= resetSig2Distance;
resetAlarmeSig <= reset;

alarmbuttonSig2 <= alarmbuttonSig or alarmebouton;
end Behavioral;