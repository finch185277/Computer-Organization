module Full_Adder (sum, carry_out, inA, inB, carry_in);
  output wire sum, carry_out;

  input wire inA, inB, carry_in;

  wire w1, w2, w3;

  xor   (w1, inA, inB);
  xor   (sum, w1, carry_in);

  and   (w2, inA, inB);
  and   (w3, w1, carry_in);
  or    (carry_out, w2, w3);
endmodule // Full_Adder
