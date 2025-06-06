case (state)
0: begin
	add7_opr1 <= reg_list[inst_addr_opr2 + 6]; add7_opr2 <= reg_list[inst_addr_opr2 + 10]; issub7 <= 0;
	mm0_opr10 <= reg_list[inst_addr_opr1 + 8]; mm0_opr11 <= reg_list[inst_addr_opr1 + 9]; mm0_opr20 <= reg_list[inst_addr_opr2 + 6]; mm0_opr21 <= reg_list[inst_addr_opr2 + 7]; 
	add0_opr1 <= reg_list[inst_addr_opr1 + 0]; add0_opr2 <= reg_list[inst_addr_opr1 + 8]; issub0 <= 0;
	add4_opr1 <= reg_list[inst_addr_opr2 + 0]; add4_opr2 <= reg_list[inst_addr_opr2 + 8]; issub4 <= 0;
	add6_opr1 <= reg_list[inst_addr_opr2 + 1]; add6_opr2 <= reg_list[inst_addr_opr2 + 9]; issub6 <= 0;
	add3_opr1 <= reg_list[inst_addr_opr1 + 9]; add3_opr2 <= reg_list[inst_addr_opr1 + 3]; issub3 <= 0;
	add2_opr1 <= reg_list[inst_addr_opr2 + 0]; add2_opr2 <= reg_list[inst_addr_opr2 + 4]; issub2 <= 0;
	add5_opr1 <= reg_list[inst_addr_opr2 + 1]; add5_opr2 <= reg_list[inst_addr_opr2 + 5]; issub5 <= 0;
	add1_opr1 <= reg_list[inst_addr_opr2 + 9]; add1_opr2 <= reg_list[inst_addr_opr2 + 3]; issub1 <= 0;
	state <= state + 1;
end
1: begin
	mm0_opr10 <= reg_list[inst_addr_opr1 + 2]; mm0_opr11 <= reg_list[inst_addr_opr1 + 3]; mm0_opr20 <= reg_list[inst_addr_opr2 + 10]; mm0_opr21 <= reg_list[inst_addr_opr2 + 11]; 
	add5_opr1 <= reg_list[inst_addr_opr2 + 7]; add5_opr2 <= reg_list[inst_addr_opr2 + 11]; issub5 <= 0;
	add0_opr1 <= reg_list[inst_addr_opr1 + 1]; add0_opr2 <= reg_list[inst_addr_opr1 + 9]; issub0 <= 0;
	add2_opr1 <= reg_list[inst_addr_opr1 + 1]; add2_opr2 <= add3_out; issub2 <= 0;
	add6_opr1 <= add5_out; add6_opr2 <= add1_out; issub6 <= 0;
	add3_opr1 <= reg_list[inst_addr_opr1 + 8]; add3_opr2 <= reg_list[inst_addr_opr1 + 2]; issub3 <= 0;
	add1_opr1 <= reg_list[inst_addr_opr2 + 8]; add1_opr2 <= reg_list[inst_addr_opr2 + 2]; issub1 <= 0;
	state <= state + 1;
end
2: begin
	mm0_opr10 <= reg_list[inst_addr_opr1 + 0]; mm0_opr11 <= reg_list[inst_addr_opr1 + 1]; mm0_opr20 <= reg_list[inst_addr_opr2 + 6]; mm0_opr21 <= reg_list[inst_addr_opr2 + 7]; 
	add3_opr1 <= reg_list[inst_addr_opr1 + 0]; add3_opr2 <= add3_out; issub3 <= 0;
	add0_opr1 <= add2_out; add0_opr2 <= add1_out; issub0 <= 0;
	mid_reg_list[0] <= add7_out_reg;
	mid_reg_list[1] <= add0_out_reg;
	mid_reg_list[2] <= add4_out_reg;
	mid_reg_list[3] <= add6_out_reg;
	mid_reg_list[4] <= add3_out_reg;
	mid_reg_list[5] <= add2_out_reg;
	mid_reg_list[6] <= add5_out_reg;
	mid_reg_list[7] <= add1_out_reg;
	state <= state + 1;
end
3: begin
	mm0_opr10 <= reg_list[inst_addr_opr1 + 2]; mm0_opr11 <= reg_list[inst_addr_opr1 + 3]; mm0_opr20 <= reg_list[inst_addr_opr2 + 2]; mm0_opr21 <= reg_list[inst_addr_opr2 + 3]; 
	mid_reg_list[8] <= add5_out_reg;
	mid_reg_list[9] <= add0_out_reg;
	mid_reg_list[10] <= add2_out_reg;
	mid_reg_list[11] <= add6_out_reg;
	mid_reg_list[12] <= add3_out_reg;
	mid_reg_list[13] <= add1_out_reg;
	state <= state + 1;
end
4: begin
	mm0_opr10 <= reg_list[inst_addr_opr1 + 2]; mm0_opr11 <= reg_list[inst_addr_opr1 + 3]; mm0_opr20 <= reg_list[inst_addr_opr2 + 4]; mm0_opr21 <= reg_list[inst_addr_opr2 + 5]; 
	mid_reg_list[16] <= add3_out_reg;
	mid_reg_list[17] <= add0_out_reg;
	state <= state + 1;
end
5: begin
	mm0_opr10 <= reg_list[inst_addr_opr1 + 0]; mm0_opr11 <= reg_list[inst_addr_opr1 + 1]; mm0_opr20 <= reg_list[inst_addr_opr2 + 0]; mm0_opr21 <= reg_list[inst_addr_opr2 + 1]; 
	state <= state + 1;
end
6: begin
	mm0_opr10 <= reg_list[inst_addr_opr1 + 8]; mm0_opr11 <= reg_list[inst_addr_opr1 + 9]; mm0_opr20 <= reg_list[inst_addr_opr2 + 8]; mm0_opr21 <= reg_list[inst_addr_opr2 + 9]; 
	state <= state + 1;
end
7: begin
	mm0_opr10 <= mid_reg_list[12]; mm0_opr11 <= mid_reg_list[4]; mm0_opr20 <= mid_reg_list[0]; mm0_opr21 <= mid_reg_list[8]; 
	state <= state + 1;
end
8: begin
	mm0_opr10 <= mid_reg_list[1]; mm0_opr11 <= mid_reg_list[9]; mm0_opr20 <= mid_reg_list[2]; mm0_opr21 <= mid_reg_list[3]; 
	state <= state + 1;
end
9: begin
	const1_opr1 <= mm0_out1; const1_opr2 <= mm0_out2; mode_const1 <= `MODEONE;
	const0_opr1 <= mm0_out1; const0_opr2 <= mm0_out2; mode_const0 <= `MODEONE;
	mm0_opr10 <= reg_list[inst_addr_opr1 + 0]; mm0_opr11 <= reg_list[inst_addr_opr1 + 1]; mm0_opr20 <= mid_reg_list[5]; mm0_opr21 <= mid_reg_list[6]; 
	state <= state + 1;
end
10: begin
	const0_opr1 <= mm0_out1; const0_opr2 <= mm0_out2; mode_const0 <= `MODEONE;
	const1_opr1 <= mm0_out1; const1_opr2 <= mm0_out2; mode_const1 <= `MODEONE;
	add6_opr1 <= const1_out2; add6_opr2 <= const0_out1; issub6 <= 0;
	add0_opr1 <= reg_list[`RAM_ZERO]; add0_opr2 <= const0_out2; issub0 <= 1;
	mm0_opr10 <= mid_reg_list[12]; mm0_opr11 <= mid_reg_list[4]; mm0_opr20 <= mid_reg_list[13]; mm0_opr21 <= mid_reg_list[7]; 
	state <= state + 1;
end
11: begin
	add0_opr1 <= const0_out2; add0_opr2 <= const1_out1; issub0 <= 0;
	add2_opr1 <= reg_list[`RAM_ZERO]; add2_opr2 <= const1_out2; issub2 <= 1;
	add4_opr1 <= const1_out1; add4_opr2 <= add0_out; issub4 <= 0;
	mm0_opr10 <= reg_list[inst_addr_opr1 + 0]; mm0_opr11 <= reg_list[inst_addr_opr1 + 1]; mm0_opr20 <= mid_reg_list[0]; mm0_opr21 <= mid_reg_list[8]; 
	state <= state + 1;
end
12: begin
	const1_opr1 <= mm0_out1; const1_opr2 <= mm0_out2; mode_const1 <= `MODEONE;
	const0_opr1 <= mm0_out1; const0_opr2 <= mm0_out2; mode_const0 <= `MODEONE;
	add1_opr1 <= const0_out1; add1_opr2 <= add2_out; issub1 <= 0;
	mm0_opr10 <= mid_reg_list[16]; mm0_opr11 <= mid_reg_list[10]; mm0_opr20 <= mid_reg_list[17]; mm0_opr21 <= mid_reg_list[11]; 
	mid_reg_list[14] <= mm0_out1_reg; mid_reg_list[15] <= mm0_out2_reg;
	mid_reg_list[1] <= add6_out_reg;
	state <= state + 1;
end
13: begin
	add7_opr1 <= const1_out2; add7_opr2 <= const0_out1; issub7 <= 0;
	add0_opr1 <= reg_list[`RAM_ZERO]; add0_opr2 <= const0_out2; issub0 <= 1;
	mid_reg_list[18] <= mm0_out1_reg; mid_reg_list[19] <= mm0_out2_reg;
	mid_reg_list[2] <= add0_out_reg;
	mid_reg_list[3] <= add4_out_reg;
	state <= state + 1;
end
14: begin
	add7_opr1 <= const1_out1; add7_opr2 <= add0_out; issub7 <= 0;
	add3_opr1 <= mm0_out1; add3_opr2 <= mid_reg_list[3]; issub3 <= 0;
	add0_opr1 <= mm0_out2; add0_opr2 <= mid_reg_list[1]; issub0 <= 0;
	mid_reg_list[20] <= mm0_out1_reg; mid_reg_list[21] <= mm0_out2_reg;
	mid_reg_list[0] <= add1_out_reg;
	state <= state + 1;
end
15: begin
	add1_opr1 <= add7_out; add1_opr2 <= add3_out; issub1 <= 0;
	add3_opr1 <= add7_out; add3_opr2 <= add0_out; issub3 <= 0;
	add7_opr1 <= mid_reg_list[0]; add7_opr2 <= add3_out; issub7 <= 0;
	add5_opr1 <= mid_reg_list[2]; add5_opr2 <= add0_out; issub5 <= 0;
	add4_opr1 <= mid_reg_list[14]; add4_opr2 <= mm0_out1; issub4 <= 0;
	add0_opr1 <= mid_reg_list[15]; add0_opr2 <= mm0_out2; issub0 <= 0;
	add2_opr1 <= mm0_out1; add2_opr2 <= mm0_out1; issub2 <= 0;
	add6_opr1 <= mm0_out2; add6_opr2 <= mm0_out2; issub6 <= 0;
	state <= state + 1;
end
16: begin
	reg_list[ret_addr + 0] <= add1_out;
	reg_list[ret_addr + 1] <= add3_out;
	add4_opr1 <= mid_reg_list[20]; add4_opr2 <= add4_out; issub4 <= 0;
	add5_opr1 <= mid_reg_list[21]; add5_opr2 <= add0_out; issub5 <= 0;
	add6_opr1 <= mid_reg_list[18]; add6_opr2 <= add4_out; issub6 <= 0;
	add1_opr1 <= mid_reg_list[19]; add1_opr2 <= add0_out; issub1 <= 0;
	const1_opr1 <= mm0_out1; const1_opr2 <= mm0_out2; mode_const1 <= `MODEONE;
	const0_opr1 <= mm0_out1; const0_opr2 <= mm0_out2; mode_const0 <= `MODEONE;
	state <= state + 1;
end
17: begin
	reg_list[ret_addr + 6] <= add4_out;
	reg_list[ret_addr + 7] <= add5_out;
	add4_opr1 <= mm0_out1; add4_opr2 <= add2_out; issub4 <= 1;
	add2_opr1 <= mm0_out2; add2_opr2 <= add6_out; issub2 <= 1;
	add0_opr1 <= const1_out2; add0_opr2 <= const0_out1; issub0 <= 0;
	add1_opr1 <= reg_list[`RAM_ZERO]; add1_opr2 <= const0_out2; issub1 <= 1;
	mid_reg_list[1] <= add7_out_reg;
	mid_reg_list[3] <= add5_out_reg;
	state <= state + 1;
end
18: begin
	add4_opr1 <= mid_reg_list[0]; add4_opr2 <= add4_out; issub4 <= 0;
	add0_opr1 <= mid_reg_list[2]; add0_opr2 <= add2_out; issub0 <= 0;
	add1_opr1 <= mid_reg_list[20]; add1_opr2 <= add4_out; issub1 <= 0;
	add5_opr1 <= mid_reg_list[21]; add5_opr2 <= add2_out; issub5 <= 0;
	add2_opr1 <= mm0_out2; add2_opr2 <= add0_out; issub2 <= 0;
	add3_opr1 <= const1_out1; add3_opr2 <= add1_out; issub3 <= 0;
	mid_reg_list[4] <= add6_out_reg;
	mid_reg_list[5] <= add1_out_reg;
	state <= state + 1;
end
19: begin
	reg_list[ret_addr + 8] <= add4_out;
	reg_list[ret_addr + 9] <= add0_out;
	add5_opr1 <= add2_out; add5_opr2 <= mid_reg_list[3]; issub5 <= 1;
	add0_opr1 <= mm0_out1; add0_opr2 <= add3_out; issub0 <= 0;
	add6_opr1 <= mm0_out1; add6_opr2 <= mm0_out1; issub6 <= 0;
	add1_opr1 <= mm0_out2; add1_opr2 <= mm0_out2; issub1 <= 0;
	state <= state + 1;
end
20: begin
	reg_list[ret_addr + 5] <= add5_out;
	add0_opr1 <= add0_out; add0_opr2 <= mid_reg_list[1]; issub0 <= 1;
	add2_opr1 <= mm0_out1; add2_opr2 <= mm0_out1; issub2 <= 0;
	add1_opr1 <= mm0_out2; add1_opr2 <= mm0_out2; issub1 <= 0;
	mid_reg_list[6] <= add1_out_reg;
	mid_reg_list[7] <= add5_out_reg;
	state <= state + 1;
end
21: begin
	reg_list[ret_addr + 4] <= add0_out;
	add6_opr1 <= add2_out; add6_opr2 <= mid_reg_list[4]; issub6 <= 1;
	add0_opr1 <= add1_out; add0_opr2 <= mid_reg_list[5]; issub0 <= 1;
	add5_opr1 <= mm0_out1; add5_opr2 <= add6_out; issub5 <= 1;
	add1_opr1 <= mm0_out2; add1_opr2 <= add1_out; issub1 <= 1;
	state <= state + 1;
end
22: begin
	reg_list[ret_addr + 10] <= add6_out;
	reg_list[ret_addr + 11] <= add0_out;
	add6_opr1 <= add5_out; add6_opr2 <= mid_reg_list[6]; issub6 <= 1;
	add0_opr1 <= add1_out; add0_opr2 <= mid_reg_list[7]; issub0 <= 1;
	state <= state + 1;
end
23: begin
	reg_list[ret_addr + 2] <= add6_out;
	reg_list[ret_addr + 3] <= add0_out;
	state <= state + 1;
end
24: begin
	state <= 0;
end
endcase
