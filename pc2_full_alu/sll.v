module sll32(data_sll, data_input, ctrl_shiftamt);

	output [31:0] data_sll;
	input [31:0] data_input;
	input [4:0] ctrl_shiftamt;
	
	wire [31:0] data_mux_0, data_mux_1, data_mux_2, data_mux_3;
	
	mux2to1 mux_0[31:0](data_mux_0, data_input, {data_input[30:0], 1'b0}, ctrl_shiftamt[0]);
	
	mux2to1 mux_1[31:0](data_mux_1, data_mux_0, {data_mux_0[29:0], 2'b00}, ctrl_shiftamt[1]);
	
	mux2to1 mux_2[31:0](data_mux_2, data_mux_1, {data_mux_1[27:0], 4'h0}, ctrl_shiftamt[2]);
	
	mux2to1 mux_3[31:0](data_mux_3, data_mux_2, {data_mux_2[23:0], 8'h00}, ctrl_shiftamt[3]);

	mux2to1 mux_4[31:0](data_sll,   data_mux_3, {data_mux_3[15:0], 16'h0000}, ctrl_shiftamt[4]);
	
endmodule
