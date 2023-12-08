
`define Local_State_Size 3
`define Local_packet_cnt_Size 10




module Control_Center (
	input clk,    // Clock
	input user_clk,
	input rst,  // Asynchronous reset active low



	output global_rst,

	output use_ETH_CMD,


	input user_rx_fifo_wr_en_in,
	input [7:0]  user_rx_fifo_data_in,
	input user_rx_fifo_data_last_in,


        output [0:0] multi_boot_top_INNER,
        output [0:0] rst_logic_INNER,
        output [0:0] rst_gen_tdim_INNER,
        output [0:0] rst_gen_tmsm_INNER,
        output [0:0] rst_gen_tckm_INNER,
        output [0:0] rst_gen_ttco_INNER,
        output [0:0] rst_chk_tdo_m_INNER,
        output [17:0] rst_chk_tms_s_INNER,
        output [10:0] errcnt_rst4ch_INNER,
        output [17:0] rst_chk_tck_s_INNER,
        output [5:0] rst_chk_elinkttc_INNER,
        output [0:0] errcnt_inj_INNER,
        output [17:0] jtag_daisychain_INNER,
        output [0:0] mbt_trigger_minisas_INNER,
        output [0:0] rst_sma_FE_INNER,
        output [0:0] rst_clkdiv_INNER,




	user_tx_2_SC.user_port user_tx_2_SC_CC_int,


	//CC_2_vio_control.CC_port CC_2_vio_control_int,
	CC_2_ETH_TX_Packing.CC_port CC_2_ETH_TX_Packing_int,
	CC_2_fake_data_sent.CC_port CC_2_fake_data_sent_int
);


CC_2_CC CC_2_CC_int();

reg[`ETH_RX_CMD_BIN_SIZE-1:0]  ETH_CMD_reg;
reg[`ETH_RX_DATA_BIN_SIZE-1:0] ETH_DATA_reg;



reg CMD_valid;
reg [`Local_packet_cnt_Size-1:0] packet_cnter;



localparam IDLE 		= `Local_State_Size'd0, 
		   GET_CMD  = `Local_State_Size'd1, 
		   GET_DATA  = `Local_State_Size'd2;

reg [`Local_State_Size-1:0] STATE;







always @(posedge clk) begin 
	if(rst) begin
		STATE        <= IDLE;
		packet_cnter <= {`Local_packet_cnt_Size{1'b0}};
		ETH_CMD_reg  <= {`ETH_RX_CMD_BIN_SIZE{1'b0}};
		ETH_DATA_reg <= {`ETH_RX_DATA_BIN_SIZE{1'b0}};
		CMD_valid    <= 1'b0;
	end else begin
		CMD_valid    <= 1'b0;
		case (STATE)
			IDLE: begin 
				if (user_rx_fifo_wr_en_in) begin 
					ETH_CMD_reg[7:0] <= user_rx_fifo_data_in;
					STATE <= GET_CMD;
					packet_cnter <= `Local_packet_cnt_Size'd1;
				end else begin 
					packet_cnter <= {`Local_packet_cnt_Size{1'b0}};
				end
			end

			GET_CMD: begin 
				if (user_rx_fifo_wr_en_in) begin 
					if (packet_cnter <= (`ETH_RX_CMD_PACKET_NUM-1)) begin 
						ETH_CMD_reg[7:0]  <= user_rx_fifo_data_in;
						ETH_CMD_reg[`ETH_RX_CMD_BIN_SIZE-1:8] <= ETH_CMD_reg[`ETH_RX_CMD_BIN_SIZE-9:0];
						packet_cnter <= packet_cnter +`Local_packet_cnt_Size'd1;
					end else begin 
						ETH_DATA_reg[7:0] <= user_rx_fifo_data_in;
						STATE <= GET_DATA;
						packet_cnter <= `Local_packet_cnt_Size'd1;
					end
				end
			end

			GET_DATA: begin  // need to be careful, PC need to send exact bit of data!!!.
				if (user_rx_fifo_wr_en_in) begin 
					if (packet_cnter <= (`ETH_RX_DATA_PACKET_NUM-1)) begin 
						ETH_DATA_reg[7:0]  <= user_rx_fifo_data_in;
						ETH_DATA_reg[`ETH_RX_DATA_BIN_SIZE-1:8] <= ETH_DATA_reg[`ETH_RX_DATA_BIN_SIZE-9:0];
						packet_cnter <= packet_cnter +`Local_packet_cnt_Size'd1;
						if(user_rx_fifo_data_last_in) begin 
							STATE <= IDLE;
							CMD_valid    <= 1'b1;
						end 
					end else begin 
						if(user_rx_fifo_data_last_in) begin 
							STATE <= IDLE;
							CMD_valid    <= 1'b1;
						end 
					end
				end
			end
		endcase
	end
end












wire sent_config_back;
wire[15:0] sent_config_CMD;
wire sent_busy; // doesn't care right now since you can send another command if is missing. 
reg[`ETH_RX_BIN_SIZE-1:0]ETH_reply_DATA;
wire sent_en;

///////////////////////////////////////////////////////////////////////
//                              ||                                   //
//                           \\ || //                                //
//                            \\||//                                 //
//                              ><                                   //
///////////////////////////////////////////////////////////////////////
// Start of Code for CONTROL_CENTER

//define parameters
`define CC_CONTROL `ETH_RX_CMD_BIN_SIZE'h0001

`define ETH_CONFIG `ETH_RX_CMD_BIN_SIZE'h0002

`define FAKE_DATA_CONTROL `ETH_RX_CMD_BIN_SIZE'h0003

`define VIO_CONTROL `ETH_RX_CMD_BIN_SIZE'h0101

//define reg
reg[0:0] global_rst_config_reg;
reg[0:0] use_ETH_CMD_config_reg;
reg[0:0] sent_config_back_config_reg;
reg[15:0] sent_config_CMD_config_reg;
reg[47:0] DST_MAC_ADDR_config_reg;
reg[47:0] SRC_MAC_ADDR_config_reg;
reg[0:0] sent_once_config_reg;
reg[0:0] sent_loop_config_reg;
reg[15:0] sent_loop_interval_config_reg;
reg[0:0] multi_boot_top_config_reg;
reg[0:0] rst_logic_config_reg;
reg[0:0] rst_gen_tdim_config_reg;
reg[0:0] rst_gen_tmsm_config_reg;
reg[0:0] rst_gen_tckm_config_reg;
reg[0:0] rst_gen_ttco_config_reg;
reg[0:0] rst_chk_tdo_m_config_reg;
reg[17:0] rst_chk_tms_s_config_reg;
reg[10:0] errcnt_rst4ch_config_reg;
reg[17:0] rst_chk_tck_s_config_reg;
reg[5:0] rst_chk_elinkttc_config_reg;
reg[0:0] errcnt_inj_config_reg;
reg[17:0] jtag_daisychain_config_reg;
reg[0:0] mbt_trigger_minisas_config_reg;
reg[0:0] rst_sma_FE_config_reg;
reg[0:0] rst_clkdiv_config_reg;

always @(posedge clk) begin
    if (rst) begin
        global_rst_config_reg <= 1'b0;
        use_ETH_CMD_config_reg <= 1'b0;
        sent_config_back_config_reg <= 1'b0;
        sent_config_CMD_config_reg <= 16'b0;
        
        DST_MAC_ADDR_config_reg <= 48'b0;
        SRC_MAC_ADDR_config_reg <= 48'b0;
        
        sent_once_config_reg <= 1'b0;
        sent_loop_config_reg <= 1'b0;
        sent_loop_interval_config_reg <= 16'b0;
        
        multi_boot_top_config_reg <= 1'b0;
        rst_logic_config_reg <= 1'b0;
        rst_gen_tdim_config_reg <= 1'b0;
        rst_gen_tmsm_config_reg <= 1'b0;
        rst_gen_tckm_config_reg <= 1'b0;
        rst_gen_ttco_config_reg <= 1'b0;
        rst_chk_tdo_m_config_reg <= 1'b0;
        rst_chk_tms_s_config_reg <= 18'b0;
        errcnt_rst4ch_config_reg <= 11'b0;
        rst_chk_tck_s_config_reg <= 18'b0;
        rst_chk_elinkttc_config_reg <= 6'b0;
        errcnt_inj_config_reg <= 1'b0;
        jtag_daisychain_config_reg <= 18'b0;
        mbt_trigger_minisas_config_reg <= 1'b0;
        rst_sma_FE_config_reg <= 1'b0;
        rst_clkdiv_config_reg <= 1'b0;
        
    end else begin
        if (CMD_valid) begin
            case (ETH_CMD_reg)
                `CC_CONTROL: begin
                    global_rst_config_reg <= ETH_DATA_reg[0:0];
                    use_ETH_CMD_config_reg <= ETH_DATA_reg[1:1];
                    sent_config_back_config_reg <= ETH_DATA_reg[2:2];
                    sent_config_CMD_config_reg <= ETH_DATA_reg[18:3];
                end
                
                `ETH_CONFIG: begin
                    DST_MAC_ADDR_config_reg <= ETH_DATA_reg[47:0];
                    SRC_MAC_ADDR_config_reg <= ETH_DATA_reg[95:48];
                end
                
                `FAKE_DATA_CONTROL: begin
                    sent_once_config_reg <= ETH_DATA_reg[0:0];
                    sent_loop_config_reg <= ETH_DATA_reg[1:1];
                    sent_loop_interval_config_reg <= ETH_DATA_reg[17:2];
                end
                
                `VIO_CONTROL: begin
                    multi_boot_top_config_reg <= ETH_DATA_reg[0:0];
                    rst_logic_config_reg <= ETH_DATA_reg[1:1];
                    rst_gen_tdim_config_reg <= ETH_DATA_reg[2:2];
                    rst_gen_tmsm_config_reg <= ETH_DATA_reg[3:3];
                    rst_gen_tckm_config_reg <= ETH_DATA_reg[4:4];
                    rst_gen_ttco_config_reg <= ETH_DATA_reg[5:5];
                    rst_chk_tdo_m_config_reg <= ETH_DATA_reg[6:6];
                    rst_chk_tms_s_config_reg <= ETH_DATA_reg[24:7];
                    errcnt_rst4ch_config_reg <= ETH_DATA_reg[35:25];
                    rst_chk_tck_s_config_reg <= ETH_DATA_reg[53:36];
                    rst_chk_elinkttc_config_reg <= ETH_DATA_reg[59:54];
                    errcnt_inj_config_reg <= ETH_DATA_reg[60:60];
                    jtag_daisychain_config_reg <= ETH_DATA_reg[78:61];
                    mbt_trigger_minisas_config_reg <= ETH_DATA_reg[79:79];
                    rst_sma_FE_config_reg <= ETH_DATA_reg[80:80];
                    rst_clkdiv_config_reg <= ETH_DATA_reg[81:81];
                end
                
            endcase
        end
    end
end

//assign interface
assign CC_2_CC_int.global_rst_CC = global_rst_config_reg;
assign CC_2_CC_int.use_ETH_CMD_CC = use_ETH_CMD_config_reg;
assign CC_2_CC_int.sent_config_back_CC = sent_config_back_config_reg;
assign CC_2_CC_int.sent_config_CMD_CC = sent_config_CMD_config_reg;
assign CC_2_ETH_TX_Packing_int.DST_MAC_ADDR_CC = DST_MAC_ADDR_config_reg;
assign CC_2_ETH_TX_Packing_int.SRC_MAC_ADDR_CC = SRC_MAC_ADDR_config_reg;
assign CC_2_fake_data_sent_int.sent_once_CC = sent_once_config_reg;
assign CC_2_fake_data_sent_int.sent_loop_CC = sent_loop_config_reg;
assign CC_2_fake_data_sent_int.sent_loop_interval_CC = sent_loop_interval_config_reg;
//assign CC_2_vio_control_int.multi_boot_top_CC = multi_boot_top_config_reg;
//assign CC_2_vio_control_int.rst_logic_CC = rst_logic_config_reg;
//assign CC_2_vio_control_int.rst_gen_tdim_CC = rst_gen_tdim_config_reg;
//assign CC_2_vio_control_int.rst_gen_tmsm_CC = rst_gen_tmsm_config_reg;
//assign CC_2_vio_control_int.rst_gen_tckm_CC = rst_gen_tckm_config_reg;
//assign CC_2_vio_control_int.rst_gen_ttco_CC = rst_gen_ttco_config_reg;
//assign CC_2_vio_control_int.rst_chk_tdo_m_CC = rst_chk_tdo_m_config_reg;
//assign CC_2_vio_control_int.rst_chk_tms_s_CC = rst_chk_tms_s_config_reg;
//assign CC_2_vio_control_int.errcnt_rst4ch_CC = errcnt_rst4ch_config_reg;
//assign CC_2_vio_control_int.rst_chk_tck_s_CC = rst_chk_tck_s_config_reg;
//assign CC_2_vio_control_int.rst_chk_elinkttc_CC = rst_chk_elinkttc_config_reg;
//assign CC_2_vio_control_int.errcnt_inj_CC = errcnt_inj_config_reg;
//assign CC_2_vio_control_int.jtag_daisychain_CC = jtag_daisychain_config_reg;
//assign CC_2_vio_control_int.mbt_trigger_minisas_CC = mbt_trigger_minisas_config_reg;
//assign CC_2_vio_control_int.rst_sma_FE_CC = rst_sma_FE_config_reg;
//assign CC_2_vio_control_int.rst_clkdiv_CC = rst_clkdiv_config_reg;


always @* begin 
    ETH_reply_DATA[`ETH_RX_BIN_SIZE-1:`ETH_RX_BIN_SIZE-`ETH_RX_CMD_BIN_SIZE] =  sent_config_CMD;
    ETH_reply_DATA[`ETH_RX_BIN_SIZE-`ETH_RX_CMD_BIN_SIZE-1:0] =  0;
    case (sent_config_CMD) 
        `CC_CONTROL: begin
            ETH_reply_DATA[18:0] = { sent_config_CMD_config_reg, sent_config_back_config_reg, use_ETH_CMD_config_reg, global_rst_config_reg};
        end
        
        `ETH_CONFIG: begin
            ETH_reply_DATA[95:0] = { SRC_MAC_ADDR_config_reg, DST_MAC_ADDR_config_reg};
        end
        
        `FAKE_DATA_CONTROL: begin
            ETH_reply_DATA[17:0] = { sent_loop_interval_config_reg, sent_loop_config_reg, sent_once_config_reg};
        end
        
        `VIO_CONTROL: begin
            ETH_reply_DATA[81:0] = { rst_clkdiv_config_reg, rst_sma_FE_config_reg, mbt_trigger_minisas_config_reg, jtag_daisychain_config_reg, errcnt_inj_config_reg, rst_chk_elinkttc_config_reg, rst_chk_tck_s_config_reg, errcnt_rst4ch_config_reg, rst_chk_tms_s_config_reg, rst_chk_tdo_m_config_reg, rst_gen_ttco_config_reg, rst_gen_tckm_config_reg, rst_gen_tmsm_config_reg, rst_gen_tdim_config_reg, rst_logic_config_reg, multi_boot_top_config_reg};
        end
        
    endcase
end


// End of Code for CONTROL_CENTER
///////////////////////////////////////////////////////////////////////
//                              ><                                   //
//                            //||\\                                 //
//                           // || \\                                //
//                              ||                                   //
///////////////////////////////////////////////////////////////////////


//assign multi_boot_top_INNER      = CC_2_vio_control_int.multi_boot_top_CC;
//assign rst_logic_INNER           = CC_2_vio_control_int.rst_logic_CC;
//assign rst_gen_tdim_INNER        = CC_2_vio_control_int.rst_gen_tdim_CC;
//assign rst_gen_tmsm_INNER        = CC_2_vio_control_int.rst_gen_tmsm_CC;
//assign rst_gen_tckm_INNER        = CC_2_vio_control_int.rst_gen_tckm_CC;
//assign rst_gen_ttco_INNER        = CC_2_vio_control_int.rst_gen_ttco_CC;
//assign rst_chk_tdo_m_INNER       = CC_2_vio_control_int.rst_chk_tdo_m_CC;
//assign rst_chk_tms_s_INNER       = CC_2_vio_control_int.rst_chk_tms_s_CC;
//assign errcnt_rst4ch_INNER       = CC_2_vio_control_int.errcnt_rst4ch_CC;
//assign rst_chk_tck_s_INNER       = CC_2_vio_control_int.rst_chk_tck_s_CC;
//assign rst_chk_elinkttc_INNER    = CC_2_vio_control_int.rst_chk_elinkttc_CC;
//assign errcnt_inj_INNER          = CC_2_vio_control_int.errcnt_inj_CC;
//assign jtag_daisychain_INNER     = CC_2_vio_control_int.jtag_daisychain_CC;
//assign mbt_trigger_minisas_INNER = CC_2_vio_control_int.mbt_trigger_minisas_CC;
//assign rst_sma_FE_INNER          = CC_2_vio_control_int.rst_sma_FE_CC;
//assign rst_clkdiv_INNER          = CC_2_vio_control_int.rst_clkdiv_CC;


assign multi_boot_top_INNER = multi_boot_top_config_reg;
assign rst_logic_INNER = rst_logic_config_reg;
assign rst_gen_tdim_INNER = rst_gen_tdim_config_reg;
assign rst_gen_tmsm_INNER = rst_gen_tmsm_config_reg;
assign rst_gen_tckm_INNER = rst_gen_tckm_config_reg;
assign rst_gen_ttco_INNER = rst_gen_ttco_config_reg;
assign rst_chk_tdo_m_INNER = rst_chk_tdo_m_config_reg;
assign rst_chk_tms_s_INNER = rst_chk_tms_s_config_reg;
assign errcnt_rst4ch_INNER = errcnt_rst4ch_config_reg;
assign rst_chk_tck_s_INNER = rst_chk_tck_s_config_reg;
assign rst_chk_elinkttc_INNER = rst_chk_elinkttc_config_reg;
assign errcnt_inj_INNER = errcnt_inj_config_reg;
assign jtag_daisychain_INNER = jtag_daisychain_config_reg;
assign mbt_trigger_minisas_INNER = mbt_trigger_minisas_config_reg;
assign rst_sma_FE_INNER = rst_sma_FE_config_reg;
assign rst_clkdiv_INNER = rst_clkdiv_config_reg;
//

assign sent_config_back = CC_2_CC_int.sent_config_back_CC;
assign sent_config_CMD = CC_2_CC_int.sent_config_CMD_CC;




 Risingedge_Pulse Risingedge_Pulse_sent_inst(
 	.clk      (user_clk),
 	.signal_in(sent_config_back),
 	.pulse_out(sent_en)
 	);


ETH_TX_Submodule_Sending_FSM  #(.PACKAET_NUMBER(`ETH_TX_HEADER_PACKET_NUM + `ETH_RX_PACKET_NUM))
	ETH_TX_Submodule_Sending_CC_inst
	(
	.rst(rst),
	.clk(user_clk),
	.user_tx_2_SC_int(user_tx_2_SC_CC_int),
	.busy(sent_busy),
	.sent_en(sent_en),
	.data({`ETH_TX_HEADER_CC,ETH_reply_DATA})		


	);




assign use_ETH_CMD = CC_2_CC_int.use_ETH_CMD_CC;
assign global_rst = CC_2_CC_int.global_rst_CC;




endmodule
