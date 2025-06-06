case (state)
0: begin
	const0_opr1 <= reg_list[inst_addr_opr1 + 2]; const0_opr2 <= reg_list[inst_addr_opr1 + 3]; mode_const0 <= `MODEONE;
	add6_opr1 <= reg_list[inst_addr_opr1 + 1]; add6_opr2 <= reg_list[inst_addr_opr1 + 3]; issub6 <= 0;
	add1_opr1 <= reg_list[inst_addr_opr1 + 4]; add1_opr2 <= reg_list[inst_addr_opr1 + 6]; issub1 <= 0;
	add3_opr1 <= reg_list[inst_addr_opr1 + 5]; add3_opr2 <= reg_list[inst_addr_opr1 + 7]; issub3 <= 0;
	mm0_opr10 <= reg_list[inst_addr_opr1 + 4]; mm0_opr11 <= reg_list[inst_addr_opr1 + 5]; mm0_opr20 <= reg_list[inst_addr_opr1 + 6]; mm0_opr21 <= reg_list[inst_addr_opr1 + 7]; 
	const1_opr1 <= reg_list[inst_addr_opr1 + 10]; const1_opr2 <= reg_list[inst_addr_opr1 + 11]; mode_const1 <= `MODEONE;
	add0_opr1 <= reg_list[inst_addr_opr1 + 8]; add0_opr2 <= reg_list[inst_addr_opr1 + 10]; issub0 <= 0;
	add7_opr1 <= reg_list[inst_addr_opr1 + 0]; add7_opr2 <= reg_list[inst_addr_opr1 + 4]; issub7 <= 0;
	add5_opr1 <= reg_list[inst_addr_opr1 + 1]; add5_opr2 <= reg_list[inst_addr_opr1 + 5]; issub5 <= 0;
	add2_opr1 <= reg_list[inst_addr_opr1 + 7]; add2_opr2 <= reg_list[inst_addr_opr1 + 11]; issub2 <= 0;
	add4_opr1 <= reg_list[inst_addr_opr1 + 9]; add4_opr2 <= reg_list[inst_addr_opr1 + 1]; issub4 <= 0;
	state <= state + 1;
end
1: begin
	add1_opr1 <= reg_list[inst_addr_opr1 + 0]; add1_opr2 <= reg_list[inst_addr_opr1 + 2]; issub1 <= 0;
	mm0_opr10 <= reg_list[inst_addr_opr1 + 0]; mm0_opr11 <= reg_list[inst_addr_opr1 + 1]; mm0_opr20 <= reg_list[inst_addr_opr1 + 2]; mm0_opr21 <= reg_list[inst_addr_opr1 + 3]; 
	const1_opr1 <= reg_list[inst_addr_opr1 + 6]; const1_opr2 <= reg_list[inst_addr_opr1 + 7]; mode_const1 <= `MODEONE;
	const0_opr1 <= reg_list[inst_addr_opr1 + 10]; const0_opr2 <= reg_list[inst_addr_opr1 + 11]; mode_const0 <= `MODEONE;
	add3_opr1 <= reg_list[inst_addr_opr1 + 9]; add3_opr2 <= reg_list[inst_addr_opr1 + 11]; issub3 <= 0;
	add2_opr1 <= reg_list[inst_addr_opr1 + 2]; add2_opr2 <= reg_list[inst_addr_opr1 + 6]; issub2 <= 0;
	add7_opr1 <= reg_list[inst_addr_opr1 + 3]; add7_opr2 <= reg_list[inst_addr_opr1 + 7]; issub7 <= 0;
	add6_opr1 <= reg_list[inst_addr_opr1 + 6]; add6_opr2 <= reg_list[inst_addr_opr1 + 10]; issub6 <= 0;
	add4_opr1 <= reg_list[inst_addr_opr1 + 8]; add4_opr2 <= reg_list[inst_addr_opr1 + 0]; issub4 <= 0;
	add0_opr1 <= reg_list[inst_addr_opr1 + 10]; add0_opr2 <= reg_list[inst_addr_opr1 + 2]; issub0 <= 0;
	add5_opr1 <= reg_list[inst_addr_opr1 + 11]; add5_opr2 <= reg_list[inst_addr_opr1 + 3]; issub5 <= 0;
	state <= state + 1;
end
2: begin
	const1_opr1 <= reg_list[inst_addr_opr1 + 2]; const1_opr2 <= reg_list[inst_addr_opr1 + 3]; mode_const1 <= `MODEONE;
	const0_opr1 <= reg_list[inst_addr_opr1 + 6]; const0_opr2 <= reg_list[inst_addr_opr1 + 7]; mode_const0 <= `MODEONE;
	add2_opr1 <= reg_list[`RAM_ZERO]; add2_opr2 <= const1_out2; issub2 <= 1;
	add4_opr1 <= const1_out2; add4_opr2 <= const0_out1; issub4 <= 0;
	add6_opr1 <= reg_list[`RAM_ZERO]; add6_opr2 <= const0_out2; issub6 <= 1;
	mm0_opr10 <= reg_list[inst_addr_opr1 + 8]; mm0_opr11 <= reg_list[inst_addr_opr1 + 9]; mm0_opr20 <= reg_list[inst_addr_opr1 + 10]; mm0_opr21 <= reg_list[inst_addr_opr1 + 11]; 
	add7_opr1 <= add7_out; add7_opr2 <= add2_out; issub7 <= 0;
	add0_opr1 <= add5_out; add0_opr2 <= add7_out; issub0 <= 0;
	add5_opr1 <= reg_list[inst_addr_opr1 + 4]; add5_opr2 <= reg_list[inst_addr_opr1 + 8]; issub5 <= 0;
	add1_opr1 <= reg_list[inst_addr_opr1 + 5]; add1_opr2 <= reg_list[inst_addr_opr1 + 9]; issub1 <= 0;
	add3_opr1 <= add4_out; add3_opr2 <= add5_out; issub3 <= 0;
	mid_reg_list[0] <= const0_out1_reg; mid_reg_list[1] <= const0_out2_reg;
	mid_reg_list[2] <= add6_out_reg;
	mid_reg_list[3] <= add1_out_reg;
	mid_reg_list[4] <= add3_out_reg;
	mid_reg_list[7] <= const1_out1_reg; 
	mid_reg_list[8] <= add0_out_reg;
	mid_reg_list[9] <= add7_out_reg;
	mid_reg_list[10] <= add5_out_reg;
	mid_reg_list[11] <= add2_out_reg;
	mid_reg_list[12] <= add4_out_reg;
	state <= state + 1;
end
3: begin
	add5_opr1 <= mid_reg_list[1]; add5_opr2 <= const1_out1; issub5 <= 0;
	add4_opr1 <= reg_list[`RAM_ZERO]; add4_opr2 <= const1_out2; issub4 <= 1;
	add7_opr1 <= const0_out1; add7_opr2 <= add2_out; issub7 <= 0;
	add6_opr1 <= const0_out2; add6_opr2 <= const1_out1; issub6 <= 0;
	add0_opr1 <= mid_reg_list[7]; add0_opr2 <= add6_out; issub0 <= 0;
	add1_opr1 <= reg_list[inst_addr_opr1 + 9]; add1_opr2 <= add4_out; issub1 <= 0;
	const1_opr1 <= add2_out; const1_opr2 <= add7_out; mode_const1 <= `MODEONE;
	const0_opr1 <= add2_out; const0_opr2 <= add7_out; mode_const0 <= `MODEONE;
	add3_opr1 <= add5_out; add3_opr2 <= add6_out; issub3 <= 0;
	add2_opr1 <= add1_out; add2_opr2 <= mid_reg_list[11]; issub2 <= 0;
	mm0_opr10 <= add4_out; mm0_opr11 <= mid_reg_list[12]; mm0_opr20 <= add0_out; mm0_opr21 <= add5_out; 
	mid_reg_list[13] <= add1_out_reg;
	mid_reg_list[16] <= add3_out_reg;
	mid_reg_list[17] <= add2_out_reg;
	mid_reg_list[18] <= add7_out_reg;
	mid_reg_list[19] <= add6_out_reg;
	mid_reg_list[20] <= add4_out_reg;
	mid_reg_list[21] <= add0_out_reg;
	mid_reg_list[22] <= add5_out_reg;
	state <= state + 1;
end
4: begin
	add2_opr1 <= mid_reg_list[0]; add2_opr2 <= add4_out; issub2 <= 0;
	add1_opr1 <= reg_list[inst_addr_opr1 + 1]; add1_opr2 <= add5_out; issub1 <= 0;
	add5_opr1 <= reg_list[inst_addr_opr1 + 4]; add5_opr2 <= add7_out; issub5 <= 0;
	add0_opr1 <= reg_list[inst_addr_opr1 + 5]; add0_opr2 <= add6_out; issub0 <= 0;
	add4_opr1 <= reg_list[inst_addr_opr1 + 8]; add4_opr2 <= add0_out; issub4 <= 0;
	add3_opr1 <= const1_out2; add3_opr2 <= const0_out1; issub3 <= 0;
	add6_opr1 <= reg_list[`RAM_ZERO]; add6_opr2 <= const0_out2; issub6 <= 1;
	const1_opr1 <= mid_reg_list[19]; const1_opr2 <= mid_reg_list[11]; mode_const1 <= `MODEONE;
	mm0_opr10 <= add5_out; mm0_opr11 <= add1_out; mm0_opr20 <= mid_reg_list[19]; mm0_opr21 <= mid_reg_list[11]; 
	const0_opr1 <= mid_reg_list[21]; const0_opr2 <= mid_reg_list[22]; mode_const0 <= `MODEONE;
	add7_opr1 <= mid_reg_list[20]; add7_opr2 <= mid_reg_list[21]; issub7 <= 0;
	mid_reg_list[25] <= add7_out_reg;
	mid_reg_list[26] <= add0_out_reg;
	mid_reg_list[27] <= add5_out_reg;
	mid_reg_list[28] <= add1_out_reg;
	mid_reg_list[29] <= add3_out_reg;
	state <= state + 1;
end
5: begin
	add3_opr1 <= reg_list[inst_addr_opr1 + 0]; add3_opr2 <= add2_out; issub3 <= 0;
	add6_opr1 <= const1_out1; add6_opr2 <= add6_out; issub6 <= 0;
	add2_opr1 <= mid_reg_list[10]; add2_opr2 <= add3_out; issub2 <= 0;
	mm0_opr10 <= mid_reg_list[9]; mm0_opr11 <= mid_reg_list[10]; mm0_opr20 <= mid_reg_list[17]; mm0_opr21 <= mid_reg_list[18]; 
	const0_opr1 <= mid_reg_list[19]; const0_opr2 <= mid_reg_list[11]; mode_const0 <= `MODEONE;
	add1_opr1 <= reg_list[`RAM_ZERO]; add1_opr2 <= const1_out2; issub1 <= 1;
	const1_opr1 <= mid_reg_list[21]; const1_opr2 <= mid_reg_list[22]; mode_const1 <= `MODEONE;
	add0_opr1 <= reg_list[`RAM_ZERO]; add0_opr2 <= const0_out2; issub0 <= 1;
	mid_reg_list[30] <= add1_out_reg;
	mid_reg_list[31] <= add3_out_reg;
	mid_reg_list[32] <= add2_out_reg;
	state <= state + 1;
end
6: begin
	mm0_opr10 <= add3_out; mm0_opr11 <= add1_out; mm0_opr20 <= mid_reg_list[13]; mm0_opr21 <= mid_reg_list[2]; 
	add7_opr1 <= mid_reg_list[9]; add7_opr2 <= add6_out; issub7 <= 0;
	add2_opr1 <= const0_out1; add2_opr2 <= add1_out; issub2 <= 0;
	add6_opr1 <= const0_out2; add6_opr2 <= const1_out1; issub6 <= 0;
	add1_opr1 <= const1_out1; add1_opr2 <= add0_out; issub1 <= 0;
	add0_opr1 <= const1_out2; add0_opr2 <= const0_out1; issub0 <= 0;
	mid_reg_list[7] <= add5_out_reg;
	mid_reg_list[35] <= add0_out_reg;
	mid_reg_list[36] <= add4_out_reg;
	mid_reg_list[39] <= add7_out_reg;
	state <= state + 1;
end
7: begin
	mm0_opr10 <= mid_reg_list[36]; mm0_opr11 <= mid_reg_list[30]; mm0_opr20 <= mid_reg_list[8]; mm0_opr21 <= mid_reg_list[16]; 
	add0_opr1 <= mid_reg_list[27]; add0_opr2 <= add2_out; issub0 <= 0;
	add3_opr1 <= mid_reg_list[28]; add3_opr2 <= add6_out; issub3 <= 0;
	add5_opr1 <= mid_reg_list[20]; add5_opr2 <= add1_out; issub5 <= 0;
	add4_opr1 <= mid_reg_list[12]; add4_opr2 <= add0_out; issub4 <= 0;
	mid_reg_list[0] <= add2_out_reg;
	state <= state + 1;
end
8: begin
	mm0_opr10 <= mid_reg_list[7]; mm0_opr11 <= mid_reg_list[35]; mm0_opr20 <= mid_reg_list[3]; mm0_opr21 <= mid_reg_list[4]; 
	mid_reg_list[11] <= add7_out_reg;
	state <= state + 1;
end
9: begin
	add7_opr1 <= mm0_out1; add7_opr2 <= mm0_out1; issub7 <= 0;
	add0_opr1 <= mm0_out2; add0_opr2 <= mm0_out2; issub0 <= 0;
	const0_opr1 <= mm0_out1; const0_opr2 <= mm0_out2; mode_const0 <= `MODEONE;
	const1_opr1 <= mm0_out1; const1_opr2 <= mm0_out2; mode_const1 <= `MODEONE;
	mm0_opr10 <= add5_out; mm0_opr11 <= add4_out; mm0_opr20 <= mid_reg_list[39]; mm0_opr21 <= mid_reg_list[29]; 
	mid_reg_list[9] <= add0_out_reg;
	mid_reg_list[13] <= add3_out_reg;
	state <= state + 1;
end
10: begin
	add1_opr1 <= mm0_out1; add1_opr2 <= mm0_out1; issub1 <= 0;
	add2_opr1 <= mm0_out2; add2_opr2 <= mm0_out2; issub2 <= 0;
	const0_opr1 <= mm0_out1; const0_opr2 <= mm0_out2; mode_const0 <= `MODEONE;
	const1_opr1 <= mm0_out1; const1_opr2 <= mm0_out2; mode_const1 <= `MODEONE;
	add0_opr1 <= const0_out2; add0_opr2 <= const1_out1; issub0 <= 0;
	add7_opr1 <= reg_list[`RAM_ZERO]; add7_opr2 <= const1_out2; issub7 <= 1;
	mm0_opr10 <= mid_reg_list[9]; mm0_opr11 <= mid_reg_list[13]; mm0_opr20 <= mid_reg_list[31]; mm0_opr21 <= mid_reg_list[32]; 
	mid_reg_list[5] <= mm0_out1_reg; mid_reg_list[6] <= mm0_out2_reg;
	state <= state + 1;
end
11: begin
	add1_opr1 <= const0_out2; add1_opr2 <= const1_out1; issub1 <= 0;
	add2_opr1 <= reg_list[`RAM_ZERO]; add2_opr2 <= const1_out2; issub2 <= 1;
	add7_opr1 <= const0_out1; add7_opr2 <= add7_out; issub7 <= 0;
	add5_opr1 <= mid_reg_list[6]; add5_opr2 <= add0_out; issub5 <= 0;
	add3_opr1 <= mm0_out1; add3_opr2 <= mm0_out1; issub3 <= 0;
	add4_opr1 <= mm0_out2; add4_opr2 <= mm0_out2; issub4 <= 0;
	const1_opr1 <= mm0_out1; const1_opr2 <= mm0_out2; mode_const1 <= `MODEONE;
	const0_opr1 <= mm0_out1; const0_opr2 <= mm0_out2; mode_const0 <= `MODEONE;
	mm0_opr10 <= mid_reg_list[11]; mm0_opr11 <= mid_reg_list[0]; mm0_opr20 <= mid_reg_list[25]; mm0_opr21 <= mid_reg_list[26]; 
	add6_opr1 <= add1_out; add6_opr2 <= add7_out; issub6 <= 0;
	add0_opr1 <= add2_out; add0_opr2 <= add0_out; issub0 <= 0;
	mid_reg_list[14] <= mm0_out1_reg; mid_reg_list[15] <= mm0_out2_reg;
	mid_reg_list[3] <= add7_out_reg;
	mid_reg_list[4] <= add0_out_reg;
	state <= state + 1;
end
12: begin
	add4_opr1 <= mid_reg_list[3]; add4_opr2 <= add3_out; issub4 <= 0;
	add3_opr1 <= mid_reg_list[4]; add3_opr2 <= add4_out; issub3 <= 0;
	add2_opr1 <= add3_out; add2_opr2 <= add1_out; issub2 <= 0;
	add7_opr1 <= add4_out; add7_opr2 <= add2_out; issub7 <= 0;
	const0_opr1 <= add3_out; const0_opr2 <= add4_out; mode_const0 <= `MODEONE;
	add5_opr1 <= const1_out2; add5_opr2 <= const0_out1; issub5 <= 0;
	add6_opr1 <= reg_list[`RAM_ZERO]; add6_opr2 <= const0_out2; issub6 <= 1;
	add1_opr1 <= mm0_out1; add1_opr2 <= mm0_out1; issub1 <= 0;
	add0_opr1 <= mm0_out2; add0_opr2 <= mm0_out2; issub0 <= 0;
	const1_opr1 <= mm0_out1; const1_opr2 <= mm0_out2; mode_const1 <= `MODEONE;
	mid_reg_list[23] <= mm0_out1_reg; mid_reg_list[24] <= mm0_out2_reg;
	mid_reg_list[7] <= add1_out_reg;
	mid_reg_list[8] <= add2_out_reg;
	mid_reg_list[12] <= const0_out1_reg; 
	state <= state + 1;
end
13: begin
	add2_opr1 <= mid_reg_list[12]; add2_opr2 <= add2_out; issub2 <= 0;
	add5_opr1 <= add1_out; add5_opr2 <= add2_out; issub5 <= 1;
	add1_opr1 <= mid_reg_list[5]; add1_opr2 <= add7_out; issub1 <= 0;
	add4_opr1 <= const1_out1; add4_opr2 <= add6_out; issub4 <= 0;
	add6_opr1 <= mid_reg_list[24]; add6_opr2 <= add5_out; issub6 <= 0;
	add3_opr1 <= mm0_out1; add3_opr2 <= mm0_out1; issub3 <= 0;
	add7_opr1 <= mm0_out2; add7_opr2 <= mm0_out2; issub7 <= 0;
	const1_opr1 <= mm0_out1; const1_opr2 <= mm0_out2; mode_const1 <= `MODEONE;
	const0_opr1 <= mm0_out1; const0_opr2 <= mm0_out2; mode_const0 <= `MODEONE;
	add0_opr1 <= reg_list[`RAM_ZERO]; add0_opr2 <= const1_out2; issub0 <= 1;
	mid_reg_list[33] <= mm0_out1_reg; mid_reg_list[34] <= mm0_out2_reg;
	mid_reg_list[9] <= add1_out_reg;
	mid_reg_list[13] <= add5_out_reg;
	mid_reg_list[16] <= add6_out_reg;
	mid_reg_list[17] <= add0_out_reg;
	state <= state + 1;
end
14: begin
	add4_opr1 <= mid_reg_list[14]; add4_opr2 <= add2_out; issub4 <= 0;
	add6_opr1 <= add3_out; add6_opr2 <= add4_out; issub6 <= 1;
	add7_opr1 <= add0_out; add7_opr2 <= add7_out; issub7 <= 1;
	add1_opr1 <= mid_reg_list[23]; add1_opr2 <= add4_out; issub1 <= 0;
	add0_opr1 <= mm0_out1; add0_opr2 <= mm0_out1; issub0 <= 0;
	add5_opr1 <= mm0_out2; add5_opr2 <= mm0_out2; issub5 <= 0;
	const1_opr1 <= mm0_out1; const1_opr2 <= mm0_out2; mode_const1 <= `MODEONE;
	const0_opr1 <= mm0_out1; const0_opr2 <= mm0_out2; mode_const0 <= `MODEONE;
	add2_opr1 <= const0_out1; add2_opr2 <= add0_out; issub2 <= 0;
	add3_opr1 <= const0_out2; add3_opr2 <= const1_out1; issub3 <= 0;
	mid_reg_list[37] <= mm0_out1_reg; mid_reg_list[38] <= mm0_out2_reg;
	mid_reg_list[0] <= add3_out_reg;
	mid_reg_list[11] <= const0_out1_reg; mid_reg_list[18] <= const0_out2_reg;
	state <= state + 1;
end
15: begin
	add2_opr1 <= mid_reg_list[3]; add2_opr2 <= add5_out; issub2 <= 0;
	add1_opr1 <= mid_reg_list[4]; add1_opr2 <= add7_out; issub1 <= 0;
	add4_opr1 <= mm0_out1; add4_opr2 <= add4_out; issub4 <= 1;
	add7_opr1 <= mid_reg_list[15]; add7_opr2 <= mid_reg_list[9]; issub7 <= 0;
	add6_opr1 <= add0_out; add6_opr2 <= mid_reg_list[16]; issub6 <= 1;
	add0_opr1 <= add7_out; add0_opr2 <= mid_reg_list[0]; issub0 <= 1;
	const1_opr1 <= mid_reg_list[11]; const1_opr2 <= mid_reg_list[18]; mode_const1 <= `MODEONE;
	add5_opr1 <= reg_list[`RAM_ZERO]; add5_opr2 <= const0_out2; issub5 <= 1;
	const0_opr1 <= mid_reg_list[37]; const0_opr2 <= mid_reg_list[38]; mode_const0 <= `MODEONE;
	add3_opr1 <= mid_reg_list[33]; add3_opr2 <= add2_out; issub3 <= 0;
	mid_reg_list[1] <= mm0_out1_reg; mid_reg_list[40] <= mm0_out2_reg;
	mid_reg_list[19] <= add1_out_reg;
	mid_reg_list[20] <= add6_out_reg;
	mid_reg_list[21] <= const1_out1_reg; mid_reg_list[22] <= const1_out2_reg;
	state <= state + 1;
end
16: begin
	reg_list[ret_addr + 10] <= add2_out;
	reg_list[ret_addr + 11] <= add1_out;
	add7_opr1 <= add5_out; add7_opr2 <= mid_reg_list[17]; issub7 <= 1;
	const1_opr1 <= add6_out; const1_opr2 <= add0_out; mode_const1 <= `MODEONE;
	const0_opr1 <= mid_reg_list[11]; const0_opr2 <= mid_reg_list[18]; mode_const0 <= `MODEONE;
	add0_opr1 <= reg_list[`RAM_ZERO]; add0_opr2 <= const1_out2; issub0 <= 1;
	add3_opr1 <= mm0_out2; add3_opr2 <= mid_reg_list[20]; issub3 <= 1;
	add2_opr1 <= const1_out1; add2_opr2 <= add5_out; issub2 <= 0;
	add5_opr1 <= const1_out2; add5_opr2 <= const0_out1; issub5 <= 0;
	add4_opr1 <= mid_reg_list[22]; add4_opr2 <= const0_out1; issub4 <= 0;
	add1_opr1 <= reg_list[`RAM_ZERO]; add1_opr2 <= const0_out2; issub1 <= 1;
	add6_opr1 <= mid_reg_list[34]; add6_opr2 <= add3_out; issub6 <= 0;
	mid_reg_list[10] <= mm0_out2_reg;
	mid_reg_list[5] <= add1_out_reg;
	state <= state + 1;
end
17: begin
	add5_opr1 <= mid_reg_list[10]; add5_opr2 <= add7_out; issub5 <= 1;
	add6_opr1 <= mm0_out1; add6_opr2 <= mid_reg_list[19]; issub6 <= 1;
	add0_opr1 <= mm0_out2; add0_opr2 <= mid_reg_list[13]; issub0 <= 1;
	const0_opr1 <= const1_out1; const0_opr2 <= const1_out2; mode_const0 <= `MODEONE;
	const1_opr1 <= const1_out1; const1_opr2 <= const1_out2; mode_const1 <= `MODEONE;
	add2_opr1 <= const0_out1; add2_opr2 <= add0_out; issub2 <= 0;
	add4_opr1 <= const0_out2; add4_opr2 <= const1_out1; issub4 <= 0;
	add7_opr1 <= mid_reg_list[1]; add7_opr2 <= add2_out; issub7 <= 0;
	add1_opr1 <= mid_reg_list[21]; add1_opr2 <= add1_out; issub1 <= 0;
	add3_opr1 <= mid_reg_list[38]; add3_opr2 <= add4_out; issub3 <= 0;
	mid_reg_list[2] <= mm0_out1_reg; 
	mid_reg_list[6] <= add4_out_reg;
	mid_reg_list[12] <= add6_out_reg;
	mid_reg_list[14] <= add3_out_reg;
	state <= state + 1;
end
18: begin
	add4_opr1 <= add0_out; add4_opr2 <= add3_out; issub4 <= 0;
	add6_opr1 <= const0_out2; add6_opr2 <= const1_out1; issub6 <= 0;
	add5_opr1 <= reg_list[`RAM_ZERO]; add5_opr2 <= add4_out; issub5 <= 0;
	add2_opr1 <= mid_reg_list[2]; add2_opr2 <= mid_reg_list[5]; issub2 <= 1;
	add0_opr1 <= mid_reg_list[40]; add0_opr2 <= add5_out; issub0 <= 0;
	add3_opr1 <= mid_reg_list[37]; add3_opr2 <= add1_out; issub3 <= 0;
	add7_opr1 <= mm0_out1; add7_opr2 <= mid_reg_list[14]; issub7 <= 1;
	add1_opr1 <= mm0_out2; add1_opr2 <= add6_out; issub1 <= 1;
	mid_reg_list[0] <= add7_out_reg;
	mid_reg_list[3] <= add3_out_reg;
	state <= state + 1;
end
19: begin
	add0_opr1 <= add6_out; add0_opr2 <= add2_out; issub0 <= 0;
	add6_opr1 <= add2_out; add6_opr2 <= mid_reg_list[6]; issub6 <= 0;
	add7_opr1 <= mid_reg_list[3]; add7_opr2 <= add5_out; issub7 <= 0;
	add3_opr1 <= reg_list[`RAM_ZERO]; add3_opr2 <= add6_out; issub3 <= 0;
	add4_opr1 <= reg_list[`RAM_ZERO]; add4_opr2 <= const1_out2; issub4 <= 1;
	const0_opr1 <= add2_out; const0_opr2 <= mid_reg_list[3]; mode_const0 <= `MODEONE;
	add1_opr1 <= mm0_out1; add1_opr2 <= add3_out; issub1 <= 1;
	add2_opr1 <= mm0_out2; add2_opr2 <= add3_out; issub2 <= 1;
	add5_opr1 <= mid_reg_list[6]; add5_opr2 <= add6_out; issub5 <= 0;
	mid_reg_list[4] <= add5_out_reg;
	mid_reg_list[9] <= add6_out_reg;
	mid_reg_list[10] <= add0_out_reg;
	mid_reg_list[11] <= const0_out1_reg; 
	mid_reg_list[15] <= add2_out_reg;
	mid_reg_list[16] <= add7_out_reg;
	state <= state + 1;
end
20: begin
	add5_opr1 <= mid_reg_list[4]; add5_opr2 <= add3_out; issub5 <= 0;
	add0_opr1 <= add1_out; add0_opr2 <= add0_out; issub0 <= 1;
	add2_opr1 <= add2_out; add2_opr2 <= add4_out; issub2 <= 1;
	add3_opr1 <= add1_out; add3_opr2 <= add7_out; issub3 <= 1;
	add7_opr1 <= mid_reg_list[11]; add7_opr2 <= add4_out; issub7 <= 0;
	add4_opr1 <= mm0_out1; add4_opr2 <= mid_reg_list[16]; issub4 <= 1;
	add1_opr1 <= mm0_out2; add1_opr2 <= add0_out; issub1 <= 1;
	add6_opr1 <= mid_reg_list[4]; add6_opr2 <= mid_reg_list[10]; issub6 <= 0;
	mid_reg_list[1] <= add5_out_reg;
	mid_reg_list[13] <= add7_out_reg;
	state <= state + 1;
end
21: begin
	reg_list[ret_addr + 1] <= add5_out;
	add7_opr1 <= mid_reg_list[10]; add7_opr2 <= add3_out; issub7 <= 0;
	add2_opr1 <= add4_out; add2_opr2 <= add5_out; issub2 <= 1;
	add6_opr1 <= add1_out; add6_opr2 <= add6_out; issub6 <= 1;
	add5_opr1 <= mid_reg_list[13]; add5_opr2 <= add6_out; issub5 <= 1;
	add1_opr1 <= reg_list[`RAM_ZERO]; add1_opr2 <= add7_out; issub1 <= 0;
	const0_opr1 <= add0_out; const0_opr2 <= add2_out; mode_const0 <= `MODEONE;
	add3_opr1 <= reg_list[`RAM_ZERO]; add3_opr2 <= mid_reg_list[15]; issub3 <= 0;
	add0_opr1 <= reg_list[`RAM_ZERO]; add0_opr2 <= const0_out1; issub0 <= 0;
	add4_opr1 <= reg_list[`RAM_ZERO]; add4_opr2 <= const0_out2; issub4 <= 0;
	state <= state + 1;
end
22: begin
	reg_list[ret_addr + 9] <= add7_out;
	add4_opr1 <= mid_reg_list[6]; add4_opr2 <= add1_out; issub4 <= 0;
	add7_opr1 <= add2_out; add7_opr2 <= add3_out; issub7 <= 0;
	add3_opr1 <= add6_out; add3_opr2 <= mid_reg_list[1]; issub3 <= 0;
	add5_opr1 <= mid_reg_list[12]; add5_opr2 <= add0_out; issub5 <= 0;
	add0_opr1 <= mid_reg_list[0]; add0_opr2 <= add4_out; issub0 <= 0;
	add1_opr1 <= mid_reg_list[9]; add1_opr2 <= add5_out; issub1 <= 0;
	add2_opr1 <= reg_list[`RAM_ZERO]; add2_opr2 <= const0_out1; issub2 <= 0;
	add6_opr1 <= reg_list[`RAM_ZERO]; add6_opr2 <= const0_out2; issub6 <= 0;
	state <= state + 1;
end
23: begin
	reg_list[ret_addr + 0] <= add4_out;
	reg_list[ret_addr + 4] <= add7_out;
	reg_list[ret_addr + 5] <= add3_out;
	reg_list[ret_addr + 6] <= add5_out;
	reg_list[ret_addr + 7] <= add0_out;
	reg_list[ret_addr + 8] <= add1_out;
	add0_opr1 <= mid_reg_list[7]; add0_opr2 <= add2_out; issub0 <= 0;
	add7_opr1 <= mid_reg_list[8]; add7_opr2 <= add6_out; issub7 <= 0;
	state <= state + 1;
end
24: begin
	reg_list[ret_addr + 2] <= add0_out;
	reg_list[ret_addr + 3] <= add7_out;
	state <= state + 1;
end
25: begin
	state <= 0;
end
endcase
