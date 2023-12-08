----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Xueye Hu
-- 
-- Create Date: 04/05/2021 05:43:50 PM
-- Design Name: 
-- Module Name: prbs_gen - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: generate 4.8Gbps prbs data, clk--240MHz, datawith--20bits
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- error counter overflow time: 400ms
-- upload/refresh error result: 64ms
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

entity prbs_chk is
   generic (      
       CHK_MODE: boolean := true; 
       INV_PATTERN : boolean := false;
       POLY_LENGHT : natural range 2 to 63 := 31 ;
       POLY_TAP : natural range 1 to 62 := 28 ;
       NBITS : natural range 1 to 512 := 40
);
   Port (
        clk             : in std_logic;     -- system clock --1MHz
        reset           : in std_logic;     -- sync reset active high
        errcnt_rstin      : in std_logic;
--        errcnt_cntrl    : in std_logic_vector(7 downto 0);
        prbs_in         : in std_logic_vector(39 downto 0);     -- data to be checked
        err_detect      : out std_logic_vector(23 downto 0)  -- generated prbs pattern
         );
end prbs_chk;

architecture Behavioral of prbs_chk is

--function count_ones(s: in std_logic_vector(19 downto 0)) return std_logic_vector;

function count_ones(s: in std_logic_vector(39 downto 0)) return integer is
      variable temp : integer := 0;
    begin
      for i in s'range loop
        if s(i) = '1' then 
        temp := temp + 1; 
        end if;
      end loop;
      
      return temp;
end function count_ones;

component PRBS_ANY 
   generic (      
      CHK_MODE: boolean := false; 
      INV_PATTERN : boolean := false;  -- The generated pattern is not inverted or the checker does not invert the pattern before checking it.
      POLY_LENGHT : natural range 0 to 63 := 31 ;
      POLY_TAP : natural range 0 to 63 := 28 ;
      NBITS : natural range 0 to 512 := 40
   );
   port (
      RST             : in  std_logic;                               -- sync reset active high
      CLK             : in  std_logic;                               -- system clock
      DATA_IN         : in  std_logic_vector(NBITS - 1 downto 0); -- inject error/data to be checked
      EN              : in  std_logic;                               -- enable/pause pattern generation
      DATA_OUT        : out std_logic_vector(NBITS - 1 downto 0)  -- generated prbs pattern/errors found
   );
end component;


signal err_out_40			: std_logic_vector(NBITS - 1 downto 0);
--signal chk_en_20		    : std_logic;
--signal sp20_cnt             : std_logic_vector (4 downto 0) := (others => '0');
signal err_add              : integer;
--signal err_vector           : std_logic_vector(31 downto 0);
signal errcnt_rst           : std_logic;


 signal err_per_cycle       : std_logic_vector(5 downto 0);
 signal err_total           : std_logic_vector(23 downto 0);
 signal cnt                 :std_logic_vector(15 downto 0);

begin

	 errcnt_rst		<= errcnt_rstin; --errcnt_cntrl(0);
   ----------------------------------------------		
	-- Instantiate the checker with 40 bits input
   ----------------------------------------------
	I_PRBS_ANY_CHK: PRBS_ANY 
   GENERIC MAP(
      CHK_MODE =>  TRUE,
      INV_PATTERN =>INV_PATTERN,
      POLY_LENGHT => POLY_LENGHT,              
      POLY_TAP => POLY_TAP,
      NBITS => 40
   )
   PORT MAP(
		RST => reset, --'0',
		CLK => clk,
		DATA_IN => prbs_in,
		EN => '1',
		DATA_OUT => err_out_40
	);	
   
   
   
  ----------------------------------------------		
     -- Error detect from the 40 bit checker 
    ----------------------------------------------       

 err_add <= count_ones(s => err_out_40); 
 err_per_cycle <= CONV_STD_LOGIC_VECTOR(err_add,6);
 
 process(clk)
 begin
  if(clk'event and clk ='1') then
   if(reset = '1' or errcnt_rst = '1') then
     cnt <= (others =>'0');
   else
     cnt <= cnt + '1';
   end if;
  end if;
 end process;

process(clk)
begin
  if rising_edge(clk) then
   if(reset = '1' or errcnt_rst = '1') then
      err_total <= (others =>'0');
    else
      err_total <= err_total + err_per_cycle;
    end if;
  end if;
end process;    

-- sample error_total to register
--process(clk)
--begin
-- if(clk'event and clk ='1') then
--    if(cnt=x"ffff") then
--       err_detect <= err_total;
--    end if;
--  end if;
--end process;
err_detect <= err_total;
--err_detect(31 downto 16) <= x"0000";
    	
end Behavioral;
