module Control(
    Op_i,
    ALUOp_o,
    ALUSrc_o,
    RegWrite_o
);
input	[6:0]		Op_i;
output	[1:0]		ALUOp_o;
output 				ALUSrc_o, RegWrite_o;
reg		[3:0]		ctrl_signal;

always @(Op_i) begin
        case(Op_i)
            7'b0110011: //R-type
                ctrl_signal <= {2'b10,1'b0,1'b1};
            7'b0010011://i-type
                ctrl_signal <= {2'b00,1'b1,1'b1};
            default:
                ctrl_signal <= 5'd0;
        endcase
end
assign	ALUOp_o = ctrl_signal[3:2];
assign	ALUSrc_o = ctrl_signal[1];
assign	RegWrite_o = ctrl_signal[0];

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

fuction     opcode    ALUop     ALUsrc
and         0110011     10        0
xor         0110011     10        0
sll         0110011     10        0
add         0110011     10        0
sub         0110011     10        0
mul         0110011     10        0
addi        0010011     00        1
srai        0010011     00        1
*/
endmodule
