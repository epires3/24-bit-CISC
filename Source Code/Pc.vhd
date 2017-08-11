---------------------------------------------------
-- School:     University of Massachusetts Dartmouth
-- Department: Computer and Electrical Engineering
-- Class:      ECE 368 Digital Design
-- Engineer:   Eric Pires
--             Khang Nguyen
-- 
-- Create Date:    March 2017
-- Module Name:    PC
-- Project Name:   CISC-24
-- Target Devices: Spartan-3E
-- Tool versions:  Xilinx ISE 14.7
--
-- Description:
--  CISC-24 CPU Program Counter
--
-- Notes: Implemented from 16-bit CPU example
--  http://labs.domipheus.com/blog/designing-a-cpu-in-vhdl-part-6-program-counter-instruction-fetch-branching/
--  Does not take addressing mode into account
-- Revision:
-- 	v.3.0
--			Added EN
--			Modified HALT condition to point back to previous ADDR
---------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity pc is
    port (
      CLK      : in  STD_LOGIC;
		EN			: in  STD_LOGIC;
		RST      : in  STD_LOGIC;
		PCIN		: in  STD_LOGIC_VECTOR(23 downto 0);
		OP			: in  STD_LOGIC_VECTOR(1 downto 0);
		OFST		: in 	STD_LOGIC_VECTOR(23 downto 0);
		PCOUT		: out STD_LOGIC_VECTOR(23 downto 0)
    );
end pc;

architecture Behavioral of pc is
	signal addr: STD_LOGIC_VECTOR(23 downto 0) := (others => '0'); 
	begin
		process(CLK, OP, addr, EN)
	   begin
			if (RST = '1') then											--  Reset PC
				addr <= (others => '0');
			elsif (CLK'event and CLK='1' and EN = '1') then
				case OP is
					when "00" =>										   -- Halt
						addr <= addr;--STD_LOGIC_VECTOR(unsigned(addr));
					when "01" =>											-- INC
						addr <= addr + 1;--STD_LOGIC_VECTOR(unsigned(addr) + 1);	
					when "10" =>											-- Jump to new address
						addr <= PCIN;
					when others =>										   --  Branch
						addr <= addr + OFST;
				end case;
			end if;
		PCOUT <= addr;
		end process;
end Behavioral;