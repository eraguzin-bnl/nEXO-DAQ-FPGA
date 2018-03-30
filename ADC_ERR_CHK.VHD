--*********************************************************
--* FILE  : ADC_ERR_CHK.VHD
--* Author: Jack Fried
--*
--* Last Modified: 08/11/2017
--*  
--* Description: ADC ERROR CHECK
--*		 		               
--*
--*
--*
--*
--*********************************************************

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;


--  Entity Declaration

ENTITY ADC_ERR_CHK IS

	PORT
	(
		sys_rst     	: IN STD_LOGIC;		-- SYSTEM RESET
		clk    		 	: IN STD_LOGIC;		-- SYSTEM RESET
		ERROR_RESET   	: IN STD_LOGIC;		-- TIME STAMP RESET FROM REGISTERS
		CONV_CLOCK    	: IN STD_LOGIC;		-- SYNC CMD_ SIGNAL
		ADC_BUSY			: IN STD_LOGIC;		-- ADC BUSY  verify ADC convert took place
		SYNC_IN			: IN STD_LOGIC_VECTOR(1 downto 0);
		CONV_ERROR		: OUT STD_LOGIC_VECTOR(15 downto 0);
		HDR1_ERROR		: OUT STD_LOGIC_VECTOR(15 downto 0);
		HDR2_ERROR		: OUT STD_LOGIC_VECTOR(15 downto 0)
		
		

	);
	

	END ADC_ERR_CHK;

ARCHITECTURE ADC_ERR_CHK_ARCH OF ADC_ERR_CHK IS


 SIGNAL CONV_CNT			: STD_LOGIC_VECTOR(7 downto 0);
 SIGNAL ADC_BSY_CNT		: STD_LOGIC_VECTOR(7 downto 0);

 SIGNAL CONV_ERR_CNT  	: STD_LOGIC_VECTOR(15 downto 0);
 SIGNAL HDR1_ERR_CNT 	: STD_LOGIC_VECTOR(15 downto 0);
 SIGNAL HDR2_ERR_CNT 	: STD_LOGIC_VECTOR(15 downto 0);
 
 SIGNAL CONV_CLOCK_S1	: STD_LOGIC;
 SIGNAL CONV_CLOCK_S2	: STD_LOGIC;
 SIGNAL ADC_BSY_S1		: STD_LOGIC;
 SIGNAL ADC_BSY_S2		: STD_LOGIC;
 
 
 
begin


CONV_ERROR		<= CONV_ERR_CNT;
HDR1_ERROR		<= HDR1_ERR_CNT;
HDR2_ERROR		<= HDR2_ERR_CNT;

process(clk) 
begin
	if clk'event and clk = '1' then

			CONV_CLOCK_S1	<= CONV_CLOCK;
			CONV_CLOCK_S2	<= CONV_CLOCK_S1;
			ADC_BSY_S1		<= ADC_BUSY;
			ADC_BSY_S2		<= ADC_BSY_S1;
	end if;
end process;	
	


process(clk,ERROR_RESET) 
begin
	if(ERROR_RESET = '1') then
		CONV_CNT				<= x"00";
		ADC_BSY_CNT			<= x"00";
		CONV_ERR_CNT   	<= x"0000";
		HDR1_ERR_CNT	 	<= x"0000";
		HDR2_ERR_CNT	 	<= x"0000";
		
	elsif clk'event and clk = '1' then
		if(CONV_CLOCK_S1 = '1' and CONV_CLOCK_S2 = '0') then
			CONV_CNT	<= CONV_CNT +1;
		end if;	
		if(ADC_BSY_S1 = '1' and ADC_BSY_S2 = '0') then
			ADC_BSY_CNT	<= ADC_BSY_CNT +1;
		end if;		
		if(CONV_CLOCK_S1 = '0' and CONV_CLOCK_S2 = '1') then
			if(ADC_BSY_CNT /= CONV_CNT) then 
				CONV_ERR_CNT	<= CONV_ERR_CNT + 1;
			end if;		
			if(SYNC_IN(0) = '1') then
					HDR1_ERR_CNT <= HDR1_ERR_CNT +1;
			end if;
			if(SYNC_IN(1) = '1') then
					HDR2_ERR_CNT <= HDR2_ERR_CNT +1;
			end if;					
			
		end if;
	end if;
end process;	
	
	


END ADC_ERR_CHK_ARCH ;

	
	