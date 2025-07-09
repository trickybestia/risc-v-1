`include "alu_ops.v"

module decode (
	instr,

	rs1_addr,
	rs2_addr,
	rd_addr,
	rd_write_enable,
	imm,
	alu_decode_imm,
	alu_op,
	branch,
	alu_compare_sel,
	data_mem_write_enable,
	rd_write_data_sel,
	J_imm,
	jal
);

localparam OPCODE_OP     = 7'b0110011;
localparam OPCODE_OP_IMM = 7'b0010011;
localparam OPCODE_JAL    = 7'b1101111;
localparam OPCODE_BRANCH = 7'b1100011;
localparam OPCODE_LOAD   = 7'b0000011;
localparam OPCODE_STORE  = 7'b0100011;

localparam FUNCT3_BEQ = 3'b000;
localparam FUNCT3_BNE = 3'b001;

localparam FUNCT3_ADD  = 3'b000;
localparam FUNCT3_SUB  = 3'b000;
localparam FUNCT3_SLT  = 3'b010;
localparam FUNCT3_SLTU = 3'b011;
localparam FUNCT3_AND  = 3'b111;
localparam FUNCT3_OR   = 3'b110;
localparam FUNCT3_XOR  = 3'b100;

localparam FUNCT3_ADDI  = 3'b000;
localparam FUNCT3_SLTI  = 3'b010;
localparam FUNCT3_SLTIU = 3'b011;
localparam FUNCT3_ANDI  = 3'b111;
localparam FUNCT3_ORI   = 3'b110;
localparam FUNCT3_XORI  = 3'b100;

localparam FUNCT7_ADD  = 7'b0000000;
localparam FUNCT7_SLT  = 7'b0000000;
localparam FUNCT7_SLTU = 7'b0000000;
localparam FUNCT7_AND  = 7'b0000000;
localparam FUNCT7_OR   = 7'b0000000;
localparam FUNCT7_XOR  = 7'b0000000;
localparam FUNCT7_SUB  = 7'b0100000;

input [31:0] instr;

output     [4:0]  rs1_addr;
output     [4:0]  rs2_addr;
output     [4:0]  rd_addr;
output reg        rd_write_enable;
output     [11:0] imm;
output            alu_decode_imm;
output reg [2:0]  alu_op;
output            branch;
output reg [1:0]  alu_compare_sel;
output            data_mem_write_enable;
output reg [1:0]  rd_write_data_sel;
output     [19:0] J_imm;
output            jal;

wire [6:0] funct7 = instr[31:25];
wire [2:0] funct3 = instr[14:12];
wire [6:0] opcode = instr[6:0];

assign rs1_addr = instr[19:15];
assign rs2_addr = instr[24:20];
assign rd_addr  = instr[11:7];

assign imm = (opcode == OPCODE_STORE) ? {instr[31:25], instr[11:7]} : instr[31:20];
assign alu_decode_imm = (opcode == OPCODE_OP_IMM || opcode == OPCODE_BRANCH || opcode == OPCODE_LOAD || opcode == OPCODE_STORE);
assign branch = (opcode == OPCODE_BRANCH);
assign data_mem_write_enable = (opcode == OPCODE_STORE);
assign J_imm = {instr[31], instr[19:12], instr[20], instr[30:21]};
assign jal = (opcode == OPCODE_JAL);

always @(*) begin
	alu_op = `ALU_ADD;

	if (opcode == OPCODE_LOAD || opcode == OPCODE_STORE) begin
		alu_op = `ALU_ADD;
	end else if ((opcode == OPCODE_OP && funct7 == FUNCT7_ADD && funct3 == FUNCT3_ADD)
				|| (opcode == OPCODE_OP_IMM && funct3 == FUNCT3_ADDI)) begin
		alu_op = `ALU_ADD;
	end else if (opcode == OPCODE_OP && funct7 == FUNCT7_SUB && funct3 == FUNCT3_SUB) begin
		alu_op = `ALU_SUB;
	end else if ((opcode == OPCODE_OP && funct7 == FUNCT7_SLT && funct3 == FUNCT3_SLT)
				|| (opcode == OPCODE_OP_IMM && funct3 == FUNCT3_SLTI)) begin
		alu_op = `ALU_SLT;
	end else if ((opcode == OPCODE_OP && funct7 == FUNCT7_SLTU && funct3 == FUNCT3_SLTU)
				|| (opcode == OPCODE_OP_IMM && funct3 == FUNCT3_SLTIU)) begin
		alu_op = `ALU_SLTU;
	end else if ((opcode == OPCODE_OP && funct7 == FUNCT7_AND && funct3 == FUNCT3_AND)
				|| (opcode == OPCODE_OP_IMM && funct3 == FUNCT3_ANDI)) begin
		alu_op = `ALU_AND;
	end else if ((opcode == OPCODE_OP && funct7 == FUNCT7_OR && funct3 == FUNCT3_OR)
				|| (opcode == OPCODE_OP_IMM && funct3 == FUNCT3_ORI)) begin
		alu_op = `ALU_OR;
	end else if ((opcode == OPCODE_OP && funct7 == FUNCT7_XOR && funct3 == FUNCT3_XOR)
				|| (opcode == OPCODE_OP_IMM && funct3 == FUNCT3_XORI)) begin
		alu_op = `ALU_XOR;
	end
end

always @(*) begin
	alu_compare_sel = 0;

	case (funct3)
		FUNCT3_BEQ: alu_compare_sel = 0;
		FUNCT3_BNE: alu_compare_sel = 1;
	endcase
end

always @(*) begin
	rd_write_enable = 0;
	rd_write_data_sel = 0;

	if (opcode == OPCODE_OP || opcode == OPCODE_OP_IMM) begin
		rd_write_data_sel = 0;
		rd_write_enable   = 1;
	end else if (opcode == OPCODE_LOAD) begin
		rd_write_data_sel = 1;
		rd_write_enable   = 1;
	end else begin
		rd_write_data_sel = 2;
		rd_write_enable   = 1;
	end
end


endmodule