module alu(data_operandA, data_operandB, ctrl_ALUopcode, ctrl_shiftamt, data_result, isNotEqual, isLessThan, overflow);

   input [31:0] data_operandA, data_operandB;
   input [4:0] ctrl_ALUopcode, ctrl_shiftamt;

   output [31:0] data_result;
   output isNotEqual, isLessThan, overflow;

   // YOUR CODE HERE //
	
	wire [31:0] data_operandB_1complement, data_operandB_mux, data_sum, data_bitwise_and, data_bitwise_or, data_sll, data_sra;
	wire [1:0] cout;
	
	// calculate 2's complement during subtraction
	not     not_B[31:0](data_operandB_1complement, data_operandB);
	mux2to1 mux_B[31:0](data_operandB_mux, data_operandB, data_operandB_1complement, ctrl_ALUopcode[0]);
	
	// 32-bit addition
	cla32 cla_sum(data_sum, cout, ctrl_ALUopcode[0], data_operandA, data_operandB_mux);
	
	// select result by tri-state buffer
	nor   nor_flag_add_sub (flag_add_sub, ctrl_ALUopcode[4], ctrl_ALUopcode[3], ctrl_ALUopcode[2], ctrl_ALUopcode[1]);
	bufif1 tri_state_buf_sum[31:0](data_result, data_sum, flag_add_sub); 
	
	// signed int overflow: cin != cout at the most significant bit in addition
	xor xor_ovf(ovf, cout[1], cout[0]);
	bufif1 tri_state_buf_ovf(overflow, ovf, flag_add_sub);
		
	// isNotEqual
	or or_neq01(or_7_0,    data_sum[7], data_sum[6], data_sum[5], data_sum[4], data_sum[3], data_sum[2], data_sum[1], data_sum[0]);
	or or_neq02(or_15_8,  data_sum[15],data_sum[14],data_sum[13],data_sum[12],data_sum[11],data_sum[10], data_sum[9], data_sum[8]);
	or or_neq03(or_23_16, data_sum[23],data_sum[22],data_sum[21],data_sum[20],data_sum[19],data_sum[18],data_sum[17],data_sum[16]);
	or or_neq04(or_31_24, data_sum[31],data_sum[30],data_sum[29],data_sum[28],data_sum[27],data_sum[26],data_sum[25],data_sum[24]);
	or or_neq  (is_neq, or_31_24, or_23_16, or_15_8, or_7_0);
	
	and and_flag_sub(flag_sub, flag_add_sub, ctrl_ALUopcode[0]);
	bufif1 tri_state_buf_neq(isNotEqual, is_neq, flag_sub);
	
	// isLessThan
	not not_signed_bit(n_sum_31, data_sum[31]);
	mux2to1 mux_LessThan(is_less, data_sum[31], n_sum_31, ovf);
	bufif1 tri_state_buf_less(isLessThan, is_less, flag_sub);
	
	// bitwise AND
	and and_bitwise[31:0](data_bitwise_and, data_operandA, data_operandB);
	//assign data_bitwise_and = data_operandA & data_operandB;
	
	not not_opcode_1(not_op_1, ctrl_ALUopcode[1]);
	nor nor_flag_bitand(flag_bitand, ctrl_ALUopcode[4], ctrl_ALUopcode[3], ctrl_ALUopcode[2], not_op_1, ctrl_ALUopcode[0]);
	bufif1 tri_state_buf_bitand[31:0](data_result, data_bitwise_and, flag_bitand);
	
	// bitwise OR
	or or_bitwise[31:0](data_bitwise_or, data_operandA, data_operandB);
	//assign data_bitwise_or = data_operandA | data_operandB;
	
	nand nand_opcode_10(na_op_10, ctrl_ALUopcode[1], ctrl_ALUopcode[0]);
	nor nor_flag_bitor(flag_bitor, ctrl_ALUopcode[4], ctrl_ALUopcode[3], ctrl_ALUopcode[2], na_op_10);
	bufif1 tri_state_buf_bitor[31:0](data_result, data_bitwise_or, flag_bitor);
	
	// Logical left-shift
	sll32 sll_ (data_sll, data_operandA, ctrl_shiftamt);
	
	not not_opcode_2(not_op_2, ctrl_ALUopcode[2]);
	nor nor_flag_sll(flag_sll, ctrl_ALUopcode[4], ctrl_ALUopcode[3], not_op_2, ctrl_ALUopcode[1], ctrl_ALUopcode[0]);
	bufif1 tri_state_buf_sll[31:0](data_result, data_sll, flag_sll);
	
	// Arithmetic right-shift
	sra32 sra_ (data_sra, data_operandA, ctrl_shiftamt);
	
	nand nand_opcode_20(na_op_20, ctrl_ALUopcode[2], ctrl_ALUopcode[0]);
	nor nor_flag_sra(flag_sra, ctrl_ALUopcode[4], ctrl_ALUopcode[3], ctrl_ALUopcode[1], na_op_20);
	bufif1 tri_state_buf_sra[31:0](data_result, data_sra, flag_sra);
	
endmodule

