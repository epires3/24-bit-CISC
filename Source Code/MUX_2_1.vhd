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
--  24-bit Adressing Mode GPR MUX
--
-- Notes:
--  Implemented from 8-bit register example
-- 		http://userweb.eng.gla.ac.uk/scott.roy/DCD3/sources.pdf	
--
-- Revision:
-- 	v.2.0
--		Added Auto Incrementing
---------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity mux_gpr is
    port (
      SEL		: in  STD_LOGIC_VECTOR(2 downto 0);
		DIN_A		: in  STD_LOGIC_VECTOR(23 downto 0);
		DIN_B		: in  STD_LOGIC_VECTOR(23 downto 0);
		DIN_C		: in  STD_LOGIC_VECTOR(23 downto 0);
		DIN_D    : in  STD_LOGIC_VECTOR(23 downto 0);
		DOUT		: out STD_LOGIC_VECTOR(23 downto 0)
    );
end mux_gpr;

architecture Behavioral of mux_gpr is
begin
	with SEl select DOUT <=
		DIN_A when "000",											 -- RD
		DIN_B when "001",											 -- GPR_OUT
		DIN_C when "010",											 -- IMM_OOP
		DIN_D when "011",											 -- RI
		STD_LOGIC_VECTOR(unsigned(DIN_A)+1) when "100",	 -- RD_AI
		STD_LOGIC_VECTOR(unsigned(DIN_D)+1) when others; -- DI_AI
end Behavioral;