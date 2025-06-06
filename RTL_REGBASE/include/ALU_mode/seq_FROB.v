case (state)
0: begin
	add5_opr1 <= reg_list[inst_addr_opr1 + 0]; add5_opr2 <= reg_list[`RAM_ZERO]; issub5 <= 0;
	add6_opr1 <= reg_list[inst_addr_opr1 + 2]; add6_opr2 <= reg_list[`RAM_ZERO]; issub6 <= 0;
	add4_opr1 <= reg_list[`RAM_ZERO]; add4_opr2 <= reg_list[inst_addr_opr1 + 3]; issub4 <= 1;
	add2_opr1 <= reg_list[inst_addr_opr1 + 4]; add2_opr2 <= reg_list[`RAM_ZERO]; issub2 <= 0;
	add7_opr1 <= reg_list[`RAM_ZERO]; add7_opr2 <= reg_list[inst_addr_opr1 + 5]; issub7 <= 1;
	add3_opr1 <= reg_list[inst_addr_opr1 + 6]; add3_opr2 <= reg_list[`RAM_ZERO]; issub3 <= 0;
	add0_opr1 <= reg_list[inst_addr_opr1 + 10]; add0_opr2 <= reg_list[`RAM_ZERO]; issub0 <= 0;
	add1_opr1 <= reg_list[`RAM_ZERO]; add1_opr2 <= reg_list[inst_addr_opr1 + 11]; issub1 <= 1;
	state <= state + 1;
end
1: begin
	reg_list[ret_addr + 0] <= add5_out;
	add1_opr1 <= reg_list[`RAM_ZERO]; add1_opr2 <= reg_list[inst_addr_opr1 + 1]; issub1 <= 1;
	mm0_opr10 <= add0_out; mm0_opr11 <= add1_out; mm0_opr20 <= reg_list[`RAM_XI50]; mm0_opr21 <= reg_list[`RAM_XI51]; 
	add3_opr1 <= reg_list[`RAM_ZERO]; add3_opr2 <= reg_list[inst_addr_opr1 + 7]; issub3 <= 1;
	add2_opr1 <= reg_list[inst_addr_opr1 + 8]; add2_opr2 <= reg_list[`RAM_ZERO]; issub2 <= 0;
	add5_opr1 <= reg_list[`RAM_ZERO]; add5_opr2 <= reg_list[inst_addr_opr1 + 9]; issub5 <= 1;
	state <= state + 1;
end
2: begin
	reg_list[ret_addr + 1] <= add1_out;
	mm0_opr10 <= add2_out; mm0_opr11 <= add7_out; mm0_opr20 <= reg_list[`RAM_XI10]; mm0_opr21 <= reg_list[`RAM_XI11]; 
	mid_reg_list[0] <= add6_out_reg;
	mid_reg_list[1] <= add4_out_reg;
	mid_reg_list[2] <= add3_out_reg;
	state <= state + 1;
end
3: begin
	mm0_opr10 <= mid_reg_list[0]; mm0_opr11 <= mid_reg_list[1]; mm0_opr20 <= reg_list[`RAM_XI30]; mm0_opr21 <= reg_list[`RAM_XI31]; 
	mid_reg_list[3] <= add3_out_reg;
	mid_reg_list[4] <= add2_out_reg;
	mid_reg_list[5] <= add5_out_reg;
	state <= state + 1;
end
4: begin
	mm0_opr10 <= mid_reg_list[2]; mm0_opr11 <= mid_reg_list[3]; mm0_opr20 <= reg_list[`RAM_XI40]; mm0_opr21 <= reg_list[`RAM_XI41]; 
	state <= state + 1;
end
5: begin
	mm0_opr10 <= mid_reg_list[4]; mm0_opr11 <= mid_reg_list[5]; mm0_opr20 <= reg_list[`RAM_XI20]; mm0_opr21 <= reg_list[`RAM_XI21]; 
	state <= state + 1;
end
6: begin
	state <= state + 1;
end
7: begin
	state <= state + 1;
end
8: begin
	state <= state + 1;
end
9: begin
	state <= state + 1;
end
10: begin
	reg_list[ret_addr + 10] <= mm0_out1;
	reg_list[ret_addr + 11] <= mm0_out2;
	state <= state + 1;
end
11: begin
	reg_list[ret_addr + 4] <= mm0_out1;
	reg_list[ret_addr + 5] <= mm0_out2;
	state <= state + 1;
end
12: begin
	reg_list[ret_addr + 2] <= mm0_out1;
	reg_list[ret_addr + 3] <= mm0_out2;
	state <= state + 1;
end
13: begin
	reg_list[ret_addr + 6] <= mm0_out1;
	reg_list[ret_addr + 7] <= mm0_out2;
	state <= state + 1;
end
14: begin
	reg_list[ret_addr + 8] <= mm0_out1;
	reg_list[ret_addr + 9] <= mm0_out2;
	state <= state + 1;
end
15: begin
	state <= 0;
end
endcase
