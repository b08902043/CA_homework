module ALU(
    data1_i,
    data2_i,
    ALUCtrl_i,
    data_o,
);
input   [31:0]  data1_i;
input   [31:0]  data2_i;
input   [3:0]   ALUCtrl_i;
output  [31:0]  data_o;
assign	data_o = (ALUCtrl_i == 4'b0010)?	data1_i + data2_i : //add addi ld sd
				 (ALUCtrl_i == 4'b0000)?	data1_i & data2_i : //and
				 (ALUCtrl_i == 4'b0101)?	data1_i << data2_i : //sll
                 (ALUCtrl_i == 4'b0001)?	data1_i ^ data2_i : //xor
                 (ALUCtrl_i == 4'b0110)?	data1_i - data2_i : //sub
				 (ALUCtrl_i == 4'b0100)?	data1_i >> data2_i[4:0] : //srai
				 (ALUCtrl_i == 4'b0111)?	data1_i * data2_i : //mul

				 32'd0;

endmodule