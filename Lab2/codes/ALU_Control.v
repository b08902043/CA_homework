module ALU_Control(
	funct_i,
	ALUOp_i,
	ALUCtrl_o
);
input  [9:0]   funct_i;
input  [1:0]   ALUOp_i;
output [3:0]   ALUCtrl_o;
reg    [3:0]   ALUCtrl_reg;

assign ALUCtrl_o = ALUCtrl_reg;

always @(*)
begin
	if (ALUOp_i == 2'b10)    //R-type
	begin
		if (funct_i[2:0] == 3'b000)
		begin
			if (funct_i[9 : 3] == 7'b0000000) //add
			begin
				ALUCtrl_reg = 4'b0010;
			end
			else if (funct_i[9 : 3] == 7'b0100000) //sub
			begin
				ALUCtrl_reg = 4'b0110;
			end
			else if (funct_i[9 : 3] == 7'b0000001) //mul
			begin
				ALUCtrl_reg = 4'b0111;
			end
		end
		else if (funct_i[2:0] == 3'b001)  //sll
		begin
			ALUCtrl_reg = 4'b0101;
		end
		else if (funct_i[2:0] == 3'b111)   //and
		begin
			ALUCtrl_reg = 4'b0000;
		end
		else if (funct_i[2:0] == 3'b100)   // xor
		begin
			ALUCtrl_reg = 4'b0001;
		end
	end
	else if (ALUOp_i == 2'b00) // lw sw
	begin
        ALUCtrl_reg = 4'b0010;
	end
	else if (ALUOp_i == 2'b01) //branch
	begin
		ALUCtrl_reg = 4'b0110;
	end
	else
	begin
		if(funct_i[2:0] == 3'b000) //addi
		begin
			ALUCtrl_reg = 4'b0010;
		end
		else 
		begin
			ALUCtrl_reg = 4'b0100; //srai
		end
	end
end

endmodule
