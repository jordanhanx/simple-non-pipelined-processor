module control_circuit(q_imem, isNotEqual, isLessThan, overflow, 
Rwe, Rdst, ALUinB, ALUop, Dmwe, Rwd, BR, JP, Jr, rd_30, rd_31, rA_r0, Rwd_ovf, Rwd_pc_1, ovf_val);
	
	input [31:0] q_imem;
	input isNotEqual, isLessThan, overflow;
	
	output Rwe, Rdst, ALUinB,  Dmwe, Rwd, BR, JP, Jr, rd_30, rd_31, rA_r0, Rwd_ovf, Rwd_pc_1;
	output [4:0] ALUop;
	output [31:0] ovf_val;
	
	wire op_00000, op_addi, op_sw, op_lw, op_j, op_bne, op_jal, op_jr, op_blt, op_bex, op_setx;
	
	// parse opcode
	and and_op_00000(op_00000, ~q_imem[31], ~q_imem[30], ~q_imem[29], ~q_imem[28], ~q_imem[27]);  // 5'b00000
	and and_op_addi (op_addi,  ~q_imem[31], ~q_imem[30],  q_imem[29], ~q_imem[28],  q_imem[27]);  // 5'b00101
	and and_op_sw   (op_sw,    ~q_imem[31], ~q_imem[30],  q_imem[29],  q_imem[28],  q_imem[27]);  // 5'b00111
	and and_op_lw   (op_lw,    ~q_imem[31],  q_imem[30], ~q_imem[29], ~q_imem[28], ~q_imem[27]);  // 5'b01000
	
	and and_op_j    (op_j,     ~q_imem[31], ~q_imem[30], ~q_imem[29], ~q_imem[28],  q_imem[27]);  // 5'b00001
	and and_op_bne  (op_bne,   ~q_imem[31], ~q_imem[30], ~q_imem[29],  q_imem[28], ~q_imem[27]);  // 5'b00010
	and and_op_jal  (op_jal,   ~q_imem[31], ~q_imem[30], ~q_imem[29],  q_imem[28],  q_imem[27]);  // 5'b00011
	and and_op_jr   (op_jr,    ~q_imem[31], ~q_imem[30],  q_imem[29], ~q_imem[28], ~q_imem[27]);  // 5'b00100

	and and_op_blt  (op_blt,   ~q_imem[31], ~q_imem[30],  q_imem[29],  q_imem[28], ~q_imem[27]);  // 5'b00110
	
	and and_op_bex  (op_bex,    q_imem[31], ~q_imem[30],  q_imem[29],  q_imem[28], ~q_imem[27]);  // 5'b10110
	and and_op_setx (op_setx ,  q_imem[31], ~q_imem[30],  q_imem[29], ~q_imem[28],  q_imem[27]);  // 5'b10101


	// ALUop
	// if op_00000, then ALUop = q_imem[6:2] 
	// if op_bne || op_blt || op_bex, then ALUop = 5'b00001
	// else then ALUop = 5'b00000
	wire op_b__;
	wire [4:0] ALUop_op_not_00000;
	or or_op_b__(op_b__, op_bne, op_blt, op_bex);
	assign ALUop_op_not_00000 = op_b__ ? 5'b00001 : 5'b00000;
	assign ALUop = op_00000 ? q_imem[6:2] : ALUop_op_not_00000;
	
	
	// Rwe
	// if (op_00000 || op_addi || op_lw) && Rd(q_imem[26:22]) != 5'b00000
	// OR if op_jal || op_setx
	// then Rwe = 1'b1 
	wire addi_00000_lw, rd_r0, Rwe_addi_00000_lw, Rwe_jal_setx;
	
	or or_addi_00000_lw (addi_00000_lw, op_00000, op_addi, op_lw);
	and and_rd_r0(rd_r0, ~q_imem[26], ~q_imem[25], ~q_imem[24], ~q_imem[23], ~q_imem[22]);					 
	and and_Rwe_addi_00000_lw(Rwe_addi_00000_lw, addi_00000_lw, ~rd_r0);
	
	or or_Rwe_jal_setx(Rwe_jal_setx, op_jal, op_setx);
	
	or or_Rwe(Rwe, Rwe_addi_00000_lw, Rwe_jal_setx);
	
	
	// Rdst
	// if op_sw || op_bne || op_jr || op_blt || op_bex, then Rdst = 1'b1
	or or_sw_bne_jr_blt(Rdst, op_sw, op_bne, op_jr, op_blt, op_bex);
	
	// ALUinB
	//	if op_addi || op_sw || op_lw, then ALUinB = 1'b1
	or or_addi_sw_lw(ALUinB, op_addi, op_sw, op_lw);
	
	// Dmwe
	//	if op_sw, then Dmwe = 1'b1 
	assign Dmwe = op_sw;
	
	// Rwd
	// if op_lw, then Rwd = 1'b1
	assign Rwd = op_lw;
	
	// BR
	// if (op_bne && isNotEqual) || (op_blt && isNotEqual &&~isLessThan), then BR = 1'b1
	wire bne_ne, blt_lt;
	and and_bne_ne(bne_ne, op_bne, isNotEqual);
	and and_blt_lt(blt_lt, op_blt, isNotEqual, ~isLessThan);
	or or_bne_blt(BR, bne_ne, blt_lt);
	
	// JP
	// if op_j || op_jal || (op_bex && isNotEqual), then JP = 1'b1
	wire bex_ne;
	and and_bex_ne(bex_ne, op_bex, isNotEqual);
	or or_j_jal_bex(JP, op_j, op_jal, bex_ne);
	
	// Jr
	// if op_jr, then Jr = 1'b1;
	assign Jr = op_jr;
	
	// rd_30
	// if Rwd_ovf || op_bex || op_setx, then rd_30 = 1'b1
	or or_ovf_bex_setx(rd_30, Rwd_ovf, op_bex, op_setx);
	
	// rd_31
	// if op_jal, then jal = 1'b1
	assign rd_31 = op_jal;
	
	// rA_r0
	// if op_bex, then rA_r0 = 1'b1
	assign rA_r0 = op_bex;
	
	// Rwd_ovf
	// if (overflow) && (op_addi || (op_00000 && q_imem[6:3] == 4'b0000)), then Rwd_ovf = 1'b1
	wire op_addsub, addi_addsub;
	and and_op_addsub(op_addsub, op_00000, ~q_imem[6], ~q_imem[5], ~q_imem[4], ~q_imem[3]);
	or or_addi_addsub(addi_addsub, op_addi, op_addsub);
	and and_Rwd_ovf(Rwd_ovf, overflow, addi_addsub);
	
	// ovf_val
	// if q_imem[2] == 1'b1, then ovf_val_not_addi = 32'd3 
	// else then ovf_val_not_addi = 32'd1
	wire [31:0] ovf_val_not_addi;
	assign ovf_val_not_addi = q_imem[2] ? 32'd3 : 32'd1;
	// if op_addi, then ovf_val = 32'd2
	assign ovf_val = op_addi ? 32'd2 : ovf_val_not_addi;
	
	// Rwd_pc_1
	assign Rwd_pc_1 = op_jal;
	
	
endmodule
