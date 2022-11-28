/**
 * READ THIS DESCRIPTION!
 *
 * The processor takes in several inputs from a skeleton file.
 *
 * Inputs
 * clock: this is the clock for your processor at 50 MHz
 * reset: we should be able to assert a reset to start your pc from 0 (sync or
 * async is fine)
 *
 * Imem: input data from imem
 * Dmem: input data from dmem
 * Regfile: input data from regfile
 *
 * Outputs
 * Imem: output control signals to interface with imem
 * Dmem: output control signals and data to interface with dmem
 * Regfile: output control signals and data to interface with regfile
 *
 * Notes
 *
 * Ultimately, your processor will be tested by subsituting a master skeleton, imem, dmem, so the
 * testbench can see which controls signal you active when. Therefore, there needs to be a way to
 * "inject" imem, dmem, and regfile interfaces from some external controller module. The skeleton
 * file acts as a small wrapper around your processor for this purpose.
 *
 * You will need to figure out how to instantiate two memory elements, called
 * "syncram," in Quartus: one for imem and one for dmem. Each should take in a
 * 12-bit address and allow for storing a 32-bit value at each address. Each
 * should have a single clock.
 *
 * Each memory element should have a corresponding .mif file that initializes
 * the memory element to certain value on start up. These should be named
 * imem.mif and dmem.mif respectively.
 *
 * Importantly, these .mif files should be placed at the top level, i.e. there
 * should be an imem.mif and a dmem.mif at the same level as process.v. You
 * should figure out how to point your generated imem.v and dmem.v files at
 * these MIF files.
 *
 * imem
 * Inputs:  12-bit address, 1-bit clock enable, and a clock
 * Outputs: 32-bit instruction
 *
 * dmem
 * Inputs:  12-bit address, 1-bit clock, 32-bit data, 1-bit write enable
 * Outputs: 32-bit data at the given address
 *
 */
module processor(
    // Control signals
    clock,                          // I: The master clock
    reset,                          // I: A reset signal

    // Imem
    address_imem,                   // O: The address of the data to get from imem
    q_imem,                         // I: The data from imem

    // Dmem
    address_dmem,                   // O: The address of the data to get or put from/to dmem
    data,                           // O: The data to write to dmem
    wren,                           // O: Write enable for dmem
    q_dmem,                         // I: The data from dmem

    // Regfile
    ctrl_writeEnable,               // O: Write enable for regfile
    ctrl_writeReg,                  // O: Register to write to in regfile
    ctrl_readRegA,                  // O: Register to read from port A of regfile
    ctrl_readRegB,                  // O: Register to read from port B of regfile
    data_writeReg,                  // O: Data to write to for regfile
    data_readRegA,                  // I: Data from port A of regfile
    data_readRegB                   // I: Data from port B of regfile
);
	 
    // Control signals
    input clock, reset;

    // Imem
    output [11:0] address_imem;
    input [31:0] q_imem;

    // Dmem
    output [11:0] address_dmem;
    output [31:0] data;
    output wren;
    input [31:0] q_dmem;

    // Regfile
    output ctrl_writeEnable;
    output [4:0] ctrl_writeReg, ctrl_readRegA, ctrl_readRegB;
    output [31:0] data_writeReg;
    input [31:0] data_readRegA, data_readRegB;

	 /* YOUR CODE STARTS HERE */
	 wire pc_1_isNotEqual, pc_1_isLessThan, pc_1_overflow, pc_i_isNotEqual, pc_i_isLessThan, pc_i_overflow;
	 wire [31:0] pc_in, pc_out, pc_1, pc_i, pc_br, pc_jp;
	 
	 wire Rwe, Rdst, ALUinB, Dmwe, Rwd, BR, JP, Jr, rd_30, rd_31, rA_r0, Rwd_ovf, Rwd_pc_1, Rwd_setx;
	 wire [4:0] ALUop;
	 wire [31:0] ovf_val;
	 
	 wire isNotEqual, isLessThan, overflow;
	 wire [4:0] ctrl_writeReg_temp, ctrl_ALUopcode, ctrl_shiftamt;
	 wire [31:0] immed_sx, immed_sx_pos, immed_sx_neg, data_operandA, data_operandB, data_result;
	 
	 wire [31:0] data_writeReg_t1, data_writeReg_t2, data_writeReg_t3;
	 
	 // PC
	 register PC_reg(pc_out, pc_in, clock, reset, 1'b1);
	 // PC + 1
	 alu PCplus1(32'b1, pc_out, 5'b0, 5'b0, pc_1, pc_1_isNotEqual, pc_1_isLessThan, pc_1_overflow);
	 // PC + immediate number
	 alu PCplusImmed(pc_1, immed_sx,  5'b0, 5'b0, pc_i, pc_i_isNotEqual, pc_i_isLessThan, pc_i_overflow);
	 assign pc_br = BR ? pc_i : pc_1;
	 // PC JP
	 assign pc_jp = JP ? {5'b00000, q_imem[26:0]} : pc_br;
	 // PC Jr
	 assign pc_in = Jr ? data_readRegB : pc_jp;
	 
	 // InsnMem
	 assign address_imem = pc_out[11:0];
	 
	 // Control Circuit
	 control_circuit cc(q_imem, isNotEqual, isLessThan, overflow, 
	 Rwe, Rdst, ALUinB, ALUop, Dmwe, Rwd, BR, JP, Jr, rd_30, rd_31, rA_r0, Rwd_ovf, Rwd_pc_1, Rwd_setx, ovf_val);
	 
	 // regfile
	 assign ctrl_writeEnable = Rwe;
	 assign ctrl_writeReg_temp = rd_30 ? 5'd30 : q_imem[26:22];
	 assign ctrl_writeReg = rd_31 ? 5'd31 : ctrl_writeReg_temp;
	 assign ctrl_readRegA = rA_r0 ? 5'b00000 : q_imem[21:17];
	 assign ctrl_readRegB = Rdst ? ctrl_writeReg_temp : q_imem[16:12];

	 
	 // ALU
	 assign data_operandA = data_readRegA;
	 assign immed_sx_pos = {15'h0000, q_imem[16:0]};
	 assign immed_sx_neg = {15'h7fff, q_imem[16:0]};
	 assign immed_sx = q_imem[16] ? immed_sx_neg : immed_sx_pos;
	 assign data_operandB = ALUinB ? immed_sx : data_readRegB;
	 assign ctrl_ALUopcode = ALUop;
	 assign ctrl_shiftamt = q_imem[11:7];
	 alu main_alu(data_operandA, data_operandB, ctrl_ALUopcode, ctrl_shiftamt, data_result, isNotEqual, isLessThan, overflow);
	 
	 // DataMem
	 assign address_dmem = data_result[11:0];
	 assign data = data_readRegB;
	 assign wren = Dmwe;
	 assign data_writeReg_t1 = Rwd ? q_dmem : data_result;
	 assign data_writeReg_t2 = Rwd_ovf ? ovf_val : data_writeReg_t1;
	 assign data_writeReg_t3 = Rwd_pc_1 ? pc_1 : data_writeReg_t2;
	 assign data_writeReg = Rwd_setx ? {5'b00000, q_imem[26:0]} : data_writeReg_t3;
	
endmodule