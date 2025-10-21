// Testbench
module branch_testbench;                   // Testbench program will exercise design with different instructions

   parameter NUM_INSTRUCTIONS = 9;
   

   reg [15:0] instruction;
   
   wire [2:0] alu_func;
	
   wire [2:0] destination_reg;
   wire [2:0] source_reg1;
   wire [2:0] source_reg2;
   
   wire [11:0] immediate;
   
   wire        arith_2op;
   wire        arith_1op; 
   
   wire      movi_lower;
   wire      movi_higher;
	
   wire      addi;
   wire      subi;
   
   wire      load;
   wire      store;
   
   wire      branch_eq;
   wire      branch_ge;
   wire      branch_le;
   wire      branch_carry;
	
   wire      jump;
   wire      stc_cmd;
   wire      stb_cmd;
   wire      halt_cmd;
   wire      rst_cmd;

   wire [15:0] reg1_data;
   wire [15:0] reg2_data;
   
   wire        alu_carry_in;
   wire        alu_borrow_in; 

   wire [15:0] alu_result;
   wire        alu_carry_out;
   wire        alu_borrow_out; 

   wire        is_branch_taken;

decoder myDecoder(
.instruction_pi(instruction),
.alu_func_po(alu_func),
.destination_reg_po(destination_reg),
.source_reg1_po(source_reg1),
.source_reg2_po(source_reg2), 
.immediate_po(immediate),
.arith_2op_po(arith_2op),
.arith_1op_po(arith_1op),
.movi_lower_po(movi_lower), 
.movi_higher_po(movi_higher), 
.addi_po(addi),
.subi_po(subi), 
.load_po(load), 
.store_po(store),  
.branch_eq_po(branch_eq),
.branch_ge_po(branch_ge),
.branch_le_po(branch_le),
.branch_carry_po(branch_carry),
.jump_po(jump),
.stc_cmd_po(stc_cmd),
.stb_cmd_po(stb_cmd),
.halt_cmd_po(halt_cmd),
.rst_cmd_po(rst_cmd)
); 
   
  

alu  myALU(
.arith_1op_pi(arith_1op),
.arith_2op_pi(arith_2op),
.alu_func_pi(alu_func),
.addi_pi(addi),
.subi_pi(subi),
.load_or_store_pi(load | store), 
.reg1_data_pi(reg1_data),
.reg2_data_pi(reg2_data),
.immediate_pi(immediate[5:0]),
.stc_cmd_pi(stc_cmd),
.stb_cmd_pi(stb_cmd), 
.carry_in_pi(alu_carry_in), 
.borrow_in_pi(alu_borrow_in),  
.alu_result_po(alu_result),  
.carry_out_po(alu_carry_out), 
.borrow_out_po(alu_borrow_out)
);

   
regfile  myRegfile(
.source_reg1_pi(source_reg1), 
.source_reg2_pi(source_reg2), 
.new_carry_pi(alu_carry_out), 
.new_borrow_pi(alu_borrow_out), 
.reg1_data_po(reg1_data), 
.reg2_data_po(reg2_data), 
.current_carry_po(alu_carry_in), 
.current_borrow_po(alu_borrow_in)
);
   

branch  myBranch( 
.branch_eq_pi(branch_eq), 
.branch_ge_pi(branch_ge),
.branch_le_pi(branch_le),
.branch_carry_pi(branch_carry), 
.reg1_data_pi(reg1_data), 
.reg2_data_pi(reg2_data), 
.alu_carry_bit_pi(alu_carry_in), 
.is_branch_taken_po(is_branch_taken)
);
   
   

   reg [15:0] INSTRUCTION[31:0];
   integer i;
   
   
initial begin
   for (i = 0; i < NUM_INSTRUCTIONS; i= i+1) begin
case (i)
0: INSTRUCTION[0] = 16'b1000001001111111; // BEQ $1, $1, 0x3f 
1: INSTRUCTION[1] = 16'b1000001010111110; // BEQ $1, $2, 0x3e
2: INSTRUCTION[2] = 16'b1001001001111111; // BGE $1, $1, 0x3f 
3: INSTRUCTION[3] = 16'b1001001010111110; // BGE $1, $2, 0x3e
4: INSTRUCTION[4] = 16'b1001010001111110; // BGE $2, $1, 0x3e
5: INSTRUCTION[5] = 16'b1010001001111111; // BLE $1, $1, 0x3f 
6: INSTRUCTION[6] = 16'b1010001010111110; // BLE $1, $2, 0x3e
7: INSTRUCTION[7] = 16'b1010010001111110; // BLE $2, $1, 0x3e
8: INSTRUCTION[8] = 16'b1011000000111111; // BC  0x3f 


default INSTRUCTION[i] = 16'b0;
  endcase
   end
   
   $display("*************************************");  // Verilog version of print
   $display("\tNo.\tInstruction\t\tDecoded Signals\n");
end
   
   
   always @(*) begin


      for (i=0; i < NUM_INSTRUCTIONS; i=i+1)  begin
	#1;	instruction = INSTRUCTION[i];
	#1;     $display("%d.\t%x\t\t%o %o %o %o %o\t%b %b %b %b %b %b %b %b %b %b %b %b %b %b %b %b %b\n", i, instruction, alu_func, destination_reg, source_reg1, source_reg2, immediate, arith_2op, arith_1op, movi_lower, movi_higher, addi,  subi, load, store,  branch_eq, branch_ge, branch_le, branch_carry, jump, stc_cmd, stb_cmd, halt_cmd, rst_cmd);

      
	 #1;        $display("\t\tBranch Module Output --- isBranchTaken: %b\n",  is_branch_taken);



      end // endfor
      
       $finish;
   end

endmodule // tb_branch
