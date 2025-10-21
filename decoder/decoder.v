  `timescale 1ns/1ns

`define NOP 4'b0000
`define ARITH_2OP 4'b0001
`define ARITH_1OP 4'b0010
`define MOVI 4'b0011
`define ADDI 4'b0100
`define SUBI 4'b0101
`define LOAD 4'b0110
`define STOR 4'b0111
`define BEQ 4'b1000
`define BGE 4'b1001
`define BLE 4'b1010
`define BC 4'b1011
`define J 4'b1100
`define CONTROL 4'b1111

`define ADD 3'b000
`define ADDC 3'b001
`define SUB 3'b010
`define SUBB 3'b011
`define AND 3'b100
`define OR 3'b101
`define XOR 3'b110
`define XNOR 3'b111

`define NOT 3'b000
`define SHIFTL 3'b001
`define SHIFTR 3'b010
`define CP 3'b011

`define STC    12'b000000000001
`define STB    12'b000000000010
`define RESET  12'b101010101010
`define HALT   12'b111111111111

/*
 * Module: instruction_decode
 * Description: Decodes the instruction.
 *              All outputs must be driven based upon instruction opcode and function.
 *              All logic should be combinational.
 */

module decoder(
	input [15:0] instruction_pi,
	
	output [2:0] alu_func_po,
	
	output [2:0] destination_reg_po,
	output [2:0] source_reg1_po,
	output [2:0] source_reg2_po,
	
	output  [11:0] immediate_po,
	
	output arith_2op_po,
	output arith_1op_po,
	
	output movi_lower_po,
	output movi_higher_po,
	
	output addi_po,
	output subi_po,
	
	output load_po,
	output store_po,
	
	output branch_eq_po,
	output branch_ge_po,
	output branch_le_po,
	output branch_carry_po,
	
	output jump_po,

	output stc_cmd_po,
	output stb_cmd_po,
	output halt_cmd_po,
	output rst_cmd_po
);
	wire [3:0] op_code = instruction_pi[15:12];

	assign arith_2op_po = op_code == `ARITH_2OP;
	assign arith_1op_po = op_code == `ARITH_1OP;

	assign movi_lower_po = (op_code == `MOVI) & ~instruction_pi[8];
	assign movi_higher_po = (op_code == `MOVI) & instruction_pi[8];

	assign addi_po = op_code == `ADDI;
	assign subi_po = op_code == `SUBI;

	assign load_po = op_code == `LOAD;
	assign store_po = op_code == `STOR;

	assign branch_eq_po = op_code == `BEQ;
	assign branch_ge_po = op_code == `BGE;
	assign branch_le_po = op_code == `BLE;
	assign branch_carry_po = op_code == `BC;

	assign jump_po = op_code == `J;

	wire is_ctrl = op_code == `CONTROL;
	wire [11:0] ctrl_op = instruction_pi[11:0];

	assign stc_cmd_po = is_ctrl & (ctrl_op == `STC);
	assign stb_cmd_po = is_ctrl & (ctrl_op == `STB);
	assign rst_cmd_po = is_ctrl & (ctrl_op == `RESET);
	assign halt_cmd_po = is_ctrl & (ctrl_op == `HALT);

	assign alu_func_po = instruction_pi[2:0];
	assign destination_reg_po = instruction_pi[11:9];

	wire is_branch = branch_eq_po | branch_ge_po | branch_le_po | branch_carry_po;

	assign source_reg1_po = is_branch ? instruction_pi[11:9] : instruction_pi[8:6];
	assign source_reg2_po = is_branch ? instruction_pi[8:6] : instruction_pi[5:3];

	assign immediate_po = instruction_pi[11:0];
endmodule // decoder
