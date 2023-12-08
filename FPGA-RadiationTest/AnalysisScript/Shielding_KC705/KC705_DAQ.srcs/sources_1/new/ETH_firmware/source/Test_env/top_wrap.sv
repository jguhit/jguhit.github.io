

module top_wrap(

//ethernet interface
    input eth_clk_in_p,
    input eth_clk_in_n,

    output phy_resetn,

    output [7:0]  gmii_txd,
    output        gmii_tx_en,
    output        gmii_tx_er,
    output        gmii_tx_clk,
    input  [7:0]  gmii_rxd,
    input         gmii_rx_dv,
    input         gmii_rx_er,
    input         gmii_rx_clk,
    input         mii_tx_clk,

    inout         mdio,
    output        mdc,    

// Xueye's port
    input sma_clk_p,
    input sma_clk_n,

    input osc_clk_p,
    input osc_clk_n,
        
        
    output tdi_master_o,
    input tdo_master_i,
    output tms_master_o,
    output tck_master_o,
             
    input [17:0] tdi_slave_i,
    output [17:0] tdo_slave_o,
    input [17:0] tms_slave_i,
    input [17:0] tck_slave_i,
                
    output elink_TTC_out_p,
    output elink_TTC_out_n,
               
    input [5:0] mezz_enc_in_p,
    input [5:0] mezz_enc_in_n,
        
    output [17:0] jtag_daisychain,
        
    output multi_boot_top,
    output locked_top,
        
    // SEM status signals via miniSAS
    input [2:0] design_number_minisas,
    input sem_fatalerr_minisas,
    input sem_heartbeat_minisas,
        
    output mbt_trigger_minisas,
        
    // sma
    output rst_sma_FE

    );



wire clk_user;
wire use_ETH_CMD;
wire tx_clk;



//clk_master clk_master_inst
   //(
   //// Clock in ports
    //.clk_in1_p(USER_CLOCK_P),    // input clk_in1_p
    //.clk_in1_n(USER_CLOCK_N),    // input clk_in1_n
    //// Clock out ports
    //.clk_out1(clk_user));    // output clk_out1



wire [7:0] tx_axis_fifo_tdata;
wire tx_axis_fifo_tvalid;
wire  tx_axis_fifo_tready;
wire tx_axis_fifo_tlast;

wire [7:0] rx_axis_fifo_tdata;
wire rx_axis_fifo_tvalid;
wire  rx_axis_fifo_tready;
wire rx_axis_fifo_tlast;

ethernet_mac_interface ethernet_inst
   (
      // asynchronous reset
      .glbl_rst(1'b0),

      // 200MHz clock input from board
      .clk_in_p(eth_clk_in_p),
      .clk_in_n(eth_clk_in_n),
      // 125 MHz clock from MMCM
      .gtx_clk_bufg_out(gtx_clk_bufg_out),
      .phy_resetn(phy_resetn),


      .gmii_txd(gmii_txd),
      .gmii_tx_en(gmii_tx_en),
      .gmii_tx_er(gmii_tx_er),
      .gmii_tx_clk(gmii_tx_clk),
      .gmii_rxd(gmii_rxd),
      .gmii_rx_dv(gmii_rx_dv),
      .gmii_rx_er(gmii_rx_er),
      .gmii_rx_clk(gmii_rx_clk),
      .mii_tx_clk(mii_tx_clk),

      
      // MDIO Interface
      //---------------
      .mdio(mdio),
      .mdc(mdc),
      .rx_axis_fifo_tdata(rx_axis_fifo_tdata),
      .rx_axis_fifo_tvalid(rx_axis_fifo_tvalid),
      .rx_axis_fifo_tready(rx_axis_fifo_tready),
      .rx_axis_fifo_tlast(rx_axis_fifo_tlast),      
      
      .tx_axis_fifo_tdata(tx_axis_fifo_tdata),
      .tx_axis_fifo_tvalid(tx_axis_fifo_tvalid),
      .tx_axis_fifo_tready(tx_axis_fifo_tready),
      .tx_axis_fifo_tlast(tx_axis_fifo_tlast)       
     );


assign tx_clk = gtx_clk_bufg_out;

///////////////////////////////////////////////////////////////////////
//                              ||                                   //
//                           \\ || //                                //
//                            \\||//                                 //
//                              ><                                   //
///////////////////////////////////////////////////////////////////////
// Start of Code for interface claim


//claim interface
//CC_2_CC CC_2_CC_int();
CC_2_ETH_TX_Packing CC_2_ETH_TX_Packing_int();
CC_2_fake_data_sent CC_2_fake_data_sent_int();
//CC_2_vio_control CC_2_vio_control_int();

// End of Code for interface claim
///////////////////////////////////////////////////////////////////////
//                              ><                                   //
//                            //||\\                                 //
//                           // || \\                                //
//                              ||                                   //
///////////////////////////////////////////////////////////////////////


user_tx_2_SC user_tx_2_SC_fake_data_sent_int();
user_tx_2_SC user_tx_2_SC_CC_int();
user_tx_2_SC user_tx_2_SC_vio_data_int();

wire tx_eth_fifo_empty;
wire tx_eth_fifo_rd_en;
wire [8:0]tx_eth_fifo_dout;
wire tx_eth_fifo_valid;


// Send fake data. for debuging purpose
fake_data_sent fake_data_sent_inst (
    .clk                             (clk_user),
    .rst                             (global_rst),
    .use_ETH_CMD                     (use_ETH_CMD),
    .CC_2_fake_data_sent_int         (CC_2_fake_data_sent_int),
    .user_tx_2_SC_fake_data_sent_int (user_tx_2_SC_fake_data_sent_int)
    );


// control which module have the right to send back data to PC
Sendback_Center Sendback_Center_inst (
  .user_clk                        (clk_user),
  .ETH_clk                         (tx_clk),
  .rst                             (global_rst),

  .user_tx_2_SC_fake_data_sent_int (user_tx_2_SC_fake_data_sent_int),
  .user_tx_2_SC_CC_int             (user_tx_2_SC_CC_int),
  .user_tx_2_SC_vio_data_int       (user_tx_2_SC_vio_data_int),

  .tx_eth_fifo_rd_en               (tx_eth_fifo_rd_en),
  .tx_eth_fifo_empty               (tx_eth_fifo_empty),
  .tx_eth_fifo_dout                (tx_eth_fifo_dout),
  .tx_eth_fifo_valid               (tx_eth_fifo_valid)

  );


ETH_TX_Packing ETH_TX_Packing_inst(
  .clk                     (tx_clk),
  .rst                     (global_rst),
  .CC_2_ETH_TX_Packing_int (CC_2_ETH_TX_Packing_int),
  .use_ETH_CMD             (use_ETH_CMD),

  .tx_axis_fifo_tready     (tx_axis_fifo_tready),
  .tx_axis_fifo_tdata      (tx_axis_fifo_tdata),
  .tx_axis_fifo_tvalid     (tx_axis_fifo_tvalid),
  .tx_axis_fifo_tlast      (tx_axis_fifo_tlast),

  .tx_eth_fifo_rd_en       (tx_eth_fifo_rd_en),
  //.tx_eth_fifo_empty       (tx_eth_fifo_empty),
  .tx_eth_fifo_dout        (tx_eth_fifo_dout),
  .tx_eth_fifo_valid       (tx_eth_fifo_valid)
  );


wire user_rx_fifo_wr_en;
wire[7:0]user_rx_fifo_data;
wire user_rx_fifo_data_last;

ETH_RX_Filter ETH_RX_Filter_inst (
  .clk(tx_clk),
  .rst(1'b0),
  .rx_axis_fifo_tdata(rx_axis_fifo_tdata),
  .rx_axis_fifo_tvalid(rx_axis_fifo_tvalid),
  .rx_axis_fifo_tready(rx_axis_fifo_tready),
  .rx_axis_fifo_tlast(rx_axis_fifo_tlast),
  .user_rx_fifo_wr_en_out(user_rx_fifo_wr_en),
  .user_rx_fifo_data_last_out(user_rx_fifo_data_last),
  .user_rx_fifo_data_out(user_rx_fifo_data)
  
);


ila_eth_rx ila_eth_rx_inst (
  .clk(tx_clk), // input wire clk


  .probe0(rx_axis_fifo_tvalid), // input wire [0:0]  probe0  
  .probe1(rx_axis_fifo_tlast), // input wire [0:0]  probe1 
  .probe2(rx_axis_fifo_tdata), // input wire [7:0]  probe2 
  .probe3(user_rx_fifo_wr_en), // input wire [0:0]  probe3 
  .probe4({user_rx_fifo_data_last,user_rx_fifo_data}) // input wire [8:0]  probe4
);


wire[0:0] multi_boot_top_INNER;
wire[0:0] rst_logic_INNER;
wire[0:0] rst_gen_tdim_INNER;
wire[0:0] rst_gen_tmsm_INNER;
wire[0:0] rst_gen_tckm_INNER;
wire[0:0] rst_gen_ttco_INNER;
wire[0:0] rst_chk_tdo_m_INNER;
wire[17:0] rst_chk_tms_s_INNER;
wire[10:0] errcnt_rst4ch_INNER;
wire[17:0] rst_chk_tck_s_INNER;
wire[5:0] rst_chk_elinkttc_INNER;
wire[0:0] errcnt_inj_INNER;
wire[17:0] jtag_daisychain_INNER;
wire[0:0] mbt_trigger_minisas_INNER;
wire[0:0] rst_sma_FE_INNER;
wire[0:0] rst_clkdiv_INNER;

Control_Center Control_Center_inst (
  .clk                       (tx_clk),
  .user_clk                  (clk_user),
  .rst                       (1'b0),

  .global_rst                (global_rst),
  .use_ETH_CMD               (use_ETH_CMD),


  .user_rx_fifo_wr_en_in     (user_rx_fifo_wr_en),
  .user_rx_fifo_data_in      (user_rx_fifo_data),
  .user_rx_fifo_data_last_in (user_rx_fifo_data_last),

  .user_tx_2_SC_CC_int       (user_tx_2_SC_CC_int),

  // 
    .multi_boot_top_INNER (multi_boot_top_INNER),
    .rst_logic_INNER (rst_logic_INNER),
    .rst_gen_tdim_INNER (rst_gen_tdim_INNER),
    .rst_gen_tmsm_INNER (rst_gen_tmsm_INNER),
    .rst_gen_tckm_INNER (rst_gen_tckm_INNER),
    .rst_gen_ttco_INNER (rst_gen_ttco_INNER),
    .rst_chk_tdo_m_INNER (rst_chk_tdo_m_INNER),
    .rst_chk_tms_s_INNER (rst_chk_tms_s_INNER),
    .errcnt_rst4ch_INNER (errcnt_rst4ch_INNER),
    .rst_chk_tck_s_INNER (rst_chk_tck_s_INNER),
    .rst_chk_elinkttc_INNER (rst_chk_elinkttc_INNER),
    .errcnt_inj_INNER (errcnt_inj_INNER),
    .jtag_daisychain_INNER (jtag_daisychain_INNER),
    .mbt_trigger_minisas_INNER (mbt_trigger_minisas_INNER),
    .rst_sma_FE_INNER (rst_sma_FE_INNER),
    .rst_clkdiv_INNER (rst_clkdiv_INNER),

  //.CC_2_vio_control          (CC_2_vio_control_int),
  .CC_2_ETH_TX_Packing_int   (CC_2_ETH_TX_Packing_int),
  .CC_2_fake_data_sent_int   (CC_2_fake_data_sent_int)

  );

// Wrap Xueye's firmware below



wire [1037:0] result_out;
reg [1037:0] result_out_reg;
wire trig_enable; 

top top_inst (
    .sma_clk_p                 (sma_clk_p),
    .sma_clk_n                 (sma_clk_n),

    .osc_clk_p                 (osc_clk_p),
    .osc_clk_n                 (osc_clk_n),
            
            
    .tdi_master_o              (tdi_master_o),
    .tdo_master_i              (tdo_master_i),
    .tms_master_o              (tms_master_o),
    .tck_master_o              (tck_master_o),
                 
    .tdi_slave_i               (tdi_slave_i),
    .tdo_slave_o               (tdo_slave_o),
    .tms_slave_i               (tms_slave_i),
    .tck_slave_i               (tck_slave_i),
                    
    .elink_TTC_out_p           (elink_TTC_out_p),
    .elink_TTC_out_n           (elink_TTC_out_n),
                   
    .mezz_enc_in_p             (mezz_enc_in_p),
    .mezz_enc_in_n             (mezz_enc_in_n),
            
    .jtag_daisychain           (jtag_daisychain),
            
    .multi_boot_top            (multi_boot_top),
    .locked_top                (locked_top),
            
        // SEM status signals via miniSAS
    .design_number_minisas     (design_number_minisas),
    .sem_fatalerr_minisas      (sem_fatalerr_minisas),
    .sem_heartbeat_minisas     (sem_heartbeat_minisas),
            
    .mbt_trigger_minisas       (mbt_trigger_minisas),
            
        // sma
    .rst_sma_FE                (rst_sma_FE),

    // Following ports are added by xx
    // Clock provide to ethernet modules
    .clk_user_out              (clk_user),
    .use_ETH_CMD               (use_ETH_CMD),

    // ports to emulate vio output
    .multi_boot_top_INNER      (multi_boot_top_INNER),
    .rst_logic_INNER           (rst_logic_INNER),
    .rst_gen_tdim_INNER        (rst_gen_tdim_INNER),
    .rst_gen_tmsm_INNER        (rst_gen_tmsm_INNER),
    .rst_gen_tckm_INNER        (rst_gen_tckm_INNER),
    .rst_gen_ttco_INNER        (rst_gen_ttco_INNER),
    .rst_chk_tdo_m_INNER       (rst_chk_tdo_m_INNER),
    .rst_chk_tms_s_INNER       (rst_chk_tms_s_INNER),
    .errcnt_rst4ch_INNER       (errcnt_rst4ch_INNER),
    .rst_chk_tck_s_INNER       (rst_chk_tck_s_INNER),
    .rst_chk_elinkttc_INNER    (rst_chk_elinkttc_INNER),
    .errcnt_inj_INNER          (errcnt_inj_INNER),
    .jtag_daisychain_INNER     (jtag_daisychain_INNER),
    .mbt_trigger_minisas_INNER (mbt_trigger_minisas_INNER),
    .rst_sma_FE_INNER          (rst_sma_FE_INNER),
    .rst_clkdiv_INNER          (rst_clkdiv_INNER),

    .trig_enable               (trig_enable),
    .result_out                (result_out)

);

// (1038 + 2) / 8 = 130
wire sent_busy;
ETH_TX_Submodule_Sending_FSM  #(.PACKAET_NUMBER(130 + 4 + 2))
	ETH_TX_Submodule_Sending_FSM_vio_data_inst
	(
	.rst(global_rst),
	.clk(clk_user),
	.user_tx_2_SC_int(user_tx_2_SC_vio_data_int),
	.busy(sent_busy),
	.sent_en(trig_enable),
	.data({16'd134,32'hface0505,2'b0,result_out})		

	);



endmodule
