module adder (
	a,
	b,
	result
);

parameter WIDTH;

input [WIDTH-1:0] a;
input [WIDTH-1:0] b;

output [WIDTH-1:0] result;

assign result = a + b;

endmodule