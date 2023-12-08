from ETH_CMD_BASE import *

test = ETH_control()

# set to use ETH control
# switch to 0 if you want to use vio to control

test.use_ETH_CMD[0] = '1'
test.update_CC_CONTROL()

# reset ETH logic
test.global_rst[0] = '1'
test.update_CC_CONTROL()
test.global_rst[0] = '0'
test.update_CC_CONTROL()
#
# # set DST and SRC MAC address
test.DST_MAC_ADDR[0] = "0d0d0d0d0d0d"
test.SRC_MAC_ADDR[0] = "0708090a0b0c"
test.update_ETH_CONFIG()
#
# # example to control the vio
# # Test to send this so that you can stop firmware to send data in every second
# # Stop rst test logic
# test.rst_logic = '0'
# test.update_VIO_CONTROL()
#
# test.sent_once = '1'
# test.update_FAKE_DATA_CONTROL()
# test.sent_once = '0'
# test.update_FAKE_DATA_CONTROL()
#
# test.sent_config_back = '1'
# test.sent_config_CMD = hex_to_bin("0101")
# test.update_CC_CONTROL()
#
# test.sent_config_back = '0'
# test.update_CC_CONTROL()





