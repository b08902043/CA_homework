module EX_MEM(
    clk_i,
    Mem_stall,
    RegWrite_i,
    MemtoReg_i,
    MemRead_i,
    MemWrite_i,
    RegWrite_o,
    MemtoReg_o,
    MemRead_o,
    MemWrite_o,
    ALU_result_i,
    MUX_ALUSrc_i,
    ID_EX_RD_i,
    ALU_result_o,
    Write_Data_o,
    RD_addr_o
);
input             clk_i,Mem_stall;
input      [4:0]  ID_EX_RD_i;
input      [31:0] MUX_ALUSrc_i,ALU_result_i;
input             MemRead_i,MemWrite_i,RegWrite_i,MemtoReg_i;
output     [4:0]  RD_addr_o;
output     [31:0] Write_Data_o,ALU_result_o;
output            MemRead_o,MemWrite_o,RegWrite_o,MemtoReg_o;

reg [4 : 0]  RD_addr_reg;
reg [31 : 0] Write_Data_reg;
reg [31 : 0] ALU_result_reg;
reg          MemRead_reg;
reg          MemWrite_reg;
reg          RegWrite_reg;
reg          MemtoReg_reg;
 
assign RD_addr_o = RD_addr_reg;
assign Write_Data_o = Write_Data_reg;
assign ALU_result_o = ALU_result_reg;
assign MemRead_o = MemRead_reg;
assign MemWrite_o = MemWrite_reg;
assign RegWrite_o = RegWrite_reg;
assign MemtoReg_o = MemtoReg_reg; 
always @(posedge clk_i)
begin
    if(!Mem_stall) begin
        RD_addr_reg <= ID_EX_RD_i;
        Write_Data_reg <= MUX_ALUSrc_i;
        ALU_result_reg <= ALU_result_i;
        MemRead_reg <= MemRead_i;
        MemWrite_reg <= MemWrite_i;
        RegWrite_reg <= RegWrite_i;
        MemtoReg_reg <= MemtoReg_i;
    end
end

endmodule