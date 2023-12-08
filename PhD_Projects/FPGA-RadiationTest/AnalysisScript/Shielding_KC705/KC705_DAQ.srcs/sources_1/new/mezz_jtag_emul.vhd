----------------------------------------------------------------------------------
-- Company: U of M
-- Engineer: Xueye
-- 
-- Create Date: 04/12/2021 11:41:58 AM
-- Design Name: 
-- Module Name: mezz_jtag_emul - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
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
use ieee.numeric_std.all;
use IEEE.std_logic_unsigned.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
library UNISIM;
use UNISIM.VComponents.all;


entity mezz_jtag_emul is
  Port (
        clk_80mhz               : in std_logic;
        clk_40mhz               : in std_logic;
        clk_1mhz                : in std_logic;
        clk_2mhz                : in std_logic;
        rst_logic               : in std_logic;
        
        errcnt_injerr           : in std_logic_vector(0 downto 0);
        
        rst_gen_tdim             : in std_logic;
        rst_gen_tmsm             : in std_logic;
        rst_gen_tckm             : in std_logic;
        rst_gen_ttco             : in std_logic;   
             
        tdi_master_o              : out std_logic;
        tdo_master_i              : in std_logic;
        tms_master_o              : out std_logic;
        tck_master_o              : out std_logic;
        
        
        rst_chk_tdo_m              : in std_logic;
        rst_chk_tms_s              : in std_logic_vector(17 downto 0);        
        errcnt_rst4ch              : in std_logic_vector(10 downto 0); 
          
        rst_chk_tck_s              : in std_logic_vector(17 downto 0);  
        rst_chk_elinkttc           : in std_logic_vector(5 downto 0); 
        
                
        tdi_slave_i         : in std_logic_vector (17 downto 0);
        tdo_slave_o         : out std_logic_vector (17 downto 0);
        tms_slave_i         : in std_logic_vector (17 downto 0);
        tck_slave_i         : in std_logic_vector (17 downto 0);
        
        elink_TTC_out       : out std_logic;
        mezz_enc_in         : in std_logic_vector (5 downto 0);
        
        tdo_m_err_reg       : out std_logic_vector (23 downto 0);
        tms_err_reg_0       : out std_logic_vector (23 downto 0);   
        tms_err_reg_1       : out std_logic_vector (23 downto 0);  
        tms_err_reg_2       : out std_logic_vector (23 downto 0);   
        tms_err_reg_3       : out std_logic_vector (23 downto 0);         
        tms_err_reg_4       : out std_logic_vector (23 downto 0);   
        tms_err_reg_5       : out std_logic_vector (23 downto 0);  
        tms_err_reg_6       : out std_logic_vector (23 downto 0);   
        tms_err_reg_7       : out std_logic_vector (23 downto 0);         
        tms_err_reg_8       : out std_logic_vector (23 downto 0);   
        tms_err_reg_9       : out std_logic_vector (23 downto 0);  
        tms_err_reg_10       : out std_logic_vector (23 downto 0);   
        tms_err_reg_11       : out std_logic_vector (23 downto 0); 
        tms_err_reg_12       : out std_logic_vector (23 downto 0);   
        tms_err_reg_13       : out std_logic_vector (23 downto 0);  
        tms_err_reg_14       : out std_logic_vector (23 downto 0);   
        tms_err_reg_15       : out std_logic_vector (23 downto 0); 
        tms_err_reg_16       : out std_logic_vector (23 downto 0);   
        tms_err_reg_17       : out std_logic_vector (23 downto 0); 
        
        tck_err_reg_0       : out std_logic_vector (23 downto 0);   
        tck_err_reg_1       : out std_logic_vector (23 downto 0);  
        tck_err_reg_2       : out std_logic_vector (23 downto 0);   
        tck_err_reg_3       : out std_logic_vector (23 downto 0);         
        tck_err_reg_4       : out std_logic_vector (23 downto 0);   
        tck_err_reg_5       : out std_logic_vector (23 downto 0);  
        tck_err_reg_6       : out std_logic_vector (23 downto 0);   
        tck_err_reg_7       : out std_logic_vector (23 downto 0);         
        tck_err_reg_8       : out std_logic_vector (23 downto 0);   
        tck_err_reg_9       : out std_logic_vector (23 downto 0);  
        tck_err_reg_10       : out std_logic_vector (23 downto 0);   
        tck_err_reg_11       : out std_logic_vector (23 downto 0); 
        tck_err_reg_12       : out std_logic_vector (23 downto 0);   
        tck_err_reg_13       : out std_logic_vector (23 downto 0);  
        tck_err_reg_14       : out std_logic_vector (23 downto 0);   
        tck_err_reg_15       : out std_logic_vector (23 downto 0); 
        tck_err_reg_16       : out std_logic_vector (23 downto 0);   
        tck_err_reg_17       : out std_logic_vector (23 downto 0); 
        
        elink_TTCin_err_reg_0       : out std_logic_vector (23 downto 0); 
        elink_TTCin_err_reg_1       : out std_logic_vector (23 downto 0); 
        elink_TTCin_err_reg_2       : out std_logic_vector (23 downto 0); 
        elink_TTCin_err_reg_3       : out std_logic_vector (23 downto 0); 
        elink_TTCin_err_reg_4       : out std_logic_vector (23 downto 0);                      
        elink_TTCin_err_reg_5       : out std_logic_vector (23 downto 0) 

         );
end mezz_jtag_emul;

architecture Behavioral of mezz_jtag_emul is

component prbs_gen_4ch is
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
end component;


component prbs_chk_4ch is
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
end component;


COMPONENT ila_0

PORT (
	clk : IN STD_LOGIC;



	probe0 : IN STD_LOGIC_VECTOR(0 DOWNTO 0); 
	probe1 : IN STD_LOGIC_VECTOR(0 DOWNTO 0); 
	probe2 : IN STD_LOGIC_VECTOR(0 DOWNTO 0); 
	probe3 : IN STD_LOGIC_VECTOR(0 DOWNTO 0); 
	probe4 : IN STD_LOGIC_VECTOR(17 DOWNTO 0); 
	probe5 : IN STD_LOGIC_VECTOR(17 DOWNTO 0); 
	probe6 : IN STD_LOGIC_VECTOR(17 DOWNTO 0);
	probe7 : IN STD_LOGIC_VECTOR(17 DOWNTO 0)
);
END COMPONENT  ;

signal tdi_master_o_pl ,tdi_master_o_pl_tmp             : std_logic_vector(39 downto 0);
--signal tdo_master_i_p              : std_logic_vector(39 downto 0);
signal tms_master_o_pl  ,tms_master_o_pl_tmp            : std_logic_vector(39 downto 0);
signal tck_master_o_pl ,tck_master_o_pl_tmp             : std_logic_vector(39 downto 0);
signal elink_TTC_out_pl,elink_TTC_out_pl_tmp             : std_logic_vector(39 downto 0);

signal tdi_master_o_msb             : std_logic;
signal tms_master_o_msb             : std_logic;
signal tck_master_o_msb             : std_logic;
signal elink_TTC_out_msb            : std_logic;

signal tdo_master_i_pl              : std_logic_vector(39 downto 0);
signal tdo_m_err_load               : std_logic_vector(23 downto 0);

--signal tms_s0_i_pl                  : std_logic_vector(39 downto 0);
--signal tms_s1_i_pl                  : std_logic_vector(39 downto 0);
--signal tms_s2_i_pl                  : std_logic_vector(39 downto 0);
--signal tms_s3_i_pl                  : std_logic_vector(39 downto 0);

type jtag_slave_array is array (17 downto 0) of std_logic_vector(39 downto 0);
signal tms_s_i_pl ,tms_s_i_pl_tmp      : jtag_slave_array;
signal tck_s_i_pl,tck_s_i_pl_tmp      : jtag_slave_array;

type jtag_slave_array_4_cnt is array (17 downto 0) of std_logic_vector(5 downto 0);
signal tms_s_i_pl_cnt      : jtag_slave_array_4_cnt;
signal tck_s_i_pl_cnt      : jtag_slave_array_4_cnt;

type err_detectjtag_array is array (17 downto 0) of std_logic_vector(23 downto 0);
signal tms_err_load       : err_detectjtag_array;
signal tck_err_load       : err_detectjtag_array;

type elink_TTCin_array is array (5 downto 0) of std_logic_vector(39 downto 0);
signal elink_TTCin_pl,elink_TTCin_pl_tmp       : elink_TTCin_array;

type elink_TTCin_array_cnt is array (5 downto 0) of std_logic_vector(39 downto 0);
signal elink_TTCin_pl_cnt       : elink_TTCin_array_cnt;

type err_detect_TTCin_array is array (5 downto 0) of std_logic_vector(23 downto 0);
signal elink_TTCin_err_load       : err_detect_TTCin_array;


signal sipo_cnt,posi_cnt,posi_cnt_80mhz: std_logic_vector(5 downto 0);
signal tdo_master_i_pl_tmp: std_logic_vector(39 downto 0);

begin

tdo_m_err_reg  <= tdo_m_err_load;

tms_err_reg_0  <= tms_err_load(0);
tms_err_reg_1  <= tms_err_load(1);
tms_err_reg_2  <= tms_err_load(2);  
tms_err_reg_3  <= tms_err_load(3);        
tms_err_reg_4  <= tms_err_load(4);  
tms_err_reg_5  <= tms_err_load(5);
tms_err_reg_6  <= tms_err_load(6);
tms_err_reg_7  <= tms_err_load(7);  
tms_err_reg_8  <= tms_err_load(8);        
tms_err_reg_9  <= tms_err_load(9);  
tms_err_reg_10  <= tms_err_load(10);
tms_err_reg_11  <= tms_err_load(11);
tms_err_reg_12  <= tms_err_load(12);  
tms_err_reg_13  <= tms_err_load(13);        
tms_err_reg_14  <= tms_err_load(14);  
tms_err_reg_15  <= tms_err_load(15);
tms_err_reg_16  <= tms_err_load(16);
tms_err_reg_17  <= tms_err_load(17);  

tck_err_reg_0   <= tck_err_load(0);
tck_err_reg_1   <= tck_err_load(1);
tck_err_reg_2   <= tck_err_load(2);
tck_err_reg_3   <= tck_err_load(3);
tck_err_reg_4   <= tck_err_load(4);
tck_err_reg_5   <= tck_err_load(5);
tck_err_reg_6   <= tck_err_load(6);
tck_err_reg_7   <= tck_err_load(7);
tck_err_reg_8   <= tck_err_load(8);
tck_err_reg_9   <= tck_err_load(9);
tck_err_reg_10   <= tck_err_load(10);
tck_err_reg_11   <= tck_err_load(11);
tck_err_reg_12   <= tck_err_load(12);
tck_err_reg_13   <= tck_err_load(13);
tck_err_reg_14   <= tck_err_load(14);
tck_err_reg_15   <= tck_err_load(15);
tck_err_reg_16   <= tck_err_load(16);
tck_err_reg_17   <= tck_err_load(17);        

elink_TTCin_err_reg_0   <= elink_TTCin_err_load(0);
elink_TTCin_err_reg_1   <= elink_TTCin_err_load(1);  
elink_TTCin_err_reg_2   <= elink_TTCin_err_load(2);
elink_TTCin_err_reg_3   <= elink_TTCin_err_load(3); 
elink_TTCin_err_reg_4   <= elink_TTCin_err_load(4);
elink_TTCin_err_reg_5   <= elink_TTCin_err_load(5);       




tdi_master_o    <= tdi_master_o_msb;
tms_master_o    <= tms_master_o_msb;
tck_master_o    <= tck_master_o_msb;
elink_TTC_out   <= elink_TTC_out_msb;       


--ila_inst : ila_0
--PORT MAP (
--	clk => clk_80mhz,



--	probe0(0) => tdi_master_o_msb, 
--	probe1(0) => elink_TTC_out_msb, 
--	probe2(0) => tms_master_o_msb, 
--	probe3(0) => tck_master_o_msb, 
--	probe4 => tdi_slave_i, 
--	probe5 => rst_chk_tck_s, 
--	probe6 => tms_slave_i,
--	probe7 => tck_slave_i
--);
 
        
        
jtag_tditdo_slaveemul_gen: for i in 0 to 17 generate
                            begin
                                tdo_slave_o (i) <= tdi_slave_i(i);
                            end generate;
                            

prbs_gen_4ch_inst: prbs_gen_4ch
           generic map ( 
                           CHK_MODE        => FALSE,
                           INV_PATTERN     => FALSE,
                           POLY_LENGHT     => 31,
                           POLY_TAP        => 28,
                           NBITS           => 40
                       )
           port map (
                           clk_ch0                 => clk_1mhz,
                           reset_ch0               => rst_gen_tdim,
                           clk_ch1                 => clk_1mhz,
                           reset_ch1               => rst_gen_tmsm,                               
                           clk_ch2                 => clk_1mhz,
                           reset_ch2               => rst_gen_tckm,
                           clk_ch3                 => clk_2mhz,
                           reset_ch3               => rst_gen_ttco,      
                                                          
                           errcnt_injerr       => errcnt_injerr,

      
                           prbs_gen_ch0      => tdi_master_o_pl_tmp,--prbs_40Mbps
                           prbs_gen_ch1      => tms_master_o_pl_tmp,--prbs_gtxtx_ch1,
                           prbs_gen_ch2      => tck_master_o_pl_tmp,--prbs_gtxtx_ch2,
                           prbs_gen_ch3      => elink_TTC_out_pl_tmp --prbs_gtxtx_ch3
                     );
                     

piso_inst_40: process (clk_40mhz)
                begin
                     if rising_edge (clk_40mhz) then
                        if rst_logic = '1' then
                            tdi_master_o_pl  <= (others => '0');  
                            tms_master_o_pl  <= (others => '0');   
                            tck_master_o_pl  <= (others => '0');  
                        elsif posi_cnt = "100111" then
                            tdi_master_o_pl  <= tdi_master_o_pl_tmp;  
                            tms_master_o_pl  <= tms_master_o_pl_tmp;   
                            tck_master_o_pl  <= tck_master_o_pl_tmp;                                                                                       
                        else
                            tdi_master_o_pl(39 downto 0) <=  '0'& tdi_master_o_pl(39 downto 1) ;
                            tms_master_o_pl(39 downto 0) <=  '0'& tms_master_o_pl(39 downto 1) ;
                            tck_master_o_pl(39 downto 0) <=  '0'& tck_master_o_pl(39 downto 1) ;
                         end if;
                    end if;
                end process;
 process (clk_40mhz) begin
    if rising_edge (clk_40mhz) then
       if posi_cnt="100111" then
          posi_cnt <=(others=>'0');
       else
          posi_cnt <= posi_cnt + '1';
       end if;
    end if;
 end process;
                
tdi_master_o_msb <= tdi_master_o_pl(0);                 
tms_master_o_msb <= tms_master_o_pl(0); 
tck_master_o_msb <= tck_master_o_pl(0); 




 process (clk_80mhz) begin
    if rising_edge (clk_80mhz) then
       if posi_cnt_80mhz="100111" then
          posi_cnt_80mhz <=(others=>'0');
       else
          posi_cnt_80mhz <= posi_cnt_80mhz + '1';
       end if;
    end if;
 end process;
 
piso_inst_80: process (clk_80mhz)
                begin
                if rising_edge (clk_80mhz) then
                    if rst_logic = '1' then
                       elink_TTC_out_pl  <= (others => '0'); 
                    elsif posi_cnt_80mhz="100111" then
                       elink_TTC_out_pl <= elink_TTC_out_pl_tmp;
                    else
                       elink_TTC_out_pl(39 downto 0) <= '0' & elink_TTC_out_pl(39 downto 1) ;
                    end if;
                 end if;     
                end process;
                                                 
elink_TTC_out_msb <= elink_TTC_out_pl(0); 



prbs_chk_1jtagm_3jtags_tms_inst: prbs_chk_4ch 
                   generic map ( 
                                   CHK_MODE        => TRUE,
                                   INV_PATTERN     => FALSE,
                                   POLY_LENGHT     => 31,
                                   POLY_TAP        => 28,
                                   NBITS           => 40
                               )
                  port map (
                          clk_ch0                 => clk_1mhz,
                          reset_ch0               => rst_chk_tdo_m,        
                          clk_ch1                 => clk_1mhz,     -- system clock
                          reset_ch1               => rst_chk_tms_s(0),     -- sync reset active high
                          clk_ch2                 => clk_1mhz,    -- system clock
                          reset_ch2               => rst_chk_tms_s(1),     -- sync reset active high          
                          clk_ch3                 => clk_1mhz,    -- system clock
                          reset_ch3               => rst_chk_tms_s(2),     -- sync reset active high
                                              
                          errcnt_rst4ch           => errcnt_rst4ch(0),
                          
                          prbs_in_ch0         => tdo_master_i_pl, 
                          prbs_in_ch1         => tms_s_i_pl(0),
                          prbs_in_ch2         => tms_s_i_pl(1),
                          prbs_in_ch3         => tms_s_i_pl(2),
                          
                          err_detect_ch0      => tdo_m_err_load,
                          err_detect_ch1      => tms_err_load(0),
                          err_detect_ch2      => tms_err_load(1),
                          err_detect_ch3      => tms_err_load(2)
                        );          

prbs_chk_4jtags_tms_inst: prbs_chk_4ch 
                   generic map ( 
                                   CHK_MODE        => TRUE,
                                   INV_PATTERN     => FALSE,
                                   POLY_LENGHT     => 31,
                                   POLY_TAP        => 28,
                                   NBITS           => 40
                               )
                  port map (
                          clk_ch0                 => clk_1mhz,
                          reset_ch0               => rst_chk_tms_s(3),        
                          clk_ch1                 => clk_1mhz,     -- system clock
                          reset_ch1               => rst_chk_tms_s(4),     -- sync reset active high
                          clk_ch2                 => clk_1mhz,    -- system clock
                          reset_ch2               => rst_chk_tms_s(5),     -- sync reset active high          
                          clk_ch3                 => clk_1mhz,    -- system clock
                          reset_ch3               => rst_chk_tms_s(6),     -- sync reset active high
                                              
                          errcnt_rst4ch           => errcnt_rst4ch(1),
                          
                          prbs_in_ch0         => tms_s_i_pl(3), 
                          prbs_in_ch1         => tms_s_i_pl(4),
                          prbs_in_ch2         => tms_s_i_pl(5),
                          prbs_in_ch3         => tms_s_i_pl(6),
                          
                          err_detect_ch0      => tms_err_load(3),
                          err_detect_ch1      => tms_err_load(4),
                          err_detect_ch2      => tms_err_load(5),
                          err_detect_ch3      => tms_err_load(6)
                        );     

prbs_chk_4jtags_tms_inst1: prbs_chk_4ch 
                   generic map ( 
                                   CHK_MODE        => TRUE,
                                   INV_PATTERN     => FALSE,
                                   POLY_LENGHT     => 31,
                                   POLY_TAP        => 28,
                                   NBITS           => 40
                               )
                  port map (
                          clk_ch0                 => clk_1mhz,
                          reset_ch0               => rst_chk_tms_s(7),        
                          clk_ch1                 => clk_1mhz,     -- system clock
                          reset_ch1               => rst_chk_tms_s(8),     -- sync reset active high
                          clk_ch2                 => clk_1mhz,    -- system clock
                          reset_ch2               => rst_chk_tms_s(9),     -- sync reset active high          
                          clk_ch3                 => clk_1mhz,    -- system clock
                          reset_ch3               => rst_chk_tms_s(10),     -- sync reset active high
                                              
                          errcnt_rst4ch           => errcnt_rst4ch(2),
                          
                          prbs_in_ch0         => tms_s_i_pl(7), 
                          prbs_in_ch1         => tms_s_i_pl(8),
                          prbs_in_ch2         => tms_s_i_pl(9),
                          prbs_in_ch3         => tms_s_i_pl(10),
                          
                          err_detect_ch0      => tms_err_load(7),
                          err_detect_ch1      => tms_err_load(8),
                          err_detect_ch2      => tms_err_load(9),
                          err_detect_ch3      => tms_err_load(10)
                        );


prbs_chk_4jtags_tms_inst2: prbs_chk_4ch 
                   generic map ( 
                                   CHK_MODE        => TRUE,
                                   INV_PATTERN     => FALSE,
                                   POLY_LENGHT     => 31,
                                   POLY_TAP        => 28,
                                   NBITS           => 40
                               )
                  port map (
                          clk_ch0                 => clk_1mhz,
                          reset_ch0               => rst_chk_tms_s(11),        
                          clk_ch1                 => clk_1mhz,     -- system clock
                          reset_ch1               => rst_chk_tms_s(12),     -- sync reset active high
                          clk_ch2                 => clk_1mhz,    -- system clock
                          reset_ch2               => rst_chk_tms_s(13),     -- sync reset active high          
                          clk_ch3                 => clk_1mhz,    -- system clock
                          reset_ch3               => rst_chk_tms_s(14),     -- sync reset active high
                                              
                          errcnt_rst4ch           => errcnt_rst4ch(3),
                          
                          prbs_in_ch0         => tms_s_i_pl(11), 
                          prbs_in_ch1         => tms_s_i_pl(12),
                          prbs_in_ch2         => tms_s_i_pl(13),
                          prbs_in_ch3         => tms_s_i_pl(14),
                          
                          err_detect_ch0      => tms_err_load(11),
                          err_detect_ch1      => tms_err_load(12),
                          err_detect_ch2      => tms_err_load(13),
                          err_detect_ch3      => tms_err_load(14)
                        );

prbs_chk_jtags_3tms1tck_inst: prbs_chk_4ch 
                   generic map ( 
                                   CHK_MODE        => TRUE,
                                   INV_PATTERN     => FALSE,
                                   POLY_LENGHT     => 31,
                                   POLY_TAP        => 28,
                                   NBITS           => 40
                               )
                  port map (
                          clk_ch0                 => clk_1mhz,
                          reset_ch0               => rst_chk_tms_s(15),        
                          clk_ch1                 => clk_1mhz,     -- system clock
                          reset_ch1               => rst_chk_tms_s(16),     -- sync reset active high
                          clk_ch2                 => clk_1mhz,    -- system clock
                          reset_ch2               => rst_chk_tms_s(17),     -- sync reset active high          
                          clk_ch3                 => clk_1mhz,    -- system clock
                          reset_ch3               => rst_chk_tck_s(0),     -- sync reset active high
                                              
                          errcnt_rst4ch           => errcnt_rst4ch(4),
                          
                          prbs_in_ch0         => tms_s_i_pl(15), 
                          prbs_in_ch1         => tms_s_i_pl(16),
                          prbs_in_ch2         => tms_s_i_pl(17),
                          prbs_in_ch3         => tck_s_i_pl(0),
                          
                          err_detect_ch0      => tms_err_load(15),
                          err_detect_ch1      => tms_err_load(16),
                          err_detect_ch2      => tms_err_load(17),
                          err_detect_ch3      => tck_err_load(0)
                        );                                                    

prbs_chk_jtags_4tck_inst: prbs_chk_4ch 
                   generic map ( 
                                   CHK_MODE        => TRUE,
                                   INV_PATTERN     => FALSE,
                                   POLY_LENGHT     => 31,
                                   POLY_TAP        => 28,
                                   NBITS           => 40
                               )
                  port map (
                          clk_ch0                 => clk_1mhz,
                          reset_ch0               => rst_chk_tck_s(1),        
                          clk_ch1                 => clk_1mhz,     -- system clock
                          reset_ch1               => rst_chk_tck_s(2),     -- sync reset active high
                          clk_ch2                 => clk_1mhz,    -- system clock
                          reset_ch2               => rst_chk_tck_s(3),     -- sync reset active high          
                          clk_ch3                 => clk_1mhz,    -- system clock
                          reset_ch3               => rst_chk_tck_s(4),     -- sync reset active high
                                              
                          errcnt_rst4ch           => errcnt_rst4ch(5),
                          
                          prbs_in_ch0         => tck_s_i_pl(1), 
                          prbs_in_ch1         => tck_s_i_pl(2),
                          prbs_in_ch2         => tck_s_i_pl(3),
                          prbs_in_ch3         => tck_s_i_pl(5),
                          
                          err_detect_ch0      => tck_err_load(1),
                          err_detect_ch1      => tck_err_load(2),
                          err_detect_ch2      => tck_err_load(3),
                          err_detect_ch3      => tck_err_load(4)
                        );

prbs_chk_jtags_4tck_inst1: prbs_chk_4ch 
                   generic map ( 
                                   CHK_MODE        => TRUE,
                                   INV_PATTERN     => FALSE,
                                   POLY_LENGHT     => 31,
                                   POLY_TAP        => 28,
                                   NBITS           => 40
                               )
                  port map (
                          clk_ch0                 => clk_1mhz,
                          reset_ch0               => rst_chk_tck_s(5),        
                          clk_ch1                 => clk_1mhz,     -- system clock
                          reset_ch1               => rst_chk_tck_s(6),     -- sync reset active high
                          clk_ch2                 => clk_1mhz,    -- system clock
                          reset_ch2               => rst_chk_tck_s(7),     -- sync reset active high          
                          clk_ch3                 => clk_1mhz,    -- system clock
                          reset_ch3               => rst_chk_tck_s(8),     -- sync reset active high
                                              
                          errcnt_rst4ch           => errcnt_rst4ch(6),
                          
                          prbs_in_ch0         => tck_s_i_pl(5), 
                          prbs_in_ch1         => tck_s_i_pl(6),
                          prbs_in_ch2         => tck_s_i_pl(7),
                          prbs_in_ch3         => tck_s_i_pl(8),
                          
                          err_detect_ch0      => tck_err_load(5),
                          err_detect_ch1      => tck_err_load(6),
                          err_detect_ch2      => tck_err_load(7),
                          err_detect_ch3      => tck_err_load(8)
                        );
                                                

prbs_chk_jtags_4tck_inst2: prbs_chk_4ch 
                   generic map ( 
                                   CHK_MODE        => TRUE,
                                   INV_PATTERN     => FALSE,
                                   POLY_LENGHT     => 31,
                                   POLY_TAP        => 28,
                                   NBITS           => 40
                               )
                  port map (
                          clk_ch0                 => clk_1mhz,
                          reset_ch0               => rst_chk_tck_s(9),        
                          clk_ch1                 => clk_1mhz,     -- system clock
                          reset_ch1               => rst_chk_tck_s(10),     -- sync reset active high
                          clk_ch2                 => clk_1mhz,    -- system clock
                          reset_ch2               => rst_chk_tck_s(11),     -- sync reset active high          
                          clk_ch3                 => clk_1mhz,    -- system clock
                          reset_ch3               => rst_chk_tck_s(12),     -- sync reset active high
                                              
                          errcnt_rst4ch           => errcnt_rst4ch(7),
                          
                          prbs_in_ch0         => tck_s_i_pl(9), 
                          prbs_in_ch1         => tck_s_i_pl(10),
                          prbs_in_ch2         => tck_s_i_pl(11),
                          prbs_in_ch3         => tck_s_i_pl(12),
                          
                          err_detect_ch0      => tck_err_load(9),
                          err_detect_ch1      => tck_err_load(10),
                          err_detect_ch2      => tck_err_load(11),
                          err_detect_ch3      => tck_err_load(12)
                        );

prbs_chk_jtags_4tck_inst3: prbs_chk_4ch 
                   generic map ( 
                                   CHK_MODE        => TRUE,
                                   INV_PATTERN     => FALSE,
                                   POLY_LENGHT     => 31,
                                   POLY_TAP        => 28,
                                   NBITS           => 40
                               )
                  port map (
                          clk_ch0                 => clk_1mhz,
                          reset_ch0               => rst_chk_tck_s(13),        
                          clk_ch1                 => clk_1mhz,     -- system clock
                          reset_ch1               => rst_chk_tck_s(14),     -- sync reset active high
                          clk_ch2                 => clk_1mhz,    -- system clock
                          reset_ch2               => rst_chk_tck_s(15),     -- sync reset active high          
                          clk_ch3                 => clk_1mhz,    -- system clock
                          reset_ch3               => rst_chk_tck_s(16),     -- sync reset active high
                                              
                          errcnt_rst4ch           => errcnt_rst4ch(8),
                          
                          prbs_in_ch0         => tck_s_i_pl(13), 
                          prbs_in_ch1         => tck_s_i_pl(14),
                          prbs_in_ch2         => tck_s_i_pl(15),
                          prbs_in_ch3         => tck_s_i_pl(16),
                          
                          err_detect_ch0      => tck_err_load(13),
                          err_detect_ch1      => tck_err_load(14),
                          err_detect_ch2      => tck_err_load(15),
                          err_detect_ch3      => tck_err_load(16)
                        );
                                                    
prbs_chk_jtags_1tck3ttc_inst3: prbs_chk_4ch 
                   generic map ( 
                                   CHK_MODE        => TRUE,
                                   INV_PATTERN     => FALSE,
                                   POLY_LENGHT     => 31,
                                   POLY_TAP        => 28,
                                   NBITS           => 40
                               )
                  port map (
                          clk_ch0                 => clk_1mhz,
                          reset_ch0               => rst_chk_tck_s(17),        
                          clk_ch1                 => clk_2mhz,     -- system clock
                          reset_ch1               => rst_chk_elinkttc(0),     -- sync reset active high
                          clk_ch2                 => clk_2mhz,    -- system clock
                          reset_ch2               => rst_chk_elinkttc(1),     -- sync reset active high          
                          clk_ch3                 => clk_2mhz,    -- system clock
                          reset_ch3               => rst_chk_elinkttc(2),     -- sync reset active high
                                              
                          errcnt_rst4ch           => errcnt_rst4ch(9),
                          
                          prbs_in_ch0         => tck_s_i_pl(17), 
                          prbs_in_ch1         => elink_TTCin_pl(0),
                          prbs_in_ch2         => elink_TTCin_pl(1),
                          prbs_in_ch3         => elink_TTCin_pl(2),
                          
                          err_detect_ch0      => tck_err_load(17),
                          err_detect_ch1      => elink_TTCin_err_load(0),
                          err_detect_ch2      => elink_TTCin_err_load(1),
                          err_detect_ch3      => elink_TTCin_err_load(2)
                        );
                        

prbs_chk_jtags_3ttc_inst3: prbs_chk_4ch 
                   generic map ( 
                                   CHK_MODE        => TRUE,
                                   INV_PATTERN     => FALSE,
                                   POLY_LENGHT     => 31,
                                   POLY_TAP        => 28,
                                   NBITS           => 40
                               )
                  port map (
                          clk_ch0                 => clk_2mhz,
                          reset_ch0               => rst_chk_elinkttc(3),        
                          clk_ch1                 => clk_2mhz,     -- system clock
                          reset_ch1               => rst_chk_elinkttc(4),     -- sync reset active high
                          clk_ch2                 => clk_2mhz,    -- system clock
                          reset_ch2               => rst_chk_elinkttc(5),     -- sync reset active high          
                          clk_ch3                 => clk_2mhz,    -- system clock
                          reset_ch3               => rst_chk_elinkttc(5),     -- N/A
                                              
                          errcnt_rst4ch           => errcnt_rst4ch(10),
                          
                          prbs_in_ch0         => elink_TTCin_pl(3), 
                          prbs_in_ch1         => elink_TTCin_pl(4),
                          prbs_in_ch2         => elink_TTCin_pl(5),
                          prbs_in_ch3         => elink_TTCin_pl(5), --N/A
                          
                          err_detect_ch0      => elink_TTCin_err_load(3),
                          err_detect_ch1      => elink_TTCin_err_load(4),
                          err_detect_ch2      => elink_TTCin_err_load(5),
                          err_detect_ch3      => OPEN
                        );
--        rst_piso                   : in std_logic;
--        rst_sipo                   : in std_logic;



--sipo_tdom40_inst: process (clk_40mhz)
--                    begin
--                        if rst_logic = '1' then
--                           tdo_master_i_pl_tmp  <= (others => '0');
                           
--                        elsif rising_edge (clk_40mhz) then
--                            tdo_master_i_pl_tmp (39 downto 1)   <= tdo_master_i_pl (38 downto 0);
--                            tdo_master_i_pl_tmp (0)             <= tdo_master_i;
--                        end if;
--                  end process;
 sipo_tdom40_inst: process (clk_40mhz)
                    begin
                    if falling_edge (clk_40mhz) then
                        if rst_logic = '1' then
                           tdo_master_i_pl_tmp  <= (others => '0');
                        else
                            tdo_master_i_pl_tmp (38 downto 0)   <= tdo_master_i_pl_tmp (39 downto 1);
                            tdo_master_i_pl_tmp (39)             <= tdo_master_i;
                        end if;
                    end if;
                  end process;
                  
 sipo_tdom40_inst_load:process(clk_40mhz)
 begin
           if falling_edge (clk_40mhz) then
              if rst_logic = '1' or sipo_cnt="100111" then
                 sipo_cnt <=(others=>'0');
                 tdo_master_i_pl <= tdo_master_i_pl_tmp;
              else 
                 sipo_cnt <= sipo_cnt + '1';
              end if;
            end if;
  end process;



sipo_tms40_gen: for i in 0 to 17 generate
                    begin
                        process (clk_40mhz)
                            begin
                                if falling_edge (clk_40mhz) then
                                    if rst_logic = '1' then
                                        tms_s_i_pl_tmp(i)  <= (others => '0');                                   
                                    else
                                        tms_s_i_pl_tmp(i)(38 downto 0)   <= tms_s_i_pl_tmp(i)(39 downto 1);
                                        tms_s_i_pl_tmp(i)(39)             <= tms_slave_i(i);
                                    end if;
                                end if;
                            end process;  
                    end generate;  

sipo_tms40_gen_load: for i in 0 to 17 generate
                    begin
                        process (clk_40mhz)
                            begin
                                if falling_edge (clk_40mhz) then
                                    if rst_logic = '1' or tms_s_i_pl_cnt(i)="100111" then
                                        tms_s_i_pl_cnt(i)  <= (others => '0');
                                        tms_s_i_pl(i) <= tms_s_i_pl_tmp(i);                                   
                                    else
                                        tms_s_i_pl_cnt(i) <= tms_s_i_pl_cnt(i) +'1';
                                    end if;
                                end if;
                            end process;  
                    end generate;     


--sipo_tck40_gen: for i in 0 to 17 generate
--                    begin
--                        process (clk_40mhz)
--                            begin
--                                if rst_logic = '1' then
--                                    tck_s_i_pl(i)  <= (others => '0');                                   
--                                elsif rising_edge (clk_40mhz) then
--                                    tck_s_i_pl(i)(39 downto 1)   <= tck_s_i_pl(i)(38 downto 0);
--                                    tck_s_i_pl(i)(0)             <= tck_slave_i(i);
--                                end if;
--                            end process;  
--                    end generate;   




sipo_tck40_gen: for i in 0 to 17 generate
                    begin
                        process (clk_40mhz)
                            begin
                                if falling_edge (clk_40mhz) then
                                    if rst_logic = '1' then
                                        tck_s_i_pl_tmp(i)  <= (others => '0');                                   
                                    else
                                        tck_s_i_pl_tmp(i)(38 downto 0)   <= tck_s_i_pl_tmp(i)(39 downto 1);
                                        tck_s_i_pl_tmp(i)(39)             <= tck_slave_i(i);
                                    end if;
                                end if;
                            end process;  
                    end generate;  

sipo_tck40_gen_load: for i in 0 to 17 generate
                    begin
                        process (clk_40mhz)
                            begin
                                if falling_edge (clk_40mhz) then
                                    if rst_logic = '1' or tck_s_i_pl_cnt(i)="100111" then
                                        tck_s_i_pl_cnt(i)  <= (others => '0');
                                        tck_s_i_pl(i) <= tck_s_i_pl_tmp(i);                                   
                                    else
                                        tck_s_i_pl_cnt(i) <= tck_s_i_pl_cnt(i) +'1';
                                    end if;
                                end if;
                            end process;  
                    end generate; 

--sipo_ttc_gen: for i in 0 to 5 generate
--                    begin
--                        process (clk_80mhz)
--                            begin
--                                if rst_logic = '1' then
--                                    elink_TTCin_pl(i)  <= (others => '0');                                   
--                                elsif rising_edge (clk_80mhz) then
--                                    elink_TTCin_pl(i)(39 downto 1)   <= elink_TTCin_pl(i)(38 downto 0);
--                                    elink_TTCin_pl(i)(0)             <= mezz_enc_in(i);
--                                end if;
--                            end process;  
--                    end generate;   
                                        
sipo_ttc_gen: for i in 0 to 5 generate
                    begin
                        process (clk_80mhz)
                            begin
                                if falling_edge (clk_80mhz) then
                                    if rst_logic = '1' then
                                        elink_TTCin_pl_tmp(i)  <= (others => '0');                                   
                                    else
                                        elink_TTCin_pl_tmp(i)(38 downto 0)   <= elink_TTCin_pl_tmp(i)(39 downto 1);
                                        elink_TTCin_pl_tmp(i)(39)             <= mezz_enc_in(i);
                                    end if;
                                end if;
                            end process;  
                    end generate;  

sipo_ttc_gen_load: for i in 0 to 5 generate
                    begin
                        process (clk_80mhz)
                            begin
                                if falling_edge (clk_80mhz) then
                                    if rst_logic = '1' or elink_TTCin_pl_cnt(i)="100111" then
                                        elink_TTCin_pl_cnt(i)  <= (others => '0');
                                        elink_TTCin_pl(i) <= elink_TTCin_pl_tmp(i);                                   
                                    else
                                        elink_TTCin_pl_cnt(i) <= elink_TTCin_pl_cnt(i) +'1';
                                    end if;
                                end if;
                            end process;  
                    end generate; 
                                            
                                                                                    
end Behavioral;
