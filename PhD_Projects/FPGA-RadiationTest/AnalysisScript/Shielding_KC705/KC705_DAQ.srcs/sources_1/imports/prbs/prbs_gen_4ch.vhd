----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Xueye Hu
-- 
-- Create Date: 05/11/2015 01:33:43 PM
-- Design Name: 
-- Module Name: prbs_gen_4ch - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: wrapper 4 channels of prbs generator
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- PRBS clock for JTAG 1MHz (40Mbps)
-- PRBS clock for ENC  2MHz (80Mbps)
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_MISC.ALL;


--library UNISIM;
--use UNISIM.VComponents.all;

entity prbs_gen_4ch is
   generic (      
    CHK_MODE: boolean := false; 
    INV_PATTERN : boolean := false;
    POLY_LENGHT : natural range 2 to 63 := 31 ;
    POLY_TAP : natural range 1 to 62 := 28 ;
    NBITS : natural range 1 to 512 := 40
    );
  Port (
          clk_ch0                 : in std_logic;     -- system clock
          reset_ch0               : in std_logic;     -- sync reset active high          
          clk_ch1                 : in std_logic;     -- system clock
          reset_ch1               : in std_logic;     -- sync reset active high
          clk_ch2                 : in std_logic;     -- system clock
          reset_ch2               : in std_logic;     -- sync reset active high          
          clk_ch3                 : in std_logic;     -- system clock
          reset_ch3               : in std_logic;     -- sync reset active high

        errcnt_injerr       : in std_logic_vector (0 downto 0);

        prbs_gen_ch0      : out std_logic_vector(39 downto 0);
        prbs_gen_ch1      : out std_logic_vector(39 downto 0);
        prbs_gen_ch2      : out std_logic_vector(39 downto 0);
        prbs_gen_ch3      : out std_logic_vector(39 downto 0)
         );
end prbs_gen_4ch;

architecture Behavioral of prbs_gen_4ch is

component prbs_gen is
   generic (      
       CHK_MODE: boolean := false; 
       INV_PATTERN : boolean := false;
       POLY_LENGHT : natural range 2 to 63 := 31 ;
       POLY_TAP : natural range 1 to 62 := 28 ;
       NBITS : natural range 1 to 512 := 40
);
   Port (
        err_injerr  : in std_logic_vector (0 downto 0);     -- inject error for test, need to cross clk domain (100MHz--240MHz)
        clk         : in std_logic;     -- system clock
        reset       : in std_logic;     -- sync reset active high
        prbs_out    : out std_logic_vector(39 downto 0)  -- generated prbs pattern
         );
end component;

begin

prbs_gen_ch0_inst: prbs_gen 
   GENERIC MAP(
       CHK_MODE =>  FALSE, -- PRBS generator
       INV_PATTERN => INV_PATTERN,
       POLY_LENGHT => POLY_LENGHT,              
       POLY_TAP => POLY_TAP,
       NBITS => 40
        )
    
   PORT MAP(
         err_injerr => errcnt_injerr,
         clk        => clk_ch0,
         reset      => reset_ch0,
         prbs_out   => prbs_gen_ch0
     );

prbs_gen_ch1_ins: prbs_gen 
   GENERIC MAP(
       CHK_MODE =>  FALSE, -- PRBS generator
       INV_PATTERN => INV_PATTERN,
       POLY_LENGHT => POLY_LENGHT,              
       POLY_TAP => POLY_TAP,
       NBITS => 40
        )
    
   PORT MAP(
         err_injerr => errcnt_injerr,
         clk        => clk_ch1,
         reset      => reset_ch1,
         prbs_out   => prbs_gen_ch1
     );

prbs_gen_ch2_ins: prbs_gen 
   GENERIC MAP(
       CHK_MODE =>  FALSE, -- PRBS generator
       INV_PATTERN => INV_PATTERN,
       POLY_LENGHT => POLY_LENGHT,              
       POLY_TAP => POLY_TAP,
       NBITS => 40
        )
    
   PORT MAP(
         err_injerr => errcnt_injerr,
         clk        => clk_ch2,
         reset      => reset_ch2,
         prbs_out   => prbs_gen_ch2
     );

prbs_gen_ch3_ins: prbs_gen 
   GENERIC MAP(
       CHK_MODE =>  FALSE, -- PRBS generator
       INV_PATTERN => INV_PATTERN,
       POLY_LENGHT => POLY_LENGHT,              
       POLY_TAP => POLY_TAP,
       NBITS => 40
        )
    
   PORT MAP(
         err_injerr => errcnt_injerr,
         clk        => clk_ch3,
         reset      => reset_ch3,
         prbs_out   => prbs_gen_ch3
     );



end Behavioral;
