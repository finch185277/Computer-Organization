module Branch_Control(zero_i, result_i, branch_type_i, branch_select_o);

  // I/O ports
  input           zero_i;
  input           result_i;
  input  [2-1:0]  branch_type_i;

  output          branch_select_o;

  // Internal Signals
  wire            branch_select_o;

  // Select
  assign branch_select_o = (branch_type_i == 2'b00) ? ((zero_i == 1)   ? 1 : 0) : // beq
                           (branch_type_i == 2'b01) ? ((zero_i == 0)   ? 1 : 0) : // bnez
                           (branch_type_i == 2'b10) ? ((result_i == 0) ? 0 : 1) : // ble
                                                      ((result_i == 1) ? 1 : 0) ; // bltz

endmodule
