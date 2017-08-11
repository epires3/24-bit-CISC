------------------------------------------------------------------------
-- School:     University of Massachusetts Dartmouth
-- Department: Computer and Electrical Engineering
-- Class:      ECE 368 Digital Design
-- Engineer:   Eric Pires
--             Khang Nguyen
-- 
-- Create Date:    March 2017
-- Module Name:    Controller
-- Project Name:   CISC-24
-- Target Devices: Spartan-3E
-- Tool versions:  Xilinx ISE 14.7
--
-- Description:
--  CISC-24 CPU Controller Unit
--
-- Notes:
--
--
-- Revision:
-- 	v.3.0
--		Adressing Mode implemented
-- 	OOP, JMP insructions implemented
------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity cntrl is   
 port (  CLK         : in  STD_LOGIC;
			RST         : in  STD_LOGIC;
			--INT_SEL		: in  STD_LOGIC;
			OP				: in  STD_LOGIC_VECTOR(4 downto 0);
			AM_A			: in  STD_LOGIC_VECTOR(1 downto 0);
			AM_B			: in  STD_LOGIC_VECTOR(1 downto 0);
			MASK_CMP   	: in 	STD_LOGIC;
			PC_OP			: out STD_LOGIC_VECTOR(1 downto 0);
			PC_EN			: out STD_LOGIC;
			IR_EN			: out STD_LOGIC;
			DECODE_EN   : out STD_LOGIC;
			GPR_WE		: out STD_LOGIC;
			GPR_W_SEL	: out STD_LOGIC;
			GPR_MUX_SEL : out STD_LOGIC_VECTOR(2 downto 0);
			RA_EN			: out STD_LOGIC;
			RB_EN			: out STD_LOGIC;
			ALU_SEL_A	: out STD_LOGIC_VECTOR(2 downto 0);
			ALU_SEL_B	: out STD_LOGIC_VECTOR(2 downto 0);
			ALU_A_EN		: out STD_LOGIC;
			ALU_B_EN		: out STD_LOGIC;
			ALU_OP		: out STD_LOGIC_VECTOR(3 downto 0);
			AC_EN			: out STD_LOGIC;
			MEM_RWE		: out STD_LOGIC;
			DATA_MUX_SEL: out STD_LOGIC_VECTOR(1 downto 0);
			INS_MUX_SEL : out STD_LOGIC_VECTOR(2 downto 0);
			OUT_SEL		: out STD_LOGIC_VECTOR(1 downto 0);
			OUT_EN		: out STD_LOGIC;
			CLR			: out STD_LOGIC;
			PCL_EN		: out STD_LOGIC;
			PCIN_EN		: out STD_LOGIC;
			STS_EN		: out STD_LOGIC;
			STS_CLR		: out STD_LOGIC);
end cntrl;

architecture Behavioral of cntrl is
type state_type is (start, fetch, decode, op_sel, oop_access, top_access, oop_imm_exec, top_exec, 
alu_store, reg_store, mem_store, mem_write, stop);
signal state : state_type;

--signal INT_ACK			: STD_LOGIC := '0';
signal PC_O       	: STD_LOGIC_VECTOR(1 downto 0) := (others => '0');
signal PC_E				: STD_LOGIC := '0';
signal IR 		 		: STD_LOGIC := '0';
signal DCD	 			: STD_LOGIC := '0';
signal GPR_WRITE 		: STD_LOGIC := '0';
signal GPR_SEL   		: STD_LOGIC := '0';
signal GPR_MUX			: STD_LOGIC_VECTOR(2 downto 0) := (others => '0');
signal RA 		 		: STD_LOGIC := '0';
signal RB 		 		: STD_LOGIC := '0';
signal ALU_A			: STD_LOGIC_VECTOR(2 downto 0) := "000";
signal ALU_B			: STD_LOGIC_VECTOR(2 downto 0) := "000";
signal ALU_A_E			: STD_LOGIC := '0';
signal ALU_B_E			: STD_LOGIC := '0';
signal AOP		 		: STD_LOGIC_VECTOR(3 downto 0) := "1001";	-- Load by default	 
signal AC	     		: STD_LOGIC := '0';
signal RAM		 		: STD_LOGIC := '0';
signal RAM_DATA_SEL	: STD_LOGIC_VECTOR(1 downto 0) := (others => '0');
signal RAM_INS_SEL	: STD_LOGIC_VECTOR(2 downto 0) := (others => '0');
signal OUT_MUX			: STD_LOGIC_VECTOR(1 downto 0) := (others => '0');
signal OUT_E			: STD_LOGIC := '0';
signal SFT_RST			: STD_LOGIC := '0';
signal PCL_E         : STD_LOGIC := '0'; 
signal PCIN_E        : STD_LOGIC := '0'; 
signal STS_E			: STD_LOGIC := '0';			
signal STS_C			: STD_LOGIC := '0';

begin
    FSM: process (CLK, RST)
	begin		
        if (RST = '1') then
			state <= start;
		elsif (CLK'event and CLK='1') then
			case state is
			-- RESET all output signals for new instruction
				when start =>
					SFT_RST <= '0';
					--INT_ACK <= '0';
					PC_O <= "00";
					PC_E <= '0';
					IR <= '0';
					DCD <= '0';
					GPR_WRITE <= '0';
					GPR_SEL <= '0';
					GPR_MUX <= "000";
					RA <= '0';
					RB <= '0';
					ALU_A <= "000";
					ALU_B <= "000";
					ALU_A_E <= '1';
					ALU_B_E <= '1';
					AC <= '0';
					RAM <= '0';
					RAM_DATA_SEL <= "00";
					RAM_INS_SEL <= "000";
					OUT_MUX <= "00";
					OUT_E <= '0';
					PCL_E <= '0';
					PCIN_E <= '0';
					STS_E <= '0';
					STS_C <= '0';
					state <= fetch;
					
				-- Enable read to fetch instruction from RAM and IR to latch new instruction	
				when fetch =>		
					RAM <= '0'; 
					IR <= '1';
					state <= decode;
					
				when decode =>			-- Enable Decoder to split up instruction
					PC_E <= '0';
					DCD <= '1';		
					state <= op_sel;
				
				-- Handler that determines 
				when op_sel => 
					case OP is
						when "00000" => state <= op_sel;		 -- HALT
						when "00001" => state <= stop;		 -- WAIT
						when "00010" => SFT_RST <= '1';		 -- RST
											 state <= stop;
						when "00100" => state <= oop_access; -- CLR
						when "00101" => state <= oop_access; -- INC
						when "00110" => state <= oop_access; -- DEC
						when "00111" => state <= oop_access; -- NEG
						when "01000" => state <= oop_access; -- SLL
						when "01001" => state <= oop_access; -- SRL
						when "01010" => state <= reg_store;  -- MVS
						when "01011" => state <= mem_store;  -- MVMI
						when "01100" => state <= mem_store;  -- MSM
						when "01101" => state <= mem_store;  -- MMS
						when "10111" => state <= oop_access; -- ADDI
						when "11000" => state <= oop_access; -- SUBI
						when "10000" => state <= top_access; -- ADD
						when "10001" => state <= top_access; -- SUB
--						when "10010" => state <= top_access; -- MUL--IMPLEMENT
--						when "10011" => state <= top_access; -- DIV--IMPLEMENT
						when "10100" => state <= top_access; -- AND
						when "10101" => state <= top_access; -- OR
						when "10110" => state <= top_access; -- XOR
						when "11001" => state <= stop;		 -- JMP
						when "11010" => state <= stop;		 -- JSR
						when "11011" => state <= stop;		 -- RSR
						when "11100" => state <= stop;		 -- BRNCH
						when "11111" => STS_C <= '1';			 -- CLRS
											 state <= stop;
						when others  => state <= oop_access; -- FIX 
					end case;
					
				when oop_access =>
					RA <= '1';
					RB <= '0';
						case OP is
							when "10111" => ALU_B <= "011"; -- ADDI
							when "11000" => ALU_B <= "011"; -- SUBI
							when "00101" => ALU_B <= "001"; -- INC
							when "00110" => ALU_B <= "010"; -- DEC
							when "01000" => ALU_B <= "011"; -- SLL
							when "01001" => ALU_B <= "011"; -- SRL
							when others  => ALU_B <= "011"; -- FIX		
						end case;
					
						if (AM_A(0) = '1') then 
							ALU_A <= "100";
							RAM_INS_SEL <= "001";  -- GPR_OUT is location for ram to read in data
							RAM <= '0';
							DCD <= '0';
						end if;
						if (AM_A(1) = '1') then
							ALU_B <= "101";
						end if;
					state <= oop_imm_exec;
					
				--ONE OP IMM				
				when oop_imm_exec =>	
					--DCD <= '0';
					case OP is
						when "00100" => AOP <= "1111";			-- CLR
						when "00111" => AOP <= "1100";			-- NEG
						when "01000" => AOP <= OP(3 downto 0); -- SLL
						when "01001" => AOP <= OP(3 downto 0); -- SRL
						when "10111" => AOP <= "0000";			-- ADDI	
						when "11000" => AOP <= "0001";			-- SUBI
						when others  => AOP <= "0000";			--    FIX
					end case;
					AC <= '1';
					state <= alu_store;
				
							
				-- TWO OP CASE	
				when top_access =>		
					RA <= '1';
					RB <= '1';
					ALU_A <= "000";
					if (AM_A(0) = '1') then 
							ALU_A <= "100";
							RAM_INS_SEL <= "001";  -- GPR_OUT_A is location for ram to read in data
							RAM <= '0';
							DCD <= '0';
						end if;
						if (AM_A(1) = '1') then
							ALU_A(0) <= '1';
						end if;
					state <= top_exec;
	
				when top_exec =>			
					ALU_B <= "000";
					AOP <= OP(3 downto 0);
					if(OP = "10100") then
						AOP <= "0010";
					end if;
					AC <= '1';
					if (AM_B(0) = '1') then 
							ALU_B <= "100";
							RAM_INS_SEL <= "101";  -- GPR_OUT_B is location for ram to read in data
							RAM <= '0';
							DCD <= '0';
							ALU_A_E <= '0';
						end if;
						if (AM_B(1) = '1') then
							ALU_B(0) <= '1';
						end if;
					state <= alu_store; 
				
				-- AC Writeback
				when alu_store =>
					GPR_MUX <= "000";
					GPR_WRITE <= '1';
					if(AM_A(0) = '1' AND AM_B(0) = '1') then
						GPR_WRITE <= '0';
					end if;
					GPR_SEL <= '0';
					STS_E <= '1';
					state <= stop; 
				
				-- REG writeback
				when reg_store =>
					GPR_MUX <= "001";
					GPR_WRITE <= '1';
					if(OP = "01010") then -- MVS
						GPR_SEL <= '1';
					else 
						GPR_SEL <= '0';
					end if;
					state <= stop;
				
				-- MEM writeback 
				when mem_store =>
				RAM_INS_SEL <= "010";
				GPR_SEL <= '0';
				DCD <= '0';
					case OP is
						when "01011" => --MVMI
							RAM_INS_SEL <= "011";
							RAM_DATA_SEL <= "11";
							OUT_MUX <= "01";
							state <= mem_write;
						when "01100" => --MSM 
							GPR_MUX <= "010";
							GPR_WRITE <= '0';
							RAM <= '1';
							OUT_MUX <= "10";
							state <= stop;
							
						--when "01110" =>
							
						when others => --MMS
							RAM <= '0';
							RAM_DATA_SEL <= "01";
							GPR_MUX <= "011";
							GPR_WRITE <= '1';
							OUT_MUX <= "01";
							state <= stop;
						end case;
				
				-- MVMI writeback	
				when mem_write =>
					RAM_INS_SEL <= "100";
					RAM <= '1';
					OUT_MUX <= "10";
					OUT_E <= '1';
					state <= stop;
					
				when stop =>
					RAM <= '0';
					GPR_WRITE <= '0';
    			   RAM_INS_SEL <= "000";
					RAM_DATA_SEL <= "00";
					PC_E <= '1';
					case OP is
						when "00000" => PC_O <= "00";	-- WAIT
						when "11001" => PC_O <= "10";	-- JMPI
						when "11010" => PC_O <= "10"; -- JSR
											 PCL_E <= '1';
						when "11011" => PC_O <= "10"; -- RSR
											 PCIN_E <= '1';
						when "11100" => if(MASK_CMP = '1') then
												PC_O <= "11";
											 else
												PC_O <= "01";
											 end if;
						when others  => PC_O <= "01";
					end case;
					AC <= '0';
					if(AM_A(0) = '1' AND AM_B(0) = '1') then
						GPR_WRITE <= '1';
					end if;
					OUT_E <= '1';
					if(OP = "01011") then 
						RAM <= '1';
					end if;
					state <= start;
				end case;
			end if;
	end process;		
	PC_OP 		<= PC_O;
	PC_EN			<= PC_E;
	IR_EN 		<= IR;
	DECODE_EN 	<= DCD;   
	GPR_WE 		<= GPR_WRITE;
	GPR_W_SEL	<= GPR_SEL;
	GPR_MUX_SEL <= GPR_MUX;
	RA_EN			<= RA;
	RB_EN			<= RB;
	ALU_SEL_A	<= ALU_A;
	ALU_SEL_B	<= ALU_B;
	ALU_A_EN		<= ALU_A_E;
	ALU_B_EN		<= ALU_B_E;
	ALU_OP 		<= AOP;
	AC_EN			<= AC;
	MEM_RWE		<= RAM;
	DATA_MUX_SEL<= RAM_DATA_SEL;
	INS_MUX_SEL <= RAM_INS_SEL;
	OUT_SEL		<= OUT_MUX;
	OUT_EN		<= OUT_E;
	CLR			<= SFT_RST;
	PCIN_EN		<= PCIN_E;
	PCL_EN 		<= PCL_E;
	STS_EN		<= STS_E;
	STS_CLR		<= STS_C;
end Behavioral;