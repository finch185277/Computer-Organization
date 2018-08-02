//Subject:     CO project 1 - Simple Single CPU
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:       0616221 Yu-Chen Hsiao
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
  wire          RegWrite;
  wire          Branch;
  wire [2-1:0]  memToReg;
  wire [2-1:0]  BranchType;
  wire          Jump;
  wire          memRead;
  wire          memWrite;
  wire [4-1:0]  ALU_op;
  wire          ALUSrc;
  wire          RegDst;
  wire [4-1:0]  ALUCtrl;


  /* Program Counter */
  wire [32-1:0] program_Jump;
  wire [32-1:0] program_PC;
  wire [32-1:0] program_add4;
  wire [32-1:0] program_branch;
  wire [32-1:0] program_no_jump;
  wire [32-1:0] program_final;

  /* MUX */
  wire  [5-1:0]  instrReg;
  wire  [5-1:0]  writeReg;
  wire  [32-1:0] ALUSrcMux;
  wire  [32-1:0] memRegMux;
  wire  [32-1:0] writeData;

  /* Data memory */
  wire  [32-1:0] readData_DM;


  /* branch */
  wire  [32-1:0] signExtend;
  wire  [32-1:0] signExtend_shifted;
  wire           zero;
  wire           BranchSelect;
  wire           BranchCheck;

  /* jump */
  wire  [32-1:0] jump_address;
  assign jump_address = ({program_add4[32-1:28],instruction[26-1:0],2'b00});

  /* jal, jr */
  wire           jal_sel;
  wire           jr_sel;


  // Branch
  and   BS(BranchCheck, BranchSelect, Branch);

  //Greate componentes
  ProgramCounter PC(
        .clk_i(clk_i),
  	    .rst_i (rst_i),
  	    .pc_in_i(program_final),
  	    .pc_out_o(program_PC)
  	    );

  Adder Adder1(
        .src1_i(program_PC),
  	    .src2_i(32'd4),
  	    .sum_o(program_add4)
  	    );

  Instr_Memory IM(
        .addr_i(program_PC),
  	    .instr_o(instruction)
  	    );

  MUX_2to1 #(.size(5)) Mux_Write_Reg(
          .data0_i(instruction[20:16]),
          .data1_i(instruction[15:11]),
          .select_i(RegDst),
          .data_o(instrReg)
          );

  MUX_2to1 #(.size(5)) Mux_Jal_Reg(
          .data0_i(instrReg),
          .data1_i(5'd31),
          .select_i(jal_sel),
          .data_o(writeReg)
          );

  MUX_2to1 #(.size(32)) Mux_Jal_Data(
          .data0_i(memRegMux),
          .data1_i(program_add4),
          .select_i(jal_sel),
          .data_o(writeData)
          );


  Reg_File RF(
          .clk_i(clk_i),
  	      .rst_i(rst_i),
          .RSaddr_i(instruction[25:21]),
          .RTaddr_i(instruction[20:16]),
          .RDaddr_i(writeReg),
          .RDdata_i(writeData),
          .RegWrite_i(RegWrite),
          .RSdata_o(readData1),
          .RTdata_o(readData2)
          );

  Decoder Decoder(
          .instr_op_i(instruction[31:26]),
    	    .RegWrite_o(RegWrite),
          .Branch_o(Branch),
          .MemToReg_o(memToReg),
          .Branch_Type_o(BranchType),
          .Jump_o(Jump),
          .Jal_o(jal_sel),
          .MemRead_o(memRead),
          .MemWrite_o(memWrite),
    	    .ALU_op_o(ALU_op),
    	    .ALUSrc_o(ALUSrc),
    	    .RegDst_o(RegDst)
    	    );

  ALU_Ctrl AC(
          .funct_i(instruction[5:0]),
          .ALUOp_i(ALU_op),
          .ALUCtrl_o(ALUCtrl),
          .Jr_o(jr_sel)
          );

  Sign_Extend SE(
          .data_i(instruction[15:0]),
          .data_o(signExtend)
          );

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

  Branch_Control BC(
          .zero_i(zero),
          .result_i(ALU_result[31]),
          .branch_type_i(BranchType),
          .branch_select_o(BranchSelect)
          );

  Data_Memory Data_Memory(
          .clk_i(clk_i),
          .addr_i(ALU_result),
          .data_i(readData2),
          .MemRead_i(memRead),
          .MemWrite_i(memWrite),
          .data_o(readData_DM)
          );

  MUX_3to1 #(.size(32)) MemToReg(
          .data0_i(ALU_result),
          .data1_i(readData_DM),
          .data2_i(signExtend),
          .select_i(memToReg),
          .data_o(memRegMux)
          );

  Adder Adder2(
          .src1_i(program_add4),
    	    .src2_i(signExtend_shifted),
    	    .sum_o(program_branch)
    	    );

  Shift_Left_Two_32 Shifter(
          .data_i(signExtend),
          .data_o(signExtend_shifted)
          );

  MUX_2to1 #(.size(32)) Mux_PC_Source(
          .data0_i(program_add4),
          .data1_i(program_branch),
          .select_i(BranchCheck),
          .data_o(program_no_jump)
          );

  MUX_2to1 #(.size(32)) MUX_Jump(
          .data0_i(jump_address),
          .data1_i(program_no_jump),
          .select_i(Jump),
          .data_o(program_Jump)
          );

  MUX_2to1 #(.size(32)) MUX_Jal(
          .data0_i(program_Jump),
          .data1_i(readData1),
          .select_i(jr_sel),
          .data_o(program_final)
          );

endmodule
