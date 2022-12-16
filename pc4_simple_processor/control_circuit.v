module control_circuit(Rwe, Rdst, ALUinB, ALUop, Dmwe, Rwd, BR, JP, set_r30, r30_value, q_imem, overflow);

	output Rwe, Rdst, ALUinB,  Dmwe, Rwd, BR, JP, set_r30;
	output [4:0] ALUop;
	output [31:0] r30_value;
	input overflow;
	input [31:0] q_imem;
	
	wire s_op_00000, s_addi, s_lw, s_op00000_addi_lw, s_rd_r0, s_sw, add_sub_flag, add_addi_sub_flag;
	wire [31:0] r30_add_sub_value;

	// ALUop
	// s_op_00000 = 1'b1 when q_imem[31:27] == 5'b00000
	and and_s_op_00000(s_op_00000, ~q_imem[31], ~q_imem[30], ~q_imem[29], ~q_imem[28], ~q_imem[27]);
	// ALUop = q_imem[6:2] when s_op_00000 == 1'b1; else ALUop = 5'b00000 
	assign ALUop = s_op_00000 ? q_imem[6:2] : 5'b00000;
	
	// Rwe = 1'b1 when (op == 5'00000 or 5'b00101 or 5'b01000) and Rd(q_imem[26:22]) != 5'b00000
	and and_s_addi(s_addi, ~q_imem[31], ~q_imem[30], q_imem[29], ~q_imem[28], q_imem[27]);
	and and_s_lw(s_lw, ~q_imem[31], q_imem[30], ~q_imem[29], ~q_imem[28], ~q_imem[27]);
	or or_s_op00000_addi_lw(s_op00000_addi_lw, s_op_00000, s_addi, s_lw);
	
	and and_rd_r0(s_rd_r0, ~q_imem[26], ~q_imem[25], ~q_imem[24], ~q_imem[23], ~q_imem[22]);					 
	
	and and_Rwe(Rwe, s_op00000_addi_lw, ~s_rd_r0);
	
	// Rdst = 1'b1 when op == 5'b00111
	and and_sw(s_sw, ~q_imem[31], ~q_imem[30], q_imem[29], q_imem[28], q_imem[27]);
	assign Rdst = s_sw ? 1'b1 : 1'b0;
	
	// ALUinB = 1'b1 when q_imem[31:27] != 5'b00000
	assign ALUinB = ~s_op_00000 ? 1'b1 : 1'b0;
	
	// Dmwe = 1'b1 when op == 5'b00111
	assign Dmwe = s_sw ? 1'b1 : 1'b0;
	
	// Rwd = 1'b1 when op == 5'b01000
	assign Rwd = s_lw ? 1'b1 : 1'b0;
	
	// BR
	assign BR = 1'b0;
	
	// JP
	assign JP = 1'b0;
	
	// !!!overflow : set_r30
	// add_sub_flag = 1'b1 when q_imem[31:27] == 5'b00000 && q_imem[6:3] == 4'b0000
	and and_add_sub_flag(add_sub_flag, s_op_00000, ~q_imem[6], ~q_imem[5], ~q_imem[4], ~q_imem[3]);
	// add_addi_sub_flag = 1'b1 when add_sub_flag || addi_flag
	or or_add_addi_sub_flag(add_addi_sub_flag, add_sub_flag, s_addi);
	// set_r30 = 1'b1 when add_addi_sub_flag && overflow
	and and_set_r30(set_r30, add_addi_sub_flag, overflow);
	
	// !!!overflow : r30_value
	// r30_add_sub_value = 32'd3 when q_imem[2] == 1'b1 --> sub ; else 32'd1
	assign r30_add_sub_value = q_imem[2] ? 32'd3 : 32'd1;
	// r30_value = 32'd2 when addi_flag; else r30_add_sub_value
	assign r30_value = s_addi ? 32'd2 : r30_add_sub_value;
	
	
endmodule
