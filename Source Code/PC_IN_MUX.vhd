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
--  24-bit 2 to 1 MUX specific to the PC_IN module
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

entity pc_mux is
    port (
      SEL		: in  STD_LOGIC;
		DIN_A		: in  STD_LOGIC_VECTOR(23 downto 0);
		DIN_B		: in  STD_LOGIC_VECTOR(23 downto 0);
		DOUT		: out STD_LOGIC_VECTOR(23 downto 0)
    );
end pc_mux;

architecture Behavioral of pc_mux is
begin
	with SEl select DOUT <=
		DIN_A when '0',
		STD_LOGIC_VECTOR(unsigned(DIN_B)+1)when others;
end Behavioral;