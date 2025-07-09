module reg_file (
	input clk,

	input  [4:0] rs1_addr,
	output [31:0] rs1_data,

	input  [4:0] rs2_addr,
	output [31:0] rs2_data,

	input [4:0]  rd_addr,
	input        rd_write_enable,
	input [31:0] rd_write_data
);

reg [31:0] regs [0:31];

assign rs1_data = (rs1_addr == 0) ? 0 : regs[rs1_addr];
assign rs2_data = (rs2_addr == 0) ? 0 : regs[rs2_addr];

always @(posedge clk) begin
	if (rd_write_enable) begin
		regs[rd_addr] <= rd_write_data;
	end
end

integer i;

initial begin
	for (i = 0; i != 32; i = i + 1) begin
		regs[i] = 0;
	end
end

endmodule