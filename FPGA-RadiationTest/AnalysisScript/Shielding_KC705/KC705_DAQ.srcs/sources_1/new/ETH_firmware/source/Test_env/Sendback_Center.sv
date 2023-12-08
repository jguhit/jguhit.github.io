//Sendback_Center.sv



`define GRANT_SEL_SIZE 2


`define GRANT_vio_data 1
`define GRANT_CC 2
`define GRANT_fake_data_sent 3


module Sendback_Center (
	input user_clk,    
	input ETH_clk,
	input rst,  


	user_tx_2_SC.SC_port user_tx_2_SC_fake_data_sent_int,
	user_tx_2_SC.SC_port user_tx_2_SC_CC_int,
	user_tx_2_SC.SC_port user_tx_2_SC_vio_data_int,


	input tx_eth_fifo_rd_en,
    output tx_eth_fifo_empty,
    output [8:0] tx_eth_fifo_dout,    
    output tx_eth_fifo_valid

);






wire tx_eth_fifo_wr_en;
wire [8:0]tx_eth_fifo_din;
reg tx_eth_fifo_wr_en_reg; // used to sample inside. Better for time constrain.
reg [8:0]tx_eth_fifo_din_reg;

wire tx_eth_fifo_full;
wire tx_eth_fifo_prog_full;
reg[`GRANT_SEL_SIZE-1:0]Grant_sel;


reg user_wr_en;
reg [7:0]user_tdata;
reg user_tlast;


always @(posedge user_clk) begin 
	if (rst) begin 
		Grant_sel <= {`GRANT_SEL_SIZE{1'b0}};
	end else begin 
		if (!Grant_sel) begin 
			if (user_tx_2_SC_vio_data_int.to_SC_request) begin 
				Grant_sel <= `GRANT_SEL_SIZE'd`GRANT_vio_data;
			end else if (user_tx_2_SC_CC_int.to_SC_request) begin 
				Grant_sel <= `GRANT_SEL_SIZE'd`GRANT_CC;
			end else if (user_tx_2_SC_fake_data_sent_int.to_SC_request) begin 
				Grant_sel <= `GRANT_SEL_SIZE'd`GRANT_fake_data_sent;
			end
		end else begin 
			if (user_tlast) begin 
				Grant_sel <= {`GRANT_SEL_SIZE{1'b0}};
			end
		end
	end
end


assign user_tx_2_SC_fake_data_sent_int.from_SC_Grant = (Grant_sel == `GRANT_SEL_SIZE'd`GRANT_fake_data_sent)?(~tx_eth_fifo_prog_full):1'b0;
assign user_tx_2_SC_CC_int.from_SC_Grant = (Grant_sel == `GRANT_SEL_SIZE'd`GRANT_CC)?(~tx_eth_fifo_prog_full):1'b0;
assign user_tx_2_SC_vio_data_int.from_SC_Grant = (Grant_sel == `GRANT_SEL_SIZE'd`GRANT_vio_data)?(~tx_eth_fifo_prog_full):1'b0;



always @* begin 
	case (Grant_sel)

		`GRANT_SEL_SIZE'd`GRANT_vio_data: begin 
			user_wr_en = user_tx_2_SC_vio_data_int.to_SC_wr_en;
			user_tdata = user_tx_2_SC_vio_data_int.to_SC_tdata;
			user_tlast = user_tx_2_SC_vio_data_int.to_SC_tlast;
		end	

		`GRANT_SEL_SIZE'd`GRANT_CC: begin 
			user_wr_en = user_tx_2_SC_CC_int.to_SC_wr_en;
			user_tdata = user_tx_2_SC_CC_int.to_SC_tdata;
			user_tlast = user_tx_2_SC_CC_int.to_SC_tlast;
		end	

		`GRANT_SEL_SIZE'd`GRANT_fake_data_sent: begin 
			user_wr_en = user_tx_2_SC_fake_data_sent_int.to_SC_wr_en;
			user_tdata = user_tx_2_SC_fake_data_sent_int.to_SC_tdata;
			user_tlast = user_tx_2_SC_fake_data_sent_int.to_SC_tlast;
		end

		default: begin 
			user_wr_en = 1'b0;
			user_tdata = 8'b0;
			user_tlast = 1'b0;
		end
	endcase
end






assign tx_eth_fifo_wr_en = user_wr_en;
assign tx_eth_fifo_din = {user_tlast,user_tdata};



always @(posedge user_clk) begin 
	tx_eth_fifo_wr_en_reg <= tx_eth_fifo_wr_en; 
	tx_eth_fifo_din_reg <= tx_eth_fifo_din;
end


fifo_ETH_TX fifo_ETH_TX_inst (
  .rst(rst),        // input wire rst
  .wr_clk(user_clk),  // input wire wr_clk
  .rd_clk(ETH_clk),  // input wire rd_clk
  .din(tx_eth_fifo_din_reg),        // input wire [8 : 0] din
  .wr_en(tx_eth_fifo_wr_en_reg),    // input wire wr_en
  // .almost_full(tx_eth_fifo_almost_full),  // output wire almost_full
  .rd_en(tx_eth_fifo_rd_en),    // input wire rd_en
  .dout(tx_eth_fifo_dout),      // output wire [8 : 0] dout
  .full(tx_eth_fifo_full),      // output wire full
  .empty(tx_eth_fifo_empty),          // output wire valid
  .valid(tx_eth_fifo_valid),          // output wire valid
  .prog_full(tx_eth_fifo_prog_full)  // output wire prog_full
);






endmodule
