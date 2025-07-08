module cpu (
	input clk,

	input  [31:0] instr_mem_read_data,
	output [29:0] instr_mem_read_addr,

	input  [31:0] data_mem_read_data,
	output [29:0] data_mem_addr,
	output        data_mem_write_enable,
	output [31:0] data_mem_write_data
);

wire [29:0] default_pc_adder_result;

wire [29:0] branch_pc_adder_result;

wire [29:0] jal_pc_adder_result;

wire [29:0] next_pc_mux0_out;

wire [29:0] next_pc_mux1_out;

wire [29:0] pc_current;
assign instr_mem_read_addr = pc_current;

wire [4:0]  decode_rs1_addr;
wire [4:0]  decode_rs2_addr;
wire [4:0]  decode_rd_addr;
wire        decode_rd_write_enable;
wire [11:0] decode_imm;
wire        decode_alu_decode_imm;
wire [2:0]  decode_alu_op;
wire        decode_branch;
wire [1:0]  decode_alu_compare_sel;
wire        decode_data_mem_write_enable;
wire [1:0]  decode_rd_write_data_sel;
wire [19:0] decode_J_imm;
wire        decode_jal;
assign data_mem_write_enable = decode_data_mem_write_enable;

wire [31:0] rd_write_data_mux_out;

wire [31:0] reg_file_rs1_data;
wire [31:0] reg_file_rs2_data;
assign data_mem_write_data = reg_file_rs2_data;

wire [31:0] alu_decode_b;

wire [31:0] alu_result;
wire        alu_eq;
wire        alu_ne;
wire        alu_lt;
wire        alu_gt;
assign data_mem_addr = alu_result[31:2];

wire alu_compare_mux_out;

wire branch_condition_and_out = alu_compare_mux_out & decode_branch;

adder #(
	.WIDTH (30)
) default_pc_adder (
	.a      (pc_current),
	.b      (30'd1),
	.result (default_pc_adder_result)
);

adder #(
	.WIDTH (30)
) branch_pc_adder (
	.a      (pc_current),
	.b      ({{19{decode_imm[1]}}, decode_imm[11:1]}),
	.result (branch_pc_adder_result)
);

adder #(
	.WIDTH (30)
) jal_pc_adder (
	.a      (pc_current),
	.b      ({{11{decode_J_imm[19]}}, decode_J_imm[19:1]}),
	.result (jal_pc_adder_result)
);

mux #(
	.SEL_WIDTH  (1),
	.DATA_WIDTH (30)
) next_pc_mux0 (
	.sel  (branch_condition_and_out),
	.data ({branch_pc_adder_result, default_pc_adder_result}),
	.out  (next_pc_mux0_out)
);

mux #(
	.SEL_WIDTH  (1),
	.DATA_WIDTH (30)
) next_pc_mux1 (
	.sel  (decode_jal),
	.data ({jal_pc_adder_result, next_pc_mux0_out}),
	.out  (next_pc_mux1_out)
);

d_reg #(
	.WIDTH (30)
) pc (
	.clk     (clk),
	.next    (next_pc_mux1_out),
	.current (pc_current)
);

decode decode_instance (
	.instr           (instr_mem_read_data),
	.rs1_addr        (decode_rs1_addr),
	.rs2_addr        (decode_rs2_addr),
	.rd_addr         (decode_rd_addr),
	.rd_write_enable (decode_rd_write_enable),
	.imm             (decode_imm),
	.alu_decode_imm  (decode_alu_decode_imm),
	.alu_op          (decode_alu_op),
	.branch          (decode_branch),
	.alu_compare_sel (decode_alu_compare_sel),
	.data_mem_write_enable (decode_data_mem_write_enable),
	.rd_write_data_sel     (decode_rd_write_data_sel),
	.J_imm                 (decode_J_imm),
	.jal                   (decode_jal)
);

mux #(
	.SEL_WIDTH  (2),
	.DATA_WIDTH (32)
) rd_write_data_mux (
	.sel  (decode_rd_write_data_sel),
	.data ({32'b0, {default_pc_adder_result, 2'b00}, data_mem_read_data, alu_result}),
	.out  (rd_write_data_mux_out)
);

reg_file reg_file_instance (
	.clk             (clk),
	.rs1_addr        (decode_rs1_addr),
	.rs1_data        (reg_file_rs1_data),
	.rs2_addr        (decode_rs2_addr),
	.rs2_data        (reg_file_rs2_data),
	.rd_addr         (decode_rd_addr),
	.rd_write_enable (decode_rd_write_enable),
	.rd_write_data   (rd_write_data_mux_out)
);

alu_decode alu_decode_instance (
	.rs2_data   (reg_file_rs2_data),
	.imm        (decode_imm),
	.decode_imm (decode_alu_decode_imm),
	.b          (alu_decode_b)
);

alu alu_instance (
	.op     (decode_alu_op),
	.a      (reg_file_rs1_data),
	.b      (alu_decode_b),
	.result (alu_result),
	.eq     (alu_eq),
	.ne     (alu_ne),
	.lt     (alu_lt),
	.gt     (alu_gt)
);

mux #(
	.SEL_WIDTH  (2),
	.DATA_WIDTH (1)
) alu_compare_mux (
	.sel  (decode_alu_compare_sel),
	.data ({alu_gt, alu_lt, alu_ne, alu_eq}),
	.out  (alu_compare_mux_out)
);

endmodule