//set_property is_global_include true [get_files  /home/XX/Work/Ethernet_study/ethernet_temp/firmware/source/Test_env/sys_defs.sv]
//update_compile_order -fileset sources_1

`define ETH_CMD_Size 16

`define ETH_RX_PACKET_NUM 46 //46
`define ETH_RX_CMD_PACKET_NUM 2 //2
`define ETH_RX_DATA_PACKET_NUM (`ETH_RX_PACKET_NUM - `ETH_RX_CMD_PACKET_NUM) //44


`define ETH_RX_BIN_SIZE (`ETH_RX_PACKET_NUM*8)
`define ETH_RX_CMD_BIN_SIZE 16
`define ETH_RX_DATA_BIN_SIZE (`ETH_RX_DATA_PACKET_NUM*8)


`define ETH_TX_DATA_PACKET_NUM 46 //48
`define ETH_TX_HEADER_PACKET_NUM 4
`define ETH_TX_PACKET_NUM (`ETH_TX_DATA_PACKET_NUM + `ETH_TX_HEADER_PACKET_NUM)


`define ETH_TX_DATA_BIN_SIZE (`ETH_TX_DATA_PACKET_NUM*8) // 46*8 byte
`define ETH_TX_HEADER_BIN_SIZE (`ETH_TX_HEADER_PACKET_NUM*8)
`define ETH_TX_BIN_SIZE (`ETH_TX_PACKET_NUM*8)



`define ETH_TX_HEADER_CC 32'hface0001 
`define ETH_TX_HEADER_fake_data_sent 32'hface0002
`define ETH_TX_HEADER_vio_data 32'hface0003



interface user_tx_2_SC;
    wire from_SC_Grant;      
    wire to_SC_request;       
    wire [7:0] to_SC_tdata;    
    wire to_SC_wr_en;    
    wire to_SC_tlast; 

    modport SC_port (output from_SC_Grant, input to_SC_request, to_SC_tdata, to_SC_wr_en, to_SC_tlast);
    modport user_port (input from_SC_Grant, output to_SC_request, to_SC_tdata, to_SC_wr_en, to_SC_tlast);
endinterface

//define interface
interface CC_2_CC;
    wire[0:0] global_rst_CC;
    wire[0:0] use_ETH_CMD_CC;
    wire[0:0] sent_config_back_CC;
    wire[15:0] sent_config_CMD_CC;

endinterface :CC_2_CC


interface CC_2_ETH_TX_Packing;
    wire[47:0] DST_MAC_ADDR_CC;
    wire[47:0] SRC_MAC_ADDR_CC;

    modport CC_port ( output DST_MAC_ADDR_CC, SRC_MAC_ADDR_CC);
    modport ETH_TX_Packing_port ( input DST_MAC_ADDR_CC, SRC_MAC_ADDR_CC);
endinterface :CC_2_ETH_TX_Packing

interface CC_2_fake_data_sent;
    wire[0:0] sent_once_CC;
    wire[0:0] sent_loop_CC;
    wire[15:0] sent_loop_interval_CC;

    modport CC_port ( output sent_once_CC, sent_loop_CC, sent_loop_interval_CC);
    modport fake_data_sent_port ( input sent_once_CC, sent_loop_CC, sent_loop_interval_CC);
endinterface :CC_2_fake_data_sent

interface CC_2_vio_control;
    wire[0:0] multi_boot_top_CC;
    wire[0:0] rst_logic_CC;
    wire[0:0] rst_gen_tdim_CC;
    wire[0:0] rst_gen_tmsm_CC;
    wire[0:0] rst_gen_tckm_CC;
    wire[0:0] rst_gen_ttco_CC;
    wire[0:0] rst_chk_tdo_m_CC;
    wire[17:0] rst_chk_tms_s_CC;
    wire[10:0] errcnt_rst4ch_CC;
    wire[17:0] rst_chk_tck_s_CC;
    wire[5:0] rst_chk_elinkttc_CC;
    wire[0:0] errcnt_inj_CC;
    wire[17:0] jtag_daisychain_CC;
    wire[0:0] mbt_trigger_minisas_CC;
    wire[0:0] rst_sma_FE_CC;
    wire[0:0] rst_clkdiv_CC;

    modport CC_port ( output multi_boot_top_CC, rst_logic_CC, rst_gen_tdim_CC, rst_gen_tmsm_CC, rst_gen_tckm_CC, rst_gen_ttco_CC, rst_chk_tdo_m_CC, rst_chk_tms_s_CC, errcnt_rst4ch_CC, rst_chk_tck_s_CC, rst_chk_elinkttc_CC, errcnt_inj_CC, jtag_daisychain_CC, mbt_trigger_minisas_CC, rst_sma_FE_CC, rst_clkdiv_CC );
    modport vio_control_port ( input multi_boot_top_CC, rst_logic_CC, rst_gen_tdim_CC, rst_gen_tmsm_CC, rst_gen_tckm_CC, rst_gen_ttco_CC, rst_chk_tdo_m_CC, rst_chk_tms_s_CC, errcnt_rst4ch_CC, rst_chk_tck_s_CC, rst_chk_elinkttc_CC, errcnt_inj_CC, jtag_daisychain_CC, mbt_trigger_minisas_CC, rst_sma_FE_CC, rst_clkdiv_CC );
endinterface :CC_2_vio_control

