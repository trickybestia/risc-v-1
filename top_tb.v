`timescale 1ns / 100ps

module top_tb;

reg clk;

top uut (
	.clk (clk)
);

always begin
	#5 clk = 1;
	#5 clk = 0;
end

initial begin
	clk = 0;

	$monitor("pc: %d", uut.cpu_instance.pc_current);
end

endmodule