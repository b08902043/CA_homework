module ALU_Control(
    funct_i,
    ALUOp_i,
    ALUCtrl_o
);
input   [9:0]   funct_i;
input   [1:0]   ALUOp_i;
output  [2:0]   ALUCtrl_o;
assign	ALUCtrl_o = (ALUOp_i == 2'b10 && funct_i == 10'b0000000000)?	3'b000 :	// add
					(ALUOp_i == 2'b10 && funct_i == 10'b0000000111)?	3'b001 :	// and
					(ALUOp_i == 2'b10 && funct_i == 10'b0000000001)?	3'b010 :	// sll
					(ALUOp_i == 2'b10 && funct_i == 10'b0000000100)?	3'b011 :	// xor
					(ALUOp_i == 2'b10 && funct_i == 10'b0100000000)?	3'b100 :	// sub
					(ALUOp_i == 2'b10 && funct_i == 10'b0000001000)?	3'b101 :	// mul
                    (ALUOp_i == 2'b00 && funct_i == 10'b0100000101)?    3'b110 :    //srai
					3'b000;


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

fuction     opcode    ALUop     ALUsrc     ALUCtrl
and         0110011     10        0         001
xor         0110011     10        0         011
sll         0110011     10        0         010
add         0110011     10        0         000
sub         0110011     10        0         100
mul         0110011     10        0         101
addi        0010011     00        1         000
srai        0010011     00        1         110
*/
endmodule