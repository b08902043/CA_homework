module And
(
	data1_i,
	data2_i,
	data_o
);

input      data1_i,data2_i;
output     data_o;
reg        And_gate;
assign     data_o = And_gate;
always @(*)
begin
	And_gate = data1_i & data2_i;
end

endmodule