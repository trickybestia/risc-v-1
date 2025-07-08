module top (
	input clk
);

wire [31:0] instr_mem_read_data;

wire [31:0] data_mem_read_data;

wire [29:0] cpu_instr_mem_read_addr;
wire [29:0] cpu_data_mem_addr;
wire        cpu_data_mem_write_enable;
wire [31:0] cpu_data_mem_write_data;

instr_mem instr_mem_instance (
	.addr      (cpu_instr_mem_read_addr),
	.read_data (instr_mem_read_data)
);

data_mem data_mem_instance (
	.clk          (clk),
	.addr         (cpu_data_mem_addr),
	.write_enable (cpu_data_mem_write_enable),
	.write_data   (cpu_data_mem_write_data),
	.read_data    (data_mem_read_data)
);

cpu cpu_instance (
	.clk (clk),
	.instr_mem_read_data   (instr_mem_read_data),
	.instr_mem_read_addr   (cpu_instr_mem_read_addr),
	.data_mem_read_data    (data_mem_read_data),
	.data_mem_addr         (cpu_data_mem_addr),
	.data_mem_write_enable (cpu_data_mem_write_enable),
	.data_mem_write_data   (cpu_data_mem_write_data)
);

endmodule