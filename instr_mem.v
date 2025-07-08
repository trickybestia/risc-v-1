module instr_mem (
	input  [7:0]  addr,
	output [31:0] read_data
);

reg [31:0] mem [0:255];

assign read_data = mem[addr];

integer i;

initial begin
	for (i = 0; i != 256; i = i + 1) begin
		mem[i] = 0;
	end

	$readmemh ("instr_mem.mem", mem);
end

endmodule