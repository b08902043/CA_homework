module MEM_WB(
    clk_i,
    RegWrite_i,
    MemtoReg_i,
    ALU_result_i,
    Memory_data_i,
    RD_addr_i,
    RegWrite_o,
    MemtoReg_o,
    From_MEM_o, //to memtoreg mux
    From_ALU_o,
    RD_addr_o
);
input           clk_i;
input           RegWrite_i,MemtoReg_i;
output          RegWrite_o,MemtoReg_o;
input   [31:0]  ALU_result_i,Memory_data_i;
output  [31:0]  From_MEM_o,From_ALU_o;
input   [4:0]   RD_addr_i;
output  [4:0]   RD_addr_o;

reg             RegWrite_reg,MemtoReg_reg;
reg     [31:0]  ALU_result_reg,Memory_data_reg;
reg     [4:0]   RD_addr_reg;

assign RD_addr_o = RD_addr_reg;
assign From_ALU_o = ALU_result_reg;
assign From_MEM_o = Memory_data_reg;
assign RegWrite_o = RegWrite_reg;
assign MemtoReg_o = MemtoReg_reg;
always @(posedge clk_i)
begin
    RD_addr_reg <= RD_addr_i;
    ALU_result_reg <= ALU_result_i;
    Memory_data_reg <= Memory_data_i;
    RegWrite_reg <= RegWrite_i;
    MemtoReg_reg <= MemtoReg_i;
end



   
endmodule