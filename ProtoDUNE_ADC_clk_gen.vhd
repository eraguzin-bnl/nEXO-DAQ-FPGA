--*********************************************************
--* FILE  : ProtoDUNE_ADC_clk_gen.VHD
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

ENTITY ProtoDUNE_ADC_clk_gen IS

	PORT
	(
		sys_rst     	: IN STD_LOGIC;				-- clock
		clk_200MHz	 	: IN STD_LOGIC;				-- clock		
		sys_clk	 		: IN STD_LOGIC;				-- clock		
		CLK_DIS			: IN STD_LOGIC;		
		ADC_CONV			: IN STD_LOGIC;
		
		pll_STEP0		: IN STD_LOGIC_VECTOR(31 downto 0);  -- OFFSET
		pll_STEP1		: IN STD_LOGIC_VECTOR(31 downto 0);  -- OFFSET
		pll_STEP2		: IN STD_LOGIC_VECTOR(31 downto 0);  -- OFFSET
		
		INV_RST	 		: IN STD_LOGIC;							-- invert
		OFST_RST			: IN STD_LOGIC_VECTOR(15 downto 0);  -- OFFSET
		WDTH_RST			: IN STD_LOGIC_VECTOR(15 downto 0);  -- WIDTH

		INV_READ 		: IN STD_LOGIC;							-- invert		
		OFST_READ	 	: IN STD_LOGIC_VECTOR(15 downto 0);  -- OFFSET
		WDTH_READ	 	: IN STD_LOGIC_VECTOR(15 downto 0);  -- WIDTH

		INV_IDXM		 	: IN STD_LOGIC;							-- invert		
		OFST_IDXM		: IN STD_LOGIC_VECTOR(15 downto 0);  -- OFFSET
		WDTH_IDXM	 	: IN STD_LOGIC_VECTOR(15 downto 0);  -- WIDTH

		INV_IDXL		 	: IN STD_LOGIC;							-- invert		
		OFST_IDXL	 	: IN STD_LOGIC_VECTOR(15 downto 0);  -- OFFSET
		WDTH_IDXL	 	: IN STD_LOGIC_VECTOR(15 downto 0);  -- WIDTH
		
	
		INV_IDL		 	: IN STD_LOGIC;							-- invert		
		OFST_IDL_f1	 	: IN STD_LOGIC_VECTOR(15 downto 0);  -- OFFSET
		WDTH_IDL_f1	 	: IN STD_LOGIC_VECTOR(15 downto 0);  -- WIDTH
		OFST_IDL_f2	 	: IN STD_LOGIC_VECTOR(15 downto 0);  -- OFFSET
		WDTH_IDL_f2	 	: IN STD_LOGIC_VECTOR(15 downto 0);  -- WIDTH

		
		ADC_RST			: OUT STD_LOGIC;	
		ADC_IDXM			: OUT STD_LOGIC;	
		ADC_IDL			: OUT STD_LOGIC;	
		ADC_READ			: OUT STD_LOGIC;	
		ADC_IDXL			: OUT STD_LOGIC		
		
	
	);
END ProtoDUNE_ADC_clk_gen;

ARCHITECTURE behavior OF ProtoDUNE_ADC_clk_gen IS

 signal COUNTER	 		: STD_LOGIC_VECTOR(15 downto 0);
 signal ADC_CONV_SYNC_1	: STD_LOGIC; 
 signal ADC_CONV_SYNC_2	: STD_LOGIC; 
 signal RST			: STD_LOGIC;
 signal IDXM		: STD_LOGIC;
 signal IDL			: STD_LOGIC;
 signal IDL0		: STD_LOGIC;
 signal IDL1		: STD_LOGIC;

 signal READo		: STD_LOGIC;
 signal IDXL		: STD_LOGIC;


 
 signal RST_s		: STD_LOGIC;
 signal IDXM_s		: STD_LOGIC;
 signal IDL0_s		: STD_LOGIC;
 signal IDL1_s		: STD_LOGIC;
 signal READ_s		: STD_LOGIC;
 signal IDXL_s		: STD_LOGIC;

 
 
 signal RST_clk    	: STD_LOGIC;				-- clock		
 signal IDXL_clk    	: STD_LOGIC;				-- clock		
 signal IDXM_clk    	: STD_LOGIC;				-- clock		
 signal IDL0_clk    	: STD_LOGIC;				-- clock		
 signal IDL1_clk    	: STD_LOGIC;				-- clock		
 signal READ_clk    	: STD_LOGIC;				-- clock		
 

signal p_cs1         : std_logic_vector (2 downto 0) ; 
signal p_done1       : std_logic ; 
signal p_ud1         : std_logic ; 
signal p_step1       : std_logic ; 
signal phase1_locked : std_logic ; 

 

   begin

	
	
phase_pll_inst : entity work.phase_pll 

PORT MAP (
		areset	 				=> sys_rst ,
		inclk0	 				=> clk_200MHz,
		phasecounterselect	=> p_cs1,
		phasestep	 			=> p_step1,
		phaseupdown	 			=> p_ud1,
		scanclk	 				=> sys_clk, 
		c0	 						=> READ_clk,
		c1	 						=> IDXM_clk,
		c2	 						=> IDXL_clk,
		c3	 					   => IDL0_clk,
		c4	 						=> IDL1_clk,
		locked	 				=> phase1_locked,
		phasedone	 			=> p_done1
	);	
		
				
pll_adj_inst1: entity work.pll_phase_ENT 
  port map (
         clk       	=> sys_clk, 
         rst       	=> sys_rst ,  
         reg_step0 	=> pll_STEP0,  
			reg_step1 	=> pll_STEP1,
			reg_step2 	=> pll_STEP2, 
         p_done    	=> p_done1,
			p_cs	   	=> p_cs1,  
         p_ud       	=> p_ud1,  
         p_step    	=> p_step1  
       ) ;

	
		ADC_RST		<= RST_s;
		ADC_IDXM		<= IDXM_s;
		ADC_IDL		<= IDL1_s or IDL0_s;
		ADC_READ		<= READ_s;
		ADC_IDXL		<= IDXL_s;
		


process(clk_200MHz) 
  begin
     if (clk_200MHz'event AND clk_200MHz = '1') then
			RST_s <=	RST;
	 end if;
end process;

process(READ_clk) 
  begin
     if (READ_clk'event AND READ_clk = '1') then
			READ_s <=	READo;
	 end if;
end process;

process(IDXM_clk) 
  begin
     if (IDXM_clk'event AND IDXM_clk = '1') then
			IDXM_s	<= IDXM;
	 end if;
end process;

process(IDXL_clk) 
  begin
     if (IDXL_clk'event AND IDXL_clk = '1') then
			IDXL_s	<= IDXL;
	 end if;
end process;

process(IDL0_clk) 
  begin
     if (IDL0_clk'event AND IDL0_clk = '1') then
			IDL0_s	<= IDL0;
	 end if;
end process;

process(IDL1_clk) 
  begin
     if (IDL1_clk'event AND IDL1_clk = '1') then
			IDL1_s	<= IDL1;
	 end if;
end process;


		
  process(clk_200MHz,sys_rst) 
  begin
  
	 if (sys_rst = '1') then

		RST	<= '0';
		IDXM	<= '0';
		IDL0	<= '0';
		IDL1	<= '0';		
		READo	<= '0';
		IDXL	<= '0';
		COUNTER			<= x"0000";
     elsif (clk_200MHz'event AND clk_200MHz = '1') then
	  
		RST 			<= '0' xnor (not INV_RST);		
		IDXM 	 	 	<= '0' xnor (not INV_IDXM);	
		IDL0 	  		<= '0' xnor (not INV_IDL);	
		IDL1 	  		<= '0' xnor (not INV_IDL);		
		READo   		<= '0' xnor (not INV_READ);
		IDXL			<= '0' xnor (not INV_IDXL);
	  
	   ADC_CONV_SYNC_1	<= ADC_CONV;
	   ADC_CONV_SYNC_2	<= ADC_CONV_SYNC_1;	  
		if( COUNTER <= 2000) then
			COUNTER		<= COUNTER + 1;
		 end if;	  
		if(ADC_CONV_SYNC_1 = '1' and ADC_CONV_SYNC_2 = '0' AND CLK_DIS = '0') then
			COUNTER <= x"0000";
		end if;			  
		if((COUNTER >= OFST_RST) AND (COUNTER <= (OFST_RST + WDTH_RST))) then
			RST 	  	<= '1' xnor (not INV_RST);	
		end if;
		if((COUNTER >= OFST_READ) AND (COUNTER <= (OFST_READ + WDTH_READ))) then
			READo	  	<= '1' xnor (not INV_READ);	
		end if;  
		if((COUNTER >= OFST_IDXM) AND (COUNTER <= (OFST_IDXM + WDTH_IDXM))) then
			IDXM 	  	<= '1' xnor (not INV_IDXM);
		end if;   
	  	if((COUNTER >= OFST_IDXL) AND (COUNTER <= (OFST_IDXL + WDTH_IDXL))) then
			IDXL 	  	<= '1' xnor (not INV_IDXL);
		end if; 
		if((COUNTER >= OFST_IDL_f1) AND (COUNTER <= (OFST_IDL_f1 + WDTH_IDL_f1))) then
			IDL0 	  	<= '1' xnor (not INV_IDL)	;
		end if; 	
		if((COUNTER >= OFST_IDL_f2) AND (COUNTER <= (OFST_IDL_f2 + WDTH_IDL_f2))) then
			IDL1 	  	<= '1' xnor (not INV_IDL)	;
		end if; 	
			  
	 end if;
end process;


		 	

END behavior;

