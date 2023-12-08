



module fake_data_sent (
  input clk,    
  input rst,  
  input use_ETH_CMD,

  CC_2_fake_data_sent.fake_data_sent_port CC_2_fake_data_sent_int,

  user_tx_2_SC.user_port user_tx_2_SC_fake_data_sent_int

 
  
);



// wire from_SC_Grant;      



wire[0:0] sent_once_VIO, sent_once_INNER;
wire[0:0] sent_loop_VIO, sent_loop_INNER;
wire[15:0] sent_loop_interval_VIO, sent_loop_interval_INNER;

assign sent_once_INNER = (~use_ETH_CMD) ? sent_once_VIO :  CC_2_fake_data_sent_int.sent_once_CC;
assign sent_loop_INNER = (~use_ETH_CMD) ? sent_loop_VIO :  CC_2_fake_data_sent_int.sent_loop_CC;
assign sent_loop_interval_INNER = (~use_ETH_CMD) ? sent_loop_interval_VIO :  CC_2_fake_data_sent_int.sent_loop_interval_CC;






reg[15:0] sent_loop_counter;
reg sent_loop;



wire sent_en;
reg[1:0] sent_once_r;
wire sent_once;
wire sent_busy;
always @(posedge clk) begin 
	sent_once_r <= {sent_once_r[0],sent_once_INNER};
end

assign sent_once = sent_once_r[0] & (~sent_once_r[1]);


always @(posedge clk) begin 
	sent_loop_counter <= sent_loop_interval_INNER; // better to not set that interval as zero, but zero is fine.
	sent_loop <= 1'b0; 
	// if (STATE == IDLE) begin 
	if (~sent_busy) begin
		if (sent_loop_INNER) begin 
			if (sent_loop_counter == 16'b0) begin 
				sent_loop <= 1'b1;
				sent_loop_counter <= sent_loop_interval_INNER;
			end else begin 
				sent_loop_counter <= sent_loop_counter - 1;
			end
		end 
	end
end


assign sent_en = sent_loop_INNER ? sent_loop : sent_once; 




wire[16*8-1:0] sent_data;


assign sent_data = 128'h0f0e_0d0c_0b0a_0908_0706_0504_0302_0100;

ETH_TX_Submodule_Sending_FSM  #(.PACKAET_NUMBER(`ETH_TX_HEADER_PACKET_NUM + 16 + 2))
	ETH_TX_Submodule_Sending_FSM_fake_data_sent_inst
	(
	.rst(rst),
	.clk(clk),
	.user_tx_2_SC_int(user_tx_2_SC_fake_data_sent_int),
	.busy(sent_busy),
	.sent_en(sent_en),
	.data({16'd22,`ETH_TX_HEADER_fake_data_sent,sent_data})		


	);

vio_fake_data vio_fake_data_inst (
  .clk(clk),                // input wire clk
  .probe_out0(sent_once_VIO),  // output wire [0 : 0] probe_out0
  .probe_out1(sent_loop_VIO),  // output wire [0 : 0] probe_out1
  .probe_out2(sent_loop_interval_VIO)  // output wire [15 : 0] probe_out2

);




ila_fake_data_monitor ila_fake_data_monitor_inst (
	.clk(clk), // input wire clk


	.probe0(user_tx_2_SC_fake_data_sent_int.to_SC_tlast), // input wire [0:0]  probe0  
	.probe1(user_tx_2_SC_fake_data_sent_int.to_SC_wr_en), // input wire [0:0]  probe1 
	.probe2(user_tx_2_SC_fake_data_sent_int.to_SC_request), // input wire [0:0]  probe2 
	.probe3(sent_en), // input wire [0:0]  probe3 
	// .probe4(STATE), // input wire [2:0]  probe4 
	.probe4(3'b0), // input wire [2:0]  probe4 
	.probe5(user_tx_2_SC_fake_data_sent_int.to_SC_tdata), // input wire [7:0]  probe5
	.probe6(user_tx_2_SC_fake_data_sent_int.from_SC_Grant)

);


endmodule // fake_data_sent
