
`define Local_State_Size 3



module ETH_RX_Filter (
  input clk,    // Clock 125MHz
  input rst,  


  input [7:0] rx_axis_fifo_tdata,
  input  rx_axis_fifo_tvalid,
  output rx_axis_fifo_tready,
  input  rx_axis_fifo_tlast,   

  output user_rx_fifo_wr_en_out,
  output [7:0]  user_rx_fifo_data_out,
  output user_rx_fifo_data_last_out
  
);


localparam IDLE 		= `Local_State_Size'd0, 
		   GET_SRC_MAC  = `Local_State_Size'd1, 
		   GET_DST_MAC  = `Local_State_Size'd2, 
		   GET_ETH_TYPE = `Local_State_Size'd3,
		   GET_DATA     = `Local_State_Size'd4, 
		   DUMP_DATA    = `Local_State_Size'd5;


localparam PC_MAC_ADDR = 48'hd89ef3241692;
localparam LOCAL_MAC_ADDR = 48'h002320212223;




reg [`Local_State_Size-1:0] STATE;



reg [47:0] received_src_MAC;
reg [47:0] received_dst_MAC;
reg [15:0] received_eth_type;
reg [3:0]  packet_cnter; // used to count the data order. For example, first 6 packet is src MAC addr 

reg user_rx_fifo_wr_en;
reg [7:0]user_rx_fifo_data; // additional bit is used as packet distiguisher.
reg user_rx_fifo_data_last;

always @(posedge clk) begin 
	if(rst) begin
		STATE  <= IDLE;
		packet_cnter <= 3'b0;
		received_src_MAC <= 48'b0;
		received_dst_MAC <= 48'b0;
		user_rx_fifo_wr_en <= 1'b0;
		user_rx_fifo_data <= 9'b0;
		user_rx_fifo_data_last <= 1'b0;
	end else begin
		user_rx_fifo_wr_en <= 1'b0;
		user_rx_fifo_data_last <= 1'b0;
		case (STATE)
			IDLE: begin 
				if (rx_axis_fifo_tvalid) begin 
					received_src_MAC[7:0] <= rx_axis_fifo_tdata;
					STATE <= GET_SRC_MAC;
					packet_cnter <= 3'b1;
				end else begin 
					packet_cnter <= 3'b0;
				end
			end

			GET_SRC_MAC: begin 
				if (rx_axis_fifo_tvalid) begin 
					if (packet_cnter <= 3'd5) begin 
						received_src_MAC[47:8] <= received_src_MAC[39:0];
						received_src_MAC[7:0]  <= rx_axis_fifo_tdata;
						packet_cnter <= packet_cnter +1;
					end else begin 
						received_dst_MAC[7:0] <= rx_axis_fifo_tdata;
						STATE <= GET_DST_MAC;
						packet_cnter <= 3'b1;
					end
				end
			end

			GET_DST_MAC: begin 
				if (rx_axis_fifo_tvalid) begin 
					if (packet_cnter <= 3'd5) begin 
						received_dst_MAC[47:8] <= received_dst_MAC[39:0];
						received_dst_MAC[7:0]  <= rx_axis_fifo_tdata;
						packet_cnter <= packet_cnter +1;
					end else begin 
						if (received_dst_MAC == LOCAL_MAC_ADDR) begin 
							STATE <= GET_ETH_TYPE;
							received_eth_type[15:8] <=rx_axis_fifo_tdata;
							packet_cnter <= 3'b1;
						end else begin 
							STATE <= DUMP_DATA;
						end
					end
				end
			end			

			GET_ETH_TYPE: begin 
				if (rx_axis_fifo_tvalid) begin 
					if(packet_cnter <= 3'd1) begin 
						received_eth_type[7:0] <=rx_axis_fifo_tdata;
						packet_cnter <= packet_cnter +1;
					end else begin 
						STATE <= GET_DATA;
						user_rx_fifo_wr_en <= 1'b1;
						user_rx_fifo_data  <= {rx_axis_fifo_tdata} ;
					end
				end
			end


			GET_DATA: begin 
				if (rx_axis_fifo_tvalid) begin 
					user_rx_fifo_wr_en <= 1'b1;
					user_rx_fifo_data  <= {rx_axis_fifo_tdata} ;
					if (rx_axis_fifo_tlast) begin 
						STATE <= IDLE;
						user_rx_fifo_data_last <= 1'b1;
						
					end
				end else begin 
					user_rx_fifo_wr_en <= 1'b0;
				end
			end

			DUMP_DATA: begin 
				if (rx_axis_fifo_tlast) begin 
					STATE <= IDLE;
				end
			end

		endcase
	end
end



assign user_rx_fifo_wr_en_out     = user_rx_fifo_wr_en;
assign user_rx_fifo_data_out  	  = user_rx_fifo_data;
assign user_rx_fifo_data_last_out = user_rx_fifo_data_last;

assign rx_axis_fifo_tready= 1'b1; // need to be careful about that.
endmodule // fake_data_sent