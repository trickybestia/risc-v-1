`include "alu_ops.v"

module alu (
	input [2:0] op,

	input [31:0] a,
	input [31:0] b,

	output reg [31:0] result,

	output eq,
	output ne,
	output lt,
	output gt
);

assign eq = a == b;
assign ne = a != b;
assign lt = a < b;
assign gt = a > b;

always @(*) begin
	case (op)
		`ALU_ADD: result = a + b;
		`ALU_SUB: result = a - b;
		`ALU_SLT: result = $signed(a) < $signed(b);
		`ALU_SLTU: result = a < b;
		`ALU_AND: result = a & b;
		`ALU_OR: result = a | b;
		`ALU_XOR: result = a ^ b;
	endcase
end

endmodule