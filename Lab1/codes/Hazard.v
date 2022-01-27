module Hazard(
    Src1_i,
    Src2_i,
    RD_i,
    MemRead_i,
    stall,
    PC_Write,
    NoOp_o
);
input              MemRead_i;
input      [4 : 0] Src1_i,Src2_i,RD_i;
output reg         stall,PC_Write,NoOp_o;

always @(*)
begin
    if(MemRead_i)
    begin
        if(Src1_i == RD_i || Src2_i == RD_i)
        begin
            stall <= 1'b1;
            PC_Write <= 1'b0;
            NoOp_o <= 1'b1;
        end
        else
        begin
            stall <= 1'b0;
            PC_Write <= 1'b1;
            NoOp_o <= 1'b0;
        end
    end
    else
    begin
        stall <= 1'b0;
        PC_Write <= 1'b1;
        NoOp_o <= 1'b0;
    end
end

endmodule