// 5 to 32 decoder
module decoder(out, in);
	input [4:0] in;
	output [31:0] out;
	wire [4:0] _in;
	
	not not_in[4:0](_in, in);
	
	// $0: 5'b00000
	nor nor_out0(out[0], in[4], in[3], in[2], in[1], in[0]);
	// $1: 5'b00001
	nor nor_out1(out[1], in[4], in[3], in[2], in[1], _in[0]);
	// $2: 5'b00010
	nor nor_out2(out[2], in[4], in[3], in[2], _in[1], in[0]);
	// $3: 5'b00011
	nor nor_out3(out[3], in[4], in[3], in[2], _in[1], _in[0]);
	// $4: 5'b00100
	nor nor_out4(out[4], in[4], in[3], _in[2], in[1], in[0]);
	// $5: 5'b00101
	nor nor_out5(out[5], in[4], in[3], _in[2], in[1], _in[0]);
	// $6: 5'b00110
	nor nor_out6(out[6], in[4], in[3], _in[2], _in[1], in[0]);
	// $7: 5'b00111
	nor nor_out7(out[7], in[4], in[3], _in[2], _in[1], _in[0]);
	// $8: 5'b01000
	nor nor_out8(out[8], in[4], _in[3], in[2], in[1], in[0]);
	// $9: 5'b01001
	nor nor_out9(out[9], in[4], _in[3], in[2], in[1], _in[0]);
	// $10: 5'b01010
	nor nor_out10(out[10], in[4], _in[3], in[2], _in[1], in[0]);
	// $11: 5'b01011
	nor nor_out11(out[11], in[4], _in[3], in[2], _in[1], _in[0]);
	// $12: 5'b01100
	nor nor_out12(out[12], in[4], _in[3], _in[2], in[1], in[0]);
	// $13: 5'b01101
	nor nor_out13(out[13], in[4], _in[3], _in[2], in[1], _in[0]);
	// $14: 5'b01110
	nor nor_out14(out[14], in[4], _in[3], _in[2], _in[1], in[0]);
	// $15: 5'b01111
	nor nor_out15(out[15], in[4], _in[3], _in[2], _in[1], _in[0]);
	// $16: 5'b10000
	nor nor_out16(out[16], _in[4], in[3], in[2], in[1], in[0]);
	// $17: 5'b10001
	nor nor_out17(out[17], _in[4], in[3], in[2], in[1], _in[0]);
	// $18: 5'b10010
	nor nor_out18(out[18], _in[4], in[3], in[2], _in[1], in[0]);
	// $19: 5'b10011
	nor nor_out19(out[19], _in[4], in[3], in[2], _in[1], _in[0]);
	// $20: 5'b10100
	nor nor_out20(out[20], _in[4], in[3], _in[2], in[1], in[0]);
	// $21: 5'b10101
	nor nor_out21(out[21], _in[4], in[3], _in[2], in[1], _in[0]);
	// $22: 5'b10110
	nor nor_out22(out[22], _in[4], in[3], _in[2], _in[1], in[0]);
	// $23: 5'b10111
	nor nor_out23(out[23], _in[4], in[3], _in[2], _in[1], _in[0]);
	// $24: 5'b11000
	nor nor_out24(out[24], _in[4], _in[3], in[2], in[1], in[0]);
	// $25: 5'b11001
	nor nor_out25(out[25], _in[4], _in[3], in[2], in[1], _in[0]);
	// $26: 5'b11010
	nor nor_out26(out[26], _in[4], _in[3], in[2], _in[1], in[0]);
	// $27: 5'b11011
	nor nor_out27(out[27], _in[4], _in[3], in[2], _in[1], _in[0]);
	// $28: 5'b11100
	nor nor_out28(out[28], _in[4], _in[3], _in[2], in[1], in[0]);
	// $29: 5'b11101
	nor nor_out29(out[29], _in[4], _in[3], _in[2], in[1], _in[0]);
	// $30: 5'b11110
	nor nor_out30(out[30], _in[4], _in[3], _in[2], _in[1], in[0]);
	// $31: 5'b11111
	nor nor_out31(out[31], _in[4], _in[3], _in[2], _in[1], _in[0]);
	
endmodule
