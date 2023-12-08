# #for KC705
#set_property CFGBVS VCCO [current_design]
#set_property CONFIG_VOLTAGE 2.5 [current_design]

##clock to test_env
#set_property IOSTANDARD LVDS_25 [get_ports clk_input_p]
#set_property PACKAGE_PIN D17 [get_ports clk_input_p]
#set_property PACKAGE_PIN D18 [get_ports clk_input_n]
#set_property IOSTANDARD LVDS_25 [get_ports clk_input_n]
#set_property DIFF_TERM TRUE [get_ports clk_input_p]
#set_property DIFF_TERM TRUE [get_ports clk_input_n]


##USERCLK
#set_property PACKAGE_PIN K29 [get_ports USER_CLOCK_N]
#set_property IOSTANDARD LVDS_25 [get_ports USER_CLOCK_N]
#set_property PACKAGE_PIN K28 [get_ports USER_CLOCK_P]
#set_property IOSTANDARD LVDS_25 [get_ports USER_CLOCK_P]


##USER SMA CLOCK
##set_property PACKAGE_PIN K25 [get_ports USER_SMA_CLOCK_N]
##set_property IOSTANDARD LVDS_25 [get_ports USER_SMA_CLOCK_N]
##set_property PACKAGE_PIN L25 [get_ports USER_SMA_CLOCK_P]
##set_property IOSTANDARD LVDS_25 [get_ports USER_SMA_CLOCK_P]

#set_property PACKAGE_PIN L25 [get_ports K_OUT]
#set_property IOSTANDARD LVCMOS25 [get_ports K_OUT]


##GPIO USER SMA
#set_property PACKAGE_PIN Y24 [get_ports USER_SMA_GPIO_N]
#set_property IOSTANDARD LVDS_25 [get_ports USER_SMA_GPIO_N]
#set_property PACKAGE_PIN Y23 [get_ports USER_SMA_GPIO_P]
#set_property IOSTANDARD LVDS_25 [get_ports USER_SMA_GPIO_P]






