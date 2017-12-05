----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:34:59 10/13/2015 
-- Design Name: 
-- Module Name:    restrainedmode - Behavioral 
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

entity restrainedmode is
    Port ( Reset : in STD_LOGIC;
	        Clk : in STD_LOGIC;
			  choix : in STD_LOGIC_VECTOR (2 downto 0);
			  valideChoix : in STD_LOGIC;
			  controleurFeedback : in STD_LOGIC_VECTOR(7 downto 0);
			  enableControleur : out STD_LOGIC;
			  modeControleur : out STD_LOGIC_VECTOR(1 downto 0);
			  loadControleur : out STD_LOGIC;
			  affichage : out STD_LOGIC_VECTOR(7 downto 0));
end restrainedmode;

architecture Behavioral of restrainedmode is


-- ### Constantes pour l'horloge
-- pour vraie vie
constant DIVFACTOR2: integer:= 29;
-- pour simulation
--constant DIVFACTOR2: integer:= 2;



component compteurx4 is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
			  clkdout: out  STD_LOGIC_VECTOR (39 downto 0));
end component;

component onehotbinary is
    Port ( onehot : in  STD_LOGIC_VECTOR (7 downto 0);
           binary : out  STD_LOGIC_VECTOR (3 downto 0));
end component;

component comp3bits is
    Port ( a : in  STD_LOGIC_VECTOR (2 downto 0);
           b : in  STD_LOGIC_VECTOR (2 downto 0);
           isequal : out  STD_LOGIC;
           issmaller : out  STD_LOGIC);
end component;

component substractone is
    Port ( number : in  STD_LOGIC_VECTOR (3 downto 0);
           numminone : out  STD_LOGIC_VECTOR (2 downto 0));
end component;



type state is (initialise, attendchoix, choixfait,
               clignote0, clignote1, clignote2, clignote3, clignote4,
					clignote5, clignote6, clignote7, clignote8, clignote9,
					trophaut, trophaut1, tropbas, tropbas1);
-- signaux d'etat
signal etatcomplet: state;

-- signaux etage
signal etagebut: std_logic_vector (2 downto 0);

-- l'etage en binaire ou on est rendus
signal etagebinairepre: std_logic_vector (3 downto 0);
signal etagebinaire: std_logic_vector (2 downto 0);

-- signal de l'horloge divisée
signal clkd: std_logic_vector(39 downto 0);

-- signaux de sortie du comparateur
signal egaux, pluspetit: std_logic;

-- signal montrant si on est sur une etage interdite
signal etageinterdite: std_logic;

begin

--instanciation du diviseur d'horloge
horloge: compteurx4 port map(reset => reset,
									  clk => clk,
									  clkdout => clkd);

--instanciation du convertisseur one-hot vers binaire 
convertisseur: onehotbinary port map( onehot => controleurFeedback, binary => etagebinairepre);
-- ici, 0 devient vraiment 000 au lieu de 001, si l'entree est 000 alors, on renvoie
soustracteur1: substractone port map( number => etagebinairepre, numminone => etagebinaire);


--instanciation du comparateur 3 bits, en fait 4 car il y a le cas de l'étage 7 représenté en tant que 8.
comparateur: comp3bits port map( a => etagebinaire, b => etagebut, isequal => egaux, issmaller => pluspetit);

-- etage interdite alors le dernier bit est a 1 (1, 3, 5, 7)
etageinterdite <= etagebinaire(0);


process(clk, reset)
begin

  if (reset = '0') then
    etatcomplet <= initialise;
	 enableControleur <= '0';
	 modeControleur <= (others => '0');
	 loadControleur <= '0';
	 affichage <= (others => '1');
	 etagebut <= "000";
	 
  elsif (rising_edge(clk)) then
    case etatcomplet is
	 
	 
	   when initialise =>
		  -- on charge l'etage 0 (la premiere etage)
		  enableControleur <= '1';
		  modeControleur <= "00";
		  loadControleur <= '1';
		  affichage <= (others => '1');
		  
		  if (egaux = '1') then
		    etatcomplet <= attendChoix;
		  end if;
		
		
		when attendchoix =>
		  enableControleur <= '0';
		  affichage <= controleurFeedback;
		  if (valideChoix = '1') then
		    etagebut <= choix;
		  end if;
		  
		  if (valideChoix = '1') then
		    etatcomplet <= choixfait;
		  end if;
		  
		when choixfait =>
		  
		  if (egaux = '1') then
			   etatcomplet <= clignote0;
		  elsif (etagebut(0) = '1') then
		      etatcomplet <= clignote0;
				
		  elsif (etageinterdite = '0') then
	       if (pluspetit = '1') then
			   etatcomplet <= tropbas;
		    elsif (pluspetit = '0') then
			   etatcomplet <= trophaut;
			 end if;
		  elsif (etageinterdite = '1') then
		    if (pluspetit = '1') then
			   etatcomplet <= tropbas1;
		    elsif (pluspetit = '0') then
			   etatcomplet <= trophaut1;
			 end if;
		  end if;
		  
		  
		when clignote0 =>
		  affichage <= "10101010";
		  enableControleur <= '0';
		  
		  if (clkd(DIVFACTOR2) = '1') then
		    etatcomplet <= clignote1;
		  end if;
		  
		  
		when clignote1 =>
		  affichage <= "01010101";
		  
		  if (clkd(DIVFACTOR2) = '0') then
		    etatcomplet <= clignote2;
		  end if;
		  
		  
		when clignote2 =>
		  affichage <= "10101010";
		
		  if (clkd(DIVFACTOR2) = '1') then
		    etatcomplet <= clignote3;
		  end if;
		  
		  
		when clignote3 =>
		  affichage <= "01010101";
		
		  if (clkd(DIVFACTOR2) = '0') then
		    etatcomplet <= clignote4;
		  end if;
		  
		  
		when clignote4 =>
		  affichage <= "10101010";
		
		  if (clkd(DIVFACTOR2) = '1') then
		    etatcomplet <= clignote5;
		  end if;
		  
		  
		when clignote5 =>
		  affichage <= "01010101";
		
		  if (clkd(DIVFACTOR2) = '0') then
		    etatcomplet <= attendChoix;
		  end if;
		  
		  
		when clignote6 =>
		  affichage <= controleurFeedback;
		
		  if (clkd(DIVFACTOR2) = '1') then
		    etatcomplet <= clignote7;
		  end if;
		  
		  
		when clignote7 =>
		  affichage <= (others => '0');
		
		  if (clkd(DIVFACTOR2) = '0') then
		    etatcomplet <= clignote8;
		  end if;
		  
		  
		when clignote8 =>
		  affichage <= controleurFeedback;
		
		  if (clkd(DIVFACTOR2) = '1') then
		    etatcomplet <= clignote9;
		  end if;
		  
		  
		when clignote9 =>
		  affichage <= (others => '0');
		
		  if (clkd(DIVFACTOR2) = '0') then
		    etatcomplet <= attendChoix;
		  end if;
		  
		  
		when trophaut =>
		  -- on doit monter
		  enablecontroleur <= '1';
		  modecontroleur <= "11"; -- descend mode
		  loadcontroleur <= '0';
		  affichage <= controleurFeedback;
		  
		  if (egaux = '1') then
		    etatcomplet <= attendchoix;
		  end if;
		  
		when trophaut1 =>
		  -- on doit monter, mais juste de 1
		  enablecontroleur <= '1';
		  modecontroleur <= "10"; -- descend mode
		  loadcontroleur <= '0';
		  affichage <= controleurFeedback;
		  
		  if (egaux = '1') then
		    etatcomplet <= attendchoix;
		  elsif (etageinterdite = '0') then
		    etatcomplet <= trophaut;
		  end if;
		  
		when tropbas =>
		-- on doit descendre
		  enablecontroleur <= '1';
		  modecontroleur <= "01"; -- monte mode
		  loadcontroleur <= '0';
		  affichage <= controleurFeedback;
		  
		  if (egaux = '1') then
		    etatcomplet <= attendchoix;
		  end if;
		  
		when tropbas1 =>
		-- on doit descendre, mais juste de 1
		  enablecontroleur <= '1';
		  modecontroleur <= "00"; -- monte mode
		  loadcontroleur <= '0';
		  affichage <= controleurFeedback;
		  
		  if (egaux = '1') then
		    etatcomplet <= attendchoix;
		  elsif (etageinterdite = '0') then
		    etatcomplet <= tropbas;
		  end if;
		  
	 end case;
  end if;
  
end process;

end Behavioral;