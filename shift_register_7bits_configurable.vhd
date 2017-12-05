----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    21:08:16 09/22/2015 
-- Design Name: 
-- Module Name:    shift_register_7bits_configurable - Behavioral 
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

entity shift_register_7bits_configurable is
    Port ( enable : in  STD_LOGIC;
           reset : in  STD_LOGIC;
			  clk: in STD_LOGIC;
			  mode: in STD_LOGIC_VECTOR (2 downto 0);
           led_out : out  STD_LOGIC_VECTOR (7 downto 0));
end shift_register_7bits_configurable;

architecture Behavioral of shift_register_7bits_configurable is

signal memoires0 : STD_LOGIC_VECTOR (7 downto 0):= (0 => '1', others=>'0');
signal memoires1 : STD_LOGIC_VECTOR (7 downto 0):= (0 => '1', others=>'0');
signal memoires2 : STD_LOGIC_VECTOR (7 downto 0):= (0 => '1', others=>'0');
signal memoires3 : STD_LOGIC_VECTOR (7 downto 0):= (0 => '1', others=>'0');
signal memoires4 : STD_LOGIC_VECTOR (7 downto 0):= (0 => '1', others=>'0');
signal memoires5 : STD_LOGIC_VECTOR (7 downto 0):= (0 => '1', others=>'0');

-- signaux pour effectuer les comparaisons de multiplexeur
signal modevector0 : STD_LOGIC_VECTOR (7 downto 0);
signal modevector1 : STD_LOGIC_VECTOR (7 downto 0);
signal modevector2 : STD_LOGIC_VECTOR (7 downto 0);

signal clk1 : STD_LOGIC :='0';
signal clk2 : STD_LOGIC :='0';

begin

shiftregister7bits0: process (clk2, Reset)
  begin
    -- Activation du reset (actif-bas)
    if (Reset = '0') then
      memoires0 <= (0 => '1', others=>'0');
    -- Sinon, si on est sur un front montant
    elsif (clk2'event and clk2 = '1' and enable = '1') then
      memoires0(0) <= memoires0(1);
      memoires0(1) <= memoires0(2);
      memoires0(2) <= memoires0(3);
      memoires0(3) <= memoires0(4);
      memoires0(4) <= memoires0(5);
      memoires0(5) <= memoires0(6);
      memoires0(6) <= memoires0(7);
      memoires0(7) <= memoires0(0);
    end if;
  end process shiftregister7bits0;
  
shiftregister7bits1: process (clk2, Reset)
  begin
    -- Activation du reset (actif-bas)
    if (Reset = '0') then
      memoires1 <= (0 => '1', others=>'0');
    -- Sinon, si on est sur un front montant
    elsif (clk2'event and clk2 = '1' and enable = '1') then
      memoires1(0) <= memoires1(2);
      memoires1(1) <= memoires1(3);
      memoires1(2) <= memoires1(4);
      memoires1(3) <= memoires1(5);
      memoires1(4) <= memoires1(6);
      memoires1(5) <= memoires1(7);
      memoires1(6) <= memoires1(0);
      memoires1(7) <= memoires1(1);
    end if;
  end process shiftregister7bits1;

shiftregister7bits2: process (clk2, Reset)
  begin
    -- Activation du reset (actif-bas)
    if (Reset = '0') then
      memoires2 <= (0 => '1', others=>'0');
    -- Sinon, si on est sur un front montant
    elsif (clk2'event and clk2 = '1' and enable = '1') then
      memoires2(0) <= memoires2(4);
      memoires2(1) <= memoires2(5);
      memoires2(2) <= memoires2(6);
      memoires2(3) <= memoires2(7);
      memoires2(4) <= memoires2(0);
      memoires2(5) <= memoires2(1);
      memoires2(6) <= memoires2(2);
      memoires2(7) <= memoires2(3);
    end if;
  end process shiftregister7bits2;

shiftregister7bits3: process (clk2, Reset)
  begin
    -- Activation du reset (actif-bas)
    if (Reset = '0') then
      memoires3 <= (0 => '1', others=>'0');
    -- Sinon, si on est sur un front montant
    elsif (clk2'event and clk2 = '1' and enable = '1') then
      memoires3(0) <= memoires3(7);
      memoires3(1) <= memoires3(0);
      memoires3(2) <= memoires3(1);
      memoires3(3) <= memoires3(2);
      memoires3(4) <= memoires3(3);
      memoires3(5) <= memoires3(4);
      memoires3(6) <= memoires3(5);
      memoires3(7) <= memoires3(6);
    end if;
  end process shiftregister7bits3;

shiftregister7bits4: process (clk2, Reset)
  begin
    -- Activation du reset (actif-bas)
    if (Reset = '0') then
      memoires4 <= (0 => '1', others=>'0');
    -- Sinon, si on est sur un front montant
    elsif (clk2'event and clk2 = '1' and enable = '1') then
      memoires4(0) <= memoires4(6);
      memoires4(1) <= memoires4(7);
      memoires4(2) <= memoires4(0);
      memoires4(3) <= memoires4(1);
      memoires4(4) <= memoires4(2);
      memoires4(5) <= memoires4(3);
      memoires4(6) <= memoires4(4);
      memoires4(7) <= memoires4(5);
    end if;
  end process shiftregister7bits4;

shiftregister7bits5: process (clk2, Reset)
  begin
    -- Activation du reset (actif-bas)
    if (Reset = '0') then
      memoires5 <= (0 => '1', others=>'0');
    -- Sinon, si on est sur un front montant
    elsif (clk2'event and clk2 = '1' and enable = '1') then
      memoires5(0) <= memoires5(4);
      memoires5(1) <= memoires5(5);
      memoires5(2) <= memoires5(6);
      memoires5(3) <= memoires5(7);
      memoires5(4) <= memoires5(0);
      memoires5(5) <= memoires5(1);
      memoires5(6) <= memoires5(2);
      memoires5(7) <= memoires5(3);
    end if;
  end process shiftregister7bits5;

-- Multiplication des signaux de mode
modevector0 <= (others => mode(0));
modevector1 <= (others => mode(1));
modevector2 <= (others => mode(2));

--Multiplexeur
-- 
led_out <= (memoires0 and not modevector2 and not modevector1 and not modevector0) or
           (memoires1 and not modevector2 and not modevector1 and modevector0) or
			  (memoires2 and not modevector2 and modevector1 and not modevector0) or
			  (memoires3 and not modevector2 and modevector1 and modevector0) or
			  (memoires4 and modevector2 and not modevector1 and not modevector0) or
			  (memoires5 and modevector2 and not modevector1 and modevector0) or
			  ("00000000");


clock1: process (clk)
begin
  if (clk'event and clk='1') then
    clk1 <= not clk1;
  end if;
end process clock1;

clock2: process (clk1)
begin
  if (clk1'event and clk1='1') then
    clk2 <= not clk2;
  end if;
end process clock2;

end Behavioral;