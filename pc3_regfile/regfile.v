module regfile (
    clock,
    ctrl_writeEnable,
    ctrl_reset, ctrl_writeReg,
    ctrl_readRegA, ctrl_readRegB, data_writeReg,
    data_readRegA, data_readRegB
);

   input clock, ctrl_writeEnable, ctrl_reset;
   input [4:0] ctrl_writeReg, ctrl_readRegA, ctrl_readRegB;
   input [31:0] data_writeReg;

   output [31:0] data_readRegA, data_readRegB;

   /* YOUR CODE HERE */
	wire [31:0] ctrl_writeReg_decode, ctrl_writeReg_decode_ena;
	wire [31:0] ctrl_readRegA_decode, ctrl_readRegB_decode;
	wire [31:0] data_readReg[31:0];
	
	// decode ctrl signal
	decoder decoder_write(ctrl_writeReg_decode, ctrl_writeReg);
	and and_write_enable[31:0](ctrl_writeReg_decode_ena, ctrl_writeEnable);
	decoder decoder_readA(ctrl_readRegA_decode,ctrl_readRegA);
	decoder decoder_readB(ctrl_readRegB_decode,ctrl_readRegB);
	
	// register 0
	register r0(data_readReg[0][31:0], 32'h00000000, clock, ctrl_reset, ctrl_writeReg_decode_ena[0]);
	bufif1 tribuf_A0[31:0](data_readRegA, data_readReg[0][31:0], ctrl_readRegA_decode[0]);
	bufif1 tribuf_B0[31:0](data_readRegB, data_readReg[0][31:0], ctrl_readRegB_decode[0]);
	
	// generate register 1-31
	genvar i;
	generate
		for (i=1;i<32;i=i+1) begin: register_loop
			register r(data_readReg[i][31:0], data_writeReg[31:0], clock, ctrl_reset, ctrl_writeReg_decode_ena[i]);
			bufif1 tribuf_A[31:0](data_readRegA, data_readReg[i][31:0], ctrl_readRegA_decode[i]);
			bufif1 tribuf_B[31:0](data_readRegB, data_readReg[i][31:0], ctrl_readRegB_decode[i]);
		end
	endgenerate
	
	
endmodule
