module CPU
(
    clk_i, 
    rst_i,
    start_i
);
// Ports
input               clk_i;
input               rst_i;
input               start_i;

wire    [31:0]  instruction;
wire    [1:0]   ALUop;
wire            ALUsrc,RegWrite;
Control Control(
    .Op_i       (instruction[6:0]),
    .ALUOp_o    (ALUop),
    .ALUSrc_o   (ALUsrc),
    .RegWrite_o (RegWrite)
);


wire    [31:0]  instr_addr,next_addr; 
Adder Add_PC(
    .data1_in   (instr_addr),
    .data2_in   (32'd4),
    .data_o     (next_addr)
);


PC PC(
    .clk_i      (clk_i),
    .rst_i      (rst_i),
    .start_i    (start_i),
    .pc_i       (next_addr),
    .pc_o       (instr_addr)
);
Instruction_Memory Instruction_Memory(
    .addr_i     (instr_addr), 
    .instr_o    (instruction)
);
wire    [31:0]  RD_Data,RS1_Data,RS2_Data;
Registers Registers(
    .clk_i      (clk_i),
    .RS1addr_i   (instruction[19:15]),
    .RS2addr_i   (instruction[24:20]),
    .RDaddr_i   (instruction[11:7]), 
    .RDdata_i   (RD_Data),
    .RegWrite_i (RegWrite), 
    .RS1data_o   (RS1_Data), 
    .RS2data_o   (RS2_Data) 
);

wire    [31:0]  Mux_Data,Ext_instr;
MUX32 MUX_ALUSrc(
    .data1_i    (RS2_Data),
    .data2_i    (Ext_instr),
    .select_i   (ALUsrc),
    .data_o     (Mux_Data)
);


Sign_Extend Sign_Extend(
    .data_i     (instruction[31:20]),
    .data_o     (Ext_instr)
);

  
wire    [2:0]   ALUctr_out;
wire            Zero;
ALU ALU(
    .data1_i    (RS1_Data),
    .data2_i    (Mux_Data),
    .ALUCtrl_i  (ALUctr_out),
    .data_o     (RD_Data),
    .Zero_o     (Zero)
);



ALU_Control ALU_Control(
    .funct_i    ({instruction[31:25],instruction[14:12]}),
    .ALUOp_i    (ALUop),
    .ALUCtrl_o  (ALUctr_out)
);


endmodule

