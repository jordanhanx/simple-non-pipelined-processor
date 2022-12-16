module sra32(data_sra, data_input, ctrl_shiftamt);

	output [31:0] data_sra;
	input [31:0] data_input;
	input [4:0] ctrl_shiftamt;
	
	wire [31:0] data_mux_p0, data_mux_p1, data_mux_p2, data_mux_p3, data_sra_pos;
	wire [31:0] data_mux_n0, data_mux_n1, data_mux_n2, data_mux_n3, data_sra_neg;
	
	// data_input is POSTIVE!
	mux2to1 mux_pos_0[31:0](data_mux_p0, data_input, {16'h0000, data_input[31:16]}, ctrl_shiftamt[4]);
	
	mux2to1 mux_pos_1[31:0](data_mux_p1, data_mux_p0, {8'h00, data_mux_p0[31:8]}, ctrl_shiftamt[3]);
	
	mux2to1 mux_pos_2[31:0](data_mux_p2, data_mux_p1, {4'h0, data_mux_p1[31:4]}, ctrl_shiftamt[2]);
	
	mux2to1 mux_pos_3[31:0](data_mux_p3, data_mux_p2, {2'b00, data_mux_p2[31:2]}, ctrl_shiftamt[1]);

	mux2to1 mux_pos_4[31:0](data_sra_pos,data_mux_p3, {1'b0, data_mux_p3[31:1]}, ctrl_shiftamt[0]);	
	
	// data_input is NEGATIVE!
	mux2to1 mux_neg_0[31:0](data_mux_n0, data_input, {16'hffff, data_input[31:16]}, ctrl_shiftamt[4]);
	
	mux2to1 mux_neg_1[31:0](data_mux_n1, data_mux_n0, {4'hf, data_mux_n0[31:4]}, ctrl_shiftamt[2]);
	
	mux2to1 mux_neg_2[31:0](data_mux_n2, data_mux_n1, {1'b1, data_mux_n1[31:1]}, ctrl_shiftamt[0]);
	
	mux2to1 mux_neg_3[31:0](data_mux_n3, data_mux_n2, {8'hff, data_mux_n2[31:8]}, ctrl_shiftamt[3]);

	mux2to1 mux_neg_4[31:0](data_sra_neg,data_mux_n3, {2'b11, data_mux_n3[31:2]}, ctrl_shiftamt[1]);	
	// order doesn't matter at all :D
	
	// select ourput corresponding to sign-bit
	mux2to1 mux_sra[31:0] (data_sra, data_sra_pos, data_sra_neg, data_input[31]);
	

endmodule