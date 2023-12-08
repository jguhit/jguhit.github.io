----------------------------------------------------------------------------------
-- Company: U OF M
-- Engineer: Xueye Hu
-- 
-- Create Date: 04/12/2021 11:40:22 AM
-- Design Name: 
-- Module Name: top - Behavioral
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

entity top is
  Port (
        
        sma_clk_p       : in std_logic;
        sma_clk_n       : in std_logic;

        osc_clk_p       : in std_logic;
        osc_clk_n       : in std_logic;        
        
        
        tdi_master_o              : out std_logic;
        tdo_master_i              : in std_logic;
        tms_master_o              : out std_logic;
        tck_master_o              : out std_logic;
             
        tdi_slave_i         : in std_logic_vector (17 downto 0);
        tdo_slave_o         : out std_logic_vector (17 downto 0);
        tms_slave_i         : in std_logic_vector (17 downto 0);
        tck_slave_i         : in std_logic_vector (17 downto 0);
                
        elink_TTC_out_p       : out std_logic;
        elink_TTC_out_n       : out std_logic; 
               
        mezz_enc_in_p         : in std_logic_vector (5 downto 0);
        mezz_enc_in_n         : in std_logic_vector (5 downto 0); 
        
        jtag_daisychain       : out std_logic_vector (17 downto 0);               
        
        multi_boot_top        : out std_logic;                        
        locked_top            : out std_logic;
        
        -- SEM status signals via miniSAS
        design_number_minisas   : in std_logic_vector(2 downto 0);
        sem_fatalerr_minisas    : in std_logic;
        sem_heartbeat_minisas   : in std_logic;
        
        mbt_trigger_minisas     : out std_logic;
        
        -- sma
        rst_sma_FE              : out std_logic;

        -- Following ports are added by xx
        -- Clock provide to ethernet modules
        clk_user_out              : out std_logic;
        use_ETH_CMD               : in std_logic;

        multi_boot_top_INNER      : in std_logic;
        rst_logic_INNER           : in std_logic;
        rst_gen_tdim_INNER        : in std_logic;
        rst_gen_tmsm_INNER        : in std_logic;
        rst_gen_tckm_INNER        : in std_logic;
        rst_gen_ttco_INNER        : in std_logic;
        rst_chk_tdo_m_INNER       : in std_logic;
        rst_chk_tms_s_INNER       : in std_logic_vector (17 downto 0);
        errcnt_rst4ch_INNER       : in std_logic_vector (10 downto 0);
        rst_chk_tck_s_INNER       : in std_logic_vector (17 downto 0);
        rst_chk_elinkttc_INNER    : in std_logic_vector (5 downto 0);
        errcnt_inj_INNER          : in std_logic;
        jtag_daisychain_INNER     : in std_logic_vector (17 downto 0);
        mbt_trigger_minisas_INNER : in std_logic;
        rst_sma_FE_INNER          : in std_logic;
        rst_clkdiv_INNER          : in std_logic;

        trig_enable               : out std_logic;
        result_out                : out std_logic_vector (1037 downto 0)




        );
end top;

architecture Behavioral of top is

component clk_wiz_0
port
 (-- Clock in ports
  -- Clock out ports
  clk_out1          : out    std_logic;
  clk_out2          : out    std_logic;
  clk_out3          : out    std_logic;
  -- Status and control signals
  reset             : in     std_logic;
  locked            : out    std_logic;
  clk_in1_p         : in     std_logic;
  clk_in1_n         : in     std_logic
 );
end component;


component mezz_jtag_emul is
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
end component;

COMPONENT vio_0
  PORT (
    clk : IN STD_LOGIC;
    probe_in0 : IN STD_LOGIC_VECTOR(23 DOWNTO 0);
    probe_in1 : IN STD_LOGIC_VECTOR(23 DOWNTO 0);
    probe_in2 : IN STD_LOGIC_VECTOR(23 DOWNTO 0);
    probe_in3 : IN STD_LOGIC_VECTOR(23 DOWNTO 0);
    probe_in4 : IN STD_LOGIC_VECTOR(23 DOWNTO 0);
    probe_in5 : IN STD_LOGIC_VECTOR(23 DOWNTO 0);
    probe_in6 : IN STD_LOGIC_VECTOR(23 DOWNTO 0);
    probe_in7 : IN STD_LOGIC_VECTOR(23 DOWNTO 0);
    probe_in8 : IN STD_LOGIC_VECTOR(23 DOWNTO 0);
    probe_in9 : IN STD_LOGIC_VECTOR(23 DOWNTO 0);
    probe_in10 : IN STD_LOGIC_VECTOR(23 DOWNTO 0);
    probe_in11 : IN STD_LOGIC_VECTOR(23 DOWNTO 0);
    probe_in12 : IN STD_LOGIC_VECTOR(23 DOWNTO 0);
    probe_in13 : IN STD_LOGIC_VECTOR(23 DOWNTO 0);
    probe_in14 : IN STD_LOGIC_VECTOR(23 DOWNTO 0);
    probe_in15 : IN STD_LOGIC_VECTOR(23 DOWNTO 0);
    probe_in16 : IN STD_LOGIC_VECTOR(23 DOWNTO 0);
    probe_in17 : IN STD_LOGIC_VECTOR(23 DOWNTO 0);
    probe_in18 : IN STD_LOGIC_VECTOR(23 DOWNTO 0);
    probe_in19 : IN STD_LOGIC_VECTOR(23 DOWNTO 0);
    probe_in20 : IN STD_LOGIC_VECTOR(23 DOWNTO 0);
    probe_in21 : IN STD_LOGIC_VECTOR(23 DOWNTO 0);
    probe_in22 : IN STD_LOGIC_VECTOR(23 DOWNTO 0);
    probe_in23 : IN STD_LOGIC_VECTOR(23 DOWNTO 0);
    probe_in24 : IN STD_LOGIC_VECTOR(23 DOWNTO 0);
    probe_in25 : IN STD_LOGIC_VECTOR(23 DOWNTO 0);
    probe_in26 : IN STD_LOGIC_VECTOR(23 DOWNTO 0);
    probe_in27 : IN STD_LOGIC_VECTOR(23 DOWNTO 0);
    probe_in28 : IN STD_LOGIC_VECTOR(23 DOWNTO 0);
    probe_in29 : IN STD_LOGIC_VECTOR(23 DOWNTO 0);
    probe_in30 : IN STD_LOGIC_VECTOR(23 DOWNTO 0);
    probe_in31 : IN STD_LOGIC_VECTOR(23 DOWNTO 0);
    probe_in32 : IN STD_LOGIC_VECTOR(23 DOWNTO 0);
    probe_in33 : IN STD_LOGIC_VECTOR(23 DOWNTO 0);
    probe_in34 : IN STD_LOGIC_VECTOR(23 DOWNTO 0);
    probe_in35 : IN STD_LOGIC_VECTOR(23 DOWNTO 0);
    probe_in36 : IN STD_LOGIC_VECTOR(23 DOWNTO 0);
    probe_in37 : IN STD_LOGIC_VECTOR(23 DOWNTO 0);
    probe_in38 : IN STD_LOGIC_VECTOR(23 DOWNTO 0);
    probe_in39 : IN STD_LOGIC_VECTOR(23 DOWNTO 0);
    probe_in40 : IN STD_LOGIC_VECTOR(23 DOWNTO 0);
    probe_in41 : IN STD_LOGIC_VECTOR(23 DOWNTO 0);
    probe_in42 : IN STD_LOGIC_VECTOR(23 DOWNTO 0);
    probe_in43 : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    probe_in44 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
    probe_in45 : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    probe_in46 : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    
    probe_out0 : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
    probe_out1 : OUT STD_LOGIC_VECTOR(5 DOWNTO 0);
    probe_out2 : OUT STD_LOGIC_VECTOR(17 DOWNTO 0);
    probe_out3 : OUT STD_LOGIC_VECTOR(10 DOWNTO 0);
    probe_out4 : OUT STD_LOGIC_VECTOR(17 DOWNTO 0);
    probe_out5 : OUT STD_LOGIC_VECTOR(5 DOWNTO 0);
    probe_out6 : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
    probe_out7 : OUT STD_LOGIC_VECTOR(17 DOWNTO 0);
    probe_out8 : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
    probe_out9 : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
    probe_out10 : OUT STD_LOGIC_VECTOR(0 DOWNTO 0)
  );
END COMPONENT;


signal clk_40mhz,clk_40mhz_tmp        : std_logic;
signal clk_80mhz        : std_logic;
signal clk_10mhz        : std_logic;
signal clk_1mhz,clk_1mhz_tmp         : std_logic;
signal clk_2mhz,clk_2mhz_tmp         : std_logic;

signal rst_logic_vio            : std_logic;
signal errcnt_inj_vio           : std_logic;
signal rst_gen_tdim_vio         : std_logic;
signal rst_gen_tmsm_vio         : std_logic;
signal rst_gen_tckm_vio         : std_logic;
signal rst_gen_ttco_vio         : std_logic;

signal rst_chk_tdo_m_vio         : std_logic;
signal rst_chk_tms_s_vio         : std_logic_vector(17 downto 0);
signal errcnt_rst4ch_vio         : std_logic_vector(10 downto 0);
signal rst_chk_tck_s_vio         : std_logic_vector(17 downto 0);
signal rst_chk_elinkttc_vio      : std_logic_vector(5 downto 0);

-- added by xx. wires connected to vio
signal multi_boot_top_tmp       : std_logic;
signal rst_logic_vio_tmp    : std_logic;
signal rst_gen_tdim_vio_tmp     : std_logic;
signal rst_gen_tmsm_vio_tmp     : std_logic;
signal rst_gen_tckm_vio_tmp     : std_logic;
signal rst_gen_ttco_vio_tmp     : std_logic;
signal rst_chk_tdo_m_vio_tmp    : std_logic;
signal rst_chk_tms_s_vio_tmp    : std_logic_vector (17 downto 0);
signal errcnt_rst4ch_vio_tmp    : std_logic_vector (10 downto 0);
signal rst_chk_tck_s_vio_tmp    : std_logic_vector (17 downto 0);
signal rst_chk_elinkttc_vio_tmp : std_logic_vector (5 downto 0);
signal errcnt_inj_vio_tmp       : std_logic;
signal jtag_daisychain_tmp      : std_logic_vector (17 downto 0);
signal mbt_trigger_minisas_tmp  : std_logic;
signal rst_sma_FE_tmp           : std_logic;
signal rst_clkdiv_tmp           : std_logic;

signal elink_TTC_out             : std_logic;
signal mezz_enc_in               : std_logic_vector (5 downto 0);

signal tdo_m_err_reg_vio               : std_logic_vector (23 downto 0);
signal tms_err_reg_0_vio               : std_logic_vector (23 downto 0);
signal tms_err_reg_1_vio               : std_logic_vector (23 downto 0);
signal tms_err_reg_2_vio               : std_logic_vector (23 downto 0);
signal tms_err_reg_3_vio               : std_logic_vector (23 downto 0);
signal tms_err_reg_4_vio               : std_logic_vector (23 downto 0);
signal tms_err_reg_5_vio               : std_logic_vector (23 downto 0);
signal tms_err_reg_6_vio               : std_logic_vector (23 downto 0);
signal tms_err_reg_7_vio               : std_logic_vector (23 downto 0);
signal tms_err_reg_8_vio               : std_logic_vector (23 downto 0);
signal tms_err_reg_9_vio               : std_logic_vector (23 downto 0);
signal tms_err_reg_10_vio               : std_logic_vector (23 downto 0);
signal tms_err_reg_11_vio               : std_logic_vector (23 downto 0);
signal tms_err_reg_12_vio               : std_logic_vector (23 downto 0);
signal tms_err_reg_13_vio               : std_logic_vector (23 downto 0);
signal tms_err_reg_14_vio               : std_logic_vector (23 downto 0);
signal tms_err_reg_15_vio               : std_logic_vector (23 downto 0);
signal tms_err_reg_16_vio               : std_logic_vector (23 downto 0);
signal tms_err_reg_17_vio               : std_logic_vector (23 downto 0);

signal tck_err_reg_0_vio               : std_logic_vector (23 downto 0);
signal tck_err_reg_1_vio               : std_logic_vector (23 downto 0);
signal tck_err_reg_2_vio               : std_logic_vector (23 downto 0);
signal tck_err_reg_3_vio               : std_logic_vector (23 downto 0);
signal tck_err_reg_4_vio               : std_logic_vector (23 downto 0);
signal tck_err_reg_5_vio               : std_logic_vector (23 downto 0);
signal tck_err_reg_6_vio               : std_logic_vector (23 downto 0);
signal tck_err_reg_7_vio               : std_logic_vector (23 downto 0);
signal tck_err_reg_8_vio               : std_logic_vector (23 downto 0);
signal tck_err_reg_9_vio               : std_logic_vector (23 downto 0);
signal tck_err_reg_10_vio               : std_logic_vector (23 downto 0);
signal tck_err_reg_11_vio               : std_logic_vector (23 downto 0);
signal tck_err_reg_12_vio               : std_logic_vector (23 downto 0);
signal tck_err_reg_13_vio               : std_logic_vector (23 downto 0);
signal tck_err_reg_14_vio               : std_logic_vector (23 downto 0);
signal tck_err_reg_15_vio               : std_logic_vector (23 downto 0);
signal tck_err_reg_16_vio               : std_logic_vector (23 downto 0);
signal tck_err_reg_17_vio               : std_logic_vector (23 downto 0);

signal elink_TTCin_err_reg_0_vio               : std_logic_vector (23 downto 0);                
signal elink_TTCin_err_reg_1_vio               : std_logic_vector (23 downto 0);    
signal elink_TTCin_err_reg_2_vio               : std_logic_vector (23 downto 0);    
signal elink_TTCin_err_reg_3_vio               : std_logic_vector (23 downto 0);    
signal elink_TTCin_err_reg_4_vio               : std_logic_vector (23 downto 0);    
signal elink_TTCin_err_reg_5_vio               : std_logic_vector (23 downto 0);    
                
signal lock_pll, locked_vio             : std_logic;     
-- cnt = (in_freq/out_freq)/2 -1           
signal clkdiv_cnt1       : std_logic_vector(5 downto 0);
signal clkdiv_cnt2       : std_logic_vector(5 downto 0);
signal clkdiv_cnt3       : std_logic_vector(10 downto 0);
signal rst_clkdiv        : std_logic;

signal trig_en_vec       : std_logic_vector(2 downto 0); 
signal trig_cnt          : std_logic_vector(23 downto 0); 

begin



OBUFDS_inst : OBUFDS
   generic map (
      IOSTANDARD => "DEFAULT", -- Specify the output I/O standard
      SLEW => "SLOW")          -- Specify the output slew rate
   port map (
      O => elink_TTC_out_p,     -- Diff_p output (connect directly to top-level port)
      OB => elink_TTC_out_n,   -- Diff_n output (connect directly to top-level port)
      I => elink_TTC_out      -- Buffer input 
   );
         


IBUF_mezzenc_gen: for i in 0 to 5 generate
                        begin
                            IBUFDS_inst : IBUFDS
                               generic map (
                                  DIFF_TERM => TRUE, -- Differential Termination 
                                  IBUF_LOW_PWR => TRUE, -- Low power (TRUE) vs. performance (FALSE) setting for referenced I/O standards
                                  IOSTANDARD => "LVDS_25")
                               port map (
                                  O => mezz_enc_in(i),  -- Buffer output
                                  I => mezz_enc_in_p(i),  -- Diff_p buffer input (connect directly to top-level port)
                                  IB => mezz_enc_in_n(i) -- Diff_n buffer input (connect directly to top-level port)
                                    );
                     end generate;                            
            
--clk_40mhz <=  clk_80mhz;           
clk_gen_inst : clk_wiz_0
   port map ( 
  -- Clock out ports  
   clk_out1 => clk_80mhz,
   clk_out2 => clk_40mhz_tmp,
   clk_out3 => clk_10mhz,
  -- Status and control signals                
   reset =>  '0', --reset,
   locked => lock_pll, --locked_top,
   -- Clock in ports
   clk_in1_p => osc_clk_p, --sma_clk_p,
   clk_in1_n => osc_clk_n --sma_clk_n
 );

locked_top  <= lock_pll; 
locked_vio  <= lock_pll; 
clk_user_out   <= clk_80mhz; -- added by xx, provice clock to ehternet module

        
        


clkdiv_40mhzto2mhz_proc: process(clk_80mhz)
                            begin
                                if rising_edge (clk_80mhz) then
                                  if rst_clkdiv = '1' then
                                     clkdiv_cnt1   <= (others => '0');
                                     clk_2mhz_tmp     <= '0';
                                 elsif (clkdiv_cnt1 = "10011") then --19
                                     clk_2mhz_tmp <= not clk_2mhz_tmp;
                                     clkdiv_cnt1  <= (others => '0');
                                 else
                                    clkdiv_cnt1  <= clkdiv_cnt1 + '1';
                                        
                                 end if;
                                 end if;
                           end process;
   BUFG_inst_0 : BUFG
   port map (
      O => clk_2mhz, -- 1-bit output: Clock output
      I => clk_2mhz_tmp  -- 1-bit input: Clock input
   );
--clk_1mhz <= clk_2mhz;
process(clk_40mhz_tmp) begin
if rising_edge(clk_40mhz_tmp) then
     clkdiv_cnt3 <= clkdiv_cnt3 +'1';
end if;
end process;

BUFG_inst_1 : BUFG
   port map (
      O => clk_40mhz, -- 1-bit output: Clock output
      I => clkdiv_cnt3(10)  -- 1-bit input: Clock input
   );
   
clkdiv_40mhzto1mhz_proc: process(clk_40mhz)
                            begin
                                if rising_edge (clk_40mhz) then
                                  if rst_clkdiv = '1' then
                                     clkdiv_cnt2   <= (others => '0');
                                     clk_1mhz_tmp     <= '0';
                                 elsif (clkdiv_cnt2 = "10011") then --19
                                     clk_1mhz_tmp <= not clk_1mhz_tmp;
                                     clkdiv_cnt2  <= (others => '0');
                                 else
                                    clkdiv_cnt2  <= clkdiv_cnt2 + '1';
                                        
                                 end if;
                                 end if;
                           end process;
   BUFG_inst_2 : BUFG
   port map (
      O => clk_1mhz, -- 1-bit output: Clock output
      I => clk_1mhz_tmp  -- 1-bit input: Clock input
   );
   

--clkdiv_40mhzto1mhz_proc: process(clk_40mhz)
--                            begin
--                                if rst_clkdiv = '1' then
--                                   clkdiv_cnt2   <= (others => '0');
--                                   clk_1mhz     <= '0';
--                                elsif rising_edge (clk_40mhz) then
--                                    clkdiv_cnt2  <= clkdiv_cnt2 + '1';
--                                    if (clkdiv_cnt2 = "10011") then --19 
--                                        clk_1mhz <= not clk_1mhz;
--                                        clkdiv_cnt2  <= (others => '0');
--                                    end if;
--                                 end if;
--                           end process;



 mezz_jtag_emul_inst: mezz_jtag_emul
    Port map (
                clk_80mhz               => clk_80mhz,
                clk_40mhz               => clk_40mhz,
                clk_1mhz                => clk_1mhz,
                clk_2mhz                => clk_2mhz,
                rst_logic               => rst_logic_vio,
                
                errcnt_injerr(0)           => errcnt_inj_vio,
                
                rst_gen_tdim            => rst_gen_tdim_vio,
                rst_gen_tmsm            => rst_gen_tmsm_vio,
                rst_gen_tckm            => rst_gen_tckm_vio,
                rst_gen_ttco            => rst_gen_ttco_vio,  
                     
                tdi_master_o            => tdi_master_o, 
                tdo_master_i            => tdo_master_i, 
                tms_master_o            => tms_master_o, 
                tck_master_o            => tck_master_o, 
                
                
                rst_chk_tdo_m           => rst_chk_tdo_m_vio,
                rst_chk_tms_s           => rst_chk_tms_s_vio,      
                errcnt_rst4ch           => errcnt_rst4ch_vio,
                  
                rst_chk_tck_s           => rst_chk_tck_s_vio, 
                rst_chk_elinkttc        => rst_chk_elinkttc_vio,
                
                        
                tdi_slave_i         => tdi_slave_i, 
                tdo_slave_o         => tdo_slave_o, 
                tms_slave_i         => tms_slave_i, 
                tck_slave_i         => tck_slave_i, 
                
                elink_TTC_out       => elink_TTC_out, 
                mezz_enc_in         => mezz_enc_in, 
                
                tdo_m_err_reg       => tdo_m_err_reg_vio, 
                tms_err_reg_0       => tms_err_reg_0_vio,   
                tms_err_reg_1       => tms_err_reg_1_vio,  
                tms_err_reg_2       => tms_err_reg_2_vio,  
                tms_err_reg_3       => tms_err_reg_3_vio,         
                tms_err_reg_4       => tms_err_reg_4_vio,    
                tms_err_reg_5       => tms_err_reg_5_vio, 
                tms_err_reg_6       => tms_err_reg_6_vio,  
                tms_err_reg_7       => tms_err_reg_7_vio,         
                tms_err_reg_8       => tms_err_reg_8_vio,    
                tms_err_reg_9       => tms_err_reg_9_vio,   
                tms_err_reg_10      => tms_err_reg_10_vio,    
                tms_err_reg_11      => tms_err_reg_11_vio, 
                tms_err_reg_12      => tms_err_reg_12_vio,    
                tms_err_reg_13      => tms_err_reg_13_vio, 
                tms_err_reg_14      => tms_err_reg_14_vio,   
                tms_err_reg_15      => tms_err_reg_15_vio, 
                tms_err_reg_16      => tms_err_reg_16_vio,   
                tms_err_reg_17      => tms_err_reg_17_vio, 
                
                tck_err_reg_0       => tck_err_reg_0_vio,  
                tck_err_reg_1       => tck_err_reg_1_vio, 
                tck_err_reg_2       => tck_err_reg_2_vio,  
                tck_err_reg_3       => tck_err_reg_3_vio,        
                tck_err_reg_4       => tck_err_reg_4_vio,   
                tck_err_reg_5       => tck_err_reg_5_vio,  
                tck_err_reg_6       => tck_err_reg_6_vio,  
                tck_err_reg_7       => tck_err_reg_7_vio,         
                tck_err_reg_8       => tck_err_reg_8_vio,  
                tck_err_reg_9       => tck_err_reg_9_vio, 
                tck_err_reg_10      => tck_err_reg_10_vio,   
                tck_err_reg_11      => tck_err_reg_11_vio, 
                tck_err_reg_12      => tck_err_reg_12_vio,   
                tck_err_reg_13      => tck_err_reg_13_vio,  
                tck_err_reg_14      => tck_err_reg_14_vio,   
                tck_err_reg_15      => tck_err_reg_15_vio, 
                tck_err_reg_16      => tck_err_reg_16_vio,   
                tck_err_reg_17      => tck_err_reg_17_vio, 
                
                elink_TTCin_err_reg_0       => elink_TTCin_err_reg_0_vio, 
                elink_TTCin_err_reg_1       => elink_TTCin_err_reg_1_vio,
                elink_TTCin_err_reg_2       => elink_TTCin_err_reg_2_vio,
                elink_TTCin_err_reg_3       => elink_TTCin_err_reg_3_vio,
                elink_TTCin_err_reg_4       => elink_TTCin_err_reg_4_vio,                     
                elink_TTCin_err_reg_5       => elink_TTCin_err_reg_5_vio

               );

vio_inst : vio_0
  PORT MAP (
    clk => clk_80mhz,
    probe_in0 => tdo_m_err_reg_vio,
    
    probe_in1 => tms_err_reg_0_vio,
    probe_in2 => tms_err_reg_1_vio,
    probe_in3 => tms_err_reg_2_vio,
    probe_in4 => tms_err_reg_3_vio,
    probe_in5 => tms_err_reg_4_vio,
    probe_in6 => tms_err_reg_5_vio,
    probe_in7 => tms_err_reg_6_vio,
    probe_in8 => tms_err_reg_7_vio,
    probe_in9 => tms_err_reg_8_vio,
    probe_in10 => tms_err_reg_9_vio,
    probe_in11 => tms_err_reg_10_vio,
    probe_in12 => tms_err_reg_11_vio,
    probe_in13 => tms_err_reg_12_vio,
    probe_in14 => tms_err_reg_13_vio,
    probe_in15 => tms_err_reg_14_vio,
    probe_in16 => tms_err_reg_15_vio,
    probe_in17 => tms_err_reg_16_vio,
    probe_in18 => tms_err_reg_17_vio,
    
    probe_in19 => tck_err_reg_0_vio,
    probe_in20 => tck_err_reg_1_vio,
    probe_in21 => tck_err_reg_2_vio,
    probe_in22 => tck_err_reg_3_vio,
    probe_in23 => tck_err_reg_4_vio,
    probe_in24 => tck_err_reg_5_vio,
    probe_in25 => tck_err_reg_6_vio,
    probe_in26 => tck_err_reg_7_vio,
    probe_in27 => tck_err_reg_8_vio,
    probe_in28 => tck_err_reg_9_vio,
    probe_in29 => tck_err_reg_10_vio,
    probe_in30 => tck_err_reg_11_vio,
    probe_in31 => tck_err_reg_12_vio,
    probe_in32 => tck_err_reg_13_vio,
    probe_in33 => tck_err_reg_14_vio,
    probe_in34 => tck_err_reg_15_vio,
    probe_in35 => tck_err_reg_16_vio,
    probe_in36 => tck_err_reg_17_vio,
    
    probe_in37 => elink_TTCin_err_reg_0_vio,
    probe_in38 => elink_TTCin_err_reg_1_vio,
    probe_in39 => elink_TTCin_err_reg_2_vio,
    probe_in40 => elink_TTCin_err_reg_3_vio,
    probe_in41 => elink_TTCin_err_reg_4_vio,
    probe_in42 => elink_TTCin_err_reg_5_vio,
    probe_in43(0) => locked_vio,
    probe_in44    => design_number_minisas,
    probe_in45(0)    => sem_fatalerr_minisas,    
    probe_in46(0)    => sem_heartbeat_minisas,
                
    probe_out0(0) => multi_boot_top_tmp,
    
    probe_out1(0) => rst_logic_vio_tmp,
    probe_out1(1) => rst_gen_tdim_vio_tmp,
    probe_out1(2) => rst_gen_tmsm_vio_tmp,
    probe_out1(3) => rst_gen_tckm_vio_tmp,
    probe_out1(4) => rst_gen_ttco_vio_tmp,
    probe_out1(5) => rst_chk_tdo_m_vio_tmp,    

    probe_out2 => rst_chk_tms_s_vio_tmp, -- 17 downto 0              
    probe_out3 => errcnt_rst4ch_vio_tmp, -- 10 downto 0
    probe_out4 => rst_chk_tck_s_vio_tmp, -- 17 downto 0
    probe_out5 => rst_chk_elinkttc_vio_tmp, -- 5 downto 0
    probe_out6(0) => errcnt_inj_vio_tmp,
    probe_out7    => jtag_daisychain_tmp,
    probe_out8(0)    => mbt_trigger_minisas_tmp,
    probe_out9(0)    => rst_sma_FE_tmp,  
    probe_out10(0)    => rst_clkdiv_tmp      
  );

trig_en_gen: process(clk_2mhz) begin 
   if rising_edge (clk_2mhz) then 
     if rst_logic_vio='1' or trig_cnt(19) ='1' then 
         trig_cnt <= (others=>'0'); 
     else 
         trig_cnt <= trig_cnt + '1'; 
     end if; 
   end if; 
end process; 
          
          
----->>>>> clk_80 
----->>>>> trig_enable -- probe(47) 
trig_en_vec_proc: process(clk_80mhz) begin 
     if rising_edge(clk_80mhz) then 
         trig_en_vec <= trig_en_vec(1 downto 0) & trig_cnt(19); 
         trig_enable <= trig_en_vec(2) and (not trig_en_vec(1)); 
     end if; 
end process; 

-- Added by xx. 
  multi_boot_top       <= multi_boot_top_INNER when use_ETH_CMD = '1' else multi_boot_top_tmp;
  rst_logic_vio        <= rst_logic_INNER when use_ETH_CMD = '1' else rst_logic_vio_tmp;
  rst_gen_tdim_vio     <= rst_gen_tdim_INNER when use_ETH_CMD = '1' else rst_gen_tdim_vio_tmp;
  rst_gen_tmsm_vio     <= rst_gen_tmsm_INNER when use_ETH_CMD = '1' else rst_gen_tmsm_vio_tmp;
  rst_gen_tckm_vio     <= rst_gen_tckm_INNER when use_ETH_CMD = '1' else rst_gen_tckm_vio_tmp;
  rst_gen_ttco_vio     <= rst_gen_ttco_INNER when use_ETH_CMD = '1' else rst_gen_ttco_vio_tmp;
  rst_chk_tdo_m_vio    <= rst_chk_tdo_m_INNER when use_ETH_CMD = '1' else rst_chk_tdo_m_vio_tmp;
  rst_chk_tms_s_vio    <= rst_chk_tms_s_INNER when use_ETH_CMD = '1' else rst_chk_tms_s_vio_tmp;
  errcnt_rst4ch_vio    <= errcnt_rst4ch_INNER when use_ETH_CMD = '1' else errcnt_rst4ch_vio_tmp;
  rst_chk_tck_s_vio    <= rst_chk_tck_s_INNER when use_ETH_CMD = '1' else rst_chk_tck_s_vio_tmp;
  rst_chk_elinkttc_vio <= rst_chk_elinkttc_INNER when use_ETH_CMD = '1' else rst_chk_elinkttc_vio_tmp;
  errcnt_inj_vio       <= errcnt_inj_INNER when use_ETH_CMD = '1' else errcnt_inj_vio_tmp;
  jtag_daisychain      <= jtag_daisychain_INNER when use_ETH_CMD = '1' else jtag_daisychain_tmp;
  mbt_trigger_minisas  <= mbt_trigger_minisas_INNER when use_ETH_CMD = '1' else mbt_trigger_minisas_tmp;
  rst_sma_FE           <= rst_sma_FE_INNER when use_ETH_CMD = '1' else rst_sma_FE_tmp;
  rst_clkdiv           <= rst_clkdiv_INNER when use_ETH_CMD = '1' else rst_clkdiv_tmp;
    

  result_out <= sem_heartbeat_minisas &
        sem_fatalerr_minisas &   
        design_number_minisas &
        locked_vio &
        elink_TTCin_err_reg_5_vio &
        elink_TTCin_err_reg_4_vio &
        elink_TTCin_err_reg_3_vio &
        elink_TTCin_err_reg_2_vio &
        elink_TTCin_err_reg_1_vio &
        elink_TTCin_err_reg_0_vio &
        tck_err_reg_17_vio &
        tck_err_reg_16_vio &
        tck_err_reg_15_vio &
        tck_err_reg_14_vio &
        tck_err_reg_13_vio &
        tck_err_reg_12_vio &
        tck_err_reg_11_vio &
        tck_err_reg_10_vio &
        tck_err_reg_9_vio &
        tck_err_reg_8_vio &
        tck_err_reg_7_vio &
        tck_err_reg_6_vio &
        tck_err_reg_5_vio &
        tck_err_reg_4_vio &
        tck_err_reg_3_vio &
        tck_err_reg_2_vio &
        tck_err_reg_1_vio &
        tck_err_reg_0_vio &
        tms_err_reg_17_vio &
        tms_err_reg_16_vio &
        tms_err_reg_15_vio &
        tms_err_reg_14_vio &
        tms_err_reg_13_vio &
        tms_err_reg_12_vio &
        tms_err_reg_11_vio &
        tms_err_reg_10_vio &
        tms_err_reg_9_vio &
        tms_err_reg_8_vio &
        tms_err_reg_7_vio &
        tms_err_reg_6_vio &
        tms_err_reg_5_vio &
        tms_err_reg_4_vio &
        tms_err_reg_3_vio &
        tms_err_reg_2_vio &
        tms_err_reg_1_vio &
        tms_err_reg_0_vio &
        tdo_m_err_reg_vio;

end Behavioral;
