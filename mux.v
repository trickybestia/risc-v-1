module mux (
	sel,
	data,
	out
);

parameter SEL_WIDTH;
parameter DATA_WIDTH;

input [SEL_WIDTH-1:0] sel;
input [(2**SEL_WIDTH)*DATA_WIDTH-1:0] data;

output [DATA_WIDTH-1:0] out;

assign out = data[sel*DATA_WIDTH+:DATA_WIDTH];

endmodule
