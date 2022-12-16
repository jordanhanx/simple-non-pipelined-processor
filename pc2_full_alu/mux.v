module mux2to1(out, a, b, s);
	
	input a, b;
	input s;
	
	output out;
	
	wire not_s;
	wire temp_a, temp_b;
	
	not not_1(not_s, s);
	
	and and_a(temp_a, a, not_s);
	and and_b(temp_b, b, s);
	
	or or_output(out, temp_a, temp_b);
	
endmodule
