case (state)
0: begin
	mm0_opr10 <= reg_list[`RAM_TY0]; mm0_opr11 <= reg_list[`RAM_TY1]; mm0_opr20 <= reg_list[`RAM_TZ0]; mm0_opr21 <= reg_list[`RAM_TZ1]; 
	state <= state + 1;
end
1: begin
	mm0_opr10 <= reg_list[`RAM_TX0]; mm0_opr11 <= reg_list[`RAM_TX1]; mm0_opr20 <= reg_list[`RAM_TX0]; mm0_opr21 <= reg_list[`RAM_TX1]; 
	state <= state + 1;
end
2: begin
	mm0_opr10 <= reg_list[`RAM_TY0]; mm0_opr11 <= reg_list[`RAM_TY1]; mm0_opr20 <= reg_list[`RAM_TY0]; mm0_opr21 <= reg_list[`RAM_TY1]; 
	state <= state + 1;
end
3: begin
	mm0_opr10 <= reg_list[`RAM_TZ0]; mm0_opr11 <= reg_list[`RAM_TZ1]; mm0_opr20 <= reg_list[`RAM_TZ0]; mm0_opr21 <= reg_list[`RAM_TZ1]; 
	state <= state + 1;
end
4: begin
	mm0_opr10 <= reg_list[`RAM_TX0]; mm0_opr11 <= reg_list[`RAM_TX1]; mm0_opr20 <= reg_list[`RAM_TY0]; mm0_opr21 <= reg_list[`RAM_TY1]; 
	state <= state + 1;
end
5: begin
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
	const0_opr1 <= mm0_out1; const0_opr2 <= mm0_out2; mode_const0 <= `MODETWO;
	state <= state + 1;
end
10: begin
	mm0_opr10 <= const0_out1; mm0_opr11 <= const0_out2; mm0_opr20 <= reg_list[`RAM_PY]; mm0_opr21 <= reg_list[`RAM_ZERO]; 
	const0_opr1 <= mm0_out1; const0_opr2 <= mm0_out2; mode_const0 <= `MODETHREE;
	state <= state + 1;
end
11: begin
	mm0_opr10 <= mm0_out1; mm0_opr11 <= mm0_out2; mm0_opr20 <= const0_out1; mm0_opr21 <= const0_out2; 
	state <= state + 1;
end
12: begin
	mm0_opr10 <= reg_list[`RAM_BT0]; mm0_opr11 <= reg_list[`RAM_BT1]; mm0_opr20 <= mm0_out1; mm0_opr21 <= mm0_out2; 
	mid_reg_list[0] <= mm0_out1_reg; mid_reg_list[1] <= mm0_out2_reg;
	mid_reg_list[2] <= const0_out1_reg; mid_reg_list[3] <= const0_out2_reg;
	state <= state + 1;
end
13: begin
	mm0_opr10 <= mid_reg_list[2]; mm0_opr11 <= mid_reg_list[3]; mm0_opr20 <= reg_list[`RAM_PX_]; mm0_opr21 <= reg_list[`RAM_ZERO]; 
	const0_opr1 <= mm0_out1; const0_opr2 <= mm0_out2; mode_const0 <= `MODETWO;
	state <= state + 1;
end
14: begin
	mm0_opr10 <= mid_reg_list[0]; mm0_opr11 <= mid_reg_list[1]; mm0_opr20 <= mid_reg_list[0]; mm0_opr21 <= mid_reg_list[1]; 
	state <= state + 1;
end
15: begin
	mid_reg_list[4] <= const0_out1_reg; mid_reg_list[5] <= const0_out2_reg;
	state <= state + 1;
end
16: begin
	state <= state + 1;
end
17: begin
	state <= state + 1;
end
18: begin
	state <= state + 1;
end
19: begin
	reg_list[ret_addr + 2] <= mm0_out1;
	reg_list[ret_addr + 3] <= mm0_out2;
	state <= state + 1;
end
20: begin
	const0_opr1 <= mm0_out1; const0_opr2 <= mm0_out2; mode_const0 <= `MODEFOUR;
	state <= state + 1;
end
21: begin
	reg_list[`RAM_TZ0] <= const0_out1;
	reg_list[`RAM_TZ1] <= const0_out2;
	const0_opr1 <= mm0_out1; const0_opr2 <= mm0_out2; mode_const0 <= `MODETHREE;
	state <= state + 1;
end
22: begin
	reg_list[ret_addr + 8] <= mm0_out1;
	reg_list[ret_addr + 9] <= mm0_out2;
	add0_opr1 <= mid_reg_list[0]; add0_opr2 <= const0_out1; issub0 <= 1;
	add5_opr1 <= mid_reg_list[1]; add5_opr2 <= const0_out2; issub5 <= 1;
	const0_opr1 <= const0_out1; const0_opr2 <= const0_out2; mode_const0 <= `MODETWO;
	state <= state + 1;
end
23: begin
	reg_list[ret_addr + 0] <= add0_out;
	reg_list[ret_addr + 1] <= add5_out;
	add3_opr1 <= const0_out1; add3_opr2 <= const0_out1; issub3 <= 0;
	add6_opr1 <= const0_out2; add6_opr2 <= const0_out2; issub6 <= 0;
	add2_opr1 <= add0_out; add2_opr2 <= const0_out1; issub2 <= 1;
	add0_opr1 <= add5_out; add0_opr2 <= const0_out2; issub0 <= 1;
	add7_opr1 <= mid_reg_list[0]; add7_opr2 <= add0_out; issub7 <= 0;
	add1_opr1 <= mid_reg_list[1]; add1_opr2 <= add5_out; issub1 <= 0;
	state <= state + 1;
end
24: begin
	mm0_opr10 <= add3_out; mm0_opr11 <= add6_out; mm0_opr20 <= add7_out; mm0_opr21 <= add1_out; 
	mid_reg_list[2] <= mm0_out1_reg; mid_reg_list[3] <= mm0_out2_reg;
	state <= state + 1;
end
25: begin
	mm0_opr10 <= add2_out; mm0_opr11 <= add0_out; mm0_opr20 <= mid_reg_list[4]; mm0_opr21 <= mid_reg_list[5]; 
	state <= state + 1;
end
26: begin
	state <= state + 1;
end
27: begin
	state <= state + 1;
end
28: begin
	state <= state + 1;
end
29: begin
	state <= state + 1;
end
30: begin
	state <= state + 1;
end
31: begin
	state <= state + 1;
end
32: begin
	state <= state + 1;
end
33: begin
	add6_opr1 <= mm0_out1; add6_opr2 <= mid_reg_list[2]; issub6 <= 0;
	add0_opr1 <= mm0_out2; add0_opr2 <= mid_reg_list[3]; issub0 <= 0;
	state <= state + 1;
end
34: begin
	reg_list[`RAM_TX0] <= mm0_out1;
	reg_list[`RAM_TX1] <= mm0_out2;
	reg_list[`RAM_TY0] <= add6_out;
	reg_list[`RAM_TY1] <= add0_out;
	state <= state + 1;
end
35: begin
	state <= 0;
end
endcase
