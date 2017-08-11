---------------------------------------------------
-- School:     University of Massachusetts Dartmouth
-- Department: Computer and Electrical Engineering
-- Class:      ECE 368 Digital Design
-- Engineer:   Eric Pires
--             Khang Nguyen
-- 
-- Create Date:    March 2017
-- Module Name:    Mux
-- Project Name:   CISC-24
-- Target Devices: Spartan-3E
-- Tool versions:  Xilinx ISE 14.7
--
-- Description:
--  24-bit 3 to 1 MUX
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
use IEEE.NUMERIC_STD.ALL;

entity debug_mux is
    port (
      SEL		: in  STD_LOGIC_VECTOR(1 downto 0);
		EN			: in  STD_LOGIC;
		RST 		: in  STD_LOGIC;
		DIN_A		: in  STD_LOGIC_VECTOR(23 downto 0);
		DIN_B		: in  STD_LOGIC_VECTOR(23 downto 0);
		DIN_C		: in  STD_LOGIC_VECTOR(23 downto 0);
		DOUT		: out STD_LOGIC_VECTOR(23 downto 0)
    );
end debug_mux;

architecture Behavioral of debug_mux is
begin
process(RST,EN)
begin
	if(RST = '1') then
		DOUT <= (others => '0');
	elsif(EN = '1') then
		case SEL is
			when "00" 	=>   DOUT <= DIN_A;
			when "01" 	=>   DOUT <= DIN_B;
			when others =>   DOUT <= DIN_C;
		end case;
	end if;
end process;
end Behavioral;