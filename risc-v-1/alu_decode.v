module alu_decode (
	input [31:0] rs2_data,

	input [11:0] imm,
	input        decode_imm,

	output [31:0] b
);

assign b = decode_imm ? $signed(imm) : rs2_data;

endmodule