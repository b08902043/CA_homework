module Control(
    Op_i,
    NoOp_i,
    ALUOp_o,
    ALUSrc_o,
    RegWrite_o,
    MemtoReg_o,
    MemRead_o,
    MemWrite_o,
    Branch_o
);
input	[6:0]		Op_i;
input               NoOp_i;
output	[1:0]		ALUOp_o;
output 				ALUSrc_o, RegWrite_o,MemtoReg_o,MemRead_o,MemWrite_o,Branch_o;
reg     [1:0]       ALUOp_reg;
reg                 ALUSrc_reg,Branch_reg,MemRead_reg,MemWrite_reg,RegWrite_reg,MemtoReg_reg;
assign ALUOp_o = ALUOp_reg;

assign ALUSrc_o = (NoOp_i)? 1'b0:ALUSrc_reg;
assign Branch_o = (NoOp_i)? 1'b0:Branch_reg;
assign MemRead_o = (NoOp_i)? 1'b0:MemRead_reg;
assign MemWrite_o = (NoOp_i)? 1'b0:MemWrite_reg;
assign RegWrite_o = (NoOp_i)? 1'b0:RegWrite_reg;
assign MemtoReg_o = (NoOp_i)? 1'b0:MemtoReg_reg;

always @(Op_i or NoOp_i) begin
        if(NoOp_i == 1'b1) begin 
            ALUOp_reg <= 2'b00;
            ALUSrc_reg <= 1'b0;
            Branch_reg <= 1'b0;
            MemRead_reg <= 1'b0;
            MemWrite_reg <= 1'b0;
            RegWrite_reg <= 1'b0;
            MemtoReg_reg <= 1'b0; 
        end
        else if(NoOp_i == 1'b0 && (Op_i == 7'b0110011))  //and xor sll add sub mul
        begin
            ALUOp_reg <= 2'b10;
            ALUSrc_reg <= 1'b0;
            Branch_reg <= 1'b0;
            MemRead_reg <= 1'b0;
            MemWrite_reg <= 1'b0;
            RegWrite_reg <= 1'b1;
            MemtoReg_reg <= 1'b0; 
        end
        else if(NoOp_i == 1'b0 &&(Op_i == 7'b0010011)) // addi srai
        begin
            ALUOp_reg <= 2'b11;
            ALUSrc_reg <= 1'b1;
            Branch_reg <= 1'b0;
            MemRead_reg <= 1'b0;
            MemWrite_reg <= 1'b0;
            RegWrite_reg <= 1'b1;
            MemtoReg_reg <= 1'b0; 
        end
        else if(NoOp_i == 1'b0 &&(Op_i == 7'b0000011)) // lw
        begin
            ALUOp_reg <= 2'b00;
            ALUSrc_reg <= 1'b1;
            Branch_reg <= 1'b0;
            MemRead_reg <= 1'b1;
            MemWrite_reg <= 1'b0;
            RegWrite_reg <= 1'b1;
            MemtoReg_reg <= 1'b1; 
        end
        else if(NoOp_i == 1'b0 &&(Op_i == 7'b0100011)) // sw
        begin
            ALUOp_reg <= 2'b00;
            ALUSrc_reg <= 1'b1;
            Branch_reg <= 1'b0;
            MemRead_reg <= 1'b0;
            MemWrite_reg <= 1'b1;
            RegWrite_reg <= 1'b0;
            MemtoReg_reg <= 1'b0; 
        end
        else if(NoOp_i == 1'b0 &&(Op_i == 7'b1100011))
        begin
            ALUOp_reg <= 2'b01;
            ALUSrc_reg <= 1'b0;
            Branch_reg <= 1'b1;
            MemRead_reg <= 1'b0;
            MemWrite_reg <= 1'b0;
            RegWrite_reg <= 1'b0;
            MemtoReg_reg <= 1'b0; 
        end 
        else 
        begin
            ALUOp_reg <= 2'b00;
            ALUSrc_reg <= 1'b0;
            Branch_reg <= 1'b0;
            MemRead_reg <= 1'b0;
            MemWrite_reg <= 1'b0;
            RegWrite_reg <= 1'b0;
            MemtoReg_reg <= 1'b0; 
        end
end
//instructions
/*
funct7     rs2      rs1      funct3      rd      opcode     function
0000000    rs2      rs1       111        rd      0110011      and
0000000    rs2      rs1       100        rd      0110011      xor
0000000    rs2      rs1       001        rd      0110011      sll
0000000    rs2      rs1       000        rd      0110011      add
0100000    rs2      rs1       000        rd      0110011      sub
0000001    rs2      rs1       000        rd      0110011      mul
imm[11:0]           rs1       000        rd      0010011      addi
0100000   imm[4:0]  rs1       101        rd      0010011      srai

new instructions:
imm[11:0]           rs1       010        rd      0000011      lw
imm[11:5]  rs2      rs1       010        rd      0100011      sw
imm[12,11:5]rs2     rs1       000   imm[4:1,11]  1100011      beq


fuction     opcode    ALUop     ALUsrc
and         0110011     10        0
xor         0110011     10        0
sll         0110011     10        0
add         0110011     10        0
sub         0110011     10        0
mul         0110011     10        0
addi        0010011     00        1
srai        0010011     00        1
new instructions:
lw          0000011     00        1
sw          0100011     00        1
beq         1100011     01        0
*/
endmodule