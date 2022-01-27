module IF_ID
(
	clk_i,
	Mem_stall,
	stall_i,
	IF_ID_flush_i,
	PC_i,
	PC_o,
	inst_i,
	inst_o
);

input               clk_i;
input               stall_i,Mem_stall;
input               IF_ID_flush_i;
input      [31 : 0] PC_i;
output     [31 : 0] PC_o;
input      [31 : 0] inst_i;
output     [31 : 0] inst_o;

reg [31 : 0] PC_reg;
reg [31 : 0] inst_reg;
assign PC_o = PC_reg;
assign inst_o = inst_reg;
always @(posedge clk_i)
begin
	if (!stall_i && !Mem_stall)
	begin
		PC_reg <= PC_i;
		if(IF_ID_flush_i)
		begin
			inst_reg <= 32'b0;
		end
		else
		begin
			inst_reg <= inst_i;
		end
	end
end

endmodule