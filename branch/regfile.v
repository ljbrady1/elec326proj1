
module   regfile(
		 input [2:0]   source_reg1_pi, 
		 input [2:0]   source_reg2_pi, 
		 input 	       new_carry_pi, 
		 inout 	       new_borrow_pi, 
		 output [15:0] reg1_data_po, 
		 output [15:0] reg2_data_po, 
		 output        current_carry_po, 
		 output        current_borrow_po
);
   
   parameter NUM_REG = 8;

   reg [15:0] REG_FILE[NUM_REG - 1:0];
   reg 	      CARRY_FLAG;
   reg 	      BORROW_FLAG;
   
   integer    i;
   initial begin
      for (i = 0; i < NUM_REG; i = i+1) 
        REG_FILE[i] =  i+1;  // Arbitrary values for debugging
        CARRY_FLAG = 1'b1;   // Fixed value for debugging
        BORROW_FLAG = 1'b1;
   end
   

   assign reg1_data_po = REG_FILE[source_reg1_pi];
   assign reg2_data_po = REG_FILE[source_reg2_pi];
   assign current_carry_po = CARRY_FLAG;
   assign current_borrow_po = BORROW_FLAG;
   
// Note that (i) register is not updated (ii) carry and borrow flags are not updated in this skeleton implementation.
endmodule // regfile
  
