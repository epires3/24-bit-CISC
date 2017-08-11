----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:33:02 04/21/2017 
-- Design Name: 
-- Module Name:    Ins_Mux - Behavioral 
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

entity Ins_Mux is
port (
      SEL		: in  STD_LOGIC_VECTOR(2 downto 0);
		DIN_A		: in  STD_LOGIC_VECTOR(23 downto 0);
		DIN_B		: in  STD_LOGIC_VECTOR(23 downto 0);
		DIN_C		: in  STD_LOGIC_VECTOR(23 downto 0);
		DIN_D		: in  STD_LOGIC_VECTOR(23 downto 0);
		DIN_E		: in  STD_LOGIC_VECTOR(23 downto 0);
		DIN_F		: in  STD_LOGIC_VECTOR(23 downto 0);
		DOUT		: out STD_LOGIC_VECTOR(23 downto 0)
    );
end Ins_Mux;

architecture Behavioral of Ins_Mux is

begin
	with SEl select DOUT <=
		DIN_A when "000",
		DIN_B when "001",
		DIN_C when "010",
		DIN_D when "011",
		DIN_E when "100",
		DIN_F when others;
end Behavioral;

