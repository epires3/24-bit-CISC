---------------------------------------------------
-- School: University of Massachusetts Dartmouth
-- Department: Computer and Electrical Engineering
-- Engineer: Daniel Noyes
-- 
-- Create Date:    SPRING 2015
-- Module Name:    ALU_MUX
-- Project Name:   ALU
-- Target Devices: Spartan-3E
-- Tool versions:  Xilinx ISE 14.7
-- Description: Mux unit
--  Output what ALU operation requested
---------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ALU_Mux is
    Port ( OP        : in  STD_LOGIC_VECTOR (3 downto 0);
           ARITH     : in  STD_LOGIC_VECTOR (23 downto 0);
           LOGIC     : in  STD_LOGIC_VECTOR (23 downto 0);
           SHIFT     : in  STD_LOGIC_VECTOR (23 downto 0);
           MEMORY    : in  STD_LOGIC_VECTOR (23 downto 0);
           CCR_ARITH : in  STD_LOGIC_VECTOR (3 downto 0);
           CCR_LOGIC : in  STD_LOGIC_VECTOR (3 downto 0);
           ALU_OUT   : out STD_LOGIC_VECTOR (23 downto 0);
           CCR_OUT   : out STD_LOGIC_VECTOR (3 downto 0));
end ALU_Mux;

architecture Combinational of ALU_Mux is

begin
	 with OP select
		  ALU_OUT <=
				ARITH     when "0000",     -- ADD
				ARITH     when "0001",     -- SUB
				LOGIC     when "0010",     -- AND
				LOGIC     when "0011",     -- NONE
				LOGIC     when "0100",     -- INV
				ARITH     when "0101",     -- XOR
				LOGIC     when "0110",     -- ANDI
				MEMORY    when "0111",     -- LW
				SHIFT     when "1000",     -- SL
				SHIFT     when "1001",     -- SR
				ARITH     when "1010",		-- ADDI
				LOGIC		 when "1100",		-- NOT
				LOGIC		 when "1101",		-- OR
				LOGIC		 when "1111",		-- CMP
				MEMORY    when OTHERS;     -- SW

	 with OP select
		  CCR_OUT <=
				CCR_ARITH when "0000",     -- ADD
				CCR_ARITH when "0001",     -- SUB
				CCR_LOGIC when "0010",     -- MUL
				CCR_LOGIC when "0011",     -- DIV
				CCR_LOGIC when "0100",     -- AND
				CCR_ARITH when "0101",     -- XOR
				CCR_LOGIC when "0110",     -- ANDI
				CCR_ARITH when "1010",		-- ADDI
				CCR_LOGIC when "1111",		-- CMP
				"0000"     when OTHERS;     -- All flags cleared for other LOGIC operations

end Combinational;

