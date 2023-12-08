

# j11, j12
set_property PACKAGE_PIN L25 [get_ports sma_clk_p];
set_property IOSTANDARD LVDS_25 [get_ports sma_clk_p];
set_property PACKAGE_PIN K25 [get_ports sma_clk_n];
set_property IOSTANDARD LVDS_25 [get_ports sma_clk_n];

# osc 200MHz
#set_property PACKAGE_PIN AD12 [get_ports osc_clk_p];
#set_property IOSTANDARD DIFF_SSTL15 [get_ports osc_clk_p];
#set_property PACKAGE_PIN AD11 [get_ports osc_clk_n];
#set_property IOSTANDARD DIFF_SSTL15 [get_ports osc_clk_n];
set_property PACKAGE_PIN K28 [get_ports osc_clk_p];
set_property IOSTANDARD LVDS_25 [get_ports osc_clk_p];
set_property PACKAGE_PIN K29 [get_ports osc_clk_n];
set_property IOSTANDARD LVDS_25 [get_ports osc_clk_n];
# JTAG Daisychain 18bits
set_property PACKAGE_PIN A22 [get_ports jtag_daisychain[0]];
set_property IOSTANDARD LVCMOS25 [get_ports jtag_daisychain[0]];

set_property PACKAGE_PIN B22 [get_ports jtag_daisychain[1]];
set_property IOSTANDARD LVCMOS25 [get_ports jtag_daisychain[1]];

set_property PACKAGE_PIN E21 [get_ports jtag_daisychain[2]];
set_property IOSTANDARD LVCMOS25 [get_ports jtag_daisychain[2]];

set_property PACKAGE_PIN F21 [get_ports jtag_daisychain[3]];
set_property IOSTANDARD LVCMOS25 [get_ports jtag_daisychain[3]];

set_property PACKAGE_PIN H30 [get_ports jtag_daisychain[4]];
set_property IOSTANDARD LVCMOS25 [get_ports jtag_daisychain[4]];

set_property PACKAGE_PIN G30 [get_ports jtag_daisychain[5]];
set_property IOSTANDARD LVCMOS25 [get_ports jtag_daisychain[5]];

set_property PACKAGE_PIN G29 [get_ports jtag_daisychain[6]];
set_property IOSTANDARD LVCMOS25 [get_ports jtag_daisychain[6]];

set_property PACKAGE_PIN F30 [get_ports jtag_daisychain[7]];
set_property IOSTANDARD LVCMOS25 [get_ports jtag_daisychain[7]];

set_property PACKAGE_PIN L16 [get_ports jtag_daisychain[8]];
set_property IOSTANDARD LVCMOS25 [get_ports jtag_daisychain[8]];

set_property PACKAGE_PIN K16 [get_ports jtag_daisychain[9]];
set_property IOSTANDARD LVCMOS25 [get_ports jtag_daisychain[9]];

set_property PACKAGE_PIN D29 [get_ports jtag_daisychain[10]];
set_property IOSTANDARD LVCMOS25 [get_ports jtag_daisychain[10]];

set_property PACKAGE_PIN C30 [get_ports jtag_daisychain[11]];
set_property IOSTANDARD LVCMOS25 [get_ports jtag_daisychain[11]];

set_property PACKAGE_PIN B30 [get_ports jtag_daisychain[12]];
set_property IOSTANDARD LVCMOS25 [get_ports jtag_daisychain[12]];

set_property PACKAGE_PIN A30 [get_ports jtag_daisychain[13]];
set_property IOSTANDARD LVCMOS25 [get_ports jtag_daisychain[13]];

set_property PACKAGE_PIN A25 [get_ports jtag_daisychain[14]];
set_property IOSTANDARD LVCMOS25 [get_ports jtag_daisychain[14]];

set_property PACKAGE_PIN A26 [get_ports jtag_daisychain[15]];
set_property IOSTANDARD LVCMOS25 [get_ports jtag_daisychain[15]];

set_property PACKAGE_PIN B28 [get_ports jtag_daisychain[16]];
set_property IOSTANDARD LVCMOS25 [get_ports jtag_daisychain[16]];

set_property PACKAGE_PIN A28 [get_ports jtag_daisychain[17]];
set_property IOSTANDARD LVCMOS25 [get_ports jtag_daisychain[17]];

## jtag master from KC705 OUT
set_property PACKAGE_PIN B18 [get_ports tdi_master_o];
set_property IOSTANDARD LVCMOS25 [get_ports tdi_master_o];
set_property PACKAGE_PIN A18 [get_ports tdo_master_i];
set_property IOSTANDARD LVCMOS25 [get_ports tdo_master_i];
set_property PACKAGE_PIN C19 [get_ports tms_master_o];
set_property IOSTANDARD LVCMOS25 [get_ports tms_master_o];
set_property PACKAGE_PIN B19 [get_ports tck_master_o];
set_property IOSTANDARD LVCMOS25 [get_ports tck_master_o];

## jtag slave to KC705 IN
set_property PACKAGE_PIN D16 [get_ports tdi_slave_i[0]];
set_property IOSTANDARD LVCMOS25 [get_ports tdi_slave_i[0]];
set_property PACKAGE_PIN C16 [get_ports tdo_slave_o[0]];
set_property IOSTANDARD LVCMOS25 [get_ports tdo_slave_o[0]];
set_property PACKAGE_PIN C22 [get_ports tms_slave_i[0]];
set_property IOSTANDARD LVCMOS25 [get_ports tms_slave_i[0]];
set_property PACKAGE_PIN D22 [get_ports tck_slave_i[0]];
set_property IOSTANDARD LVCMOS25 [get_ports tck_slave_i[0]];        

set_property PACKAGE_PIN D21 [get_ports tdi_slave_i[1]];
set_property IOSTANDARD LVCMOS25 [get_ports tdi_slave_i[1]];
set_property PACKAGE_PIN C21 [get_ports tdo_slave_o[1]];
set_property IOSTANDARD LVCMOS25 [get_ports tdo_slave_o[1]];
set_property PACKAGE_PIN D19 [get_ports tms_slave_i[1]];
set_property IOSTANDARD LVCMOS25 [get_ports tms_slave_i[1]];
set_property PACKAGE_PIN E19 [get_ports tck_slave_i[1]];
set_property IOSTANDARD LVCMOS25 [get_ports tck_slave_i[1]];  

set_property PACKAGE_PIN G18 [get_ports tdi_slave_i[2]];
set_property IOSTANDARD LVCMOS25 [get_ports tdi_slave_i[2]];
set_property PACKAGE_PIN F18 [get_ports tdo_slave_o[2]];
set_property IOSTANDARD LVCMOS25 [get_ports tdo_slave_o[2]];
set_property PACKAGE_PIN A21 [get_ports tms_slave_i[2]];
set_property IOSTANDARD LVCMOS25 [get_ports tms_slave_i[2]];
set_property PACKAGE_PIN A20 [get_ports tck_slave_i[2]];
set_property IOSTANDARD LVCMOS25 [get_ports tck_slave_i[2]];    

set_property PACKAGE_PIN L11 [get_ports tdi_slave_i[3]];
set_property IOSTANDARD LVCMOS25 [get_ports tdi_slave_i[3]];
set_property PACKAGE_PIN K11 [get_ports tdo_slave_o[3]];
set_property IOSTANDARD LVCMOS25 [get_ports tdo_slave_o[3]];
set_property PACKAGE_PIN A17 [get_ports tms_slave_i[3]];
set_property IOSTANDARD LVCMOS25 [get_ports tms_slave_i[3]];
set_property PACKAGE_PIN A16 [get_ports tck_slave_i[3]];
set_property IOSTANDARD LVCMOS25 [get_ports tck_slave_i[3]];  

set_property PACKAGE_PIN H21 [get_ports tdi_slave_i[4]];
set_property IOSTANDARD LVCMOS25 [get_ports tdi_slave_i[4]];
set_property PACKAGE_PIN H22 [get_ports tdo_slave_o[4]];
set_property IOSTANDARD LVCMOS25 [get_ports tdo_slave_o[4]];
set_property PACKAGE_PIN B15 [get_ports tms_slave_i[4]];
set_property IOSTANDARD LVCMOS25 [get_ports tms_slave_i[4]];
set_property PACKAGE_PIN C15 [get_ports tck_slave_i[4]];
set_property IOSTANDARD LVCMOS25 [get_ports tck_slave_i[4]]; 

set_property PACKAGE_PIN H15 [get_ports tdi_slave_i[5]];
set_property IOSTANDARD LVCMOS25 [get_ports tdi_slave_i[5]];
set_property PACKAGE_PIN G15 [get_ports tdo_slave_o[5]];
set_property IOSTANDARD LVCMOS25 [get_ports tdo_slave_o[5]];
set_property PACKAGE_PIN H12 [get_ports tms_slave_i[5]];
set_property IOSTANDARD LVCMOS25 [get_ports tms_slave_i[5]];
set_property PACKAGE_PIN H11 [get_ports tck_slave_i[5]];
set_property IOSTANDARD LVCMOS25 [get_ports tck_slave_i[5]]; 

set_property PACKAGE_PIN C20 [get_ports tdi_slave_i[6]];
set_property IOSTANDARD LVCMOS25 [get_ports tdi_slave_i[6]];
set_property PACKAGE_PIN B20 [get_ports tdo_slave_o[6]];
set_property IOSTANDARD LVCMOS25 [get_ports tdo_slave_o[6]];
set_property PACKAGE_PIN F17 [get_ports tms_slave_i[6]];
set_property IOSTANDARD LVCMOS25 [get_ports tms_slave_i[6]];
set_property PACKAGE_PIN G17 [get_ports tck_slave_i[6]];
set_property IOSTANDARD LVCMOS25 [get_ports tck_slave_i[6]]; 

set_property PACKAGE_PIN C17 [get_ports tdi_slave_i[7]];
set_property IOSTANDARD LVCMOS25 [get_ports tdi_slave_i[7]];
set_property PACKAGE_PIN B17 [get_ports tdo_slave_o[7]];
set_property IOSTANDARD LVCMOS25 [get_ports tdo_slave_o[7]];
set_property PACKAGE_PIN F22 [get_ports tms_slave_i[7]];
set_property IOSTANDARD LVCMOS25 [get_ports tms_slave_i[7]];
set_property PACKAGE_PIN G22 [get_ports tck_slave_i[7]];
set_property IOSTANDARD LVCMOS25 [get_ports tck_slave_i[7]]; 
##
set_property PACKAGE_PIN J16 [get_ports tdi_slave_i[8]];
set_property IOSTANDARD LVCMOS25 [get_ports tdi_slave_i[8]];
set_property PACKAGE_PIN H16 [get_ports tdo_slave_o[8]];
set_property IOSTANDARD LVCMOS25 [get_ports tdo_slave_o[8]];
set_property PACKAGE_PIN K14 [get_ports tck_slave_i[8]];
set_property IOSTANDARD LVCMOS25 [get_ports tck_slave_i[8]];
set_property PACKAGE_PIN J14 [get_ports tms_slave_i[8]];
set_property IOSTANDARD LVCMOS25 [get_ports tms_slave_i[8]];

set_property PACKAGE_PIN D11 [get_ports tdi_slave_i[9]];
set_property IOSTANDARD LVCMOS25 [get_ports tdi_slave_i[9]];
set_property PACKAGE_PIN C11 [get_ports tdo_slave_o[9]];
set_property IOSTANDARD LVCMOS25 [get_ports tdo_slave_o[9]];
set_property PACKAGE_PIN D14 [get_ports tck_slave_i[9]];
set_property IOSTANDARD LVCMOS25 [get_ports tck_slave_i[9]];
set_property PACKAGE_PIN C14 [get_ports tms_slave_i[9]];
set_property IOSTANDARD LVCMOS25 [get_ports tms_slave_i[9]];

set_property PACKAGE_PIN A11 [get_ports tdi_slave_i[10]];
set_property IOSTANDARD LVCMOS25 [get_ports tdi_slave_i[10]];
set_property PACKAGE_PIN A12 [get_ports tdo_slave_o[10]];
set_property IOSTANDARD LVCMOS25 [get_ports tdo_slave_o[10]];
set_property PACKAGE_PIN G13 [get_ports tck_slave_i[10]];
set_property IOSTANDARD LVCMOS25 [get_ports tck_slave_i[10]];
set_property PACKAGE_PIN F13 [get_ports tms_slave_i[10]];
set_property IOSTANDARD LVCMOS25 [get_ports tms_slave_i[10]];  

set_property PACKAGE_PIN J11 [get_ports tdi_slave_i[11]];
set_property IOSTANDARD LVCMOS25 [get_ports tdi_slave_i[11]];
set_property PACKAGE_PIN J12 [get_ports tdo_slave_o[11]];
set_property IOSTANDARD LVCMOS25 [get_ports tdo_slave_o[11]];
set_property PACKAGE_PIN L12 [get_ports tck_slave_i[11]];
set_property IOSTANDARD LVCMOS25 [get_ports tck_slave_i[11]];
set_property PACKAGE_PIN L13 [get_ports tms_slave_i[11]];
set_property IOSTANDARD LVCMOS25 [get_ports tms_slave_i[11]]; 

set_property PACKAGE_PIN H24 [get_ports tdi_slave_i[12]];
set_property IOSTANDARD LVCMOS25 [get_ports tdi_slave_i[12]];
set_property PACKAGE_PIN H25 [get_ports tdo_slave_o[12]];
set_property IOSTANDARD LVCMOS25 [get_ports tdo_slave_o[12]];
set_property PACKAGE_PIN G28 [get_ports tck_slave_i[12]];
set_property IOSTANDARD LVCMOS25 [get_ports tck_slave_i[12]];
set_property PACKAGE_PIN F28 [get_ports tms_slave_i[12]];
set_property IOSTANDARD LVCMOS25 [get_ports tms_slave_i[12]]; 

set_property PACKAGE_PIN E28 [get_ports tdi_slave_i[13]];
set_property IOSTANDARD LVCMOS25 [get_ports tdi_slave_i[13]];
set_property PACKAGE_PIN D28 [get_ports tdo_slave_o[13]];
set_property IOSTANDARD LVCMOS25 [get_ports tdo_slave_o[13]];
set_property PACKAGE_PIN G27 [get_ports tck_slave_i[13]];
set_property IOSTANDARD LVCMOS25 [get_ports tck_slave_i[13]];
set_property PACKAGE_PIN F27 [get_ports tms_slave_i[13]];
set_property IOSTANDARD LVCMOS25 [get_ports tms_slave_i[13]];  

set_property PACKAGE_PIN C24 [get_ports tdi_slave_i[14]];
set_property IOSTANDARD LVCMOS25 [get_ports tdi_slave_i[14]];
set_property PACKAGE_PIN B24 [get_ports tdo_slave_o[14]];
set_property IOSTANDARD LVCMOS25 [get_ports tdo_slave_o[14]];
set_property PACKAGE_PIN C12 [get_ports tck_slave_i[14]];
set_property IOSTANDARD LVCMOS25 [get_ports tck_slave_i[14]];
set_property PACKAGE_PIN B12 [get_ports tms_slave_i[14]];
set_property IOSTANDARD LVCMOS25 [get_ports tms_slave_i[14]];

set_property PACKAGE_PIN B14 [get_ports tdi_slave_i[15]];
set_property IOSTANDARD LVCMOS25 [get_ports tdi_slave_i[15]];
set_property PACKAGE_PIN A15 [get_ports tdo_slave_o[15]];
set_property IOSTANDARD LVCMOS25 [get_ports tdo_slave_o[15]];
set_property PACKAGE_PIN B13 [get_ports tck_slave_i[15]];
set_property IOSTANDARD LVCMOS25 [get_ports tck_slave_i[15]];
set_property PACKAGE_PIN A13 [get_ports tms_slave_i[15]];
set_property IOSTANDARD LVCMOS25 [get_ports tms_slave_i[15]];

set_property PACKAGE_PIN H26 [get_ports tdi_slave_i[16]];
set_property IOSTANDARD LVCMOS25 [get_ports tdi_slave_i[16]];
set_property PACKAGE_PIN H27 [get_ports tdo_slave_o[16]];
set_property IOSTANDARD LVCMOS25 [get_ports tdo_slave_o[16]];
set_property PACKAGE_PIN E29 [get_ports tck_slave_i[16]];
set_property IOSTANDARD LVCMOS25 [get_ports tck_slave_i[16]];
set_property PACKAGE_PIN E30 [get_ports tms_slave_i[16]];
set_property IOSTANDARD LVCMOS25 [get_ports tms_slave_i[16]];

set_property PACKAGE_PIN C29 [get_ports tdi_slave_i[17]];
set_property IOSTANDARD LVCMOS25 [get_ports tdi_slave_i[17]];
set_property PACKAGE_PIN B29 [get_ports tdo_slave_o[17]];
set_property IOSTANDARD LVCMOS25 [get_ports tdo_slave_o[17]];
set_property PACKAGE_PIN B27 [get_ports tck_slave_i[17]];
set_property IOSTANDARD LVCMOS25 [get_ports tck_slave_i[17]];
set_property PACKAGE_PIN A27 [get_ports tms_slave_i[17]];
set_property IOSTANDARD LVCMOS25 [get_ports tms_slave_i[17]];

## USE MEZZ0 AS TTC source OUT   
set_property PACKAGE_PIN F20 [get_ports elink_TTC_out_p];
set_property IOSTANDARD LVDS_25 [get_ports elink_TTC_out_p];
set_property PACKAGE_PIN E20 [get_ports elink_TTC_out_n];
set_property IOSTANDARD LVDS_25 [get_ports elink_TTC_out_n];

## TTC FAN IN       
set_property PACKAGE_PIN H14 [get_ports mezz_enc_in_p[0]];
set_property IOSTANDARD LVDS_25 [get_ports mezz_enc_in_p[0]];
set_property PACKAGE_PIN G14 [get_ports mezz_enc_in_n[0]];
set_property IOSTANDARD LVDS_25 [get_ports mezz_enc_in_n[0]];

set_property PACKAGE_PIN F15 [get_ports mezz_enc_in_p[1]];
set_property IOSTANDARD LVDS_25 [get_ports mezz_enc_in_p[1]];
set_property PACKAGE_PIN E16 [get_ports mezz_enc_in_n[1]];
set_property IOSTANDARD LVDS_25 [get_ports mezz_enc_in_n[1]];

set_property PACKAGE_PIN D26 [get_ports mezz_enc_in_p[2]];
set_property IOSTANDARD LVDS_25 [get_ports mezz_enc_in_p[2]];
set_property PACKAGE_PIN C26 [get_ports mezz_enc_in_n[2]];
set_property IOSTANDARD LVDS_25 [get_ports mezz_enc_in_n[2]];

set_property PACKAGE_PIN F12 [get_ports mezz_enc_in_p[3]];
set_property IOSTANDARD LVDS_25 [get_ports mezz_enc_in_p[3]];
set_property PACKAGE_PIN E13 [get_ports mezz_enc_in_n[3]];
set_property IOSTANDARD LVDS_25 [get_ports mezz_enc_in_n[3]];

set_property PACKAGE_PIN L15 [get_ports mezz_enc_in_p[4]];
set_property IOSTANDARD LVDS_25 [get_ports mezz_enc_in_p[4]];
set_property PACKAGE_PIN K15 [get_ports mezz_enc_in_n[4]];
set_property IOSTANDARD LVDS_25 [get_ports mezz_enc_in_n[4]];

set_property PACKAGE_PIN K13 [get_ports mezz_enc_in_p[5]];
set_property IOSTANDARD LVDS_25 [get_ports mezz_enc_in_p[5]];
set_property PACKAGE_PIN J13 [get_ports mezz_enc_in_n[5]];
set_property IOSTANDARD LVDS_25 [get_ports mezz_enc_in_n[5]];


# multi_boot_top  j13 on KC705
set_property PACKAGE_PIN Y23 [get_ports multi_boot_top];
set_property IOSTANDARD LVCMOS25 [get_ports multi_boot_top];
#LED                        
#locked_top 
set_property PACKAGE_PIN AB8 [get_ports locked_top];
set_property IOSTANDARD LVCMOS15 [get_ports locked_top];

set_property PACKAGE_PIN D12 [get_ports design_number_minisas[0]];
set_property IOSTANDARD LVCMOS25 [get_ports design_number_minisas[0]];

set_property PACKAGE_PIN D13 [get_ports design_number_minisas[1]];
set_property IOSTANDARD LVCMOS25 [get_ports design_number_minisas[1]];

set_property PACKAGE_PIN F11 [get_ports design_number_minisas[2]];
set_property IOSTANDARD LVCMOS25 [get_ports design_number_minisas[2]];

set_property PACKAGE_PIN E11 [get_ports sem_fatalerr_minisas];
set_property IOSTANDARD LVCMOS25 [get_ports sem_fatalerr_minisas];

set_property PACKAGE_PIN E14 [get_ports sem_heartbeat_minisas];
set_property IOSTANDARD LVCMOS25 [get_ports sem_heartbeat_minisas];

set_property PACKAGE_PIN E15 [get_ports mbt_trigger_minisas];
set_property IOSTANDARD LVCMOS25 [get_ports mbt_trigger_minisas];

set_property PACKAGE_PIN D17 [get_ports rst_sma_FE];
set_property IOSTANDARD LVCMOS25 [get_ports rst_sma_FE];
