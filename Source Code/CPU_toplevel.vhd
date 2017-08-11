----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:48:42 03/27/2017 
-- Design Name: 
-- Module Name:    cpu - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity cpu_toplevel is
    Port ( CPU_CLK : in  STD_LOGIC;
			  SEG_CLK : IN STD_LOGIC;
           CPU_RST : in  STD_LOGIC;
			  --INT		 : in STD_LOGIC;
           CPU_OUT : out STD_LOGIC_VECTOR (23 downto 0);
			  CPU_CCR : out STD_LOGIC_VECTOR (3 downto 0);
			  SEG : out STD_LOGIC_VECTOR (6 downto 0);
			  DP  : out STD_LOGIC;
           AN  : out STD_LOGIC_VECTOR (3 downto 0));
end cpu_toplevel;

architecture Structural of cpu_toplevel is
-- CPU signals
signal RESULT 			: STD_LOGIC_VECTOR(23 downto 0) := (others => '0');
signal STS				: STD_LOGIC_VECTOR(3 downto 0);
signal RST				: STD_LOGIC;
signal SFT_RST			: STD_LOGIC;
signal CLK				: STD_LOGIC;
-- IR signals
signal IR_E 		  	: STD_LOGIC;
signal IR_OUT		  	: STD_LOGIC_VECTOR(23 downto 0);
-- Decoder signals
signal DCD_E		  	: STD_LOGIC;
signal DCD_ADDR_A   	: STD_LOGIC_VECTOR(2 downto 0);
signal DCD_ADDR_B   	: STD_LOGIC_VECTOR(2 downto 0);
signal DCD_OP		  	: STD_LOGIC_VECTOR(4 downto 0);
signal DCD_AM_A	  	: STD_LOGIC_VECTOR(1 downto 0);
signal DCD_AM_B	  	: STD_LOGIC_VECTOR(1 downto 0);
signal DCD_IMM_OOP  	: STD_LOGIC_VECTOR(23 downto 0);
signal DCD_IMM_TOP  	: STD_LOGIC_VECTOR(23 downto 0);
signal DCD_IMM       : STD_LOGIC_VECTOR(23 downto 0);
signal DCD_IMM_MEM   : STD_LOGIC_VECTOR(23 downto 0);
signal DCD_IMM_BRN   : STD_LOGIC_VECTOR(23 downto 0);
signal DCD_MSK			: STD_LOGIC_VECTOR(3 downto 0);
-- GPR signals
signal GPR_E		  	: STD_LOGIC;
signal GPR_W_SEL	  	: STD_LOGIC;
signal GPR_IN		  	: STD_LOGIC_VECTOR(23 downto 0);
signal GPR_OUT_A    	: STD_LOGIC_VECTOR(23 downto 0);
signal GPR_OUT_B    	: STD_LOGIC_VECTOR(23 downto 0);
signal GPR_MUX_SEL	: STD_LOGIC_VECTOR(2 downto 0);
signal GPR_A_SEL		: STD_LOGIC;
signal BLMR_ADDR_A	: STD_LOGIC_VECTOR(2 downto 0);
-- ALU MUX signals
signal ALU_SEL_A	  	: STD_LOGIC_VECTOR(2 downto 0);
signal ALU_REG_IN_A 	: STD_LOGIC_VECTOR(23 downto 0) := (others => '0');
signal ALU_MUX_OUT_A	: STD_LOGIC_VECTOR(23 downto 0) := (others => '0');
signal ALU_SEL_B	  	: STD_LOGIC_VECTOR(2 downto 0);
signal ALU_REG_IN_B 	: STD_LOGIC_VECTOR(23 downto 0) := (others => '0');
signal ALU_MUX_OUT_B	: STD_LOGIC_VECTOR(23 downto 0) := (others => '0');
signal ALU_A_E	  		: STD_LOGIC;
signal ALU_B_E	  		: STD_LOGIC;
signal ALU_A_OUT		: STD_LOGIC_VECTOR(23 downto 0) := (others => '0');
signal ALU_B_OUT		: STD_LOGIC_VECTOR(23 downto 0) := (others => '0');
-- ALU signals
signal RA_E			  	: STD_LOGIC;
signal RB_E				: STD_LOGIC;
signal AC_E				: STD_LOGIC;
signal MDR_E			: STD_LOGIC;
signal ALU_RB		  	: STD_LOGIC_VECTOR(23 downto 0);
signal ALU_OP		  	: STD_LOGIC_VECTOR(3 downto 0);
signal ALU_CCR		  	: STD_LOGIC_VECTOR(3 downto 0) := (others => '0');
signal ALU_RSLT		: STD_LOGIC_VECTOR(23 downto 0);
signal ALU_LDST		: STD_LOGIC_VECTOR(23 downto 0);
signal STS_E			: STD_LOGIC;
signal STS_C			: STD_LOGIC;
-- OUT signal
signal OUT_SEL			: STD_LOGIC_VECTOR(1 downto 0);
signal OUT_E			: STD_LOGIC;
signal AC_OUT 			: STD_LOGIC_VECTOR(23 downto 0);
-- PC signals
signal PC_EN			: STD_LOGIC;			
signal PCIN_E			: STD_LOGIC;
signal PCIN_OUT		: STD_LOGIC_VECTOR(23 downto 0);
signal PC_OP			: STD_LOGIC_VECTOR(1 downto 0);
signal PC_next			: STD_LOGIC_VECTOR(23 downto 0) := (others => '0');
signal PCL_E			: STD_LOGIC;
signal PCL_OUT			: STD_LOGIC_VECTOR(23 downto 0) := (others => '0');
signal MASK_E			: STD_LOGIC;
-- RAM signals
signal RAM_R_W			: STD_LOGIC; 
signal RAM_DATA		: STD_LOGIC_VECTOR(23 downto 0) := (others => '0');
signal RAM_INS		   : STD_LOGIC_VECTOR(23 downto 0) := (others => '0');
signal RAM_OUT			: STD_LOGIC_VECTOR(23 downto 0) := (others => '0');
signal RAM_DATA_SEL	: STD_LOGIC_VECTOR(1 downto 0);
signal RAM_INS_SEL	: STD_LOGIC_VECTOR(2 downto 0);

signal dpc : STD_LOGIC_VECTOR (3 downto 0) := "1111";
signal cen : STD_LOGIC := '0';
			
begin
	
	CPU_OUT <= RESULT;
	CPU_CCR <= STS;
	RST <= CPU_RST or SFT_RST;	-- Hardware Reset OR'd with Software Reset
	

	RAM_DATA_MUX: entity work.mux
		port map
		(
			SEL				=> RAM_DATA_SEL,
			DIN_A				=> GPR_OUT_A,
			DIN_B				=> DCD_IMM_OOP,
			DIN_C          => RAM_OUT, -- MVMI MEMA 
			DOUT				=> RAM_DATA
		);
		
	RAM_INS_MUX: entity work.Ins_Mux
		port map
		(
			SEL				=> RAM_INS_SEL,
			DIN_A				=> PC_next,
			DIN_B				=> GPR_OUT_A,
			DIN_C				=>	DCD_IMM_OOP,
			DIN_D				=> DCD_IMM_MEM,	-- MVMI MEMA
			DIN_E				=> DCD_IMM_TOP,	-- MVMI MEMB
			DIN_F				=> GPR_OUT_B,
			DOUT				=> RAM_INS
		);
		
	RAM: entity work.RAM_8x24RW
		port map
		(
			CLOCK			=> CPU_CLK,
			READ_WRITE	=> RAM_R_W,
			DATA_IN		=> RAM_DATA,
			ADDR_IN		=> RAM_INS(7 downto 0),
			DATA_OUT		=> RAM_OUT
		);
	
	IR : entity work.Reg
		 port map 
		 (
			  CLK       => CPU_CLK,
			  RST			=> CPU_RST,
			  EN			=> IR_E,
			  DIN			=> RAM_OUT,	
			  DOUT		=> IR_OUT     
		 );
		 
	DECODE : entity work.decode
		port map 
		(
			CLK			=> CPU_CLK,
			EN				=> DCD_E,
			INS			=> RAM_OUT,
			ADDR_A		=> DCD_ADDR_A,
			ADDR_B		=> DCD_ADDR_B,
			OP				=> DCD_OP,	-- DELETE
			AM_A			=> DCD_AM_A,
			AM_B			=> DCD_AM_B,
			IMM_OOP		=> DCD_IMM_OOP,
			IMM_TOP		=> DCD_IMM_TOP,
			IMM_MEM		=> DCD_IMM_MEM,
			IMM		   => DCD_IMM,
			IMM_BRN		=> DCD_IMM_BRN,
			MSK			=> DCD_MSK
		);
	
	GPR_IN_MUX: entity work.mux_gpr
		port map
		(
				SEL			=> GPR_MUX_SEL, 
				DIN_A			=>	AC_OUT,
				DIN_B			=>	GPR_OUT_A,
				DIN_C			=> DCD_IMM_OOP,
				DIN_D			=> RAM_OUT,
				DOUT			=> GPR_IN
		);
		
--	GPR_SEL_MUX: entity work.sel_mux
--		port map
--		(
--				SEL			=> GPR_A_SEL, 
--				DIN_A			=>	DCD_ADDR_A,
--				DIN_B			=>	BLMR_ADDR_A,
--				DOUT			=> ADDR_A
--		);
		
			
	GPR : entity work.gpr
		port map 
		(
			CLK			=> CPU_CLK,
			RST			=> RST,
			WEN			=> GPR_E,
			REG_W_SEL	=> GPR_W_SEL,
			DIN			=> GPR_IN,
			SEL_A			=> DCD_ADDR_A,
			SEL_B			=> DCD_ADDR_B,
			RA				=> GPR_OUT_A,
			RB				=> GPR_OUT_B
		);
	
	RA: entity work.tri_buff
		port map
		(
			DIN			=> GPR_OUT_A,
			EN				=>	RA_E,
			DOUT			=>	ALU_REG_IN_A
		);
	
	RB: entity work.tri_buff
		port map
		(
			DIN			=> GPR_OUT_B,
			EN				=>	RB_E,
			DOUT			=>	ALU_REG_IN_B
		);
	
	-- Latches data ouptut from RAM to save unitl instruction is over
	DATA_LATCH_A : entity work.Reg
		 port map 
		 (
			  CLK       => CPU_CLK,
			  RST			=> RST,
			  EN			=> ALU_A_E,
			  DIN			=> RAM_OUT,	
			  DOUT		=> ALU_A_OUT    
		 );
	
	DATA_LATCH_B : entity work.Reg
		 port map 
		 (
			  CLK       => CPU_CLK,
			  RST			=> RST,
			  EN			=> ALU_B_E,
			  DIN			=> RAM_OUT,	
			  DOUT		=> ALU_B_OUT     
		 );	
		 
	ALU_IN_MUX_A : entity work.mux_alu
		port map
		(
			SEL			=> ALU_SEL_A,
			DIN_A			=>	ALU_REG_IN_A,
			DIN_B			=>	DCD_IMM_OOP,
			DIN_C			=> ALU_A_OUT,-- Latched RAM_OUT
			DOUT			=> ALU_MUX_OUT_A
		);
	
	ALU_IN_MUX_B : entity work.mux_alu
		port map
		(
			SEL			=> ALU_SEL_B,
			DIN_A			=>	ALU_REG_IN_B,
			DIN_B			=>	DCD_IMM_OOP,
			DIN_C			=> ALU_B_OUT,-- Latched RAM_OUT
			DOUT			=> ALU_MUX_OUT_B
		);
	
	ALU : entity work.alu
		port map
		(
			CLK			=> CPU_CLK,
			RA				=> ALU_MUX_OUT_A,
			RB				=> ALU_MUX_OUT_B,--ALU_RB,
			OPCODE		=> ALU_OP,
			CCR			=> ALU_CCR,
			ALU_OUT		=> ALU_RSLT,
			LDST_OUT		=> ALU_LDST
		);
	
	AC: entity work.reg
		port map 
		 (
			  CLK       => CPU_CLK,
			  RST			=> RST,
			  EN			=> AC_E,
			  DIN			=> ALU_RSLT,
			  DOUT		=> AC_OUT    
		 );

	STATUS: entity work.reg_sts
		port map 
		 (
			  CLK       => CPU_CLK,
			  RST			=> RST,
			  CLR			=> STS_C,
			  EN			=> STS_E,
			  DIN			=> ALU_CCR,
			  DOUT		=> STS    
		 );
	
	PC : entity work.pc
		port map
		(
			CLK			=> CPU_CLK,
			EN				=> PC_EN,
			RST			=> RST,
			PCIN			=> PCIN_OUT,
			OP				=> PC_OP,
			OFST			=> DCD_IMM_BRN,
			PCOUT			=> PC_next
		);
	
	PCIN_MUX: entity work.pc_mux
		port map
		(
			SEL			=> PCIN_E,
			DIN_A			=>	DCD_IMM,
			DIN_B			=>	PCL_OUT,
			DOUT			=> PCIN_OUT
		);

	PC_LATCH : entity work.reg
		port map 
		 (
			  CLK       => CPU_CLK,
			  RST			=> RST,
			  EN			=> PCL_E,
			  DIN			=> PC_next,
			  DOUT		=> PCL_OUT    
		 );
	
	BRANCH_COMPARE: entity work.Branch_Cmp
		port map
		(
			MASK		=> DCD_MSK,
			CCR		=> STS,
			CMP		=> MASK_E
		);
	
	CONTROLLER : entity work.cntrl
		port map
		(
			CLK			=> CPU_CLK,
			RST			=>	CPU_RST,
			--INT_SEL		=> INT,
			OP				=> IR_OUT(23 downto 19),
			AM_A			=> DCD_AM_A,
			AM_B			=> DCD_AM_B,
			MASK_CMP		=> MASK_E,
			PC_OP			=> PC_OP,
			PC_EN			=> PC_EN,
			IR_EN			=>	IR_E,
			DECODE_EN	=> DCD_E,
			GPR_WE		=> GPR_E,
			GPR_W_SEL	=> GPR_W_SEL,
			GPR_MUX_SEL => GPR_MUX_SEL,
			RA_EN			=> RA_E,
			RB_EN			=> RB_E,
			ALU_SEL_A	=>	ALU_SEL_A,
			ALU_SEL_B	=>	ALU_SEL_B,
			ALU_A_EN		=> ALU_A_E,
			ALU_B_EN		=> ALU_B_E,
			ALU_OP		=> ALU_OP,
			AC_EN			=> AC_E,
			MEM_RWE		=> RAM_R_W,
			DATA_MUX_SEL=> RAM_DATA_SEL,
			INS_MUX_SEL => RAM_INS_SEL,
			OUT_SEL 		=> OUT_SEL,
			OUT_EN		=> OUT_E,
			CLR			=> SFT_RST,
			PCIN_EN		=> PCIN_E,
			PCL_EN		=> PCL_E,
			STS_EN		=> STS_E,
			STS_CLR		=> STS_C
		);
		
		DEBUG_MUX: entity work.debug_mux
		port map
		(
			SEL				=> OUT_SEL,
			EN					=> OUT_E,
			RST				=> RST,
			DIN_A				=> AC_OUT,		-- ALU result
			DIN_B				=> GPR_IN,		-- GPR write
			DIN_C          => RAM_DATA, 	-- RAM write
			DOUT				=> RESULT
		);
		
		DEBUG_UNIT: entity work.Ssegdriver
		port map( 
				  CLK     => SEG_CLK,
              RST     => RST,
              SEG_0   => RESULT(15 downto 12),
              SEG_1   => RESULT(11 downto 8),
              SEG_2   => RESULT(7 downto 4),
              SEG_3   => RESULT(3 downto 0),
              DP_CTRL => dpc,
              COL_EN  => cen,
              SEG_OUT => SEG,
              DP_OUT  => DP,
              AN_OUT  => AN);
		
end Structural;

