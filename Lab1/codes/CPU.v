module CPU
(
    clk_i, 
    rst_i,
    start_i,
);
// Ports
input               clk_i;
input               rst_i;
input               start_i;

wire         PC_write;
wire         branch;
wire         stall;
wire         Control_branch;
wire         NoOp;
wire         ALUsrc;
wire         RegWrite;
wire         MemtoReg;
wire         MemRead;
wire         MemWrite;
wire         ID_EX_MemRea;
wire         ID_EX_ALUSrc;
wire         EX_MEM_RegWrite;
wire         MEM_WB_RegWrite;
wire         ID_EX_MemRead;
wire  [1:0]  ID_EX_ALUop;
wire  [1:0]  ALUop;
wire  [31:0]  instr_addr;
wire  [4:0]  MEM_WB_RD_addr;
wire  [4:0]  ID_EX_RD_addr;
wire  [4:0]  EX_MEM_RD_addr;
wire  [31:0] Ext_instr;
wire  [31:0] instruction;
wire  [31:0] EX_MEM_ALU;
wire  [31:0] ID_EX_RSdata;
wire  [31:0] ID_EX_RTdata;
wire  [31:0] MUX_ALUSrc_data;
wire  [31:0] Instruction_Memory_instr;
wire  [31:0] MemToReg_RDdata;
wire         MemRead2;
wire         MemWrite2;
wire         EX_MEM_MemWrite;
wire         to_PC;
wire  [31:0] register_RS1data;
wire  [31:0] register_RS2data;
reg         PC_write_reg = 1'b1;
reg         branch_reg = 1'b0;
reg         stall_reg = 1'b0;
reg         NoOp_reg = 1'b0;
reg         MEM_WB_RegWrite_reg = 1'b0;
reg         MemRead_reg = 1'b0;
always @(ID_EX_MemRead)
begin
	MemRead_reg <= ID_EX_MemRead;
end
always @(MEM_WB_RegWrite)
begin
	MEM_WB_RegWrite_reg <= MEM_WB_RegWrite;
end

always @(PC_write)
begin
	PC_write_reg <= PC_write;
end

always @(branch)
begin
	branch_reg <= branch;
end

always @(stall)
begin
	stall_reg <= stall;
end

always @(NoOp)
begin
	NoOp_reg <= NoOp;
end

//PC_write_sig = 0 if need stall, control by Harzard controller
//if PC_write_sig == 0, the program counter won't change
PC PC
(
	.clk_i      (clk_i),
	.rst_i      (rst_i),
	.start_i    (start_i),
	.PCWrite_i  (PC_write_reg),     //from Hazard
	.pc_i       (MUX_PC.data_o),    //from Mux_PC(branch?)
	.pc_o       (instr_addr)         //Current instruction
);


//MUX_PC: determine whether the instruction is branch
//data1: PC+4(from Adder) data2: from PC_branch
MUX32 MUX_PC
(
	.data1_i  (Add_PC.data_o), //PC+4
	.data2_i  (Add_PC_branch.data_o), // PC + immediate
	.select_i (branch_reg), //branch initial = 0
	.data_o   (PC.pc_i) // next PC
);

//PC_branch
Adder Add_PC_branch
(
	.data1_i (IF_ID.PC_o), //instruction read from IF_ID
	.data2_i (Ext_instr << 1),
	.data_o  (MUX_PC.data2_i) // PC +immediate
);

//Calculate PC+4
Adder Add_PC(
    .data1_i    (instr_addr),
    .data2_i    (32'd4),
    .data_o     (MUX_PC.data1_i)    //PC+4
);


//Instruction memory
//pass instruction to IF_ID to verity whether this operation need to be stalled
Instruction_Memory Instruction_Memory(
    .addr_i     (instr_addr), 
    .instr_o    (Instruction_Memory_instr)
);

//IF_ID:store instructions and determine stall and flush
//flush: from and gate
//IF_ID_PC: pass to PC_branch unit(immediate + PC)
//stall:from Hazard
IF_ID IF_ID
(
	.clk_i         (clk_i),
	.IF_ID_flush_i (branch_reg),
	.stall_i       (stall_reg),
	.PC_i          (instr_addr),
	.PC_o          (Add_PC_branch.data1_i),
	.inst_i        (Instruction_Memory_instr),
	.inst_o        (instruction)
);

//And gate: if Src1 == Src2 and Control_branch
And And
(
	.data1_i (Control.Branch_o),
	.data2_i ((register_RS1data == register_RS2data)? 1'b1 : 1'b0),
	.data_o  (branch)
);


//add MemWrite, MemRead, Branch, MemtoReg
Control Control(
    .Op_i       (instruction[6:0]),
    .NoOp_i     (NoOp_reg), //from hazard
    .ALUOp_o    (ALUop),
    .ALUSrc_o   (ALUsrc),
    .RegWrite_o (RegWrite),
    .MemtoReg_o (MemtoReg),
    .MemRead_o  (MemRead),
    .MemWrite_o (MemWrite),
    .Branch_o   (And.data1_i)
);

//Register:Rs: Src1 RT: Src2
Registers Registers
(
	.clk_i      (clk_i),
	.RS1addr_i   (instruction[19 : 15]),
	.RS2addr_i   (instruction[24 : 20]),
	.RDaddr_i   (MEM_WB_RD_addr), 
	.RDdata_i   (MemToReg_RDdata),
	.RegWrite_i (MEM_WB_RegWrite_reg), //from MEM_WB the register address of RD
	.RS1data_o   (register_RS1data),
	.RS2data_o   (register_RS2data) 
);

//extend immediate to 32 bit
Sign_Extend Sign_Extend(
    .data_i     (instruction),
    .data_o     (Ext_instr)
);

//ID_EX
ID_EX ID_EX
(
    .clk_i      (clk_i),
	.RegWrite_i   (RegWrite),
    .MemtoReg_i   (MemtoReg),
    .MemRead_i    (MemRead),
    .MemWrite_i   (MemWrite),
    .ALUop_i      (ALUop),
    .ALUSrc_i     (ALUsrc),
    .RegWrite_o   (EX_MEM.RegWrite_i),
    .MemtoReg_o   (EX_MEM.MemtoReg_i),
    .MemRead_o    (ID_EX_MemRead),
    .MemWrite_o   (EX_MEM_MemWrite),
    .ALUop_o      (ID_EX_ALUop),
    .ALUSrc_o     (ID_EX_ALUSrc),
    .RSdata_i     (register_RS1data),
    .RTdata_i     (register_RS2data),
    .RSdata_o     (ID_EX_RSdata),
    .RTdata_o     (ID_EX_RTdata),
    .imm_i        (Ext_instr),
    .imm_o        (MUX_ALUSrc.data2_i),
    .funct_i       ({instruction[31:25],instruction[14:12]}),
    .Src1_addr_i  (instruction[19:15]),
    .Src2_addr_i  (instruction[24:20]),
    .RD_addr_i    (instruction[11:7]),
    .funct_o      (ALU_Control.funct_i), // to alu control
    .Src1_addr_o  (Forward.ID_EX_RSaddr_i),
    .Src2_addr_o  (Forward.ID_EX_RTaddr_i),
    .RD_addr_o    (ID_EX_RD_addr),
    .MemRead2_o   (MemRead2),
    .MemWrite2_o  (MemWrite2)
);

/*Forward:
Src = rd in EX stage : 01
Src = rd in MEM stage: 10
else = 00
*/
Forward Forward
(
	.ID_EX_RSaddr_i    (ID_EX.Src1_addr_o),
	.ID_EX_RTaddr_i    (ID_EX.Src2_addr_o),
	.EX_MEM_RDaddr_i   (EX_MEM_RD_addr),
	.MEM_WB_RDaddr_i   (MEM_WB_RD_addr),
	.EX_MEM_RegWrite_i (EX_MEM_RegWrite),
	.MEM_WB_RegWrite_i (MEM_WB_RegWrite_reg),
	.selectA_o         (MUXA.Forward_i),
	.selectB_o         (MUXB.Forward_i)
);

//Src1 mux and Src2 mux
MUXFoward MUXA
(
    .Forward_i     (Forward.selectA_o),
    .Src_i         (ID_EX_RSdata),
    .EX_MEM_i      (EX_MEM_ALU),
    .MEM_WB_i      (MemToReg_RDdata),
    .to_ALU_o      (ALU.data1_i)
);

MUXFoward MUXB
(
    .Forward_i     (Forward.selectB_o),
    .Src_i         (ID_EX_RTdata),
    .EX_MEM_i      (EX_MEM_ALU),
    .MEM_WB_i      (MemToReg_RDdata),
    .to_ALU_o      (MUX_ALUSrc_data)
);

//0: from rs2 1:from immediate
MUX32 MUX_ALUSrc(
    .data1_i    (MUX_ALUSrc_data),
    .data2_i    (ID_EX.imm_o),
    .select_i   (ID_EX_ALUSrc),
    .data_o     (ALU.data2_i) //to ALU
);

//determine the arithmetic operation by function7 and function 3
ALU_Control ALU_Control(
    .funct_i    (ID_EX.funct_o),
    .ALUOp_i    (ID_EX.ALUop_o),
    .ALUCtrl_o  (ALU.ALUCtrl_i)
);

ALU ALU(
    .data1_i    (MUXA.to_ALU_o),
    .data2_i    (MUX_ALUSrc.data_o),
    .ALUCtrl_i  (ALU_Control.ALUCtrl_o),
    .data_o     (EX_MEM.ALU_result_i)// to EX/MEM
);
//EX_MEM:Store ALU result
EX_MEM EX_MEM(
    .clk_i          (clk_i),
    .RegWrite_i     (ID_EX.RegWrite_o),
    .MemtoReg_i     (ID_EX.MemtoReg_o),
    .MemRead_i      (MemRead2),
    .MemWrite_i     (MemWrite2),
    .RegWrite_o     (EX_MEM_RegWrite),
    .MemtoReg_o     (MEM_WB.MemtoReg_i),
    .MemRead_o      (Data_Memory.MemRead_i),
    .MemWrite_o     (Data_Memory.MemWrite_i),
    .ALU_result_i   (ALU.data_o),
    .MUX_ALUSrc_i   (MUX_ALUSrc_data),
    .ID_EX_RD_i     (ID_EX_RD_addr),
    .ALU_result_o   (EX_MEM_ALU),
    .Write_Data_o   (Data_Memory.data_i),
    .RD_addr_o      (EX_MEM_RD_addr)
);

//Data Memory
Data_Memory Data_Memory(
    .clk_i       (clk_i), 
    .addr_i      (EX_MEM_ALU), 
    .MemRead_i   (EX_MEM.MemRead_o),
    .MemWrite_i (EX_MEM.MemWrite_o),
    .data_i      (EX_MEM.Write_Data_o),
    .data_o      (MEM_WB.Memory_data_i)
);
//MEM_WB:store the data need to be written back register
MEM_WB MEM_WB(
    .clk_i        (clk_i),
    .RegWrite_i   (EX_MEM_RegWrite),
    .MemtoReg_i   (EX_MEM.MemtoReg_o),
    .ALU_result_i (EX_MEM_ALU),
    .Memory_data_i (Data_Memory.data_o),
    .RD_addr_i    (EX_MEM_RD_addr),
    .RegWrite_o   (MEM_WB_RegWrite),
    .MemtoReg_o   (MemToReg.select_i), //to memtoreg mux
    .From_MEM_o   (MemToReg.data2_i), //to memtoreg mux
    .From_ALU_o   (MemToReg.data1_i),
    .RD_addr_o    (MEM_WB_RD_addr)
);

//MemtoReg Mux
MUX32 MemToReg(
    .data1_i      (MEM_WB.From_ALU_o),
    .data2_i      (MEM_WB.From_MEM_o),
    .select_i     (MEM_WB.MemtoReg_o),
    .data_o       (MemToReg_RDdata)
);

/*Harzard: deal with stall and flush
if MemRead and EX stage rd equal to Src1 or Src2 => stall
if brench and Src1 == Src2 => flush
*/
Hazard Hazard(
    .Src1_i     (instruction[19:15]),
    .Src2_i     (instruction[24:20]),
    .RD_i       (ID_EX_RD_addr),
    .MemRead_i  (MemRead_reg),
    .stall    (stall),
    .PC_Write   (PC_write),
    .NoOp_o     (NoOp)
);

endmodule

