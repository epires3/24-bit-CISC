------------------------------------------------------------------------
-- School:     University of Massachusetts Dartmouth
-- Department: Computer and Electrical Engineering
-- Class:      ECE 368 Digital Design
-- Engineer:   Eric Pires
--             Khang Nguyen
-- 
-- Create Date:    March 2017
-- Module Name:    Tri_Buff
-- Project Name:   CISC-24
-- Target Devices: Spartan-3E
-- Tool versions:  Xilinx ISE 14.7
--
-- Description:
--  24-bit Active-High Tri-State Buffer 
--
-- Notes: Adopted from (https://startingelectronics.org/software/VHDL-CPLD-course/tut16-tri-state-buffer/)
--
--
-- Revision:
-- 	v.1.0 
------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tri_buff is
    Port ( DIN : in  STD_LOGIC_VECTOR (23 downto 0);
           EN : in  STD_LOGIC;
           DOUT : out  STD_LOGIC_VECTOR (23 downto 0));
end tri_buff;

architecture Behavioral of tri_buff is

begin
	DOUT <= DIN when (EN = '1') else x"000000";
end Behavioral;

