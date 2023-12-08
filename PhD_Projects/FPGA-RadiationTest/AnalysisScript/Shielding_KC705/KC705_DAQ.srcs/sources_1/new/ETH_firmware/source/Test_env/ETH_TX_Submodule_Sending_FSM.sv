//ETH_TX_Submodule_Sending_FSM.sv
// packet number should be less than 46 for configuration now!!!!!!



module ETH_TX_Submodule_Sending_FSM #(
	parameter PACKAET_NUMBER = `ETH_TX_PACKET_NUM
	)
	(
	input rst,
	input clk,    // Clock
 	user_tx_2_SC.user_port user_tx_2_SC_int,
	output busy,
	input sent_en,
	input[PACKAET_NUMBER*8-1:0] data


);

localparam PACKET_SIZE = PACKAET_NUMBER*8;
`define ETH_TX_State_Size 3

localparam IDLE 		= `ETH_TX_State_Size'd0, 
		   WAITING_FOR_GRANT 	= `ETH_TX_State_Size'd1, 
		   SENDING_DATA 		= `ETH_TX_State_Size'd2, 
		   LAST_PACKET  = `ETH_TX_State_Size'd3; 

reg [`ETH_TX_State_Size-1:0] STATE;
assign busy = (STATE != IDLE);





reg[7:0] tdata;
reg		 tvalid;
reg      tlast;	

reg request;
reg [15:0] DATA_cnter;


reg [PACKET_SIZE-1:0] data_reg;


wire from_SC_Grant;






always @(posedge clk) begin 
	if(rst) begin
		DATA_cnter <= 16'b0;
		tdata <= 8'b0;
		tvalid <= 1'b0;
		tlast <= 1'b0;
		request <= 1'b0;
		data_reg <= {PACKET_SIZE{1'b0}};
		STATE <= IDLE;
	end else begin
		case(STATE)
			IDLE: begin 
				DATA_cnter <= 16'b0;
				tdata <= 8'b0;
				tvalid <= 1'b0;
				tlast <= 1'b0;
				request <= 1'b0;
				if (sent_en) begin 
					request <= 1'b1;
					STATE <= WAITING_FOR_GRANT;
					data_reg <= data;
				end
			end

			WAITING_FOR_GRANT: begin 
				if (from_SC_Grant) begin 
					STATE <= SENDING_DATA;
					request <= 1'b0;
				end
			end

			SENDING_DATA: begin 
				if (from_SC_Grant) begin 
					tdata <= data_reg[PACKET_SIZE-1:PACKET_SIZE-8];
					data_reg<= data_reg <<8;
					tvalid <= 1'b1;
					tlast <= 1'b0;
					DATA_cnter <= DATA_cnter + 1;
					if (DATA_cnter >= PACKAET_NUMBER-2) begin
						STATE <= LAST_PACKET;
					end  
				end else begin 
					tvalid <= 1'b0;
					tlast <= 1'b0;
				end
			end

			LAST_PACKET: begin 
				if (from_SC_Grant) begin 
					tdata <= data_reg[PACKET_SIZE-1:PACKET_SIZE-8];
					tvalid <= 1'b1;
					tlast <= 1'b1;
					STATE <= IDLE;
				end else begin 
					tvalid <= 1'b0;
					tlast <= 1'b0;					
				end
			end

		endcase
	end
end


assign from_SC_Grant = user_tx_2_SC_int.from_SC_Grant;

assign  user_tx_2_SC_int.to_SC_tdata  = tdata;
assign  user_tx_2_SC_int.to_SC_wr_en = tvalid;
assign  user_tx_2_SC_int.to_SC_tlast  = tlast;
assign  user_tx_2_SC_int.to_SC_request = request;





endmodule


