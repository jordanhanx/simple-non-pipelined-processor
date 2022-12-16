module register(data_readReg, data_writeReg, clock, ctrl_reset, ctrl_writeEnable);

   input clock, ctrl_reset, ctrl_writeEnable;
   input [31:0] data_writeReg;

   output [31:0] data_readReg;

   dffe_ dffe_reg[31:0](data_readReg, data_writeReg, clock, ctrl_writeEnable, ctrl_reset);

endmodule
