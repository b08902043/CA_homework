module Forward
(
	ID_EX_RSaddr_i,
	ID_EX_RTaddr_i,
	EX_MEM_RDaddr_i,
	MEM_WB_RDaddr_i,
	EX_MEM_RegWrite_i,
	MEM_WB_RegWrite_i,
	selectA_o,
	selectB_o
);
input  [4 : 0] ID_EX_RSaddr_i;
input  [4 : 0] ID_EX_RTaddr_i;
input  [4 : 0] EX_MEM_RDaddr_i;
input  [4 : 0] MEM_WB_RDaddr_i;
input          EX_MEM_RegWrite_i;
input          MEM_WB_RegWrite_i;
output [1 : 0] selectA_o;
output [1 : 0] selectB_o;

reg [1 : 0] selectA_reg;
reg [1 : 0] selectB_reg;

assign selectA_o = selectA_reg;
assign selectB_o = selectB_reg;

always @(*)
begin
	if (EX_MEM_RegWrite_i && ID_EX_RSaddr_i == EX_MEM_RDaddr_i && EX_MEM_RDaddr_i != 1'b0) //RD in EX_MEM is same to Src1 in ID_EX
	begin
		selectA_reg = 2'b10;
	end
	else if (MEM_WB_RegWrite_i && ID_EX_RSaddr_i == MEM_WB_RDaddr_i && MEM_WB_RDaddr_i != 1'b0) //RD in MEM_WB is same to Src1 in ID_EX
	begin
		selectA_reg = 2'b01;
	end
	else
	begin
		selectA_reg = 2'b00;
	end

	if (EX_MEM_RegWrite_i && ID_EX_RTaddr_i == EX_MEM_RDaddr_i && EX_MEM_RDaddr_i != 1'b0) //RD in EX_MEM is same to Src2 in ID_EX
	begin
		selectB_reg = 2'b10;
	end
	else if (MEM_WB_RegWrite_i && ID_EX_RTaddr_i == MEM_WB_RDaddr_i && MEM_WB_RDaddr_i != 1'b0)//RD in MEM_WB is same to Src2 in ID_EX
	begin
		selectB_reg = 2'b01;
	end
	else
	begin
		selectB_reg = 2'b00;
	end
end

endmodule