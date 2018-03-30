#************************************************************
# THIS IS A WIZARD-GENERATED FILE.                           
#
# Version 13.1.4 Build 182 03/12/2014 SJ Full Version
#
#************************************************************

# Copyright (C) 1991-2014 Altera Corporation
# Your use of Altera Corporation's design tools, logic functions 
# and other software and tools, and its AMPP partner logic 
# functions, and any output files from any of the foregoing 
# (including device programming or simulation files), and any 
# associated documentation or information are expressly subject 
# to the terms and conditions of the Altera Program License 
# Subscription Agreement, Altera MegaCore Function License 
# Agreement, or other applicable license agreement, including, 
# without limitation, that your use is for the sole purpose of 
# programming logic devices manufactured by Altera and sold by 
# Altera or its authorized distributors.  Please refer to the 
# applicable agreement for further details.





# Clock constraints



create_clock -name "SBND_SYS_CLK" -period 10.000ns [get_ports {SBND_CLK}]
create_clock -name "SYS_CLK_IN" -period 10.000ns [get_ports {CLK_100MHz_OSC}]
create_clock -name "gxb_clk" 	  -period 10.000ns [get_ports {CLK_125MHz_OSC}]
create_clock -name "UDP_clk" 	  -period 8.000ns  [get_ports {CLK_125M_spare}]

#
#
#
#create_generated_clock -name CLK_200MHz -source {alt_pll_inst|altpll_component|auto_generated|pll1|inclk[0]} -divide_by 1 -multiply_by 2 {alt_pll_inst|altpll_component|auto_generated|pll1|clk[0]}
#create_generated_clock -name CLK_125MHz -source {alt_pll_inst|altpll_component|auto_generated|pll1|inclk[0]} -divide_by 4 -multiply_by 5 {alt_pll_inst|altpll_component|auto_generated|pll1|clk[1]}
#create_generated_clock -name CLK_100MHz -source {alt_pll_inst|altpll_component|auto_generated|pll1|inclk[0]} -divide_by 1 -multiply_by 1 {alt_pll_inst|altpll_component|auto_generated|pll1|clk[2]}
#create_generated_clock -name CLK_50MHz  -source {alt_pll_inst|altpll_component|auto_generated|pll1|inclk[0]} -divide_by 2 -multiply_by 1 {alt_pll_inst|altpll_component|auto_generated|pll1|clk[3]}
##create_generated_clock -name CLK_40MHz  -source {alt_pll_inst|altpll_component|auto_generated|pll1|inclk[0]} -divide_by 5 -multiply_by 2 {alt_pll_inst|altpll_component|auto_generated|pll1|clk[4]}
#
set_max_delay -from [get_pins {SBND_RDOUT_V1_inst|ADC_PLL_inst0|altpll_component|auto_generated|pll1|clk[0]}] -through [get_pins {SBND_RDOUT_V1_inst|CLK_SEL_inst0|LPM_MUX_component|auto_generated|result_node[0]~0|combout}] -to [get_pins {ADC_CLK[0]~output|o}] 0.1
set_max_delay -from [get_pins {SBND_RDOUT_V1_inst|ADC_PLL_inst0|altpll_component|auto_generated|pll1|clk[0]}] -through [get_pins {SBND_RDOUT_V1_inst|CLK_SEL_inst1|LPM_MUX_component|auto_generated|result_node[0]~0|combout}] -to [get_pins {ADC_CLK[1]~output|o}] 0.1
set_max_delay -from [get_pins {SBND_RDOUT_V1_inst|ADC_PLL_inst0|altpll_component|auto_generated|pll1|clk[0]}] -through [get_pins {SBND_RDOUT_V1_inst|CLK_SEL_inst2|LPM_MUX_component|auto_generated|result_node[0]~0|combout}] -to [get_pins {ADC_CLK[2]~output|o}] 0.1
set_max_delay -from [get_pins {SBND_RDOUT_V1_inst|ADC_PLL_inst0|altpll_component|auto_generated|pll1|clk[0]}] -through [get_pins {SBND_RDOUT_V1_inst|CLK_SEL_inst3|LPM_MUX_component|auto_generated|result_node[0]~0|combout}] -to [get_pins {ADC_CLK[3]~output|o}] 0.1
#
## BS constraints
#create_clock  -period 10.000 {LBNE_ASIC_RDOUT_V2:LBNE_ASIC_RDOUT_inst|LBNE_ASIC_DATA_V3:LBNE_ASIC_DATA_V3_inst1|SHIFT_latch}
#create_clock  -period 10.000 {LBNE_ASIC_RDOUT_V2:LBNE_ASIC_RDOUT_inst|LBNE_ASIC_DATA_V3:LBNE_ASIC_DATA_V3_inst2|SHIFT_latch}
#create_clock  -period 10.000 {LBNE_ASIC_RDOUT_V2:LBNE_ASIC_RDOUT_inst|LBNE_ASIC_DATA_V3:LBNE_ASIC_DATA_V3_inst3|SHIFT_latch}
#create_clock  -period 10.000 {LBNE_ASIC_RDOUT_V2:LBNE_ASIC_RDOUT_inst|LBNE_ASIC_DATA_V3:LBNE_ASIC_DATA_V3_inst4|SHIFT_latch}
#create_clock -name {LBNE_Registers:LBNE_Registers_inst|reg7_o[12]} -period 10.000 {LBNE_Registers:LBNE_Registers_inst|reg7_o[12]}
#
#




# Data constraints

set_input_delay  -clock CLK_200MHz  0.5  {ADC_FD*}
set_input_delay  -clock CLK_200MHz  5    {ADC_FE*}
set_input_delay -clock  CLK_50MHz   10   {I2C_*}

# tsu/th constraints

# tco constraints


# Automatically constrain PLL and other generated clocks
derive_pll_clocks -create_base_clocks

# Automatically calculate clock uncertainty to jitter and other effects.
derive_clock_uncertainty


# tpd constraints
report_ucp -summary
