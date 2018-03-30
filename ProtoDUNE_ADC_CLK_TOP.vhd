--*********************************************************
--* FILE  : ProtoDUNE_ADC_CLK_TOP.VHD
--* Author: Jack Fried
--*
--* Last Modified: 03/07/2017
--*  
--* Description: ProtoDUNE_ADC_clk_gen
--*		 		               
--*
--*
--*********************************************************

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;


--  Entity Declaration

ENTITY ProtoDUNE_ADC_CLK_TOP IS

	PORT
	(
		sys_rst     	: IN STD_LOGIC;				-- clock
		
		clk_200MHz	 	: IN STD_LOGIC;				-- clock		
		sys_clk	 		: IN STD_LOGIC;				-- clock		
		
		pll_STEP0_L		: IN STD_LOGIC_VECTOR(31 downto 0);  -- OFFSET
		pll_STEP1_L		: IN STD_LOGIC_VECTOR(31 downto 0);  -- OFFSET
		pll_STEP2_L		: IN STD_LOGIC_VECTOR(31 downto 0);  -- OFFSET

		
		ADC_FIX		 	: IN STD_LOGIC_VECTOR(3 downto 0);  ---clock select;
		ADC_FIX_CLOCK	: OUT STD_LOGIC; 	
		
		ADC_CONV			: IN STD_LOGIC; 	
		CLK_DIS			: IN STD_LOGIC;		
	
		INV_RST	 		: IN STD_LOGIC;	 -- invert
		OFST_RST			: IN STD_LOGIC_VECTOR(15 downto 0);  -- OFFSET
		WDTH_RST			: IN STD_LOGIC_VECTOR(15 downto 0);  -- WIDTH

		INV_READ 		: IN STD_LOGIC;	 -- invert	
		OFST_READ	 	: IN STD_LOGIC_VECTOR(15 downto 0);  -- OFFSET
		WDTH_READ	 	: IN STD_LOGIC_VECTOR(15 downto 0);  -- WIDTH

		INV_IDXM		 	: IN STD_LOGIC;	 -- invert	
		OFST_IDXM		: IN STD_LOGIC_VECTOR(15 downto 0);  -- OFFSET
		WDTH_IDXM	 	: IN STD_LOGIC_VECTOR(15 downto 0);  -- WIDTH

		INV_IDXL		 	: IN STD_LOGIC;	 -- invert	
		OFST_IDXL	 	: IN STD_LOGIC_VECTOR(15 downto 0);  -- OFFSET
		WDTH_IDXL	 	: IN STD_LOGIC_VECTOR(15 downto 0);  -- WIDTH
		
	
		INV_IDL		 	: IN STD_LOGIC;	 -- invert	
		OFST_IDL_f1	 	: IN STD_LOGIC_VECTOR(15 downto 0);  -- OFFSET
		WDTH_IDL_f1	 	: IN STD_LOGIC_VECTOR(15 downto 0);  -- WIDTH
		OFST_IDL_f2	 	: IN STD_LOGIC_VECTOR(15 downto 0);  -- OFFSET
		WDTH_IDL_f2	 	: IN STD_LOGIC_VECTOR(15 downto 0);  -- WIDTH


		ADC_RST_L		: OUT STD_LOGIC;	
		ADC_IDXM_L		: OUT STD_LOGIC;	
		ADC_IDL_L		: OUT STD_LOGIC;	
		ADC_READ_L		: OUT STD_LOGIC;	
		ADC_IDXL_L		: OUT STD_LOGIC
	
	);
END ProtoDUNE_ADC_CLK_TOP;

ARCHITECTURE behavior OF ProtoDUNE_ADC_CLK_TOP IS

signal ADC_RST_R_i		: STD_LOGIC;	
signal ADC_IDXM_R_i		: STD_LOGIC;	
signal ADC_IDL_R_i		: STD_LOGIC;	
signal ADC_READ_R_i		: STD_LOGIC;	
signal ADC_IDXL_R_i		: STD_LOGIC;


begin


ADC_FIX_CLOCK	<=	sys_clk 				when  (ADC_FIX = x"0") else
						ADC_RST_R_i			when  (ADC_FIX = x"1") else
						ADC_IDXM_R_i		when  (ADC_FIX = x"2") else
						ADC_IDL_R_i			when  (ADC_FIX = x"3") else
						ADC_READ_R_i		when  (ADC_FIX = x"4") else
						ADC_IDXL_R_i		when  (ADC_FIX = x"5") else
						not ADC_RST_R_i	when  (ADC_FIX = x"6") else
						not ADC_IDXM_R_i	when  (ADC_FIX = x"7") else
						not ADC_IDL_R_i	when  (ADC_FIX = x"8") else
						not ADC_READ_R_i	when  (ADC_FIX = x"9") else
						not ADC_IDXL_R_i	when  (ADC_FIX = x"a") else
						sys_clk;

						
						
	ProtoDUNE_ADC_clk_gen_INST1 : ENTITY WORK.ProtoDUNE_ADC_clk_gen

	PORT MAP
	(
		sys_rst     	=> sys_rst,
		clk_200MHz	 	=> clk_200MHz,
		sys_clk 			=> sys_clk, 
		
		pll_STEP0		=> pll_STEP0_L,
		pll_STEP1		=> pll_STEP1_L, 
		pll_STEP2		=> pll_STEP2_L,
		CLK_DIS			=> CLK_DIS,
		ADC_CONV			=> ADC_CONV,
		INV_RST	 		=> INV_RST,
		OFST_RST			=> OFST_RST,
		WDTH_RST			=> WDTH_RST,

		INV_READ 		=> INV_READ,
		OFST_READ	 	=> OFST_READ,
		WDTH_READ	 	=> WDTH_READ,

		INV_IDXM		 	=> INV_IDXM,
		OFST_IDXM		=> OFST_IDXM,
		WDTH_IDXM	 	=> WDTH_IDXM,

		INV_IDXL		 	=> INV_IDXL,
		OFST_IDXL	 	=> OFST_IDXL,
		WDTH_IDXL	 	=> WDTH_IDXL,
	
		INV_IDL		 	=> INV_IDL,
		OFST_IDL_f1	 	=> OFST_IDL_f1,
		WDTH_IDL_f1	 	=> WDTH_IDL_f1,
		OFST_IDL_f2	 	=> OFST_IDL_f2,
		WDTH_IDL_f2	 	=> WDTH_IDL_f2,

		
		ADC_RST			=> ADC_RST_R_i,
		ADC_IDXM			=> ADC_IDXM_R_i,
		ADC_IDL			=> ADC_IDL_R_i,
		ADC_READ			=> ADC_READ_R_i,
		ADC_IDXL			=> ADC_IDXL_R_i	
	
	);
	
	
		ADC_RST_L   	<= ADC_RST_R_i;
		ADC_IDXM_L  	<= ADC_IDXM_R_i;
		ADC_IDL_L		<= ADC_IDL_R_i;
		ADC_READ_L		<= ADC_READ_R_i;
		ADC_IDXL_L		<= ADC_IDXL_R_i;
	
 

END behavior;
