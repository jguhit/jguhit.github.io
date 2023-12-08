// Risingedge_Pulse.v


module Risingedge_Pulse (
	input clk,    
	input signal_in,
	output pulse_out

	
);

reg [1:0] reg_sync;



always @(posedge clk) begin 
	reg_sync <= {reg_sync[0],signal_in};
end

assign pulse_out = reg_sync[0] & (~reg_sync[1]);

endmodule