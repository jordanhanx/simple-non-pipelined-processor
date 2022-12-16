
// 32-bit CLA *****************************************************************
module cla32(sum, cout, cin, x, y);

	output [31:0] sum;
	output [1:0] cout; // cout[0] = cin at the most significant bit in addition, cout[1] = cout at the most significant bit in addition
		
	input cin;
	input [31:0] x, y;
	

	wire [3:0] B_g, B_p, B_c; // Block g p and c
	
	assign B_c[0] = cin;
	
	// CLA Block 0
	cla8 cla8_0(sum[7:0],   B_g[0], B_p[0], , B_c[0], x[7:0], y[7:0]);
	
	// CLA Block 1
	cla8 cla8_1(sum[15:8],  B_g[1], B_p[1], , B_c[1], x[15:8], y[15:8]);
	
	// CLA Block 2
	cla8 cla8_2(sum[23:16], B_g[2], B_p[2], , B_c[2], x[23:16], y[23:16]);
	
	// CLA Block 3
	cla8 cla8_3(sum[31:24], B_g[3], B_p[3], cout[0], B_c[3], x[31:24], y[31:24]);
	
	
	// Second level lookahead
	// cin of block 1 : B_c[1]
	and and_B_c1(t_B_c1, B_p[0], B_c[0]);
	or  or_B_c1 (B_c[1], B_g[0], t_B_c1);
	
	// cin of block 2 : B_c[2]
	and and_B_c2a(t_B_c2a, B_g[0], B_p[1]);
	and and_B_c2b(t_B_c2b, B_p[0], B_p[1], B_c[0]);
	or  or_B_c2  (B_c[2], B_g[1], t_B_c2a, t_B_c2b);
	
	// cin of block 3 : B_c[3]
	and and_B_c3a(t_B_c3a, B_g[1], B_p[2]);
	and and_B_c3b(t_B_c3b, B_g[0], B_p[1], B_p[2]);
	and and_B_c3c(t_B_c3c, B_p[0], B_p[1], B_p[2], B_c[0]);
	or  or_B_c3  (B_c[3], B_g[2], t_B_c3a, t_B_c3b, t_B_c3c);
	
	// cout of block 3
	and and_B_c4a(t_B_c4a, B_g[2], B_p[3]);
	and and_B_c4b(t_B_c4b, B_g[1], B_p[2], B_p[3]);
	and and_B_c4c(t_B_c4c, B_g[0], B_p[1], B_p[2], B_p[3]);
	and and_B_c4d(t_B_c4d, B_p[0], B_p[1], B_p[2], B_p[3], B_c[0]);
	or  or_B_c4  (cout[1], B_g[3], t_B_c4a, t_B_c4b, t_B_c4c, t_B_c4d);
	
	
endmodule


// 8-bit CLA ******************************************************************
module cla8(sum, gout, pout, c7, c0, x, y);	
	
	output [7:0] sum;
	output gout, pout, c7;
	
	input c0;
	input [7:0] x, y;
	
	wire [7:0] c, g, p;
	
	// c[0] = c0
	assign c[0] = c0;
	
	// calculate g[i] and p[i]
	and and_g[7:0](g, x, y);
	or  or_p	[7:0](p, x, y);
	
	// calculate gout and pout
	// pout = p[7]&p[6]&p[5]&p[4]&p[3]&p[2]&p[1]&p[0]
	and and_pout (pout, p[0], p[1], p[2], p[3], p[4], p[5], p[6], p[7]);
	
	// gout = g[7] + g[6]&p[7] + g[5]&p[6]&p[7] + g[4]&p[5]&p[6]&p[7] + g[3]&p[4]&p[5]&p[6]&p[7] + g[2]&p[3]&p[4]&p[5]&p[6]&p[7] + g[1]&p[2]&p[3]&p[4]&p[5]&p[6]&p[7] + g[0]&p[1]&p[2]&p[3]&p[4]&p[5]&p[6]&p[7]
	and and_gout0(t_gout0, g[6], p[7]);
	and and_gout1(t_gout1, g[5], p[6], p[7]);
	and and_gout2(t_gout2, g[4], p[5], p[6], p[7]);
	and and_gout3(t_gout3, g[3], p[4], p[5], p[6], p[7]);
	and and_gout4(t_gout4, g[2], p[3], p[4], p[5], p[6], p[7]);
	and and_gout5(t_gout5, g[1], p[2], p[3], p[4], p[5], p[6], p[7]);
	and and_gout6(t_gout6, g[0], p[1], p[2], p[3], p[4], p[5], p[6], p[7]);
	or  or_gout  (gout, g[7], t_gout0, t_gout1, t_gout2, t_gout3, t_gout4, t_gout5, t_gout6);
	
	
	// C[1] = g[0] + p[0]&c[0]
	and and_c1(t_c1, p[0], c[0]);
	or  or_c1 (c[1], g[0], t_c1);
	
	// C[2] = g[1] + g[0]&p[1] + p[0]&p[1]&c[0]
	and and_c2a(t_c2a, g[0], p[1]);
	and and_c2b(t_c2b, p[0], p[1], c[0]);
	or  or_c2  (c[2],	g[1], t_c2a, t_c2b);
	
	// C[3] = g[2] + g[1]&p[2] + g[0]&p[1]&p[2] + p[0]&p[1]&p[2]&c[0]
	and and_c3a(t_c3a, g[1], p[2]);
	and and_c3b(t_c3b, g[0], p[1], p[2]);
	and and_c3c(t_c3c, p[0], p[1], p[2], c[0]);
	or  or_c3  (c[3],	g[2], t_c3a, t_c3b, t_c3c);
	
	// c[4] = g[3] + g[2]&p[3] + g[1]&p[2]&p[3] + g[0]&p[1]&p[2]&p[3] + p[0]&p[1]&p[2]&p[3]&c[0]
	and and_c4a(t_c4a, g[2], p[3]);
	and and_c4b(t_c4b, g[1], p[2], p[3]);
	and and_c4c(t_c4c, g[0], p[1], p[2], p[3]);
	and and_c4d(t_c4d, p[0], p[1], p[2], p[3], c[0]);
	or  or_c4  (c[4],	g[3], t_c4a, t_c4b, t_c4c, t_c4d);
	
	// c[5] = g[4] + g[3]&p[4] + g[2]&p[3]&p[4] + g[1]&p[2]&p[3]&p[4] + g[0]&p[1]&p[2]&p[3]&p[4] + p[0]&p[1]&p[2]&p[3]&p[4]&c[0]
	and and_c5a(t_c5a, g[3], p[4]);
	and and_c5b(t_c5b, g[2], p[3], p[4]);
	and and_c5c(t_c5c, g[1], p[2], p[3], p[4]);
	and and_c5d(t_c5d, g[0], p[1], p[2], p[3], p[4]);
	and and_c5e(t_c5e, p[0], p[1], p[2], p[3], p[4], c[0]);
	or  or_c5  (c[5], g[4], t_c5a, t_c5b, t_c5c, t_c5d, t_c5e);
	
	// c[6] = g[5] + g[4]&p[5] + g[3]&p[4]&p[5] + g[2]&p[3]&p[4]&p[5] + g[1]&p[2]&p[3]&p[4]&p[5] + g[0]&p[1]&p[2]&p[3]&p[4]&p[5] + p[0]&p[1]&p[2]&p[3]&p[4]&p[5]&c[0]
	and and_c6a(t_c6a, g[4], p[5]);
	and and_c6b(t_c6b, g[3], p[4], p[5]);
	and and_c6c(t_c6c, g[2], p[3], p[4], p[5]);
	and and_c6d(t_c6d, g[1], p[2], p[3], p[4], p[5]);
	and and_c6e(t_c6e, g[0], p[1], p[2], p[3], p[4], p[5]);
	and and_c6f(t_c6f, p[0], p[1], p[2], p[3], p[4], p[5], c[0]);
	or  or_c6  (c[6], g[5], t_c6a, t_c6b, t_c6c, t_c6d, t_c6e, t_c6f);
	
	// c[7] = g[6] + g[5]&p[6] + g[4]&p[5]&p[6] + g[3]&p[4]&p[5]&p[6] + g[2]&p[3]&p[4]&p[5]&p[6] + g[1]&p[2]&p[3]&p[4]&p[5]&p[6] + g[0]&p[1]&p[2]&p[3]&p[4]&p[5]&p[6] + p[0]&p[1]&p[2]&p[3]&p[4]&p[5]&p[6]&c[0]
	and and_c7a(t_c7a, g[5], p[6]);
	and and_c7b(t_c7b, g[4], p[5], p[6]);
	and and_c7c(t_c7c, g[3], p[4], p[5], p[6]);
	and and_c7d(t_c7d, g[2], p[3], p[4], p[5], p[6]);
	and and_c7e(t_c7e, g[1], p[2], p[3], p[4], p[5], p[6]);
	and and_c7f(t_c7f, g[0], p[1], p[2], p[3], p[4], p[5], p[6]);
	and and_c7g(t_c7g, p[0], p[1], p[2], p[3], p[4], p[5], p[6], c[0]);
	or	 or_c7  (c[7], g[6], t_c7a, t_c7b, t_c7c, t_c7d, t_c7e, t_c7f, t_c7g);
	
	assign c7 = c[7];
	
	//calculate sum
	xor xor_sum[7:0](sum, x, y, c);
	

endmodule
