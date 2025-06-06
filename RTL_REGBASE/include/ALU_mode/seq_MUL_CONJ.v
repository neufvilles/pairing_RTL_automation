case (state)
0: begin
	add5_opr1 <= reg_list[inst_addr_opr2 + 8]; add5_opr2 <= reg_list[inst_addr_opr2 + 0]; issub5 <= 0;
	add6_opr1 <= reg_list[inst_addr_opr2 + 10]; add6_opr2 <= reg_list[inst_addr_opr2 + 2]; issub6 <= 0;
	add3_opr1 <= reg_list[inst_addr_opr2 + 11]; add3_opr2 <= reg_list[inst_addr_opr2 + 3]; issub3 <= 0;
	add7_opr1 <= reg_list[inst_addr_opr1 + 4]; add7_opr2 <= reg_list[inst_addr_opr1 + 6]; issub7 <= 0;
	add2_opr1 <= reg_list[inst_addr_opr2 + 5]; add2_opr2 <= reg_list[inst_addr_opr2 + 7]; issub2 <= 1;
	mm0_opr10 <= reg_list[inst_addr_opr1 + 10]; mm0_opr11 <= reg_list[inst_addr_opr1 + 11]; mm0_opr20 <= reg_list[inst_addr_opr2 + 10]; mm0_opr21 <= reg_list[inst_addr_opr2 + 11]; 
	add1_opr1 <= reg_list[inst_addr_opr2 + 0]; add1_opr2 <= reg_list[inst_addr_opr2 + 4]; issub1 <= 1;
	add0_opr1 <= reg_list[inst_addr_opr2 + 5]; add0_opr2 <= reg_list[inst_addr_opr2 + 9]; issub0 <= 1;
	add4_opr1 <= reg_list[inst_addr_opr2 + 7]; add4_opr2 <= reg_list[inst_addr_opr2 + 11]; issub4 <= 1;
	state <= state + 1;
end
1: begin
	add4_opr1 <= reg_list[inst_addr_opr1 + 1]; add4_opr2 <= reg_list[inst_addr_opr1 + 3]; issub4 <= 0;
	add5_opr1 <= reg_list[inst_addr_opr2 + 1]; add5_opr2 <= reg_list[inst_addr_opr2 + 3]; issub5 <= 1;
	add6_opr1 <= reg_list[inst_addr_opr2 + 9]; add6_opr2 <= reg_list[inst_addr_opr2 + 1]; issub6 <= 0;
	mm0_opr10 <= reg_list[inst_addr_opr1 + 6]; mm0_opr11 <= reg_list[inst_addr_opr1 + 7]; mm0_opr20 <= reg_list[inst_addr_opr2 + 6]; mm0_opr21 <= reg_list[inst_addr_opr2 + 7]; 
	add1_opr1 <= reg_list[inst_addr_opr1 + 9]; add1_opr2 <= reg_list[inst_addr_opr1 + 11]; issub1 <= 0;
	add7_opr1 <= reg_list[inst_addr_opr2 + 8]; add7_opr2 <= reg_list[inst_addr_opr2 + 10]; issub7 <= 1;
	add3_opr1 <= reg_list[inst_addr_opr1 + 1]; add3_opr2 <= reg_list[inst_addr_opr1 + 5]; issub3 <= 0;
	add2_opr1 <= reg_list[inst_addr_opr1 + 6]; add2_opr2 <= reg_list[inst_addr_opr1 + 10]; issub2 <= 0;
	add0_opr1 <= reg_list[inst_addr_opr1 + 11]; add0_opr2 <= reg_list[inst_addr_opr1 + 3]; issub0 <= 0;
	state <= state + 1;
end
2: begin
	mm0_opr10 <= reg_list[inst_addr_opr1 + 2]; mm0_opr11 <= reg_list[inst_addr_opr1 + 3]; mm0_opr20 <= reg_list[inst_addr_opr2 + 2]; mm0_opr21 <= reg_list[inst_addr_opr2 + 3]; 
	add6_opr1 <= reg_list[inst_addr_opr1 + 0]; add6_opr2 <= reg_list[inst_addr_opr1 + 2]; issub6 <= 0;
	add0_opr1 <= reg_list[inst_addr_opr2 + 9]; add0_opr2 <= reg_list[inst_addr_opr2 + 11]; issub0 <= 1;
	add7_opr1 <= reg_list[inst_addr_opr1 + 0]; add7_opr2 <= reg_list[inst_addr_opr1 + 4]; issub7 <= 0;
	add1_opr1 <= reg_list[inst_addr_opr1 + 2]; add1_opr2 <= reg_list[inst_addr_opr1 + 6]; issub1 <= 0;
	add5_opr1 <= reg_list[inst_addr_opr1 + 3]; add5_opr2 <= reg_list[inst_addr_opr1 + 7]; issub5 <= 0;
	add4_opr1 <= reg_list[inst_addr_opr1 + 5]; add4_opr2 <= reg_list[inst_addr_opr1 + 9]; issub4 <= 0;
	add3_opr1 <= reg_list[inst_addr_opr2 + 4]; add3_opr2 <= reg_list[inst_addr_opr2 + 8]; issub3 <= 1;
	add2_opr1 <= reg_list[inst_addr_opr1 + 9]; add2_opr2 <= reg_list[inst_addr_opr1 + 1]; issub2 <= 0;
	mid_reg_list[0] <= add5_out_reg;
	mid_reg_list[1] <= add6_out_reg;
	mid_reg_list[2] <= add3_out_reg;
	mid_reg_list[3] <= add7_out_reg;
	mid_reg_list[4] <= add2_out_reg;
	mid_reg_list[7] <= add1_out_reg;
	mid_reg_list[8] <= add0_out_reg;
	mid_reg_list[9] <= add4_out_reg;
	state <= state + 1;
end
3: begin
	mm0_opr10 <= reg_list[inst_addr_opr1 + 0]; mm0_opr11 <= reg_list[inst_addr_opr1 + 1]; mm0_opr20 <= reg_list[inst_addr_opr2 + 0]; mm0_opr21 <= reg_list[inst_addr_opr2 + 1]; 
	add2_opr1 <= reg_list[inst_addr_opr2 + 0]; add2_opr2 <= reg_list[inst_addr_opr2 + 2]; issub2 <= 1;
	add0_opr1 <= reg_list[inst_addr_opr2 + 4]; add0_opr2 <= reg_list[inst_addr_opr2 + 6]; issub0 <= 1;
	add7_opr1 <= reg_list[inst_addr_opr2 + 1]; add7_opr2 <= reg_list[inst_addr_opr2 + 5]; issub7 <= 1;
	add4_opr1 <= reg_list[inst_addr_opr2 + 2]; add4_opr2 <= reg_list[inst_addr_opr2 + 6]; issub4 <= 1;
	add5_opr1 <= reg_list[inst_addr_opr2 + 3]; add5_opr2 <= reg_list[inst_addr_opr2 + 7]; issub5 <= 1;
	add1_opr1 <= reg_list[inst_addr_opr1 + 4]; add1_opr2 <= reg_list[inst_addr_opr1 + 8]; issub1 <= 0;
	add3_opr1 <= reg_list[inst_addr_opr1 + 7]; add3_opr2 <= reg_list[inst_addr_opr1 + 11]; issub3 <= 0;
	add6_opr1 <= reg_list[inst_addr_opr1 + 10]; add6_opr2 <= reg_list[inst_addr_opr1 + 2]; issub6 <= 0;
	mid_reg_list[10] <= add4_out_reg;
	mid_reg_list[11] <= add5_out_reg;
	mid_reg_list[12] <= add6_out_reg;
	mid_reg_list[15] <= add1_out_reg;
	mid_reg_list[16] <= add7_out_reg;
	mid_reg_list[17] <= add3_out_reg;
	mid_reg_list[18] <= add2_out_reg;
	mid_reg_list[19] <= add0_out_reg;
	state <= state + 1;
end
4: begin
	add2_opr1 <= add2_out; add2_opr2 <= mid_reg_list[19]; issub2 <= 0;
	add7_opr1 <= reg_list[inst_addr_opr1 + 5]; add7_opr2 <= reg_list[inst_addr_opr1 + 7]; issub7 <= 0;
	mm0_opr10 <= reg_list[inst_addr_opr1 + 8]; mm0_opr11 <= reg_list[inst_addr_opr1 + 9]; mm0_opr20 <= reg_list[inst_addr_opr2 + 8]; mm0_opr21 <= reg_list[inst_addr_opr2 + 9]; 
	add5_opr1 <= reg_list[inst_addr_opr1 + 8]; add5_opr2 <= reg_list[inst_addr_opr1 + 10]; issub5 <= 0;
	add4_opr1 <= mid_reg_list[17]; add4_opr2 <= add5_out; issub4 <= 0;
	add3_opr1 <= add7_out; add3_opr2 <= add5_out; issub3 <= 1;
	add1_opr1 <= reg_list[inst_addr_opr2 + 6]; add1_opr2 <= reg_list[inst_addr_opr2 + 10]; issub1 <= 1;
	add0_opr1 <= add4_out; add0_opr2 <= add3_out; issub0 <= 0;
	add6_opr1 <= reg_list[inst_addr_opr1 + 8]; add6_opr2 <= reg_list[inst_addr_opr1 + 0]; issub6 <= 0;
	mid_reg_list[20] <= add6_out_reg;
	mid_reg_list[21] <= add0_out_reg;
	mid_reg_list[22] <= add7_out_reg;
	mid_reg_list[23] <= add1_out_reg;
	mid_reg_list[24] <= add5_out_reg;
	mid_reg_list[25] <= add4_out_reg;
	mid_reg_list[26] <= add3_out_reg;
	mid_reg_list[27] <= add2_out_reg;
	state <= state + 1;
end
5: begin
	add4_opr1 <= add6_out; add4_opr2 <= add6_out; issub4 <= 0;
	add7_opr1 <= mid_reg_list[0]; add7_opr2 <= mid_reg_list[1]; issub7 <= 1;
	add5_opr1 <= mid_reg_list[12]; add5_opr2 <= mid_reg_list[2]; issub5 <= 1;
	mm0_opr10 <= reg_list[inst_addr_opr1 + 4]; mm0_opr11 <= reg_list[inst_addr_opr1 + 5]; mm0_opr20 <= reg_list[inst_addr_opr2 + 4]; mm0_opr21 <= reg_list[inst_addr_opr2 + 5]; 
	add3_opr1 <= mid_reg_list[22]; add3_opr2 <= mid_reg_list[23]; issub3 <= 0;
	add1_opr1 <= mid_reg_list[7]; add1_opr2 <= add4_out; issub1 <= 1;
	add6_opr1 <= add1_out; add6_opr2 <= mid_reg_list[18]; issub6 <= 0;
	add0_opr1 <= mid_reg_list[26]; add0_opr2 <= add1_out; issub0 <= 1;
	add2_opr1 <= mid_reg_list[8]; add2_opr2 <= mid_reg_list[9]; issub2 <= 1;
	mid_reg_list[29] <= add2_out_reg;
	mid_reg_list[30] <= add0_out_reg;
	mid_reg_list[31] <= add7_out_reg;
	mid_reg_list[32] <= add4_out_reg;
	mid_reg_list[33] <= add5_out_reg;
	mid_reg_list[34] <= add1_out_reg;
	mid_reg_list[35] <= add3_out_reg;
	mid_reg_list[36] <= add6_out_reg;
	state <= state + 1;
end
6: begin
	mm0_opr10 <= mid_reg_list[18]; mm0_opr11 <= mid_reg_list[35]; mm0_opr20 <= add1_out; mm0_opr21 <= mid_reg_list[9]; 
	mid_reg_list[37] <= add2_out_reg;
	mid_reg_list[38] <= add7_out_reg;
	mid_reg_list[39] <= add5_out_reg;
	mid_reg_list[40] <= add4_out_reg;
	mid_reg_list[41] <= add3_out_reg;
	mid_reg_list[42] <= add0_out_reg;
	mid_reg_list[43] <= add6_out_reg;
	state <= state + 1;
end
7: begin
	mm0_opr10 <= mid_reg_list[34]; mm0_opr11 <= mid_reg_list[25]; mm0_opr20 <= mid_reg_list[26]; mm0_opr21 <= mid_reg_list[8]; 
	mid_reg_list[44] <= add4_out_reg;
	mid_reg_list[45] <= add7_out_reg;
	mid_reg_list[46] <= add5_out_reg;
	mid_reg_list[47] <= add3_out_reg;
	mid_reg_list[48] <= add1_out_reg;
	mid_reg_list[49] <= add6_out_reg;
	mid_reg_list[50] <= add0_out_reg;
	mid_reg_list[51] <= add2_out_reg;
	state <= state + 1;
end
8: begin
	mm0_opr10 <= mid_reg_list[39]; mm0_opr11 <= mid_reg_list[15]; mm0_opr20 <= mid_reg_list[16]; mm0_opr21 <= mid_reg_list[21]; 
	state <= state + 1;
end
9: begin
	mm0_opr10 <= mid_reg_list[20]; mm0_opr11 <= mid_reg_list[10]; mm0_opr20 <= mid_reg_list[29]; mm0_opr21 <= mid_reg_list[11]; 
	const1_opr1 <= mm0_out1; const1_opr2 <= mm0_out2; mode_const1 <= `MODEONE;
	const0_opr1 <= mm0_out1; const0_opr2 <= mm0_out2; mode_const0 <= `MODEONE;
	state <= state + 1;
end
10: begin
	mm0_opr10 <= mid_reg_list[36]; mm0_opr11 <= mid_reg_list[19]; mm0_opr20 <= mid_reg_list[1]; mm0_opr21 <= mid_reg_list[2]; 
	const0_opr1 <= mm0_out1; const0_opr2 <= mm0_out2; mode_const0 <= `MODEONE;
	const1_opr1 <= mm0_out1; const1_opr2 <= mm0_out2; mode_const1 <= `MODEONE;
	add0_opr1 <= const1_out2; add0_opr2 <= const0_out1; issub0 <= 0;
	add6_opr1 <= reg_list[`RAM_ZERO]; add6_opr2 <= const0_out2; issub6 <= 1;
	mid_reg_list[5] <= mm0_out1_reg; mid_reg_list[6] <= mm0_out2_reg;
	state <= state + 1;
end
11: begin
	const1_opr1 <= mm0_out1; const1_opr2 <= mm0_out2; mode_const1 <= `MODEONE;
	const0_opr1 <= mm0_out1; const0_opr2 <= mm0_out2; mode_const0 <= `MODEONE;
	add0_opr1 <= const0_out2; add0_opr2 <= const1_out1; issub0 <= 0;
	add6_opr1 <= reg_list[`RAM_ZERO]; add6_opr2 <= const1_out2; issub6 <= 1;
	mm0_opr10 <= mid_reg_list[3]; mm0_opr11 <= mid_reg_list[38]; mm0_opr20 <= mid_reg_list[30]; mm0_opr21 <= mid_reg_list[4]; 
	add2_opr1 <= const1_out1; add2_opr2 <= add6_out; issub2 <= 0;
	mid_reg_list[13] <= mm0_out1_reg; mid_reg_list[14] <= mm0_out2_reg;
	state <= state + 1;
end
12: begin
	add0_opr1 <= const1_out2; add0_opr2 <= const0_out1; issub0 <= 0;
	add7_opr1 <= reg_list[`RAM_ZERO]; add7_opr2 <= const0_out2; issub7 <= 1;
	add5_opr1 <= mm0_out1; add5_opr2 <= mm0_out1; issub5 <= 1;
	add6_opr1 <= mm0_out2; add6_opr2 <= mm0_out2; issub6 <= 1;
	mm0_opr10 <= mid_reg_list[43]; mm0_opr11 <= mid_reg_list[27]; mm0_opr20 <= mid_reg_list[0]; mm0_opr21 <= mid_reg_list[12]; 
	add3_opr1 <= const0_out1; add3_opr2 <= add6_out; issub3 <= 0;
	mid_reg_list[11] <= add0_out_reg;
	state <= state + 1;
end
13: begin
	add0_opr1 <= mm0_out2; add0_opr2 <= add0_out; issub0 <= 1;
	add6_opr1 <= const1_out1; add6_opr2 <= add7_out; issub6 <= 0;
	add5_opr1 <= mm0_out1; add5_opr2 <= add2_out; issub5 <= 1;
	add2_opr1 <= mm0_out2; add2_opr2 <= mid_reg_list[11]; issub2 <= 1;
	add7_opr1 <= mm0_out1; add7_opr2 <= mid_reg_list[5]; issub7 <= 1;
	add3_opr1 <= mm0_out2; add3_opr2 <= mid_reg_list[6]; issub3 <= 1;
	mm0_opr10 <= mid_reg_list[23]; mm0_opr11 <= mid_reg_list[24]; mm0_opr20 <= mid_reg_list[32]; mm0_opr21 <= mid_reg_list[33]; 
	mid_reg_list[28] <= mm0_out1_reg; 
	mid_reg_list[1] <= add0_out_reg;
	state <= state + 1;
end
14: begin
	add2_opr1 <= mid_reg_list[28]; add2_opr2 <= add6_out; issub2 <= 1;
	add1_opr1 <= mm0_out1; add1_opr2 <= add3_out; issub1 <= 1;
	add0_opr1 <= mm0_out2; add0_opr2 <= mid_reg_list[1]; issub0 <= 1;
	const0_opr1 <= add5_out; const0_opr2 <= add2_out; mode_const0 <= `MODEONE;
	add6_opr1 <= add2_out; add6_opr2 <= add0_out; issub6 <= 0;
	add7_opr1 <= mm0_out1; add7_opr2 <= mid_reg_list[13]; issub7 <= 1;
	add5_opr1 <= mm0_out2; add5_opr2 <= mid_reg_list[14]; issub5 <= 1;
	mm0_opr10 <= mid_reg_list[22]; mm0_opr11 <= mid_reg_list[17]; mm0_opr20 <= mid_reg_list[7]; mm0_opr21 <= mid_reg_list[31]; 
	mid_reg_list[2] <= add5_out_reg;
	mid_reg_list[3] <= add6_out_reg;
	state <= state + 1;
end
15: begin
	add0_opr1 <= add2_out; add0_opr2 <= add1_out; issub0 <= 1;
	add2_opr1 <= add0_out; add2_opr2 <= add0_out; issub2 <= 1;
	add5_opr1 <= reg_list[`RAM_ZERO]; add5_opr2 <= const0_out1; issub5 <= 0;
	add7_opr1 <= reg_list[`RAM_ZERO]; add7_opr2 <= const0_out2; issub7 <= 0;
	add4_opr1 <= add1_out; add4_opr2 <= add5_out; issub4 <= 1;
	add1_opr1 <= add0_out; add1_opr2 <= add2_out; issub1 <= 1;
	add3_opr1 <= add5_out; add3_opr2 <= add2_out; issub3 <= 0;
	const0_opr1 <= mm0_out1; const0_opr2 <= mm0_out2; mode_const0 <= `MODEONE;
	const1_opr1 <= mm0_out1; const1_opr2 <= mm0_out2; mode_const1 <= `MODEONE;
	mm0_opr10 <= mid_reg_list[49]; mm0_opr11 <= mid_reg_list[42]; mm0_opr20 <= mid_reg_list[50]; mm0_opr21 <= mid_reg_list[51]; 
	mid_reg_list[0] <= add0_out_reg;
	mid_reg_list[4] <= add7_out_reg;
	mid_reg_list[12] <= add3_out_reg;
	state <= state + 1;
end
16: begin
	mm0_opr10 <= mid_reg_list[44]; mm0_opr11 <= mid_reg_list[37]; mm0_opr20 <= mid_reg_list[45]; mm0_opr21 <= mid_reg_list[46]; 
	add5_opr1 <= const0_out2; add5_opr2 <= const1_out1; issub5 <= 0;
	add0_opr1 <= reg_list[`RAM_ZERO]; add0_opr2 <= const1_out2; issub0 <= 1;
	add7_opr1 <= mm0_out1; add7_opr2 <= mm0_out1; issub7 <= 1;
	add1_opr1 <= mm0_out2; add1_opr2 <= mm0_out2; issub1 <= 1;
	mid_reg_list[5] <= add2_out_reg;
	mid_reg_list[6] <= add1_out_reg;
	mid_reg_list[11] <= add0_out_reg;
	mid_reg_list[15] <= add6_out_reg;
	mid_reg_list[16] <= add7_out_reg;
	mid_reg_list[18] <= add5_out_reg;
	state <= state + 1;
end
17: begin
	add7_opr1 <= mm0_out1; add7_opr2 <= mid_reg_list[4]; issub7 <= 1;
	add6_opr1 <= mm0_out2; add6_opr2 <= mid_reg_list[12]; issub6 <= 1;
	mm0_opr10 <= mid_reg_list[47]; mm0_opr11 <= mid_reg_list[40]; mm0_opr20 <= mid_reg_list[48]; mm0_opr21 <= mid_reg_list[41]; 
	add0_opr1 <= mm0_out2; add0_opr2 <= add5_out; issub0 <= 1;
	add1_opr1 <= const0_out1; add1_opr2 <= add0_out; issub1 <= 0;
	mid_reg_list[9] <= mm0_out1_reg; 
	mid_reg_list[1] <= add0_out_reg;
	mid_reg_list[7] <= add2_out_reg;
	mid_reg_list[13] <= add5_out_reg;
	mid_reg_list[14] <= add7_out_reg;
	mid_reg_list[17] <= add4_out_reg;
	mid_reg_list[20] <= add1_out_reg;
	mid_reg_list[21] <= add3_out_reg;
	state <= state + 1;
end
18: begin
	add7_opr1 <= mm0_out1; add7_opr2 <= mid_reg_list[2]; issub7 <= 1;
	add0_opr1 <= mm0_out2; add0_opr2 <= mid_reg_list[3]; issub0 <= 1;
	const0_opr1 <= add7_out; const0_opr2 <= add6_out; mode_const0 <= `MODEONE;
	add1_opr1 <= add0_out; add1_opr2 <= mid_reg_list[20]; issub1 <= 1;
	add2_opr1 <= mid_reg_list[9]; add2_opr2 <= add1_out; issub2 <= 1;
	mid_reg_list[22] <= add7_out_reg;
	mid_reg_list[23] <= add1_out_reg;
	state <= state + 1;
end
19: begin
	const1_opr1 <= mm0_out1; const1_opr2 <= mm0_out2; mode_const1 <= `MODEONE;
	const0_opr1 <= mm0_out1; const0_opr2 <= mm0_out2; mode_const0 <= `MODEONE;
	add2_opr1 <= add2_out; add2_opr2 <= mid_reg_list[17]; issub2 <= 1;
	add6_opr1 <= add7_out; add6_opr2 <= add7_out; issub6 <= 0;
	add0_opr1 <= add6_out; add0_opr2 <= add0_out; issub0 <= 0;
	mid_reg_list[24] <= add7_out_reg;
	mid_reg_list[25] <= add6_out_reg;
	state <= state + 1;
end
20: begin
	add5_opr1 <= mm0_out1; add5_opr2 <= mid_reg_list[16]; issub5 <= 1;
	add2_opr1 <= mm0_out2; add2_opr2 <= mid_reg_list[18]; issub2 <= 1;
	add6_opr1 <= const1_out2; add6_opr2 <= const0_out1; issub6 <= 0;
	add0_opr1 <= reg_list[`RAM_ZERO]; add0_opr2 <= const0_out2; issub0 <= 1;
	const0_opr1 <= const0_out1; const0_opr2 <= const0_out2; mode_const0 <= `MODEONE;
	const1_opr1 <= const0_out1; const1_opr2 <= const0_out2; mode_const1 <= `MODEONE;
	mid_reg_list[8] <= mm0_out1_reg; mid_reg_list[10] <= mm0_out2_reg;
	mid_reg_list[4] <= add7_out_reg;
	mid_reg_list[12] <= add0_out_reg;
	mid_reg_list[26] <= add1_out_reg;
	state <= state + 1;
end
21: begin
	add1_opr1 <= mm0_out2; add1_opr2 <= add6_out; issub1 <= 1;
	add2_opr1 <= const1_out1; add2_opr2 <= add0_out; issub2 <= 0;
	add3_opr1 <= mm0_out1; add3_opr2 <= mid_reg_list[8]; issub3 <= 1;
	add0_opr1 <= mm0_out2; add0_opr2 <= mid_reg_list[10]; issub0 <= 1;
	add6_opr1 <= mid_reg_list[12]; add6_opr2 <= add2_out; issub6 <= 1;
	add5_opr1 <= const0_out2; add5_opr2 <= const1_out1; issub5 <= 0;
	add7_opr1 <= reg_list[`RAM_ZERO]; add7_opr2 <= const1_out2; issub7 <= 1;
	add4_opr1 <= add5_out; add4_opr2 <= mid_reg_list[24]; issub4 <= 1;
	const0_opr1 <= add2_out; const0_opr2 <= mid_reg_list[26]; mode_const0 <= `MODEONE;
	mid_reg_list[2] <= add6_out_reg;
	mid_reg_list[3] <= add0_out_reg;
	state <= state + 1;
end
22: begin
	add4_opr1 <= mm0_out1; add4_opr2 <= add2_out; issub4 <= 1;
	add1_opr1 <= mid_reg_list[4]; add1_opr2 <= add5_out; issub1 <= 1;
	add3_opr1 <= reg_list[`RAM_ZERO]; add3_opr2 <= add5_out; issub3 <= 0;
	add5_opr1 <= const0_out1; add5_opr2 <= add7_out; issub5 <= 0;
	add2_opr1 <= add2_out; add2_opr2 <= mid_reg_list[25]; issub2 <= 1;
	add6_opr1 <= reg_list[`RAM_ZERO]; add6_opr2 <= const0_out1; issub6 <= 0;
	add7_opr1 <= reg_list[`RAM_ZERO]; add7_opr2 <= const0_out2; issub7 <= 0;
	add0_opr1 <= add1_out; add0_opr2 <= mid_reg_list[15]; issub0 <= 1;
	const0_opr1 <= mm0_out1; const0_opr2 <= mm0_out2; mode_const0 <= `MODEONE;
	const1_opr1 <= mm0_out1; const1_opr2 <= mm0_out2; mode_const1 <= `MODEONE;
	mid_reg_list[9] <= add5_out_reg;
	mid_reg_list[17] <= add2_out_reg;
	state <= state + 1;
end
23: begin
	add3_opr1 <= mid_reg_list[4]; add3_opr2 <= add6_out; issub3 <= 1;
	add4_opr1 <= mid_reg_list[12]; add4_opr2 <= add7_out; issub4 <= 1;
	add2_opr1 <= add0_out; add2_opr2 <= mid_reg_list[11]; issub2 <= 1;
	add6_opr1 <= add4_out; add6_opr2 <= mid_reg_list[21]; issub6 <= 1;
	add1_opr1 <= const0_out2; add1_opr2 <= const1_out1; issub1 <= 0;
	add5_opr1 <= reg_list[`RAM_ZERO]; add5_opr2 <= const1_out2; issub5 <= 1;
	add7_opr1 <= mm0_out1; add7_opr2 <= mm0_out1; issub7 <= 1;
	add0_opr1 <= mm0_out2; add0_opr2 <= mm0_out2; issub0 <= 1;
	mid_reg_list[16] <= add3_out_reg;
	mid_reg_list[18] <= add0_out_reg;
	mid_reg_list[20] <= add6_out_reg;
	mid_reg_list[27] <= add4_out_reg;
	state <= state + 1;
end
24: begin
	reg_list[ret_addr + 2] <= add3_out;
	reg_list[ret_addr + 3] <= add4_out;
	reg_list[ret_addr + 9] <= add2_out;
	add1_opr1 <= add6_out; add1_opr2 <= mid_reg_list[6]; issub1 <= 1;
	add3_opr1 <= reg_list[`RAM_ZERO]; add3_opr2 <= add5_out; issub3 <= 0;
	add4_opr1 <= mm0_out2; add4_opr2 <= add1_out; issub4 <= 1;
	add2_opr1 <= const0_out1; add2_opr2 <= add5_out; issub2 <= 0;
	add5_opr1 <= mm0_out1; add5_opr2 <= mid_reg_list[22]; issub5 <= 1;
	add0_opr1 <= mm0_out2; add0_opr2 <= mid_reg_list[23]; issub0 <= 1;
	mid_reg_list[19] <= mm0_out1_reg; 
	mid_reg_list[8] <= add1_out_reg;
	mid_reg_list[10] <= add3_out_reg;
	mid_reg_list[24] <= add2_out_reg;
	state <= state + 1;
end
25: begin
	reg_list[ret_addr + 8] <= add1_out;
	add5_opr1 <= mm0_out1; add5_opr2 <= mid_reg_list[16]; issub5 <= 1;
	add2_opr1 <= mm0_out2; add2_opr2 <= mid_reg_list[18]; issub2 <= 1;
	add7_opr1 <= add4_out; add7_opr2 <= mid_reg_list[7]; issub7 <= 1;
	add6_opr1 <= add5_out; add6_opr2 <= mid_reg_list[27]; issub6 <= 1;
	add4_opr1 <= add0_out; add4_opr2 <= mid_reg_list[24]; issub4 <= 1;
	add0_opr1 <= mid_reg_list[19]; add0_opr2 <= add2_out; issub0 <= 1;
	mid_reg_list[15] <= add7_out_reg;
	mid_reg_list[25] <= add0_out_reg;
	state <= state + 1;
end
26: begin
	add4_opr1 <= add7_out; add4_opr2 <= mid_reg_list[10]; issub4 <= 0;
	add7_opr1 <= add0_out; add7_opr2 <= mid_reg_list[1]; issub7 <= 1;
	const0_opr1 <= add6_out; const0_opr2 <= add4_out; mode_const0 <= `MODEONE;
	add6_opr1 <= add5_out; add6_opr2 <= mid_reg_list[2]; issub6 <= 1;
	add0_opr1 <= add2_out; add0_opr2 <= mid_reg_list[3]; issub0 <= 1;
	add2_opr1 <= mm0_out1; add2_opr2 <= mid_reg_list[15]; issub2 <= 1;
	add5_opr1 <= mm0_out2; add5_opr2 <= mid_reg_list[25]; issub5 <= 1;
	mid_reg_list[4] <= add3_out_reg;
	state <= state + 1;
end
27: begin
	reg_list[ret_addr + 5] <= add4_out;
	add1_opr1 <= add7_out; add1_opr2 <= mid_reg_list[4]; issub1 <= 0;
	add2_opr1 <= add6_out; add2_opr2 <= mid_reg_list[9]; issub2 <= 1;
	add7_opr1 <= add0_out; add7_opr2 <= mid_reg_list[17]; issub7 <= 1;
	add6_opr1 <= add2_out; add6_opr2 <= mid_reg_list[8]; issub6 <= 1;
	add0_opr1 <= add5_out; add0_opr2 <= mid_reg_list[20]; issub0 <= 1;
	const0_opr1 <= const0_out1; const0_opr2 <= const0_out2; mode_const0 <= `MODEONE;
	const1_opr1 <= const0_out1; const1_opr2 <= const0_out2; mode_const1 <= `MODEONE;
	state <= state + 1;
end
28: begin
	reg_list[ret_addr + 4] <= add1_out;
	reg_list[ret_addr + 10] <= add2_out;
	reg_list[ret_addr + 11] <= add7_out;
	add7_opr1 <= add6_out; add7_opr2 <= mid_reg_list[13]; issub7 <= 0;
	add6_opr1 <= add0_out; add6_opr2 <= mid_reg_list[14]; issub6 <= 0;
	add1_opr1 <= const0_out2; add1_opr2 <= const1_out1; issub1 <= 0;
	add2_opr1 <= reg_list[`RAM_ZERO]; add2_opr2 <= const1_out2; issub2 <= 1;
	state <= state + 1;
end
29: begin
	reg_list[ret_addr + 6] <= add7_out;
	reg_list[ret_addr + 7] <= add6_out;
	add1_opr1 <= reg_list[`RAM_ZERO]; add1_opr2 <= add1_out; issub1 <= 0;
	add0_opr1 <= const0_out1; add0_opr2 <= add2_out; issub0 <= 0;
	state <= state + 1;
end
30: begin
	add1_opr1 <= mid_reg_list[0]; add1_opr2 <= add1_out; issub1 <= 1;
	add0_opr1 <= reg_list[`RAM_ZERO]; add0_opr2 <= add0_out; issub0 <= 0;
	state <= state + 1;
end
31: begin
	reg_list[ret_addr + 1] <= add1_out;
	add0_opr1 <= mid_reg_list[5]; add0_opr2 <= add0_out; issub0 <= 1;
	state <= state + 1;
end
32: begin
	reg_list[ret_addr + 0] <= add0_out;
	state <= state + 1;
end
33: begin
	state <= 0;
end
endcase
