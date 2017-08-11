----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:05:00 05/01/2017 
-- Design Name: 
-- Module Name:    Branch_Cmp - Behavioral 
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

entity Branch_Cmp is
    Port ( MASK : in  STD_LOGIC_VECTOR (3 downto 0);
           CCR  : 	in  STD_LOGIC_VECTOR (3 downto 0);
           CMP  : out  STD_LOGIC);
end Branch_Cmp;

architecture Behavioral of Branch_Cmp is

begin
	CMP <= '1' when MASK = CCR else '0';
end Behavioral;

