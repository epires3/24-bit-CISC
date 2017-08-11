--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   11:08:16 03/28/2017
-- Design Name:   
-- Module Name:   C:/Users/ericj/Documents/Xilinx Projects/CISC-24/TB_CPU.vhd
-- Project Name:  CISC-24
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: cpu_toplevel
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
 
ENTITY TB_CPU IS
END TB_CPU;
 
ARCHITECTURE behavior OF TB_CPU IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT cpu_toplevel
    PORT(
         CPU_CLK : IN  std_logic;
         CPU_RST : IN  std_logic;
         CPU_OUT : OUT std_logic_vector(23 downto 0);
			CPU_CCR  : OUT  STD_LOGIC_VECTOR (3 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal CPU_CLK : std_logic := '0';
   signal CPU_RST : std_logic := '0';
	--signal CPU_IN  : STD_LOGIC_VECTOR (23 downto 0) := (others => '0');

 	--Outputs
   signal CPU_OUT : std_logic_vector(23 downto 0);
	signal CPU_CCR : std_logic_vector(3 downto 0);

   -- Clock period definitions
   constant period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: cpu_toplevel PORT MAP (
          CPU_CLK => CPU_CLK,
          CPU_RST => CPU_RST,
          CPU_OUT => CPU_OUT,
			 CPU_CCR => CPU_CCR
        );

   -- Clock process definitions
   CPU_CLK_process :process
   begin
		CPU_CLK <= '0';
		wait for period;
		CPU_CLK <= '1';
		wait for period;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
		CPU_RST <= '1'; wait for 100 ns;	
		CPU_RST <= '0'; wait for period;
      -- Instruction Testing ADDI R0 x1
		--CPU_IN <= x"B80001"; wait for period*20;
		--assert (CPU_OUT = x"1")  report "Failed READ. CPU_OUT=" & integer'image(to_integer(unsigned(CPU_OUT))) severity ERROR;	
      wait;
   end process;

END;
