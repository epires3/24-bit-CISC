---------------------------------------------------
-- School:     University of Massachusetts Dartmouth
-- Department: Computer and Electrical Engineering
-- Class:      ECE 368 Digital Design
-- Engineer:   Eric Pires
--             Khang Nguyen
-- 
-- Create Date:    March 2017
-- Module Name:    Gpr
-- Project Name:   CISC-24
-- Target Devices: Spartan-3E
-- Tool versions:  Xilinx ISE 14.7
--
-- Description:
--  CISC-24 CPU General Purpose Register with 8 24-bit Registers
--
-- Notes:
--  Implemented from 16-bit CPU example
-- 		http://labs.domipheus.com/blog/designing-a-cpu-in-vhdl-part-2-xilinx-ise-suite-register-file-testing/
--		https://github.com/DavidPynes/MIPS-Processor
--  Does not take addressing mode into account
-- Revision:
-- 	v.2.0
--			Fixed reset so now reset is checked before clock tick to ensure registers are cleared on time
---------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity gpr is
    port (
      CLK         : in  STD_LOGIC;
		RST			: in  STD_LOGIC;
      WEN			: in  STD_LOGIC;
		REG_W_SEL   : in  STD_LOGIC;
		DIN			: in  STD_LOGIC_VECTOR(23 downto 0);
		SEL_A			: in  STD_LOGIC_VECTOR(2 downto 0);
		SEL_B			: in  STD_LOGIC_VECTOR(2 downto 0);
		RA				: out STD_LOGIC_VECTOR(23 downto 0);
		RB				: out STD_LOGIC_VECTOR(23 downto 0)	
    );
end gpr;

architecture Behavioral of gpr is
type reg_bank is array (0 to 7) of STD_LOGIC_VECTOR(23 downto 0);
signal reg: reg_bank := (others=> (others=>'0'));

begin
    process (CLK, RST)
    begin			
		if (RST = '1') then											-- Clear Reg Bank
					reg <= (others => (others=>'0'));
		elsif (CLK'event and CLK='1') then						-- Rising Edge Triggered
			if (WEN = '1' and REG_W_SEL = '1') then			-- Write Data to register b	(MVS)	
				reg(to_integer(unsigned(sel_b))) <= DIN;	
			elsif (WEN = '1' and REG_W_SEL = '0') then
				reg(to_integer(unsigned(sel_a))) <= DIN;		-- Write Data to register a		
         end if;
		end if;
    end process;
	 RA <= reg(to_integer(unsigned(sel_a)));
	 RB <= reg(to_integer(unsigned(sel_b)));
end Behavioral;