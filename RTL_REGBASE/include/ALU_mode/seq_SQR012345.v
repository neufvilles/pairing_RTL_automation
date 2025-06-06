case (state)
0: begin
	const0_opr1 <= reg_list[inst_addr_opr1 + 6]; const0_opr2 <= reg_list[inst_addr_opr1 + 7]; mode_const0 <= `MODEFOUR;
	const1_opr1 <= reg_list[inst_addr_opr1 + 10]; const1_opr2 <= reg_list[inst_addr_opr1 + 11]; mode_const1 <= `MODETWO;
	mm0_opr10 <= reg_list[inst_addr_opr1 + 0]; mm0_opr11 <= reg_list[inst_addr_opr1 + 1]; mm0_opr20 <= reg_list[inst_addr_opr1 + 6]; mm0_opr21 <= reg_list[inst_addr_opr1 + 7]; 
	state <= state + 1;
end
1: begin
	mm0_opr10 <= reg_list[inst_addr_opr1 + 0]; mm0_opr11 <= reg_list[inst_addr_opr1 + 1]; mm0_opr20 <= reg_list[inst_addr_opr1 + 0]; mm0_opr21 <= reg_list[inst_addr_opr1 + 1]; 
	const1_opr1 <= reg_list[inst_addr_opr1 + 10]; const1_opr2 <= reg_list[inst_addr_opr1 + 11]; mode_const1 <= `MODEONE;
	const0_opr1 <= reg_list[inst_addr_opr1 + 6]; const0_opr2 <= reg_list[inst_addr_opr1 + 7]; mode_const0 <= `MODETWO;
	state <= state + 1;
end
2: begin
	mm0_opr10 <= reg_list[inst_addr_opr1 + 4]; mm0_opr11 <= reg_list[inst_addr_opr1 + 5]; mm0_opr20 <= reg_list[inst_addr_opr1 + 6]; mm0_opr21 <= reg_list[inst_addr_opr1 + 7]; 
	const0_opr1 <= reg_list[inst_addr_opr1 + 10]; const0_opr2 <= reg_list[inst_addr_opr1 + 11]; mode_const0 <= `MODEONE;
	add3_opr1 <= reg_list[`RAM_ZERO]; add3_opr2 <= const1_out2; issub3 <= 1;
	const1_opr1 <= reg_list[inst_addr_opr1 + 8]; const1_opr2 <= reg_list[inst_addr_opr1 + 9]; mode_const1 <= `MODESIX;
	mid_reg_list[0] <= const0_out1_reg; mid_reg_list[1] <= const0_out2_reg;
	mid_reg_list[2] <= const1_out1_reg; mid_reg_list[3] <= const1_out2_reg;
	state <= state + 1;
end
3: begin
	add0_opr1 <= const0_out1; add0_opr2 <= add3_out; issub0 <= 0;
	add5_opr1 <= const0_out2; add5_opr2 <= const1_out1; issub5 <= 0;
	const0_opr1 <= reg_list[inst_addr_opr1 + 6]; const0_opr2 <= reg_list[inst_addr_opr1 + 7]; mode_const0 <= `MODEONE;
	const1_opr1 <= reg_list[inst_addr_opr1 + 2]; const1_opr2 <= reg_list[inst_addr_opr1 + 3]; mode_const1 <= `MODETWO;
	mm0_opr10 <= reg_list[inst_addr_opr1 + 0]; mm0_opr11 <= reg_list[inst_addr_opr1 + 1]; mm0_opr20 <= reg_list[inst_addr_opr1 + 8]; mm0_opr21 <= reg_list[inst_addr_opr1 + 9]; 
	mid_reg_list[4] <= const0_out1_reg; mid_reg_list[5] <= const0_out2_reg;
	state <= state + 1;
end
4: begin
	const0_opr1 <= reg_list[inst_addr_opr1 + 8]; const0_opr2 <= reg_list[inst_addr_opr1 + 9]; mode_const0 <= `MODEONE;
	const1_opr1 <= reg_list[inst_addr_opr1 + 6]; const1_opr2 <= reg_list[inst_addr_opr1 + 7]; mode_const1 <= `MODEONE;
	mm0_opr10 <= reg_list[inst_addr_opr1 + 8]; mm0_opr11 <= reg_list[inst_addr_opr1 + 9]; mm0_opr20 <= reg_list[inst_addr_opr1 + 8]; mm0_opr21 <= reg_list[inst_addr_opr1 + 9]; 
	mid_reg_list[6] <= const1_out1_reg; mid_reg_list[7] <= const1_out2_reg;
	state <= state + 1;
end
5: begin
	const0_opr1 <= reg_list[inst_addr_opr1 + 8]; const0_opr2 <= reg_list[inst_addr_opr1 + 9]; mode_const0 <= `MODEONE;
	mm0_opr10 <= reg_list[inst_addr_opr1 + 0]; mm0_opr11 <= reg_list[inst_addr_opr1 + 1]; mm0_opr20 <= reg_list[inst_addr_opr1 + 2]; mm0_opr21 <= reg_list[inst_addr_opr1 + 3]; 
	add0_opr1 <= const0_out2; add0_opr2 <= const1_out1; issub0 <= 0;
	add5_opr1 <= reg_list[`RAM_ZERO]; add5_opr2 <= const1_out2; issub5 <= 1;
	const1_opr1 <= reg_list[inst_addr_opr1 + 4]; const1_opr2 <= reg_list[inst_addr_opr1 + 5]; mode_const1 <= `MODETWO;
	mid_reg_list[8] <= add0_out_reg;
	mid_reg_list[9] <= add5_out_reg;
	mid_reg_list[10] <= const0_out1_reg; 
	mid_reg_list[11] <= const1_out1_reg; mid_reg_list[12] <= const1_out2_reg;
	state <= state + 1;
end
6: begin
	add0_opr1 <= const0_out2; add0_opr2 <= const0_out1; issub0 <= 0;
	add3_opr1 <= reg_list[`RAM_ZERO]; add3_opr2 <= const0_out2; issub3 <= 1;
	mm0_opr10 <= mid_reg_list[6]; mm0_opr11 <= mid_reg_list[7]; mm0_opr20 <= mid_reg_list[8]; mm0_opr21 <= mid_reg_list[9]; 
	add7_opr1 <= mid_reg_list[10]; add7_opr2 <= add5_out; issub7 <= 0;
	mid_reg_list[13] <= const0_out1_reg; 
	state <= state + 1;
end
7: begin
	add0_opr1 <= mid_reg_list[13]; add0_opr2 <= add3_out; issub0 <= 0;
	mm0_opr10 <= mid_reg_list[4]; mm0_opr11 <= mid_reg_list[5]; mm0_opr20 <= add7_out; mm0_opr21 <= add0_out; 
	mid_reg_list[14] <= const1_out1_reg; mid_reg_list[15] <= const1_out2_reg;
	state <= state + 1;
end
8: begin
	mm0_opr10 <= mid_reg_list[0]; mm0_opr11 <= mid_reg_list[1]; mm0_opr20 <= add0_out; mm0_opr21 <= add0_out; 
	state <= state + 1;
end
9: begin
	const1_opr1 <= mm0_out1; const1_opr2 <= mm0_out2; mode_const1 <= `MODEFOUR;
	state <= state + 1;
end
10: begin
	const1_opr1 <= mm0_out1; const1_opr2 <= mm0_out2; mode_const1 <= `MODETWO;
	state <= state + 1;
end
11: begin
	add0_opr1 <= const1_out1; add0_opr2 <= reg_list[`RAM_ONE]; issub0 <= 1;
	add6_opr1 <= const1_out2; add6_opr2 <= reg_list[`RAM_ZERO]; issub6 <= 1;
	const0_opr1 <= mm0_out1; const0_opr2 <= mm0_out2; mode_const0 <= `MODESIX;
	mid_reg_list[0] <= const1_out1_reg; mid_reg_list[1] <= const1_out2_reg;
	state <= state + 1;
end
12: begin
	add6_opr1 <= mid_reg_list[2]; add6_opr2 <= const0_out1; issub6 <= 0;
	add0_opr1 <= mid_reg_list[3]; add0_opr2 <= const0_out2; issub0 <= 0;
	const1_opr1 <= mm0_out1; const1_opr2 <= mm0_out2; mode_const1 <= `MODEFOUR;
	state <= state + 1;
end
13: begin
	reg_list[ret_addr + 10] <= add6_out;
	reg_list[ret_addr + 11] <= add0_out;
	const0_opr1 <= mm0_out1; const0_opr2 <= mm0_out2; mode_const0 <= `MODETWO;
	mid_reg_list[4] <= add0_out_reg;
	mid_reg_list[5] <= add6_out_reg;
	state <= state + 1;
end
14: begin
	add0_opr1 <= mid_reg_list[0]; add0_opr2 <= const0_out1; issub0 <= 0;
	add6_opr1 <= mid_reg_list[1]; add6_opr2 <= const0_out2; issub6 <= 0;
	const0_opr1 <= mm0_out1; const0_opr2 <= mm0_out2; mode_const0 <= `MODESIX;
	mid_reg_list[6] <= const1_out1_reg; mid_reg_list[7] <= const1_out2_reg;
	state <= state + 1;
end
15: begin
	reg_list[ret_addr + 6] <= add0_out;
	reg_list[ret_addr + 7] <= add6_out;
	add7_opr1 <= mid_reg_list[11]; add7_opr2 <= const0_out1; issub7 <= 0;
	add0_opr1 <= mid_reg_list[12]; add0_opr2 <= const0_out2; issub0 <= 0;
	add1_opr1 <= mid_reg_list[14]; add1_opr2 <= mm0_out1; issub1 <= 0;
	add2_opr1 <= mid_reg_list[15]; add2_opr2 <= mm0_out2; issub2 <= 0;
	state <= state + 1;
end
16: begin
	reg_list[ret_addr + 2] <= add7_out;
	reg_list[ret_addr + 3] <= add0_out;
	reg_list[ret_addr + 4] <= add1_out;
	reg_list[ret_addr + 5] <= add2_out;
	add0_opr1 <= mid_reg_list[6]; add0_opr2 <= mm0_out1; issub0 <= 0;
	add6_opr1 <= mid_reg_list[7]; add6_opr2 <= mm0_out2; issub6 <= 0;
	state <= state + 1;
end
17: begin
	reg_list[ret_addr + 8] <= add0_out;
	reg_list[ret_addr + 9] <= add6_out;
	add5_opr1 <= mm0_out1; add5_opr2 <= mid_reg_list[4]; issub5 <= 0;
	add2_opr1 <= mm0_out2; add2_opr2 <= mid_reg_list[5]; issub2 <= 0;
	state <= state + 1;
end
18: begin
	reg_list[ret_addr + 0] <= add5_out;
	reg_list[ret_addr + 1] <= add2_out;
	state <= state + 1;
end
19: begin
	state <= 0;
end
endcase
