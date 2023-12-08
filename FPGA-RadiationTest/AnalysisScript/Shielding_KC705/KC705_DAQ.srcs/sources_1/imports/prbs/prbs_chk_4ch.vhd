----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Xueye Hu
-- 
-- Create Date: 05/11/2015 01:52:57 PM
-- Design Name: 
-- Module Name: prbs_chk_4ch - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: wrapper 4 channels of prbs checker
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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_MISC.ALL;


--library UNISIM;
--use UNISIM.VComponents.all;

entity prbs_chk_4ch is
   generic (      
       CHK_MODE: boolean := true; 
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
                              
          errcnt_rst4ch           : in std_logic;
          
          prbs_in_ch0         : in std_logic_vector(39 downto 0);     -- ch0 data to be checked
          prbs_in_ch1         : in std_logic_vector(39 downto 0);     -- ch1 data to be checked
          prbs_in_ch2         : in std_logic_vector(39 downto 0);     -- ch2 data to be checked
          prbs_in_ch3         : in std_logic_vector(39 downto 0);     -- ch3 data to be checked
          
          err_detect_ch0      : out std_logic_vector(23 downto 0);
          err_detect_ch1      : out std_logic_vector(23 downto 0);
          err_detect_ch2      : out std_logic_vector(23 downto 0);
          err_detect_ch3      : out std_logic_vector(23 downto 0)
         );          
end prbs_chk_4ch;

architecture Behavioral of prbs_chk_4ch is

component prbs_chk is
   generic (      
       CHK_MODE: boolean := true; 
       INV_PATTERN : boolean := false;
       POLY_LENGHT : natural range 2 to 63 := 31 ;
       POLY_TAP : natural range 1 to 62 := 28 ;
       NBITS : natural range 1 to 512 := 40
);
   Port (
        clk             : in std_logic;     -- system clock
        reset           : in std_logic;     -- sync reset active high
        errcnt_rstin      : in std_logic;
--        errcnt_cntrl    : in std_logic_vector(7 downto 0);
        prbs_in         : in std_logic_vector(39 downto 0);     -- data to be checked
        err_detect      : out std_logic_vector(23 downto 0)  -- generated prbs pattern
         );
end component;


begin

prbs_chk_ch0: prbs_chk
     generic map ( 
                CHK_MODE        => TRUE,
                INV_PATTERN     => FALSE,
                POLY_LENGHT     => 31,
                POLY_TAP        => 28,
                NBITS           => 40
                )
     port map (
                clk              => clk_ch0,
                reset            => reset_ch0,
                errcnt_rstin     => errcnt_rst4ch,
                prbs_in          => prbs_in_ch0, --prbs_gtxrx,--change later when add gtx
                err_detect       => err_detect_ch0
               );

prbs_chk_ch1: prbs_chk
     generic map ( 
                CHK_MODE        => TRUE,
                INV_PATTERN     => FALSE,
                POLY_LENGHT     => 31,
                POLY_TAP        => 28,
                NBITS           => 40
                )
     port map (
                clk              => clk_ch1,
                reset            => reset_ch1,
                errcnt_rstin     => errcnt_rst4ch,
                prbs_in          => prbs_in_ch1, --prbs_gtxrx,--change later when add gtx
                err_detect       => err_detect_ch1
               );

prbs_chk_ch2: prbs_chk
     generic map ( 
                CHK_MODE        => TRUE,
                INV_PATTERN     => FALSE,
                POLY_LENGHT     => 31,
                POLY_TAP        => 28,
                NBITS           => 40
                )
     port map (
                clk              => clk_ch2,
                reset            => reset_ch2,
                errcnt_rstin     => errcnt_rst4ch,
                prbs_in          => prbs_in_ch2, --prbs_gtxrx,--change later when add gtx
                err_detect       => err_detect_ch2
               );

prbs_chk_ch3: prbs_chk
     generic map ( 
                CHK_MODE        => TRUE,
                INV_PATTERN     => FALSE,
                POLY_LENGHT     => 31,
                POLY_TAP        => 28,
                NBITS           => 40
                )
     port map (
                clk              => clk_ch3,
                reset            => reset_ch3,
                errcnt_rstin     => errcnt_rst4ch,
                prbs_in          => prbs_in_ch3, --prbs_gtxrx,--change later when add gtx
                err_detect       => err_detect_ch3
               );



end Behavioral;
