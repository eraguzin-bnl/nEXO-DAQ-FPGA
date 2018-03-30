--------------------------------------------------------------------------------
-- Software Copyright Licensing Disclaimer


-- Institution: University of Science and Technology of China  
-- Designer:    Shanshan.Gao

-- Create Date:  21-11-2012  
-- Project Name: DAMPE
-- Design Name:  BGO-FEE 
-- Entity Name:  rx_ENT
-- Description:  uart receiver
--               baud rate = 115200
--               Every bit on RXD wire will be sampled at middle position

-- Version: V2.0
-- Update Date: 
-- Revision : 
-- Revision Date:
-- Additional Comments: 
--------------------------------------------------------------------------------

library ieee ;
use ieee.all ;
use ieee.std_logic_1164.all ;
use ieee.std_logic_unsigned.all ;


entity pll_phase_ENT is
  port (
         clk           : in  std_logic ;
         rst           : in  std_logic ;
         reg_step0     : IN STD_LOGIC_VECTOR(31 downto 0);  -- WIDTH
			reg_step1	  : IN STD_LOGIC_VECTOR(31 downto 0);  -- WIDTH
			reg_step2	  : IN STD_LOGIC_VECTOR(31 downto 0);  -- WIDTH
         p_done        : IN std_logic;  
			p_cs	   	  : OUT STD_LOGIC_VECTOR(2 downto 0); 
         p_ud       	  : out std_logic;  
         p_step    	  : out std_logic  
       ) ;
end entity pll_phase_ENT ;

architecture behaviour of pll_phase_ENT is
  type state_values is (
                         ST_IDLE   ,
                         ST_C0_CLR,
                         ST_C0_SET,
                         ST_C1_CLR,
                         ST_C1_SET,
                         ST_C2_CLR,
                         ST_C2_SET,
                         ST_C3_CLR,
                         ST_C3_SET,
                         ST_C4_CLR,
                         ST_C4_SET,
                         ST_PRE_SET,
                         ST_PRE_STEPON,
                         ST_PRE_WAIT,
                         ST_PRE_STEPDONE,
                         ST_SET,
                         ST_STEPON,
                         ST_WAIT,
                         ST_STEPDONE,
                         ST_ERR,
                         ST_STOP     
                       )  ;
  signal state, next_state: state_values                   ;


  constant C0      : std_logic_vector := "010" ;  
  constant C1      : std_logic_vector := "011" ;  
  constant C2      : std_logic_vector := "100" ;  
  constant C3      : std_logic_vector := "101" ;  
  constant C4      : std_logic_vector := "110" ;  


  signal ref_en0          : std_logic ; 
  signal ref_en1          : std_logic ; 
  signal ref_en           : std_logic ; 
  signal p_done_ext          : std_logic ; 
  signal p_done_cnt         : std_logic_vector ( 15 downto 0 ) ;
  signal p_done0          : std_logic ; 
  signal p_done1          : std_logic ; 
  signal p_done2          : std_logic ; 
  signal step_cnt         : std_logic_vector ( 15 downto 0 ) ;
--  signal p_cs         : std_logic_vector(2 downto 0) ; 
--  signal p_ud         : std_logic ; 
  signal pre_pud_c0   : std_logic ; 
  signal pre_pud_c1   : std_logic ; 
  signal pre_pud_c2   : std_logic ; 
  signal pre_pud_c3   : std_logic ; 
  signal pre_pud_c4   : std_logic ; 
  signal pre_step_c0  : std_logic_vector ( 15 downto 0 ) ;
  signal pre_step_c1  : std_logic_vector ( 15 downto 0 ) ;
  signal pre_step_c2  : std_logic_vector ( 15 downto 0 ) ;
  signal pre_step_c3  : std_logic_vector ( 15 downto 0 ) ;
  signal pre_step_c4  : std_logic_vector ( 15 downto 0 ) ;
  signal pud_c0   : std_logic ; 
  signal pud_c1   : std_logic ; 
  signal pud_c2   : std_logic ; 
  signal pud_c3   : std_logic ; 
  signal pud_c4   : std_logic ; 
  signal step_c0  : std_logic_vector ( 15 downto 0 ) ;
  signal step_c1  : std_logic_vector ( 15 downto 0 ) ;
  signal step_c2  : std_logic_vector ( 15 downto 0 ) ;
  signal step_c3  : std_logic_vector ( 15 downto 0 ) ;
  signal step_c4  : std_logic_vector ( 15 downto 0 ) ;
  signal c0_on   : std_logic ; 
  signal c1_on   : std_logic ; 
  signal c2_on   : std_logic ; 
  signal c3_on   : std_logic ; 
  signal c4_on   : std_logic ; 
  signal c0_en       : std_logic ; 
  signal c0_clr      : std_logic ; 
  signal c0_done     : std_logic ; 
  signal c1_en       : std_logic ; 
  signal c1_clr      : std_logic ; 
  signal c1_done     : std_logic ; 
  signal c2_en       : std_logic ; 
  signal c2_clr      : std_logic ; 
  signal c2_done     : std_logic ; 
  signal c3_en       : std_logic ; 
  signal c3_clr      : std_logic ; 
  signal c3_done     : std_logic ; 
  signal c4_en       : std_logic ; 
  signal c4_clr      : std_logic ; 
  signal c4_done     : std_logic ; 
  signal p_step_set  : std_logic ; 
  signal p_step_clr  : std_logic ; 

begin


  EN_PROC: process ( clk, rst )
  begin
    if rst = '1' then
        ref_en0 <= '0';
        ref_en1 <= '0';
        ref_en  <= '0';
        p_done0 <= '1';
        p_done1 <= '1';
        p_done2 <= '1';
    elsif rising_edge ( clk ) then
        ref_en0 <=reg_step2(31); -- set_en;
        ref_en1 <= ref_en0;
        ref_en <= ref_en0 xor ref_en1;
        p_done0 <= p_done_ext ;
        p_done1 <= p_done0;
        p_done2 <= p_done1;
    end if;
  end process; 

  -- FSM
  state_conv_PROC: process ( clk, rst )
  begin
    if rst = '1' then -- reset
      state  <= ST_IDLE;
    elsif rising_edge ( clk ) then
      state  <= next_state ;
    end if ;
  end process ;  

  C0_PROC: process ( clk, rst )
  begin
    if rst = '1' then
      step_cnt       <= X"0000" ;
      p_cs          <= C0;
      p_ud              <= '0';
      pre_pud_c0        <= '0';
      pre_step_c0       <= X"0000";
      pre_pud_c1        <= '0';
      pre_step_c1       <= X"0000";
      pre_pud_c2        <= '0';
      pre_step_c2        <= X"0000";
      pre_pud_c3        <= '0';
      pre_step_c3        <= X"0000";
      pre_pud_c4        <= '0';
      pre_step_c4        <= X"0000";
      c0_on <= '0';
      c1_on <= '0';
      c2_on <= '0';
      c3_on <= '0';
      c4_on <= '0';
    elsif rising_edge ( clk ) then
        if (ref_en = '1' ) then
            step_c0 <= reg_step0 ( 15 downto 0 )  ;
            step_c1 <= reg_step0 ( 31 downto 16 ) ;
            step_c2 <= reg_step1 ( 15 downto 0 );
            step_c3 <= reg_step1 ( 31 downto 16 );
            step_c4 <= reg_step2 ( 15 downto 0 );
            pud_c0  <= reg_step2(16);
            pud_c1  <= reg_step2(17);
            pud_c2  <= reg_step2(18);
            pud_c3  <= reg_step2(19);
            pud_c4  <= reg_step2(20);
        end if;

        if ( c0_clr = '1' ) then
            c0_on <= '1';
            p_cs <= C0;
            --p_cs <= reg_step1(18 downto 16);
            p_ud  <= not pre_pud_c0;
            step_cnt <= pre_step_c0;
        elsif (c0_en = '1' ) then
            p_cs <= C0;
            --p_cs <= reg_step1(18 downto 16);
            p_ud  <= pud_c0;
            step_cnt <= step_c0;
        elsif (c0_done = '1' ) then
            c0_on <= '0';
            p_cs <= C0;
            --p_cs <= reg_step1(18 downto 16);
            pre_pud_c0  <= pud_c0;
            pre_step_c0 <= step_c0;

        elsif (c1_clr = '1' ) then
            c1_on <= '1';
            p_cs <= C1;
            --p_cs <= reg_step1(18 downto 16);
            p_ud  <= not pre_pud_c1;
            step_cnt <= pre_step_c1;
        elsif (c1_en = '1' ) then
            p_cs <= C1;
            --p_cs <= reg_step1(18 downto 16);
            p_ud  <= pud_c1;
            step_cnt <= step_c1;
        elsif (c1_done = '1' ) then
            c1_on <= '0';
            p_cs <= C1;
            --p_cs <= reg_step1(18 downto 16);
            pre_pud_c1  <= pud_c1;
            pre_step_c1 <= step_c1;

        elsif (c2_clr = '1' ) then
            c2_on <= '1';
            p_cs <= C2;
            --p_cs <= reg_step1(18 downto 16);
            p_ud  <= not pre_pud_c2;
            step_cnt <= pre_step_c2;
        elsif (c2_en = '1' ) then
            p_cs <= C2;
            --p_cs <= reg_step1(18 downto 16);
            p_ud  <= pud_c2;
            step_cnt <= step_c2;
        elsif (c2_done = '1' ) then
            c2_on <= '0';
            p_cs <= C2;
            --p_cs <= reg_step1(18 downto 16);
            pre_pud_c2  <= pud_c2;
            pre_step_c2 <= step_c2;

        elsif (c3_clr = '1' ) then
            c3_on <= '1';
            p_cs <= C3;
            --p_cs <= reg_step1(18 downto 16);
            p_ud  <= not pre_pud_c3;
            step_cnt <= pre_step_c3;
        elsif (c3_en = '1' ) then
            p_cs <= C3;
            --p_cs <= reg_step1(18 downto 16);
            p_ud  <= pud_c3;
            step_cnt <= step_c3;
        elsif (c3_done = '1' ) then
            c3_on <= '0';
            p_cs <= C3;
            --p_cs <= reg_step1(18 downto 16);
            pre_pud_c3  <= pud_c3;
            pre_step_c3 <= step_c3;

        elsif (c4_clr = '1' ) then
            c4_on <= '1';
            p_cs <= C4;
            --p_cs <= reg_step1(18 downto 16);
            p_ud  <= not pre_pud_c4;
            step_cnt <= pre_step_c4;
        elsif (c4_en = '1' ) then
            p_cs <= C4;
            --p_cs <= reg_step1(18 downto 16);
            p_ud  <= pud_c4;
            step_cnt <= step_c4;
        elsif (c4_done = '1' ) then
            c4_on <= '0';
            p_cs <= C4;
            --p_cs <= reg_step1(18 downto 16);
            pre_pud_c4  <= pud_c4;
            pre_step_c4 <= step_c4;
        elsif (p_step_set = '1') and (step_cnt > X"0000" ) then
            step_cnt <= step_cnt - X"0001"; 
        end if;
    end if;
  end process;

  P_STEP_SET_PROC: process ( clk, rst )
  begin
    if rst = '1' then
        p_step <= '0';
    elsif rising_edge ( clk ) then
        if (p_step_set = '1' ) then
            p_step <= '1';
        elsif ( p_step_clr = '1' ) then
            p_step <= '0';
        end if;
    end if;
  end process;

  P_CNT_PROC: process ( clk, p_done, rst )
  begin
    if p_done = '0' or rst = '1' then
        p_done_ext <= '1';
        p_done_cnt <= X"0010";
    elsif rising_edge ( clk ) then
        if ( p_done_cnt > X"0000" ) then
          p_done_cnt <= p_done_cnt - X"0001";
          p_done_ext <= '0';
        else
          p_done_cnt <= X"0000";
          p_done_ext <= '1';
        end if;
    end if;
  end process;

  next_state_PROC: process ( state, c0_en, c0_clr, c0_done, c1_en, c1_clr, c1_done, ref_en,
                             c0_on, c1_on, c2_on, c3_on, c4_on, p_done1, p_done2, step_cnt, 
                             step_c0, step_c1, step_c2, step_c3, step_c4,
                             pre_step_c0, pre_step_c1, pre_step_c2, pre_step_c3, pre_step_c4, 
                             c2_en, c2_clr, c2_done, c3_en, c3_clr, c3_done, c4_en, c4_clr, c4_done, p_step_set, p_step_clr )
  begin
  --set defaults
    next_state       <= ST_IDLE ;
    c0_en       <= '0';
    c0_clr       <= '0';
    c0_done      <= '0';
    c1_en        <= '0';
    c1_clr       <= '0';
    c1_done      <= '0';
    c2_en        <= '0';
    c2_clr       <= '0';
    c2_done      <= '0';
    c3_en        <= '0';
    c3_clr       <= '0';
    c3_done      <= '0';
    c4_en        <= '0';
    c4_clr       <= '0';
    c4_done      <= '0';
    p_step_set  <= '0';
    p_step_clr  <= '0';

    case state is 
      when ST_IDLE =>
        if ( ref_en = '1' ) then
          next_state  <= ST_C0_CLR ;
        else
          next_state  <= ST_IDLE    ;
        end if ;
      --C0
      when ST_C0_CLR =>
          c0_clr <= '1';
          if ( pre_step_c0 > X"0000" ) then
              next_state <= ST_PRE_SET;
          else
              next_state <= ST_C0_SET;
          end if;
      when ST_C0_SET =>
          if ( step_c0 > X"0000" ) then
              next_state <= ST_SET;
              c0_en <= '1';
          else
              next_state <= ST_C1_CLR;
              c0_done <= '1';
          end if;

      --C1
      when ST_C1_CLR =>
          c1_clr <= '1';
          if ( pre_step_c1 > X"0000" ) then
              next_state <= ST_PRE_SET;
          else
              next_state <= ST_C1_SET;
          end if;
      when ST_C1_SET =>
          if ( step_c1 > X"0000" ) then
              next_state <= ST_SET;
              c1_en <= '1';
          else
              next_state <= ST_C2_CLR;
              c1_done <= '1';
          end if;

      --C2
      when ST_C2_CLR =>
          c2_clr <= '1';
          if ( pre_step_c2 > X"0000" ) then
              next_state <= ST_PRE_SET;
          else
              next_state <= ST_C2_SET;
          end if;
      when ST_C2_SET =>
          if ( step_c2 > X"0000" ) then
              next_state <= ST_SET;
              c2_en <= '1';
          else
              next_state <= ST_C3_CLR;
              c2_done <= '1';
          end if;

      --C3
      when ST_C3_CLR =>
          c3_clr <= '1';
          if ( pre_step_c3 > X"0000" ) then
              next_state <= ST_PRE_SET;
          else
              next_state <= ST_C3_SET;
          end if;
      when ST_C3_SET =>
          if ( step_c3 > X"0000" ) then
              next_state <= ST_SET;
              c3_en <= '1';
          else
              next_state <= ST_C4_CLR;
              c3_done <= '1';
          end if;

      --C4
      when ST_C4_CLR =>
          c4_clr <= '1';
          if ( pre_step_c4 > X"0000" ) then
              next_state <= ST_PRE_SET;
          else
              next_state <= ST_C4_SET;
          end if;
      when ST_C4_SET =>
          if ( step_c4 > X"0000" ) then
              next_state <= ST_SET;
              c4_en <= '1';
          else
              next_state <= ST_STOP;
              c4_done <= '1';
          end if;
      when ST_PRE_SET =>
          if (p_done1 = '1' )and(p_done2 = '1' ) then
              p_step_set <= '1';
              next_state <= ST_PRE_STEPON;
          else
              next_state <= ST_PRE_SET;
          end if;
      when ST_PRE_STEPON  =>
           if (p_done1 = '0' ) and (p_done2 = '1' ) then                            
              p_step_clr <= '1';
              if step_cnt > X"0000"  then
                next_state <= ST_PRE_WAIT;
              else
                next_state <= ST_PRE_STEPDONE;
              end if;
           else
               next_state <= ST_PRE_STEPON;
           end if;
      when ST_PRE_WAIT  =>
           if (p_done1 = '1' ) and (p_done2 = '1' ) then                            
                next_state <= ST_PRE_SET;
           else
                next_state <= ST_PRE_WAIT;
           end if;
      when ST_PRE_STEPDONE  =>
          if c0_on = '1'  then
              next_state <= ST_C0_SET;
          elsif c1_on = '1'  then
              next_state <= ST_C1_SET;
          elsif c2_on = '1'  then
              next_state <= ST_C2_SET;
          elsif c3_on = '1'  then
              next_state <= ST_C3_SET;
          elsif c4_on = '1'  then
              next_state <= ST_C4_SET;
          else
              next_state <= ST_ERR;
          end if;
      when ST_SET =>
          if (p_done1 = '1' ) and(p_done2 = '1' ) then
              p_step_set <= '1';
              next_state <= ST_STEPON;
           else
              next_state <= ST_SET;
          end if;
      when ST_STEPON  =>
           if (p_done1 <= '0' ) and (p_done2 = '1' ) then                            
              p_step_clr <= '1';
              if step_cnt > X"0000"  then
                next_state <= ST_WAIT;
              else
                next_state <= ST_STEPDONE;
              end if;
           else
               next_state <= ST_STEPON;
           end if;
      when ST_WAIT  =>
           if (p_done1 = '1' ) and (p_done2 = '1' ) then                            
                next_state <= ST_SET;
           else
                next_state <= ST_WAIT;
           end if;
      when ST_STEPDONE  =>
          if c0_on = '1'  then
              next_state <= ST_C1_CLR;
              c0_done <= '1';
          elsif c1_on = '1'  then
              next_state <= ST_C2_CLR;
              c1_done <= '1';
          elsif c2_on = '1'  then
              next_state <= ST_C3_CLR;
              c2_done <= '1';
          elsif c3_on = '1'  then
              next_state <= ST_C4_CLR;
              c3_done <= '1';
          elsif c4_on = '1'  then
              next_state <= ST_STOP;
              c4_done <= '1';
          else
              next_state <= ST_ERR;
          end if;
      when    ST_ERR          =>
        next_state  <= ST_STOP ;
      when    ST_STOP          =>
        next_state  <= ST_IDLE ;
      when others =>
        next_state  <= ST_IDLE ;
    end case ;
  end process ;

end architecture behaviour ;
