----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    20:05:49 05/01/2017 
-- Design Name: 
-- Module Name:    Reg_4 - Behavioral 
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

entity reg_sts is
    port (
		CLK         : in  STD_LOGIC;
		RST			: in STD_LOGIC;
		CLR			: in STD_LOGIC;
      EN				: in STD_LOGIC;
		DIN			: in STD_LOGIC_VECTOR(3 downto 0);
		DOUT			: out STD_LOGIC_VECTOR(3 downto 0)	
    );
end reg_sts;

architecture Behavioral of reg_sts is
begin
    process (CLK,RST,EN)
    begin
		if (RST = '1' or CLR = '1') then
			DOUT <= (others => '0');
			
      elsif (CLK'event and CLK='1' and EN = '1') then	-- Rising Edge Triggered	
			DOUT <= DIN;
     end if;
    end process;
end Behavioral;

