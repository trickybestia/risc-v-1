module data_mem (
	input clk,

	input      [7:0]  addr,
	input             write_enable,
	input      [31:0] write_data,
	output reg [31:0] read_data
);

reg [31:0] mem [0:255];

assign read_data = mem[addr];

always @(posedge clk) begin
	if (write_enable) begin
		mem[addr] <= write_data;
	end
end

integer i;

initial begin
	for (i = 0; i != 256; i = i + 1) begin
		mem[i] = 0;
	end
end

endmodule