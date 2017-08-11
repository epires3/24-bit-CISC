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

entity mux_alu is
    port (
      SEL		: in  STD_LOGIC_VECTOR(2 downto 0);
		DIN_A		: in  STD_LOGIC_VECTOR(23 downto 0);
		DIN_B		: in  STD_LOGIC_VECTOR(23 downto 0);
		DIN_C		: in  STD_LOGIC_VECTOR(23 downto 0);
		DOUT		: out STD_LOGIC_VECTOR(23 downto 0)
    );
end mux_alu;

architecture Behavioral of mux_alu is
begin
	with SEl select DOUT <=
		DIN_A when "000",											-- Register Direct Output
		STD_LOGIC_VECTOR(unsigned(DIN_A)+1) when "001",	-- Register Direct INC
		STD_LOGIC_VECTOR(unsigned(DIN_A)-1) when "010", -- Register Direct DEC
		DIN_B when "011",											-- IMM_OP
		DIN_C when "100",											-- Register Indirect Output
		STD_LOGIC_VECTOR(unsigned(DIN_B)+1) when "101",	-- Register Indirect INC
		STD_LOGIC_VECTOR(unsigned(DIN_B)-1) when others; -- Register Indirect DEC
end Behavioral;