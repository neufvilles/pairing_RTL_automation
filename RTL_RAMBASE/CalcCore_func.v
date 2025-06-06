function calc_finised;
    input [`MODE_SIZE-1: 0] mode;
    input [`CALC_STATE_SIZE-1: 0] state;
    begin
        case (mode)
            `MODE_PDBL: calc_finised = (state == `CALC_PDBL_STATE_SIZE-1) ? 1 : 0;
            `MODE_PADD: calc_finised = (state == `CALC_PADD_STATE_SIZE-1) ? 1 : 0;
            `MODE_PMINUS: calc_finised = (state == `CALC_PADD_STATE_SIZE-1) ? 1 : 0;
            `MODE_SPARSE_MUL: calc_finised = (state == `CALC_SPARSE_STATE_SIZE-1) ? 1 : 0;
            `MODE_SQUARE: calc_finised = (state == `CALC_SQR_STATE_SIZE-1) ? 1 : 0;
            `MODE_CONJ: calc_finised = (state == `CALC_CONJ_STATE_SIZE-1) ? 1 : 0;
            `MODE_FROB: calc_finised = (state == `CALC_FROB_STATE_SIZE-1) ? 1 : 0;
            `MODE_MUL: calc_finised = (state == `CALC_MUL_STATE_SIZE-1) ? 1 : 0;
            `MODE_MUL_CONJ: calc_finised = (state == `CALC_MUL_STATE_SIZE-1) ? 1 : 0;
            `MODE_SQR012345: calc_finised = (state == `CALC_SQR012345_STATE_SIZE-1) ? 1 : 0;
            `MODE_INV: calc_finised = (state == `CALC_INV_STATE_SIZE-1) ? 1 : 0;
            default: calc_finised = 1;
        endcase
    end
endfunction

function [`WORD_SIZE-1: 0] wdata_func1;
    input [`WORD_SIZE-1: 0] mm0_out1, mm0_out2, const0_out1, const0_out2, const0_out1, const0_out2, add0_out, add1_out, add2_out, add3_out, add4_out, add5_out, add6_out, add7_out;
    input [`OPR_NUM_SIZE-1: 0] wdata_s1;
    begin
        case (wdata_s1)
            `MM00: wdata_func1 = mm0_out1;
            `MM01: wdata_func1 = mm0_out2;
            `CONST00: wdata_func1 = const0_out1;
            `CONST01: wdata_func1 = const0_out2;
            `CONST10: wdata_func1 = const1_out1;
            `CONST11: wdata_func1 = const1_out2;
            `ADD0: wdata_func1 = add0_out;
            `ADD1: wdata_func1 = add1_out;
            `ADD2: wdata_func1 = add2_out;
            `ADD3: wdata_func1 = add3_out;
            `ADD4: wdata_func1 = add4_out;
            `ADD5: wdata_func1 = add5_out;
            `ADD6: wdata_func1 = add6_out;
            `ADD7: wdata_func1 = add7_out;
        endcase
    end
endfunction

function [`WORD_SIZE-1: 0] wdata_func2;
    input [`WORD_SIZE-1: 0] mm0_out1, mm0_out2, const0_out1, const0_out2, const0_out1, const0_out2, add0_out, add1_out, add2_out, add3_out, add4_out, add5_out, add6_out, add7_out;
    input [`OPR_NUM_SIZE-1: 0] wdata_s2;
    begin
        case (wdata_s2)
            `MM00: wdata_func2 = mm0_out1;
            `MM01: wdata_func2 = mm0_out2;
            `CONST00: wdata_func2 = const0_out1;
            `CONST01: wdata_func2 = const0_out2;
            `CONST10: wdata_func2 = const1_out1;
            `CONST11: wdata_func2 = const1_out2;
            `ADD0: wdata_func2 = add0_out;
            `ADD1: wdata_func2 = add1_out;
            `ADD2: wdata_func2 = add2_out;
            `ADD3: wdata_func2 = add3_out;
            `ADD4: wdata_func2 = add4_out;
            `ADD5: wdata_func2 = add5_out;
            `ADD6: wdata_func2 = add6_out;
            `ADD7: wdata_func2 = add7_out;
        endcase
    end
endfunction
