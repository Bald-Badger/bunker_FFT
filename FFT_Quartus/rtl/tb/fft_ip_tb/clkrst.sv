import defines::*;
`timescale 1ns/1ns
module clkrst #(
	FREQ = FREQ
) (
	output logic clk,
	output logic rst_n
);

	localparam period = 1e9/FREQ;
	localparam half_period = period/2;

	initial begin
		clk = 1'b0;
		rst_n = 1'b0;
		repeat(2) @(negedge clk);
		#1;
		rst_n = 1'b1;
	end

	always #half_period begin
      clk = ~clk;
    end
	
endmodule : clkrst
