----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Xueye Hu
-- 
-- Create Date: 05/04/2015 05:43:50 PM
-- Design Name: 
-- Module Name: prbs_gen - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: generate 40Mbps prbs data, clk--1MHz, datawith--40bits
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


-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
library UNISIM;
use UNISIM.VComponents.all;

entity prbs_gen is
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
end prbs_gen;

architecture Behavioral of prbs_gen is

component PRBS_ANY 
   generic (      
      CHK_MODE: boolean := false; 
      INV_PATTERN : boolean := false;  -- The generated pattern is not inverted or the checker does not invert the pattern before checking it.
      POLY_LENGHT : natural range 0 to 63 := 31 ;
      POLY_TAP : natural range 0 to 63 := 28 ;
      NBITS : natural range 0 to 512 :=40
   );
   port (
      RST             : in  std_logic;                               -- sync reset active high
      CLK             : in  std_logic;                               -- system clock
      DATA_IN         : in  std_logic_vector(NBITS - 1 downto 0); -- inject error/data to be checked
      EN              : in  std_logic;                               -- enable/pause pattern generation
      DATA_OUT        : out std_logic_vector(NBITS - 1 downto 0)  -- generated prbs pattern/errors found
   );
end component;

signal inj_error_vector : std_logic_vector (0 downto 0);
constant INJ : std_logic_vector (38 downto 0) := (others => '0');

signal DATA_IN_tmp  : std_logic_vector (39 downto 0);

signal err_injerr_tmp: std_logic_vector(1 downto 0);

begin
   
   process(clk) begin
   if clk'event and clk='1' then
      err_injerr_tmp(0) <=  err_injerr(0);
      err_injerr_tmp(1) <=  err_injerr_tmp(0);
   end if;
   end process;
    
   
   inj_error_vector(0) <= err_injerr_tmp(1) and (not err_injerr_tmp(0));
   DATA_IN_tmp <= INJ & inj_error_vector;
   ----------------------------------------------		
	-- Instantiate the PRBS generator
   ----------------------------------------------		
	I_PRBS_ANY_GEN: PRBS_ANY 
   GENERIC MAP(
      CHK_MODE =>  FALSE, -- PRBS generator
      INV_PATTERN => INV_PATTERN,
      POLY_LENGHT => POLY_LENGHT,              
      POLY_TAP => POLY_TAP,
      NBITS => 40

   )
   PORT MAP(
		RST => reset, --'0',
		CLK => CLK,
		DATA_IN => DATA_IN_tmp, --INJ & inj_error_vector,
		EN => '1',
		DATA_OUT => prbs_out
	);
	
end Behavioral;
