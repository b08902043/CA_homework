module MUXFoward
(
    Forward_i,
    Src_i,
    EX_MEM_i,
    MEM_WB_i,
    to_ALU_o
);
input  [31:0]   Src_i,EX_MEM_i,MEM_WB_i;
input  [1:0]    Forward_i;
output [31:0]   to_ALU_o;

reg   [31:0]    to_ALUdata;

assign to_ALU_o = to_ALUdata; 

always @(*)
begin
	case (Forward_i)
		2'b00: 
            to_ALUdata = Src_i;
		2'b10: 
            to_ALUdata = EX_MEM_i;
		2'b01: 
            to_ALUdata = MEM_WB_i;
	endcase
end
endmodule