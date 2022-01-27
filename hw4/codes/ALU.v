module ALU(
    data1_i,
    data2_i,
    ALUCtrl_i,
    data_o,
    Zero_o
);
input   [31:0]  data1_i;
input   [31:0]  data2_i;
input   [2:0]   ALUCtrl_i;
output  [31:0]  data_o;
output          Zero_o;
assign	data_o = (ALUCtrl_i == 3'b000)?	data1_i + data2_i : //add addi
				 (ALUCtrl_i == 3'b001)?	data1_i & data2_i : //and
				 (ALUCtrl_i == 3'b010)?	data1_i << data2_i : //sll
                 (ALUCtrl_i == 3'b011)?	data1_i ^ data2_i : //xor
                 (ALUCtrl_i == 3'b100)?	data1_i - data2_i : //sub
				 (ALUCtrl_i == 3'b110)?	data1_i >> data2_i[4:0] : //srai
				 (ALUCtrl_i == 3'b101)?	data1_i * data2_i : //mul

				 32'd0;

assign	Zero_o = 1'b0;
/*
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