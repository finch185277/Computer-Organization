//Subject:     CO project 2 - ALU Controller
//--------------------------------------------------------------------------------
//Version:     2
//--------------------------------------------------------------------------------
//Writer:      0616221 Yu-Chien Hsiao
//----------------------------------------------
//Date:        2018/8/2
//----------------------------------------------
//Description:
//--------------------------------------------------------------------------------

module ALU_Ctrl(funct_i, ALUOp_i, ALUCtrl_o, Jr_o);

  //I/O ports
  input      [6-1:0] funct_i;
  input      [4-1:0] ALUOp_i;

  output     [4-1:0] ALUCtrl_o;
  output             Jr_o;

  //Internal Signals
  wire       [4-1:0] ALUCtrl_o;
  wire               Jr_o;

  //Parameter


  //Select exact operation
  assign ALUCtrl_o = (ALUOp_i == 4'b0000)                  ? 4'b0010 :  // lw
                     (ALUOp_i == 4'b0001)                  ? 4'b0010 :  // sw
                    ({ALUOp_i,funct_i} == 10'b0010_100001 | ALUOp_i == 4'b0011)
                                                           ? 4'b0010 :  // addu,addi
                    ({ALUOp_i,funct_i} == 10'b0010_100011) ? 4'b0011 :  // sub
                    ({ALUOp_i,funct_i} == 10'b0010_100100) ? 4'b0000 :  // AND
                    ({ALUOp_i,funct_i} == 10'b0010_100101 | ALUOp_i == 4'b0111)
                                                           ? 4'b0001 :  // OR,ORi
                    ({ALUOp_i,funct_i} == 10'b0010_101010 | ALUOp_i == 4'b1000)
                                                           ? 4'b1010 :  // slt,sltiu
                    ({ALUOp_i,funct_i} == 10'b0010_000011) ? 4'b1000 :  // sra
                    ({ALUOp_i,funct_i} == 10'b0010_000111) ? 4'b1001 :  // srav
                     (ALUOp_i == 4'b0100)                  ? 4'b0110 :  // beq
                     (ALUOp_i == 4'b0101)                  ? 4'b0111 :  // bnez
                     (ALUOp_i == 4'b1011)                  ? 4'b0011 :  // ble
                     (ALUOp_i == 4'b1101)                  ? 4'b0011 :  // bltz
                     (ALUOp_i == 4'b0110)                  ? 4'b1100 :  // li
                    ({ALUOp_i,funct_i} == 10'b0010_011000) ? 4'b1101 :  // mul
                                                             4'b1111 ;  // default
  // jal
  assign Jr_o     = ({ALUOp_i,funct_i} == 10'b0010_001000) ? 1 : 0;
endmodule
