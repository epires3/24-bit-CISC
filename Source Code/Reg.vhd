---------------------------------------------------
-- School:     University of Massachusetts Dartmouth
-- Department: Computer and Electrical Engineering
-- Class:      ECE 368 Digital Design
-- Engineer:   Eric Pires
--             Khang Nguyen
-- 
-- Create Date:    March 2017
-- Module Name:    Reg
-- Project Name:   CISC-24
-- Target Devices: Spartan-3E
-- Tool versions:  Xilinx ISE 14.7
--
-- Description:
--  24-bit Register 
--
-- Notes:
--  Implemented from 8-bit register example
-- 		http://userweb.eng.gla.ac.uk/scott.roy/DCD3/sources.pdf	
--
-- Revision:
-- 	v.1.0
--
---------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity reg is
    port (
		CLK         : in  STD_LOGIC;
		RST			: in STD_LOGIC;
      EN				: in STD_LOGIC;
		DIN			: in STD_LOGIC_VECTOR(23 downto 0);
		DOUT			: out STD_LOGIC_VECTOR(23 downto 0)	
    );
end reg;

architecture Behavioral of reg is
begin
    process (CLK,RST,EN)
    begin
		if (RST = '1') then
			DOUT <= (others => '0');
			
      elsif (CLK'event and CLK='1' and EN = '1') then	-- Rising Edge Triggered	
			DOUT <= DIN;
     end if;
    end process;
end Behavioral;