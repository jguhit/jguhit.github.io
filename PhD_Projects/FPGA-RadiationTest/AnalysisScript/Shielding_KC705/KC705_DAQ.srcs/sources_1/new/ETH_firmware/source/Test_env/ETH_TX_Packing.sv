//ETH_TX_Packing.sv


`define ETH_TX_P_MAIN_STATE_SIZE 3
`define HEADER_PACKET_NUM 16 // how many 8 bits for heade. 48+48+ 16(ETH_TYPE) +16(packet_cnt)
`define HEADER_BIT_SIZE (`HEADER_PACKET_NUM*8) //16*8
`define DATA_CNT_SIZE 10 // since know the largest we are using is 48. set as 10 should be engough




module ETH_TX_Packing (
  input clk,    // Clock 125MHz
  input rst,  
  input use_ETH_CMD,
  CC_2_ETH_TX_Packing.ETH_TX_Packing_port CC_2_ETH_TX_Packing_int,

  input  tx_axis_fifo_tready,      
  output [7:0] tx_axis_fifo_tdata,    
  output tx_axis_fifo_tvalid,    
  output tx_axis_fifo_tlast,   
  

  output tx_eth_fifo_rd_en,
  input [8:0]tx_eth_fifo_dout,
  input tx_eth_fifo_valid



);

wire[15:0] ETH_TYPE;

assign ETH_TYPE = 16'd`ETH_TX_DATA_PACKET_NUM +16'd`ETH_TX_HEADER_PACKET_NUM + 2; // plus 2 because packet number

///////////////////////////////////////////////////////////////////////
//                              ||                                   //
//                           \\ || //                                //
//                            \\||//                                 //
//                              ><                                   //
///////////////////////////////////////////////////////////////////////
// Start of Code for VIO and CC assign

//Assign interface for CC_2_ETH_TX_Packing_int

wire[47:0] DST_MAC_ADDR_VIO, DST_MAC_ADDR_INNER;
wire[47:0] SRC_MAC_ADDR_VIO, SRC_MAC_ADDR_INNER;

assign DST_MAC_ADDR_INNER = (~use_ETH_CMD) ? DST_MAC_ADDR_VIO :  CC_2_ETH_TX_Packing_int.DST_MAC_ADDR_CC;
assign SRC_MAC_ADDR_INNER = (~use_ETH_CMD) ? SRC_MAC_ADDR_VIO :  CC_2_ETH_TX_Packing_int.SRC_MAC_ADDR_CC;


// End of Code for VIO and CC assign
///////////////////////////////////////////////////////////////////////
//                              ><                                   //
//                            //||\\                                 //
//                           // || \\                                //
//                              ||                                   //
///////////////////////////////////////////////////////////////////////

reg [`ETH_TX_P_MAIN_STATE_SIZE-1:0] STATE;

localparam IDLE 		   = `ETH_TX_P_MAIN_STATE_SIZE'd0, 
		   LOAD_LENGTH_W   = `ETH_TX_P_MAIN_STATE_SIZE'd1, 
		   LOAD_LENGTH 	   = `ETH_TX_P_MAIN_STATE_SIZE'd2, 
		   LOAD_ETH_HEADER = `ETH_TX_P_MAIN_STATE_SIZE'd3, 
		   SEND_HEADER     = `ETH_TX_P_MAIN_STATE_SIZE'd4,
		   SEND_DATA       = `ETH_TX_P_MAIN_STATE_SIZE'd5, 
		   SEND_DATA_W     = `ETH_TX_P_MAIN_STATE_SIZE'd6,
		   DONE            = `ETH_TX_P_MAIN_STATE_SIZE'd7; 


localparam HEADER_BYTE = `DATA_CNT_SIZE'd`HEADER_PACKET_NUM;





wire[7:0]tdata;
wire     tvalid;
wire     tlast;	



reg [`HEADER_BIT_SIZE-1:0] ETH_TX_header;
reg [`DATA_CNT_SIZE-1:0] data_cnt;
reg[15:0]packet_cnt;
reg tx_eth_fifo_rd_en_reg;
reg[15:0] data_length_r;

always @(posedge clk) begin 
	if(rst) begin
		STATE  <= IDLE;
		ETH_TX_header <= 'b0;
		data_cnt <= 'b0;
		packet_cnt <= 'b0;
		data_length_r <= 'b0;
		tx_eth_fifo_rd_en_reg <=1'b0;
	end else begin
		case (STATE)
			IDLE: begin
			    data_cnt <= 1'b0;
			    tx_eth_fifo_rd_en_reg <=1'b0;
				if (tx_eth_fifo_valid) begin 
					data_length_r[15:8] <= tx_eth_fifo_dout[7:0];
					packet_cnt <= packet_cnt + 1;
					tx_eth_fifo_rd_en_reg <=1'b1;
					STATE <= LOAD_LENGTH_W;
				end
			end

			LOAD_LENGTH_W: begin 
				tx_eth_fifo_rd_en_reg <=1'b0;
				STATE <= LOAD_LENGTH;
			end

			LOAD_LENGTH: begin 
				if (tx_eth_fifo_valid) begin 	
					data_length_r[7:0] <= tx_eth_fifo_dout[7:0];
					tx_eth_fifo_rd_en_reg <=1'b1;
					STATE <= LOAD_ETH_HEADER;					
				end		
			end

			LOAD_ETH_HEADER: begin 
				tx_eth_fifo_rd_en_reg <=1'b0;
				ETH_TX_header  <= {DST_MAC_ADDR_INNER,SRC_MAC_ADDR_INNER,data_length_r,packet_cnt};
				STATE <= SEND_HEADER;
			end

			SEND_HEADER: begin 
				if (tvalid) begin  
					ETH_TX_header <= ETH_TX_header << 8;
					if (data_cnt == HEADER_BYTE-1) begin 
						STATE <= SEND_DATA;
					end else begin 
						data_cnt <= data_cnt + 1'b1;
					end
				end 
			end	

			SEND_DATA: begin 
				if (tvalid) begin 
					tx_eth_fifo_rd_en_reg <=1'b1;
					if(tlast)begin 
						STATE <= DONE;
					end else begin 
						STATE <= SEND_DATA_W;
					end
				end
			end

			SEND_DATA_W: begin 
				tx_eth_fifo_rd_en_reg <=1'b0;
				STATE <= SEND_DATA;
			end

			DONE:begin  // b/c we need to get rid of the extra valid.
				tx_eth_fifo_rd_en_reg <=1'b0;
				STATE <= IDLE;
			end

		endcase
	end
end


assign tvalid= (STATE == SEND_HEADER)? tx_axis_fifo_tready :
			     (STATE == SEND_DATA)? tx_axis_fifo_tready & tx_eth_fifo_valid:
									   1'b0;

assign tdata = (STATE == SEND_HEADER)? ETH_TX_header[`HEADER_BIT_SIZE-1:`HEADER_BIT_SIZE-8] :
				 (STATE == SEND_DATA)? tx_eth_fifo_dout[7:0]: 
								       8'b0;

assign tlast = (STATE == SEND_DATA) & tvalid & tx_eth_fifo_dout[8];


assign tx_axis_fifo_tdata = tdata;
assign tx_axis_fifo_tvalid = tvalid;
assign tx_axis_fifo_tlast = tlast;
assign tx_eth_fifo_rd_en = tx_eth_fifo_rd_en_reg;



vio_ETH_TX_PRELOAD vio_ETH_TX_PRELOAD_inst (
  .clk(clk),                // input wire clk
  .probe_out0(DST_MAC_ADDR_VIO),  // output wire [47 : 0] probe_out0
  .probe_out1(SRC_MAC_ADDR_VIO)  // output wire [47 : 0] probe_out1

);




ila_ETH_TX_PACKING ila_ETH_TX_PACKING_inst (
	.clk(clk), // input wire clk


	.probe0(tx_axis_fifo_tlast), // input wire [0:0]  probe0  
	.probe1(tx_axis_fifo_tvalid), // input wire [0:0]  probe1 
	.probe2(tx_axis_fifo_tready), // input wire [0:0]  probe2 
	.probe3(tx_eth_fifo_rd_en), // input wire [0:0]  probe3 
	.probe4(STATE), // input wire [2:0]  probe4 
	.probe5(tx_axis_fifo_tdata), // input wire [7:0]  probe5
	.probe6(1'b0), // input wire [0:0]  probe6 
	.probe7(tx_eth_fifo_valid), // input wire [0:0]  probe7 
	.probe8(tx_eth_fifo_dout),
	.probe9(data_cnt)
);

endmodule // fake_data_sent



