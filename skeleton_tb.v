`timescale 1ns/100ps
module skeleton_tb();
	
    reg clock, reset;
    /* 
        Create four clocks for each module from the original input "clock".
        These four outputs will be used to run the clocked elements of your processor on the grading side. 
        You should output the clocks you have decided to use for the imem, dmem, regfile, and processor 
        (these may be inverted, divided, or unchanged from the original clock input). Your grade will be 
        based on proper functioning with this clock.
    */
    wire processor_clock, imem_clock, dmem_clock, regfile_clock;
	 
	 skeleton sk_test(clock, reset, imem_clock, dmem_clock, processor_clock, regfile_clock);

// ********************************************************************************************* //
	// Clock generator
	localparam half_period = 10;
	always
	begin
		#half_period clock = ~clock; // period = 20ns, freq = 50MHz
	end
	
	// Run
	
	initial
	begin
		$display($time, " << Starting the Simulation >>");
		clock = 1'b0; // at time 0
		reset = 1'b1; // assert reset
		
		@(negedge clock);  // wait until next negative edge of clock
		@(negedge clock);  // wait until next negative edge of clock
		reset = 1'b0; 		 // de-assert reset
		
		//#195 reset = 1'b1; // assert reset
		//@(negedge clock);  // wait until next negative edge of clock
		//@(negedge clock);  // wait until next negative edge of clock
		//@(posedge clock);  // wait until next positive edge of clock
		//reset = 1'b0; 		 // de-assert reset
		
		//#195 reset = 1'b1; // assert reset
		//#60 reset = 1'b0;  // de-assert reset
		
		//#210 reset = 1'b1; // assert reset
		//#60 reset = 1'b0;  // de-assert reset
		
		#10000
		$display($time, " << The simulation completed >>");
		$stop;

		
	end
	
endmodule
