module clock_divider(processor_clock, imem_clock, dmem_clock, regfile_clock, clock, reset);
	input clock, reset;
	output reg imem_clock, dmem_clock, processor_clock, regfile_clock;
	reg output_clocks_enable;
	
	always @(negedge clock or posedge reset) begin
		if (reset)
			output_clocks_enable <= 1'b0;
		else
			output_clocks_enable <= 1'b1;	
	end

	always @(negedge clock or posedge reset) begin
		if (reset)
			processor_clock <= 1'b1;
		else if (output_clocks_enable)
			processor_clock <= ~processor_clock;	
	end
	
	always @(posedge clock or posedge reset) begin
		if (reset)
			imem_clock <= 1'b0;
		else if (output_clocks_enable)
			imem_clock <= ~imem_clock;	
	end
	
	always @(negedge clock or posedge reset) begin
		if (reset)
			dmem_clock <= 1'b0;
		else if (output_clocks_enable)
			dmem_clock <= ~dmem_clock;
	end
	
	always @(posedge clock or posedge reset) begin
		if (reset)
			regfile_clock <= 1'b1;
		else if (output_clocks_enable)
			regfile_clock <= ~regfile_clock;	
	end
	
endmodule
