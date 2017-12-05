----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    22:14:03 10/28/2015 
-- Design Name: 
-- Module Name:    assemblage - Behavioral 
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

entity assemblage is
    Port ( clk : in  STD_LOGIC;
	        reset : in std_logic;
			  resetAlarme : in std_logic;
			  switchs : in std_logic_vector (5 downto 0);
			  confirmeChoix : in std_logic;
			  alarmbutton : in std_logic;
			  confirmeCode : in std_logic;
           ledsOut : out  STD_LOGIC_VECTOR (7 downto 0));
end assemblage;

architecture Behavioral of assemblage is

component completemode is
    Port ( Reset : in STD_LOGIC;
	        Clk : in STD_LOGIC;
			  choix : in STD_LOGIC_VECTOR (2 downto 0);
			  valideChoix : in STD_LOGIC;
			  controleurFeedback : in STD_LOGIC_VECTOR(7 downto 0);
			  enableControleur : out STD_LOGIC;
			  modeControleur : out STD_LOGIC_VECTOR(1 downto 0);
			  loadControleur : out STD_LOGIC;
			  affichage : out STD_LOGIC_VECTOR(7 downto 0);
			  modeCompletTermine: out std_logic);
end component;

component restrainedmode is
    Port ( Reset : in STD_LOGIC;
	        Clk : in STD_LOGIC;
			  choix : in STD_LOGIC_VECTOR (2 downto 0);
			  valideChoix : in STD_LOGIC;
			  controleurFeedback : in STD_LOGIC_VECTOR(7 downto 0);
			  enableControleur : out STD_LOGIC;
			  modeControleur : out STD_LOGIC_VECTOR(1 downto 0);
			  loadControleur : out STD_LOGIC;
			  affichage : out STD_LOGIC_VECTOR(7 downto 0));
end component;

component fullaccess is
    Port ( clk : in  STD_LOGIC;
	        reset : in std_logic;
			  code : in std_logic_vector(5 downto 0);
			  confirmecode : in std_logic;
			  modecomplettermine: in std_logic;
           fullmode : out std_logic_vector (1 downto 0);
			  leds : out std_logic_vector(7 downto 0));
end component;

component alarm is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           alarmbutton : in  STD_LOGIC;
			  alarmeactive : out STD_LOGIC;
           leds : out  STD_LOGIC_VECTOR (7 downto 0));
end component;

component shiftregister8bitsmulti is
    Port ( Reset : in STD_LOGIC;
           Clk : in STD_LOGIC;
           enable : in STD_LOGIC;
			  load : in STD_LOGIC;
			  selection: in STD_LOGIC_VECTOR (1 downto 0);
			  load_value : in STD_LOGIC_VECTOR (7 downto 0);
           Output : out STD_LOGIC_VECTOR (7 downto 0);
           Input : in  STD_LOGIC);
end component;

component compteurx4 is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           clkdout : out  STD_LOGIC_VECTOR (39 downto 0));
end component;

component displaylogic is
    Port ( leds : in  STD_LOGIC_VECTOR (7 downto 0);
           sortie : out  STD_LOGIC_VECTOR (7 downto 0));
end component;


signal clkd, clkd2: std_logic_vector(39 downto 0);

-- signaux pour le shift register
signal load_valuec: std_logic_vector (7 downto 0);

signal sortieControleur: std_logic_vector(7 downto 0);
signal modeControleur: std_logic_vector(1 downto 0);
signal enableControleur, loadControleur: std_logic;

signal clkascenceur, horlogecompteur: std_logic;

--signal pour 6d, alarme
signal alarmeActive: std_logic;
signal ledsAlarme: std_logic_vector(7 downto 0);

--signal pour 6c, access au mode complet
signal fullaccessbits: std_logic_vector(1 downto 0);
signal ledsacces: std_logic_vector(7 downto 0);

--signal pour muxs de led et de choix
signal LedsMux: std_logic_vector(7 downto 0);
signal valideChoixMux1, valideChoixMux2: std_logic;

--signal pour machine complet
signal loadComplet, enableComplet: std_logic;
signal modeComplet: std_logic_vector(1 downto 0);
signal modeCompletTermine: std_logic;
signal ledsCompletpre, ledsComplet: std_logic_vector(7 downto 0);

--signal pour machine restreint
signal loadRestreint, enableRestreint: std_logic;
signal modeRestreint: std_logic_vector(1 downto 0);
signal ledsRestreintpre, ledsRestreint: std_logic_vector(7 downto 0);

-- pour vraie vie
constant DIVFACTOR1: integer:= 32;
-- pour simulation, dois etre l'autre x 2 environ
--constant DIVFACTOR1: integer:= 4;

begin

sortiecomplet: displaylogic port map (leds => ledsCompletpre, sortie => ledsComplet);
sortierestreint: displaylogic port map (leds => ledsRestreintpre, sortie => ledsRestreint);

--instanciation du diviseur d'horloge
horloge: compteurx4 port map(reset => reset,
									  clk => horlogecompteur,
									  clkdout => clkd);

--instanciation du diviseur d'horloge pour changement de longueur de période
horlogediv2: compteurx4 port map(reset => reset,
									  clk => clk,
									  clkdout => clkd2);
									  

STMalarme: alarm port map (clk => clk, reset => resetAlarme, alarmbutton => alarmbutton, alarmeactive => alarmeactive, leds => ledsAlarme);

controleur: shiftregister8bitsmulti port map (reset => reset, clk => clkascenceur,
                                              enable => enableControleur,
													       load => loadControleur,
                                              selection => modeControleur,
														    load_value => load_valuec, output => sortieControleur,
															 input => '0');
load_valuec <= "00000001";

STMaccessplein: fullaccess port map ( clk => clk, reset => reset, code => switchs,
                                   confirmecode => confirmeCode,
											  modecomplettermine => modecomplettermine,
											  fullmode => fullaccessbits,
											  leds => LedsAcces);

STMmodecomplet: completemode port map ( reset => reset, clk => clk, choix => switchs(2 downto 0),
                                       valideChoix => valideChoixMux2,
													controleurFeedback => sortieControleur,
													enableControleur => enableComplet,
													modeControleur => modeComplet,
													loadControleur => loadComplet,
													affichage => LedsCompletpre,
													modeCompletTermine => modeCompletTermine);
			  
STMmoderestreint: restrainedmode port map ( reset => reset, clk => clk, choix => switchs(2 downto 0),
                                            valideChoix => valideChoixMux1,
														  controleurFeedback => sortieControleur,
														  enableControleur => enableRestreint,
														  modeControleur => modeRestreint,
														  loadControleur => loadRestreint,
														  affichage => LedsRestreintpre);

--multiplexeurs d'entrée, simulent un démultiplexeur
with fullaccessbits select
valideChoixMux1 <= confirmeChoix when "00",
                   '0' when "01",
                   '0' when others;

with fullaccessbits select
valideChoixMux2 <= '0' when "00",
                   confirmeChoix when "01",
                   '0' when others;

--multiplexeur de sortie
with alarmeactive select
ledsOut <= LedsAlarme when '1',
           LedsMux when '0',
           (others => '1') when others;

--multiplexeur intermédiaire
with fullaccessbits select
ledsMux <= LedsRestreint when "00",
           LedsComplet when "01",
			  LedsAcces when "10",
			  LedsAcces when "11",
			  (others => '1') when others;

--multiplexeurs pour le controle de l'ascenseur
with fullaccessbits select
enableControleur <= enableRestreint when "00",
           enableComplet when "01",
			  '0' when "10",
			  '0' when "11",
			  '0' when others;
			  
with fullaccessbits select
modeControleur <= modeRestreint when "00",
           modeComplet when "01",
			  "00" when "10",
			  "00" when "11",
			  "00" when others;
			  
with fullaccessbits select
loadControleur <= loadRestreint when "00",
                  loadComplet when "01",
			         '0' when "10",
			         '0' when "11",
			         '0' when others;

-- simulateur d'ascenceur
-- si on monte de 2 on veut que l'ascenseur monte plus lentement
horlogecompteur <= (((not modeControleur(0) and clk) or (modeControleur(0) and clkd2(0))));
clkascenceur <= clkd(DIVFACTOR1);


end Behavioral;

