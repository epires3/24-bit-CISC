---------------------------------------------------
-- School:     University of Massachusetts Dartmouth
-- Department: Computer and Electrical Engineering
-- Class:      ECE 368 Digital Design
-- Engineer:   Eric Pires
--             Khang Nguyen
-- 
-- Create Date:    March 2017
-- Module Name:    Decoder
-- Project Name:   CISC-24
-- Target Devices: Spartan-3E
-- Tool versions:  Xilinx ISE 14.7
--
-- Description:
--  CISC-24 Instruction Decoder
--
-- Notes:
--  Implemented from 16-bit CPU example
-- 		http://labs.domipheus.com/blog/designing-a-cpu-in-vhdl-part-3-instruction-set-decoder-ram/
--	Branch and Jump operands not accounted for
-- Revision:
-- 	v.1.1
--		Added dual memory location decode signal
---------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity decode is
    port (
      CLK      : in  STD_LOGIC;
		EN			: in STD_LOGIC;
      INS		: in STD_LOGIC_VECTOR(23 downto 0);
		ADDR_A   : out STD_LOGIC_VECTOR(2 downto 0);
		ADDR_B   : out STD_LOGIC_VECTOR(2 downto 0);
		OP			: out STD_LOGIC_VECTOR(4 downto 0);
		AM_A		: out STD_LOGIC_VECTOR(1 downto 0);
		AM_B		: out STD_LOGIC_VECTOR(1 downto 0);
		IMM_OOP	: out STD_LOGIC_VECTOR(23 downto 0);
		IMM_TOP	: out STD_LOGIC_VECTOR(23 downto 0);
		IMM_MEM  : out STD_LOGIC_VECTOR(23 downto 0);
		IMM 		: out STD_LOGIC_VECTOR(23 downto 0);
		IMM_BRN  : out STD_LOGIC_VECTOR(23 downto 0);
		MSK		: out STD_LOGIC_VECTOR(3  downto 0)
    );
end decode;

architecture Behavioral of decode is
begin
    process (CLK, EN)
    begin			
        if (CLK'event and CLK='1' and EN='1') then	
			ADDR_A   <= INS(16 downto 14);							-- SRC_A Address
			AM_A     <= INS(18 downto 17);			
			ADDR_B   <= INS(11 downto 9);								-- SRC_B Address
			AM_B     <= INS(13 downto 12);
			IMM_OOP  <= "0000000000" & INS(13 downto 0);			-- IMMEDIATE
			IMM_TOP  <= "000000000000000" & INS(8 downto 0);
			IMM_MEM  <= "00000000000000"  & INS(18 downto 9);
			IMM_BRN  <= "000000000" & INS(14 downto 0);		
			IMM      <= "00000" & INS(18 downto 0);
			OP       <= INS(23 downto 19);							-- OPERAND
			MSK		<= INS(18 downto 15);							-- MASK
									
        end if;
    end process;
end Behavioral;