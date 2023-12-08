# PART is xc7k325tffg900-1

#
####
#######
##########
#############
#################
## System level constraints


########## GENERAL IO CONSTRAINTS FOR THE KC705 BOARD ##########
set_property PACKAGE_PIN AD12 [get_ports eth_clk_in_p]
set_property PACKAGE_PIN AD11 [get_ports eth_clk_in_n]
set_property IOSTANDARD LVDS [get_ports eth_clk_in_p]
set_property IOSTANDARD LVDS [get_ports eth_clk_in_n]


#set_property PACKAGE_PIN K28 [get_ports USER_CLOCK_P]
#set_property PACKAGE_PIN K29 [get_ports USER_CLOCK_N]
#set_property IOSTANDARD LVDS_25 [get_ports USER_CLOCK_N]
#set_property IOSTANDARD LVDS_25 [get_ports USER_CLOCK_P]

# Rev B board
#set_property PACKAGE_PIN AK4      [get_ports glbl_rst]
# Rev C or later
#set_property PACKAGE_PIN AB7      [get_ports glbl_rst]
#set_property IOSTANDARD  LVCMOS15 [get_ports glbl_rst]
#set_false_path -from [get_ports glbl_rst]


#### Module LEDs_8Bit constraints
#set_property PACKAGE_PIN AB8      [get_ports frame_error]
#set_property PACKAGE_PIN AA8      [get_ports frame_errorn]
#set_property IOSTANDARD  LVCMOS15 [get_ports frame_error]
#set_property IOSTANDARD  LVCMOS15 [get_ports frame_errorn]
#set_property PACKAGE_PIN AC9      [get_ports activity_flash]
#set_property PACKAGE_PIN AB9      [get_ports activity_flashn]
#set_property IOSTANDARD  LVCMOS15 [get_ports activity_flash]
#set_property IOSTANDARD  LVCMOS15 [get_ports activity_flashn]

#### Module Push_Buttons_4Bit constraints
#set_property PACKAGE_PIN G12      [get_ports update_speed]
# Rev B board
#set_property PACKAGE_PIN AD7      [get_ports config_board]
# Rev C or later
#set_property PACKAGE_PIN AC6      [get_ports config_board]
#set_property PACKAGE_PIN AB12     [get_ports pause_req_s]
#set_property PACKAGE_PIN AA12     [get_ports reset_error]
#set_property IOSTANDARD  LVCMOS15 [get_ports update_speed]
#set_property IOSTANDARD  LVCMOS15 [get_ports config_board]
#set_property IOSTANDARD  LVCMOS15 [get_ports pause_req_s]
#set_property IOSTANDARD  LVCMOS15 [get_ports reset_error]

#### Module DIP_Switches_4Bit constraints
#set_property PACKAGE_PIN Y28      [get_ports mac_speed[0]]
#set_property PACKAGE_PIN AA28     [get_ports mac_speed[1]]
#set_property PACKAGE_PIN W29      [get_ports gen_tx_data]
#set_property PACKAGE_PIN Y29      [get_ports chk_tx_data]
#set_property IOSTANDARD  LVCMOS25 [get_ports mac_speed[0]]
#set_property IOSTANDARD  LVCMOS25 [get_ports mac_speed[1]]
#set_property IOSTANDARD  LVCMOS25 [get_ports gen_tx_data]
#set_property IOSTANDARD  LVCMOS25 [get_ports chk_tx_data]

set_property PACKAGE_PIN L20 [get_ports phy_resetn]
set_property IOSTANDARD LVCMOS25 [get_ports phy_resetn]

# lock to unused header - ensure this is unused
#set_property PACKAGE_PIN AJ24     [get_ports serial_response]
#set_property PACKAGE_PIN AK25     [get_ports tx_statistics_s]
#set_property PACKAGE_PIN AE25     [get_ports rx_statistics_s]
#set_property IOSTANDARD  LVCMOS25 [get_ports serial_response]
#set_property IOSTANDARD  LVCMOS25 [get_ports tx_statistics_s]
#set_property IOSTANDARD  LVCMOS25 [get_ports rx_statistics_s]

set_property PACKAGE_PIN R23 [get_ports mdc]
set_property PACKAGE_PIN J21 [get_ports mdio]
set_property IOSTANDARD LVCMOS25 [get_ports mdc]
set_property IOSTANDARD LVCMOS25 [get_ports mdio]

########## GMII SPECIFIC IO CONSTRAINTS FOR the KC705 BOARD ##########

set_property PACKAGE_PIN T28 [get_ports {gmii_rxd[7]}]
set_property PACKAGE_PIN T26 [get_ports {gmii_rxd[6]}]
set_property PACKAGE_PIN T27 [get_ports {gmii_rxd[5]}]
set_property PACKAGE_PIN R19 [get_ports {gmii_rxd[4]}]
set_property PACKAGE_PIN U28 [get_ports {gmii_rxd[3]}]
set_property PACKAGE_PIN T25 [get_ports {gmii_rxd[2]}]
set_property PACKAGE_PIN U25 [get_ports {gmii_rxd[1]}]
set_property PACKAGE_PIN U30 [get_ports {gmii_rxd[0]}]
set_property IOSTANDARD LVCMOS25 [get_ports {gmii_rxd[7]}]
set_property IOSTANDARD LVCMOS25 [get_ports {gmii_rxd[6]}]
set_property IOSTANDARD LVCMOS25 [get_ports {gmii_rxd[5]}]
set_property IOSTANDARD LVCMOS25 [get_ports {gmii_rxd[4]}]
set_property IOSTANDARD LVCMOS25 [get_ports {gmii_rxd[3]}]
set_property IOSTANDARD LVCMOS25 [get_ports {gmii_rxd[2]}]
set_property IOSTANDARD LVCMOS25 [get_ports {gmii_rxd[1]}]
set_property IOSTANDARD LVCMOS25 [get_ports {gmii_rxd[0]}]

set_property PACKAGE_PIN J28 [get_ports {gmii_txd[7]}]
set_property PACKAGE_PIN L30 [get_ports {gmii_txd[6]}]
set_property PACKAGE_PIN K26 [get_ports {gmii_txd[5]}]
set_property PACKAGE_PIN J26 [get_ports {gmii_txd[4]}]
set_property PACKAGE_PIN L28 [get_ports {gmii_txd[3]}]
set_property PACKAGE_PIN M29 [get_ports {gmii_txd[2]}]
set_property PACKAGE_PIN N25 [get_ports {gmii_txd[1]}]
set_property PACKAGE_PIN N27 [get_ports {gmii_txd[0]}]
set_property IOSTANDARD LVCMOS25 [get_ports {gmii_txd[7]}]
set_property IOSTANDARD LVCMOS25 [get_ports {gmii_txd[6]}]
set_property IOSTANDARD LVCMOS25 [get_ports {gmii_txd[5]}]
set_property IOSTANDARD LVCMOS25 [get_ports {gmii_txd[4]}]
set_property IOSTANDARD LVCMOS25 [get_ports {gmii_txd[3]}]
set_property IOSTANDARD LVCMOS25 [get_ports {gmii_txd[2]}]
set_property IOSTANDARD LVCMOS25 [get_ports {gmii_txd[1]}]
set_property IOSTANDARD LVCMOS25 [get_ports {gmii_txd[0]}]


set_property PACKAGE_PIN M27 [get_ports gmii_tx_en]
set_property PACKAGE_PIN N29 [get_ports gmii_tx_er]
set_property PACKAGE_PIN K30 [get_ports gmii_tx_clk]
set_property IOSTANDARD LVCMOS25 [get_ports gmii_tx_en]
set_property IOSTANDARD LVCMOS25 [get_ports gmii_tx_er]
set_property IOSTANDARD LVCMOS25 [get_ports gmii_tx_clk]

set_property PACKAGE_PIN R28 [get_ports gmii_rx_dv]
set_property PACKAGE_PIN V26 [get_ports gmii_rx_er]
set_property IOSTANDARD LVCMOS25 [get_ports gmii_rx_dv]
set_property IOSTANDARD LVCMOS25 [get_ports gmii_rx_er]

set_property PACKAGE_PIN U27 [get_ports gmii_rx_clk]
set_property IOSTANDARD LVCMOS25 [get_ports gmii_rx_clk]
set_property PACKAGE_PIN M28 [get_ports mii_tx_clk]
set_property IOSTANDARD LVCMOS25 [get_ports mii_tx_clk]

# Map the TB clock pin gtx_clk_bufg_out to and un-used pin so that its not trimmed off
#set_property PACKAGE_PIN AC17      [get_ports gtx_clk_bufg_out]
#set_property IOSTANDARD  SSTL15    [get_ports gtx_clk_bufg_out]



#
####
#######
##########
#############
#################
#EXAMPLE DESIGN CONSTRAINTS

############################################################
# Associate the IDELAYCTRL in the support level to the I/Os
# in the core using IODELAYs
############################################################

############################################################
# Clock Period Constraints                                 #
############################################################

############################################################
# TX Clock period Constraints                              #
############################################################
# Transmitter clock period constraints: please do not relax
create_clock -period 5.000 -name eth_clk_in_p [get_ports eth_clk_in_p]
set_input_jitter eth_clk_in_p 0.050

#set to use clock backbone - this uses a long route to allow the MMCM to be placed in the other half of the device



############################################################
# Get auto-generated clock names                           #
############################################################

############################################################
# Input Delay constraints
############################################################
# these inputs are alll from either dip switchs or push buttons
# and therefore have no timing associated with them
#set_false_path -from [get_ports config_board]
#set_false_path -from [get_ports pause_req_s]
#set_false_path -from [get_ports reset_error]
#set_false_path -from [get_ports mac_speed[0]]
#set_false_path -from [get_ports mac_speed[1]]
#set_false_path -from [get_ports gen_tx_data]
#set_false_path -from [get_ports chk_tx_data]

# no timing requirements but want the capture flops close to the IO
#set_max_delay -from [get_ports update_speed] 4 -datapath_only


# Ignore pause deserialiser as only present to prevent logic stripping
#set_false_path -from [get_ports pause_req*]
#set_false_path -from [get_cells pause_req* -filter {IS_SEQUENTIAL}]
#set_false_path -from [get_cells pause_val* -filter {IS_SEQUENTIAL}]


############################################################
# Output Delay constraints
############################################################

#set_false_path -to [get_ports frame_error]
#set_false_path -to [get_ports frame_errorn]
#set_false_path -to [get_ports serial_response]
#set_false_path -to [get_ports tx_statistics_s]
#set_false_path -to [get_ports rx_statistics_s]

# no timing associated with output
set_false_path -from [get_cells -hier -filter {name =~ *phy_resetn_int_reg}] -to [get_ports phy_resetn]

############################################################
# Example design Clock Crossing Constraints                          #
############################################################
set_false_path -from [get_cells -hier -filter {name =~ *phy_resetn_int_reg}] -to [get_cells -hier -filter {name =~ *axi_lite_reset_gen/reset_sync*}]


# control signal is synched over clock boundary separately
#set_false_path -from [get_cells -hier -filter {name =~ tx_stats_reg[*]}] -to [get_cells -hier -filter {name =~ tx_stats_shift_reg[*]}]
#set_false_path -from [get_cells -hier -filter {name =~ rx_stats_reg[*]}] -to [get_cells -hier -filter {name =~ rx_stats_shift_reg[*]}]



############################################################
# Ignore paths to resync flops
############################################################
set_false_path -to [get_pins -hier -filter {NAME =~ */reset_sync*/PRE}]
set_false_path -to [get_pins -hier -filter {NAME =~ */reset_sync*/PRE}]
set_false_path -to [get_pins -hier -filter {NAME =~ */*_sync*/D}]
set_false_path -to [get_pins -hier -filter {NAME =~ */*_sync*/D}]
#set_max_delay -from [get_cells rx_stats_toggle_reg] -to [get_cells rx_stats_sync/data_sync_reg0] 6 -datapath_only



#
####
#######
##########
#############
#################
#FIFO BLOCK CONSTRAINTS

############################################################
# FIFO Clock Crossing Constraints                          #
############################################################

# control signal is synched separately so this is a false path
set_max_delay -datapath_only -from [get_cells -hier -filter {name =~ *rx_fifo_i/rd_addr_reg[*]}] -to [get_cells -hier -filter {name =~ *fifo*wr_rd_addr_reg[*]}] 3.200
set_max_delay -datapath_only -from [get_cells -hier -filter {name =~ *rx_fifo_i/wr_store_frame_tog_reg}] -to [get_cells -hier -filter {name =~ *fifo_i/resync_wr_store_frame_tog/data_sync_reg0}] 3.200
set_max_delay -datapath_only -from [get_cells -hier -filter {name =~ *rx_fifo_i/update_addr_tog_reg}] -to [get_cells -hier -filter {name =~ *rx_fifo_i/sync_rd_addr_tog/data_sync_reg0}] 3.200


