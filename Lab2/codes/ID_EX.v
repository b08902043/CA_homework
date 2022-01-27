module ID_EX
(
    clk_i,
    Mem_stall,
	RegWrite_i,
    MemtoReg_i,
    MemRead_i,
    MemWrite_i,
    ALUop_i,
    ALUSrc_i,
    RegWrite_o,
    MemtoReg_o,
    MemRead_o,
    MemWrite_o,
    ALUop_o,
    ALUSrc_o,
    RSdata_i,
    RTdata_i,
    RSdata_o,
    RTdata_o,
    imm_i,
    imm_o,
    funct_i,
    Src1_addr_i,
    Src2_addr_i,
    RD_addr_i,
    funct_o,
    Src1_addr_o,
    Src2_addr_o,
    RD_addr_o,
    MemRead2_o,
    MemWrite2_o
);
input          clk_i,RegWrite_i,MemtoReg_i,MemRead_i,MemWrite_i,ALUSrc_i,Mem_stall;
input  [1:0]   ALUop_i;
output         RegWrite_o,MemtoReg_o,MemRead_o,MemWrite_o,ALUSrc_o,MemRead2_o,MemWrite2_o;
output [1:0]   ALUop_o;
input  [31:0]  RSdata_i,RTdata_i,imm_i;
output [31:0]  RSdata_o,RTdata_o,imm_o;
input  [9:0]   funct_i;
output  [9:0]  funct_o;
input  [4:0]   Src1_addr_i,Src2_addr_i,RD_addr_i;
output  [4:0]  Src1_addr_o,Src2_addr_o,RD_addr_o;

reg [4 : 0]  RSaddr_reg;
reg [4 : 0]  RTaddr_reg;
reg [4 : 0]  RDaddr_reg;
reg [31 : 0] RSdata_reg;
reg [31 : 0] RTdata_reg;
reg [31 : 0] imm_reg;
reg [1 : 0]  ALUOp_reg;
reg          ALUSrc_reg;
reg          MemRead_reg;
reg          MemWrite_reg;
reg          RegWrite_reg;
reg          MemtoReg_reg;
reg [9:0]    Funct_reg;
assign Src1_addr_o = RSaddr_reg;
assign Src2_addr_o = RTaddr_reg;
assign RD_addr_o = RDaddr_reg;
assign RSdata_o = RSdata_reg;
assign RTdata_o = RTdata_reg;
assign imm_o = imm_reg;
assign ALUop_o = ALUOp_reg;
assign ALUSrc_o = ALUSrc_reg;
assign MemRead_o = MemRead_reg;
assign MemWrite_o = MemWrite_reg;
assign MemRead2_o = MemRead_reg;
assign MemWrite2_o = MemWrite_reg;
assign RegWrite_o = RegWrite_reg;
assign MemtoReg_o = MemtoReg_reg;
assign funct_o = Funct_reg;
always @(posedge clk_i)
begin
    if(!Mem_stall)begin
        RSaddr_reg <= Src1_addr_i;
        RTaddr_reg <= Src2_addr_i;
        RDaddr_reg <= RD_addr_i;
        RSdata_reg <= RSdata_i;
        RTdata_reg <= RTdata_i;
        imm_reg <= imm_i;
        ALUOp_reg <= ALUop_i;
        ALUSrc_reg <= ALUSrc_i;
        MemRead_reg <= MemRead_i;
        MemWrite_reg <= MemWrite_i;
        RegWrite_reg <= RegWrite_i;
        MemtoReg_reg <= MemtoReg_i;
        Funct_reg <= funct_i;
    end

end

endmodule