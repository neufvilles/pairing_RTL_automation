case (state)
0: begin
	add5_opr1 <= reg_list[inst_addr_opr1 + 0]; add5_opr2 <= reg_list[`RAM_ZERO]; issub5 <= 0;
	add4_opr1 <= reg_list[`RAM_ZERO]; add4_opr2 <= reg_list[inst_addr_opr1 + 3]; issub4 <= 1;
	add0_opr1 <= reg_list[`RAM_ZERO]; add0_opr2 <= reg_list[inst_addr_opr1 + 4]; issub0 <= 1;
	add1_opr1 <= reg_list[`RAM_ZERO]; add1_opr2 <= reg_list[inst_addr_opr1 + 5]; issub1 <= 1;
	add3_opr1 <= reg_list[inst_addr_opr1 + 7]; add3_opr2 <= reg_list[`RAM_ZERO]; issub3 <= 0;
	add7_opr1 <= reg_list[inst_addr_opr1 + 8]; add7_opr2 <= reg_list[`RAM_ZERO]; issub7 <= 0;
	add6_opr1 <= reg_list[inst_addr_opr1 + 9]; add6_opr2 <= reg_list[`RAM_ZERO]; issub6 <= 0;
	add2_opr1 <= reg_list[`RAM_ZERO]; add2_opr2 <= reg_list[inst_addr_opr1 + 10]; issub2 <= 1;
	state <= state + 1;
end
1: begin
	reg_list[ret_addr + 0] <= add5_out;
	reg_list[ret_addr + 3] <= add4_out;
	reg_list[ret_addr + 4] <= add0_out;
	reg_list[ret_addr + 5] <= add1_out;
	reg_list[ret_addr + 7] <= add3_out;
	reg_list[ret_addr + 8] <= add7_out;
	reg_list[ret_addr + 9] <= add6_out;
	reg_list[ret_addr + 10] <= add2_out;
	add4_opr1 <= reg_list[inst_addr_opr1 + 1]; add4_opr2 <= reg_list[`RAM_ZERO]; issub4 <= 0;
	add2_opr1 <= reg_list[`RAM_ZERO]; add2_opr2 <= reg_list[inst_addr_opr1 + 2]; issub2 <= 1;
	add5_opr1 <= reg_list[inst_addr_opr1 + 6]; add5_opr2 <= reg_list[`RAM_ZERO]; issub5 <= 0;
	add1_opr1 <= reg_list[`RAM_ZERO]; add1_opr2 <= reg_list[inst_addr_opr1 + 11]; issub1 <= 1;
	state <= state + 1;
end
2: begin
	reg_list[ret_addr + 1] <= add4_out;
	reg_list[ret_addr + 2] <= add2_out;
	reg_list[ret_addr + 6] <= add5_out;
	reg_list[ret_addr + 11] <= add1_out;
	state <= state + 1;
end
3: begin
	state <= 0;
end
endcase
