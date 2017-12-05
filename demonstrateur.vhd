----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:34:45 11/02/2015 
-- Design Name: 
-- Module Name:    demonstrateur - Behavioral 
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

entity demonstrateur is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           tx : in  STD_LOGIC;
			  dataready: out STD_LOGIC;
           ledout : out  STD_LOGIC_VECTOR (7 downto 0));
end demonstrateur;

architecture Behavioral of demonstrateur is

signal resetEtErreur, errorsig, datareadysig: std_logic;

component UARTReceiver is
 Port ( clk : in STD_LOGIC;
	        reset : in STD_LOGIC;
	        tx : in  STD_LOGIC;
			  error : out STD_LOGIC;
			  dataready : out STD_LOGIC;
           byteout : out  STD_LOGIC_VECTOR (7 downto 0));
end component;

begin

resetEtErreur <= reset and not errorsig;

recepteur: UARTReceiver port map (clk => clk,
                                  reset => resetEtErreur,
											 tx => tx,
											 error => errorsig,
											 dataready => datareadysig,
											 byteout => ledout);


end Behavioral;

