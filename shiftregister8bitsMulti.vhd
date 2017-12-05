----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    09:36:52 10/07/2015 
-- Design Name: 
-- Module Name:    shiftregister8bitsmulti - Behavioral 
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

entity shiftregister8bitsmulti is
    Port ( Reset : in STD_LOGIC;
           Clk : in STD_LOGIC;
           enable : in STD_LOGIC;
			  load : in STD_LOGIC;
			  selection: in STD_LOGIC_VECTOR (1 downto 0);
			  load_value : in STD_LOGIC_VECTOR (7 downto 0);
           Output : out STD_LOGIC_VECTOR (7 downto 0);
           Input : in  STD_LOGIC);
end shiftregister8bitsmulti;

architecture Behavioral of shiftregister8bitsmulti is

  component bitregister1 is
    port(reset, clk, d, en: in std_logic;
	      q: out std_logic);
	end component;
	
  component combilogic is
    port(load: in std_logic;
	      selection: in std_logic_vector (1 downto 0);
			inputs: in std_logic_vector (4 downto 0);
	      output: out std_logic);
	end component;
   
	
   signal bitsig_in: std_logic_vector (7 downto 0);
	signal bitsig_out: std_logic_vector (7 downto 0);
	
	type std_logic_vector_2d_8x4 is array (0 to 7) of std_logic_vector (4 downto 0);
   signal inputs: std_logic_vector_2d_8x4;
	

begin

  reg0: bitregister1 port map (reset => reset, clk => clk, en => enable, d => bitsig_in(0), q => bitsig_out(0));
  reg1: bitregister1 port map (reset => reset, clk => clk, en => enable, d => bitsig_in(1), q => bitsig_out(1));
  reg2: bitregister1 port map (reset => reset, clk => clk, en => enable, d => bitsig_in(2), q => bitsig_out(2));
  reg3: bitregister1 port map (reset => reset, clk => clk, en => enable, d => bitsig_in(3), q => bitsig_out(3));
  reg4: bitregister1 port map (reset => reset, clk => clk, en => enable, d => bitsig_in(4), q => bitsig_out(4));
  reg5: bitregister1 port map (reset => reset, clk => clk, en => enable, d => bitsig_in(5), q => bitsig_out(5));
  reg6: bitregister1 port map (reset => reset, clk => clk, en => enable, d => bitsig_in(6), q => bitsig_out(6));
  reg7: bitregister1 port map (reset => reset, clk => clk, en => enable, d => bitsig_in(7), q => bitsig_out(7));
  
  
  sel0: combilogic port map (load => load, selection => selection, inputs => inputs(0), output => bitsig_in(0));
  sel1: combilogic port map (load => load, selection => selection, inputs => inputs(1), output => bitsig_in(1));
  sel2: combilogic port map (load => load, selection => selection, inputs => inputs(2), output => bitsig_in(2));
  sel3: combilogic port map (load => load, selection => selection, inputs => inputs(3), output => bitsig_in(3));
  sel4: combilogic port map (load => load, selection => selection, inputs => inputs(4), output => bitsig_in(4));
  sel5: combilogic port map (load => load, selection => selection, inputs => inputs(5), output => bitsig_in(5));
  sel6: combilogic port map (load => load, selection => selection, inputs => inputs(6), output => bitsig_in(6));
  sel7: combilogic port map (load => load, selection => selection, inputs => inputs(7), output => bitsig_in(7));
  
  
  inputs(0) <= (0=> input, 1=> input, 2=> bitsig_out(1), 3=> bitsig_out(2), 4=> load_value(0));
  inputs(1) <= (0 => bitsig_out(0), 1=> '0', 2=> bitsig_out(2), 3=> bitsig_out(3), 4=> load_value(1));
  
  inputs(2) <= (0 => bitsig_out(1), 1 => bitsig_out(0), 2=> bitsig_out(3), 3=> bitsig_out(4), 4=> load_value(2));
  inputs(3) <= (0 => bitsig_out(2), 1 => bitsig_out(1), 2=> bitsig_out(4), 3=> bitsig_out(5), 4=> load_value(3));
  inputs(4) <= (0 => bitsig_out(3), 1 => bitsig_out(2), 2=> bitsig_out(5), 3=> bitsig_out(6), 4=> load_value(4));
  inputs(5) <= (0 => bitsig_out(4), 1 => bitsig_out(3), 2=> bitsig_out(6), 3=> bitsig_out(7), 4=> load_value(5));

  inputs(6) <= (0 => bitsig_out(5), 1=> bitsig_out(4), 2=> bitsig_out(7), 3=> '0', 4=> load_value(6));
  inputs(7) <= (0 => bitsig_out(6), 1=> bitsig_out(5), 2=> input, 3=> input, 4=> load_value(7));
  
  output <= bitsig_out;

end Behavioral;

