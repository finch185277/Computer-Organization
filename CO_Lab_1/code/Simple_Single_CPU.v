//Subject:     CO project 1 - Simple Single CPU
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:
//----------------------------------------------
//Date:
//----------------------------------------------
//Description:
//--------------------------------------------------------------------------------
module Simple_Single_CPU(clk_i,	rst_i);

  //I/O port
  input         clk_i;
  input         rst_i;

  //Internal Signles
  /* Main Datapath */
  wire [32-1:0] instruction;
  wire [32-1:0] readData1;
  wire [32-1:0] readData2;
  wire [32-1:0] ALU_result;

  /* Control */
  wire [3-1:0]  ALU_op;
  wire          RegDst;
  wire          RegWrite;
  wire          ALUSrc;


  /* Program Counter */
  wire [32-1:0] program_pre;
  wire [32-1:0] program_now;
  wire [32-1:0] program_next;

  /* MUX */
  wire  [5-1:0]  writeRegMux;
  wire   [32-1:0] ALUSrcMux;

  //Greate componentes
  ProgramCounter PC(
        .clk_i(clk_i),
  	    .rst_i (rst_i),
  	    .pc_in_i(program_pre),
  	    .pc_out_o(program_now)
  	    );

  Adder Adder1(
        .src1_i(program_now),
  	    .src2_i(32'd4),
  	    .sum_o(program_next)
  	    );

  Instr_Memory IM(
        .pc_addr_i(program_now),
  	    .instr_o(instruction)
  	    );

  MUX_2to1 #(.size(5)) Mux_Write_Reg(
          .data0_i(instruction[20:16]),
          .data1_i(instruction[15:11]),
          .select_i(RegDst),
          .data_o(writeRegMux)
          );

  Reg_File RF(
          .clk_i(clk_i),
  	      .rst_i(rst_i),
          .RSaddr_i(instruction[25:21]),
          .RTaddr_i(instruction[20:16]),
          .RDaddr_i(writeRegMux),
          .RDdata_i(ALU_result),
          .RegWrite_i(RegWrite),
          .RSdata_o(readData1),
          .RTdata_o(readData2)
          );

  Decoder Decoder(
        .instr_op_i(instruction[31:26]),
  	    .RegWrite_o(RegWrite),
  	    .ALU_op_o(ALU_op),
  	    .ALUSrc_o(ALUSrc),
  	    .RegDst_o(RegDst)
  	    );

  ALU_Ctrl AC(
          .funct_i(instruction[5:0]),
          .ALUOp_i(ALU_op),
          .ALUCtrl_o(ALUCtrl)
          );
  wire   [4-1:0]  ALUCtrl;

  Sign_Extend SE(
          .data_i(instruction[15:0]),
          .data_o(signExtend)
          );
  wire   [32-1:0] signExtend;

  MUX_2to1 #(.size(32)) Mux_ALUSrc(
          .data0_i(readData2),
          .data1_i(signExtend),
          .select_i(ALUSrc),
          .data_o(ALUSrcMux)
          );


  ALU ALU(
        .src1_i(readData1),
  	    .src2_i(ALUSrcMux),
  	    .ctrl_i(ALUCtrl),
        .shamt_i(instruction[10:6]),
  	    .result_o(ALU_result),
  		  .zero_o(zero)
  	    );
  wire  zero;

  Adder Adder2(
        .src1_i(program_next),
  	    .src2_i(signExtend_shifted),
  	    .sum_o(program_new)
  	    );
  wire  [32-1:0] program_new;

  Shift_Left_Two_32 Shifter(
          .data_i(signExtend),
          .data_o(signExtend_shifted)
          );
  wire  [32-1:0] signExtend_shifted;

  MUX_2to1 #(.size(32)) Mux_PC_Source(
          .data0_i(program_next),
          .data1_i(program_new),
          .select_i(zero),
          .data_o(program_pre)
          );

endmodule
