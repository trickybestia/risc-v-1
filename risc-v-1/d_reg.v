module d_reg (
	clk,

	next,
	current
);

parameter WIDTH;

input clk;

input      [WIDTH-1:0] next;
output reg [WIDTH-1:0] current;

always @(posedge clk) begin
	current <= next;
end

initial begin
	current = 0;
end

endmodule