`include "./include/parameter.vh"
`include "./include/CalcCore_param.vh"

module CalculationCore (
	input wire clk,
	input wire rst_n,
	input wire [`I_INPUTMODE_SIZE-1: 0] I_INPUTMODE,
	input wire [`CMD_SIZE-1: 0] top_cmd,
	input wire [`RAM_ADDR_SIZE-1: 0] I_WADDR1, I_WADDR2,
	input wire [`WORD_SIZE-1: 0] I_WDATA1, I_WDATA2,
	input wire [`RAM_ADDR_SIZE-1: 0] I_RADDR1, I_RADDR2,
	output wire [`WORD_SIZE-1: 0] outdata1, outdata2,
	output wire finished_flag
);

wire [`MODE_SIZE-1: 0] mode;
wire [`RAM_ADDR_SIZE-1: 0] inst_addr_opr1, inst_addr_opr2, ret_addr;

assign mode = top_cmd[`CMD_SIZE-1: `RAM_ADDR_SIZE * 3];
assign inst_addr_opr1 = top_cmd[`RAM_ADDR_SIZE*3-1: `RAM_ADDR_SIZE*2];
assign inst_addr_opr2 = top_cmd[`RAM_ADDR_SIZE*2-1: `RAM_ADDR_SIZE];
assign ret_addr = top_cmd[`RAM_ADDR_SIZE-1: 0];

reg [`CALC_STATE_SIZE-1: 0] state;
reg [`OPR_NUM_SIZE-1: 0] wdata_s1, wdata_s2;
wire [`WORD_SIZE-1: 0] result1, result2;

wire w1_n, w2_n;
reg w1_n_reg, w2_n_reg;
reg [`RAM_ADDR_SIZE-1: 0] ram_input_raddr1, ram_input_raddr2, waddr1_reg, waddr2_reg;
wire [`RAM_ADDR_SIZE-1: 0] raddr1, raddr2, waddr1, waddr2;
wire [`WORD_SIZE-1: 0] ram_input_out1, ram_input_out2, wdata1, wdata2;

assign w1_n = (I_INPUTMODE == `INPUT_COORD_CORE) ? 0 : w1_n_reg;
assign w2_n = (I_INPUTMODE == `INPUT_COORD_CORE) ? 0 : w2_n_reg;

assign waddr1 = (I_INPUTMODE == `INPUT_COORD_CORE) ? I_WADDR1 : waddr1_reg;
assign waddr2 = (I_INPUTMODE == `INPUT_COORD_CORE) ? I_WADDR2 : waddr2_reg;

assign wdata1 = (I_INPUTMODE == `INPUT_COORD_CORE) ? I_WDATA1 : result1;
assign wdata2 = (I_INPUTMODE == `INPUT_COORD_CORE) ? I_WDATA2 : result2;

// TODO: 読み出しアドレスはシーケンサで制御できるようにする
assign raddr1 = (I_INPUTMODE == `REF_RESULT) ? I_RADDR1 : ram_input_raddr1;
assign raddr2 = (I_INPUTMODE == `REF_RESULT) ? I_RADDR2 : ram_input_raddr2;

assign outdata1 = (I_INPUTMODE == `REF_RESULT) ? ram_input_out1 : {`WORD_SIZE{1'b0}};
assign outdata2 = (I_INPUTMODE == `REF_RESULT) ? ram_input_out2 : {`WORD_SIZE{1'b0}};

DW_ram_2r_2w_s_dff #(`WORD_SIZE, `RAM_ADDR_SIZE, 1'b0) RAM(
    .clk(clk),
	.rst_n(rst_n),
	.en_r1_n(1'b0),
    	.addr_r1(raddr1), // log2(RAM_BLOCKS)
        .data_r1(ram_input_out1),
	.en_r2_n(1'b0),
    	.addr_r2(raddr2), // log2(RAM_BLOCKS)
        .data_r2(ram_input_out2),
	.en_w1_n(w1_n),
    	.addr_w1(waddr1),
        .data_w1(wdata1),
	.en_w2_n(w2_n),
    	.addr_w2(waddr2),
        .data_w2(wdata2)
);

//mm0
wire [`WORD_SIZE-1: 0] mm0_out1, mm0_out2;
reg [`WORD_SIZE-1: 0] mm0_opr10, mm0_opr11, mm0_opr20, mm0_opr21, mm0_out1_reg, mm0_out2_reg;
reg ram_mm0_wr_n0;
wire ram_mm0_wr_n0_;
reg [`MM_RAM_SIZE-1:0] ram_mm0_raddr10, ram_mm0_raddr20, ram_mm0_waddr0;
wire [`MM_RAM_SIZE-1:0] ram_mm0_raddr10_, ram_mm0_raddr20_, ram_mm0_waddr0_;
wire [`WORD_SIZE-1: 0] ram_mm0_out20, ram_mm0_out20;
reg ram_mm0_wr_n1;
wire ram_mm0_wr_n1_;
reg [`MM_RAM_SIZE-1:0] ram_mm0_raddr11, ram_mm0_raddr21, ram_mm0_waddr1;
wire [`MM_RAM_SIZE-1:0] ram_mm0_raddr11_, ram_mm0_raddr21_, ram_mm0_waddr1_;
wire [`WORD_SIZE-1: 0] ram_mm0_out21, ram_mm0_out21;

assign ram_mm0_wr_n0_ = ram_mm0_wr_n0;
assign ram_mm0_raddr10_ = ram_mm0_raddr10;
assign ram_mm0_raddr20_ = ram_mm0_raddr20;
assign ram_mm0_waddr0_ = ram_mm0_waddr0;
assign ram_mm0_wr_n1_ = ram_mm0_wr_n1;
assign ram_mm0_raddr11_ = ram_mm0_raddr11;
assign ram_mm0_raddr21_ = ram_mm0_raddr21;
assign ram_mm0_waddr1_ = ram_mm0_waddr1;

MontMult2 mm0(.clk(clk), .rst_n(rst_n), .a0(mm0_opr10), .a1(mm0_opr11), .b0(mm0_opr20), .b1(mm0_opr21), .c0(mm0_out1), .c1(mm0_out2));
DW_ram_2r_w_s_dff #(`WORD_SIZE, `MM_RAM_DEPTH, 1'b0) RAM_mm00(
    .clk(clk),
        .rst_n(rst_n),
        .cs_n(1'b0),
        .wr_n(ram_mm0_wr_n0_),
    .rd1_addr(ram_mm0_raddr10_), // log2(RAM_BLOCKS)
        .data_rd1_out(ram_mm0_out20),
    .rd2_addr(ram_mm0_raddr20_),
        .data_rd2_out(ram_mm0_out20),
    .wr_addr(ram_mm0_waddr0_),
        .data_in(mm0_out1_reg)
);
DW_ram_2r_w_s_dff #(`WORD_SIZE, `MM_RAM_DEPTH, 1'b0) RAM_mm01(
    .clk(clk),
        .rst_n(rst_n),
        .cs_n(1'b0),
        .wr_n(ram_mm0_wr_n1_),
    .rd1_addr(ram_mm0_raddr11_), // log2(RAM_BLOCKS)
        .data_rd1_out(ram_mm0_out21),
    .rd2_addr(ram_mm0_raddr21_),
        .data_rd2_out(ram_mm0_out21),
    .wr_addr(ram_mm0_waddr1_),
        .data_in(mm0_out2_reg)
);

//const0
wire [`WORD_SIZE-1: 0] const0_out1, const0_out2;
reg [`WORD_SIZE-1: 0] const0_opr1, const0_opr2,  const0_out1_reg, const0_out2_reg;
reg [3:0] mode_const0;
reg ram_const0_wr_n1;
wire ram_const0_wr_n1_;
reg ram_const0_wr_n2;
wire ram_const0_wr_n2_;
reg [`MM_RAM_SIZE-1:0] ram_const0_raddr1, ram_const0_raddr2, ram_const0_waddr1, ram_const0_waddr2;
wire [`MM_RAM_SIZE-1:0] ram_const0_raddr1_, ram_const0_raddr2_, ram_const0_waddr1_, ram_const0_waddr2_;
wire [`WORD_SIZE-1: 0] ram_const0_out1, ram_const0_out2;

assign ram_const0_wr_n1_ = ram_const0_wr_n1;
assign ram_const0_wr_n2_ = ram_const0_wr_n2;
assign ram_const0_raddr1_ = ram_const0_raddr1;
assign ram_const0_raddr2_ = ram_const0_raddr2;
assign ram_const0_waddr1_ = ram_const0_waddr1;
assign ram_const0_waddr2_ = ram_const0_waddr2;

ConstMultMod const0(.mode(mode_const0[1:0]), .invert(mode_const0[2]), .a0(const0_opr1), .a1(const0_opr2), .c0(const0_out1), .c1(const0_out2));
DW_ram_2r_2w_s_dff #(`WORD_SIZE, `CONST0_RAM_DEPTH, 1'b0) RAM_const0(
    .clk(clk),
	.rst_n(rst_n),
	.en_r1_n(1'b0),
    	.addr_r1(ram_const0_raddr1_), // log2(RAM_BLOCKS)
        .data_r1(ram_const0_out1),
	.en_r2_n(1'b0),
    	.addr_r2(ram_const0_raddr2_), // log2(RAM_BLOCKS)
        .data_r2(ram_const0_out2),
	.en_w1_n(ram_const0_wr_n1_),
    	.addr_w1(ram_const0_waddr1_),
        .data_w1(const0_out1_reg),
	.en_w2_n(ram_const0_wr_n2_),
    	.addr_w2(ram_const0_waddr2_),
        .data_w2(const0_out2_reg)
);

//const1
wire [`WORD_SIZE-1: 0] const1_out1, const1_out2;
reg [`WORD_SIZE-1: 0] const1_opr1, const1_opr2,  const1_out1_reg, const1_out2_reg;
reg [3:0] mode_const1;
reg ram_const1_wr_n1;
wire ram_const1_wr_n1_;
reg ram_const1_wr_n2;
wire ram_const1_wr_n2_;
reg [`MM_RAM_SIZE-1:0] ram_const1_raddr1, ram_const1_raddr2, ram_const1_waddr1, ram_const1_waddr2;
wire [`MM_RAM_SIZE-1:0] ram_const1_raddr1_, ram_const1_raddr2_, ram_const1_waddr1_, ram_const1_waddr2_;
wire [`WORD_SIZE-1: 0] ram_const1_out1, ram_const1_out2;

assign ram_const1_wr_n1_ = ram_const1_wr_n1;
assign ram_const1_wr_n2_ = ram_const1_wr_n2;
assign ram_const1_raddr1_ = ram_const1_raddr1;
assign ram_const1_raddr2_ = ram_const1_raddr2;
assign ram_const1_waddr1_ = ram_const1_waddr1;
assign ram_const1_waddr2_ = ram_const1_waddr2;

ConstMultMod const1(.mode(mode_const1[1:0]), .invert(mode_const1[2]), .a0(const1_opr1), .a1(const1_opr2), .c0(const1_out1), .c1(const1_out2));
DW_ram_2r_2w_s_dff #(`WORD_SIZE, `CONST0_RAM_DEPTH, 1'b0) RAM_const1(
    .clk(clk),
	.rst_n(rst_n),
	.en_r1_n(1'b0),
    	.addr_r1(ram_const1_raddr1_), // log2(RAM_BLOCKS)
        .data_r1(ram_const1_out1),
	.en_r2_n(1'b0),
    	.addr_r2(ram_const1_raddr2_), // log2(RAM_BLOCKS)
        .data_r2(ram_const1_out2),
	.en_w1_n(ram_const1_wr_n1_),
    	.addr_w1(ram_const1_waddr1_),
        .data_w1(const1_out1_reg),
	.en_w2_n(ram_const1_wr_n2_),
    	.addr_w2(ram_const1_waddr2_),
        .data_w2(const1_out2_reg)
);


wire [`WORD_SIZE-1: 0] add0_out, add1_out, add2_out, add3_out;
wire [`WORD_SIZE-1: 0] add4_out, add5_out, add6_out, add7_out;
reg [`WORD_SIZE-1: 0] add0_opr1, add0_opr2, add0_out_reg, add1_opr1, add1_opr2, add1_out_reg, add2_opr1, add2_opr2, add2_out_reg, add3_opr1, add3_opr2, add3_out_reg;
reg [`WORD_SIZE-1: 0] add4_opr1, add4_opr2, add4_out_reg, add5_opr1, add5_opr2, add5_out_reg, add6_opr1, add6_opr2, add6_out_reg, add7_opr1, add7_opr2, add7_out_reg;
reg issub0, issub1, issub2, issub3;
reg issub4, issub5, issub6, issub7;

reg ram_add0_wr_n, ram_add1_wr_n, ram_add2_wr_n, ram_add3_wr_n;
wire ram_add0_wr_n_, ram_add1_wr_n_, ram_add2_wr_n_, ram_add3_wr_n_;
reg [`ADD0_RAM_SIZE-1:0] ram_add0_raddr1, ram_add0_raddr2, ram_add0_waddr;
wire [`ADD0_RAM_SIZE-1:0] ram_add0_raddr1_, ram_add0_raddr2_, ram_add0_waddr_;
reg [`ADD1_RAM_SIZE-1:0] ram_add1_raddr1, ram_add1_raddr2, ram_add1_waddr;
wire [`ADD1_RAM_SIZE-1:0] ram_add1_raddr1_, ram_add1_raddr2_, ram_add1_waddr_;
reg [`ADD2_RAM_SIZE-1:0] ram_add2_raddr1, ram_add2_raddr2, ram_add2_waddr;
wire [`ADD2_RAM_SIZE-1:0] ram_add2_raddr1_, ram_add2_raddr2_, ram_add2_waddr_;
reg [`ADD3_RAM_SIZE-1:0] ram_add3_raddr1, ram_add3_raddr2, ram_add3_waddr;
wire [`ADD3_RAM_SIZE-1:0] ram_add3_raddr1_, ram_add3_raddr2_, ram_add3_waddr_;
wire [`WORD_SIZE-1: 0] ram_add0_out1, ram_add0_out2, ram_add1_out1, ram_add1_out2, ram_add2_out1, ram_add2_out2, ram_add3_out1, ram_add3_out2;

reg ram_add4_wr_n, ram_add5_wr_n, ram_add6_wr_n, ram_add7_wr_n;
wire ram_add4_wr_n_, ram_add5_wr_n_, ram_add6_wr_n_, ram_add7_wr_n_;
reg [`ADD4_RAM_SIZE-1:0] ram_add4_raddr1, ram_add4_raddr2, ram_add4_waddr;
wire [`ADD4_RAM_SIZE-1:0] ram_add4_raddr1_, ram_add4_raddr2_, ram_add4_waddr_;
reg [`ADD5_RAM_SIZE-1:0] ram_add5_raddr1, ram_add5_raddr2, ram_add5_waddr;
wire [`ADD5_RAM_SIZE-1:0] ram_add5_raddr1_, ram_add5_raddr2_, ram_add5_waddr_;
reg [`ADD6_RAM_SIZE-1:0] ram_add6_raddr1, ram_add6_raddr2, ram_add6_waddr;
wire [`ADD6_RAM_SIZE-1:0] ram_add6_raddr1_, ram_add6_raddr2_, ram_add6_waddr_;
reg [`ADD7_RAM_SIZE-1:0] ram_add7_raddr1, ram_add7_raddr2, ram_add7_waddr;
wire [`ADD7_RAM_SIZE-1:0] ram_add7_raddr1_, ram_add7_raddr2_, ram_add7_waddr_;
wire [`WORD_SIZE-1: 0] ram_add4_out1, ram_add4_out2, ram_add5_out1, ram_add5_out2, ram_add6_out1, ram_add6_out2, ram_add7_out1, ram_add7_out2;

assign ram_add0_wr_n_ = ram_add0_wr_n;
assign ram_add0_raddr1_ = ram_add0_raddr1;
assign ram_add0_raddr2_ = ram_add0_raddr2;
assign ram_add0_waddr_ = ram_add0_waddr;

assign ram_add1_wr_n_ = ram_add1_wr_n;
assign ram_add1_raddr1_ = ram_add1_raddr1;
assign ram_add1_raddr2_ = ram_add1_raddr2;
assign ram_add1_waddr_ = ram_add1_waddr;

assign ram_add2_wr_n_ = ram_add2_wr_n;
assign ram_add2_raddr1_ = ram_add2_raddr1;
assign ram_add2_raddr2_ = ram_add2_raddr2;
assign ram_add2_waddr_ = ram_add2_waddr;

assign ram_add3_wr_n_ = ram_add3_wr_n;
assign ram_add3_raddr1_ = ram_add3_raddr1;
assign ram_add3_raddr2_ = ram_add3_raddr2;
assign ram_add3_waddr_ = ram_add3_waddr;

assign ram_add4_wr_n_ = ram_add4_wr_n;
assign ram_add4_raddr1_ = ram_add4_raddr1;
assign ram_add4_raddr2_ = ram_add4_raddr2;
assign ram_add4_waddr_ = ram_add4_waddr;

assign ram_add5_wr_n_ = ram_add5_wr_n;
assign ram_add5_raddr1_ = ram_add5_raddr1;
assign ram_add5_raddr2_ = ram_add5_raddr2;
assign ram_add5_waddr_ = ram_add5_waddr;

assign ram_add6_wr_n_ = ram_add6_wr_n;
assign ram_add6_raddr1_ = ram_add6_raddr1;
assign ram_add6_raddr2_ = ram_add6_raddr2;
assign ram_add6_waddr_ = ram_add6_waddr;

assign ram_add7_wr_n_ = ram_add7_wr_n;
assign ram_add7_raddr1_ = ram_add7_raddr1;
assign ram_add7_raddr2_ = ram_add7_raddr2;
assign ram_add7_waddr_ = ram_add7_waddr;

AddSubMod add0(.inA(add0_opr1), .inB(add0_opr2), .issub(issub0), .out(add0_out));
DW_ram_2r_w_s_dff #(`WORD_SIZE, `ADD0_RAM_DEPTH, 1'b0) RAM_add0(
    .clk(clk),
        .rst_n(rst_n),
        .cs_n(1'b0),
        .wr_n(ram_add0_wr_n_),
    .rd1_addr(ram_add0_raddr1_), // log2(RAM_BLOCKS)
        .data_rd1_out(ram_add0_out1),
    .rd2_addr(ram_add0_raddr2_),
        .data_rd2_out(ram_add0_out2),
    .wr_addr(ram_add0_waddr_),
        .data_in(add0_out_reg)
);
AddSubMod add1(.inA(add1_opr1), .inB(add1_opr2), .issub(issub1), .out(add1_out));
DW_ram_2r_w_s_dff #(`WORD_SIZE, `ADD1_RAM_DEPTH, 1'b0) RAM_add1(
    .clk(clk),
        .rst_n(rst_n),
        .cs_n(1'b0),
        .wr_n(ram_add1_wr_n_),
    .rd1_addr(ram_add1_raddr1_), // log2(RAM_BLOCKS)
        .data_rd1_out(ram_add1_out1),
    .rd2_addr(ram_add1_raddr2_),
        .data_rd2_out(ram_add1_out2),
    .wr_addr(ram_add1_waddr_),
        .data_in(add1_out_reg)
);
AddSubMod add2(.inA(add2_opr1), .inB(add2_opr2), .issub(issub2), .out(add2_out));
DW_ram_2r_w_s_dff #(`WORD_SIZE, `ADD2_RAM_DEPTH, 1'b0) RAM_add2(
    .clk(clk),
        .rst_n(rst_n),
        .cs_n(1'b0),
        .wr_n(ram_add2_wr_n_),
    .rd1_addr(ram_add2_raddr1_), // log2(RAM_BLOCKS)
        .data_rd1_out(ram_add2_out1),
    .rd2_addr(ram_add2_raddr2_),
        .data_rd2_out(ram_add2_out2),
    .wr_addr(ram_add2_waddr_),
        .data_in(add2_out_reg)
);
AddSubMod add3(.inA(add3_opr1), .inB(add3_opr2), .issub(issub3), .out(add3_out));
DW_ram_2r_w_s_dff #(`WORD_SIZE, `ADD3_RAM_DEPTH, 1'b0) RAM_add3(
    .clk(clk),
        .rst_n(rst_n),
        .cs_n(1'b0),
        .wr_n(ram_add3_wr_n_),
    .rd1_addr(ram_add3_raddr1_), // log2(RAM_BLOCKS)
        .data_rd1_out(ram_add3_out1),
    .rd2_addr(ram_add3_raddr2_),
        .data_rd2_out(ram_add3_out2),
    .wr_addr(ram_add3_waddr_),
        .data_in(add3_out_reg)
);
AddSubMod add4(.inA(add4_opr1), .inB(add4_opr2), .issub(issub0), .out(add4_out));
DW_ram_2r_w_s_dff #(`WORD_SIZE, `ADD4_RAM_DEPTH, 1'b0) RAM_add4(
    .clk(clk),
        .rst_n(rst_n),
        .cs_n(1'b0),
        .wr_n(ram_add4_wr_n_),
    .rd1_addr(ram_add4_raddr1_), // log2(RAM_BLOCKS)
        .data_rd1_out(ram_add4_out1),
    .rd2_addr(ram_add4_raddr2_),
        .data_rd2_out(ram_add4_out2),
    .wr_addr(ram_add4_waddr_),
        .data_in(add4_out_reg)
);
AddSubMod add5(.inA(add5_opr1), .inB(add5_opr2), .issub(issub1), .out(add5_out));
DW_ram_2r_w_s_dff #(`WORD_SIZE, `ADD5_RAM_DEPTH, 1'b0) RAM_add5(
    .clk(clk),
        .rst_n(rst_n),
        .cs_n(1'b0),
        .wr_n(ram_add5_wr_n_),
    .rd1_addr(ram_add5_raddr1_), // log2(RAM_BLOCKS)
        .data_rd1_out(ram_add5_out1),
    .rd2_addr(ram_add5_raddr2_),
        .data_rd2_out(ram_add5_out2),
    .wr_addr(ram_add5_waddr_),
        .data_in(add5_out_reg)
);
AddSubMod add6(.inA(add6_opr1), .inB(add6_opr2), .issub(issub2), .out(add6_out));
DW_ram_2r_w_s_dff #(`WORD_SIZE, `ADD6_RAM_DEPTH, 1'b0) RAM_add6(
    .clk(clk),
        .rst_n(rst_n),
        .cs_n(1'b0),
        .wr_n(ram_add6_wr_n_),
    .rd1_addr(ram_add6_raddr1_), // log2(RAM_BLOCKS)
        .data_rd1_out(ram_add6_out1),
    .rd2_addr(ram_add6_raddr2_),
        .data_rd2_out(ram_add6_out2),
    .wr_addr(ram_add6_waddr_),
        .data_in(add6_out_reg)
);
AddSubMod add7(.inA(add7_opr1), .inB(add7_opr2), .issub(issub3), .out(add7_out));
DW_ram_2r_w_s_dff #(`WORD_SIZE, `ADD7_RAM_DEPTH, 1'b0) RAM_add7(
    .clk(clk),
        .rst_n(rst_n),
        .cs_n(1'b0),
        .wr_n(ram_add7_wr_n_),
    .rd1_addr(ram_add7_raddr1_), // log2(RAM_BLOCKS)
        .data_rd1_out(ram_add7_out1),
    .rd2_addr(ram_add7_raddr2_),
        .data_rd2_out(ram_add7_out2),
    .wr_addr(ram_add7_waddr_),
        .data_in(add7_out_reg)
);

// for Inv
reg start;
wire inv_comp;
reg [`WORD_SIZE-1: 0] inv_opr;
wire [`WORD_SIZE-1: 0] inv_out;
reg [`WORD_SIZE-1: 0] inv_out_reg;

MontgomeryInverter MontInv(clk, rst_n, start, inv_opr, inv_out, inv_comp);

`include "./CalcCore_func.v"
assign finished_flag = calc_finised(mode, state);//要修正
assign result1 = wdata_func1(mm0_out1, mm0_out2, const0_out1, const0_out2, const0_out1, const0_out2, add0_out, add1_out, add2_out, add3_out, add4_out, add5_out, add6_out, add7_out, wdata_s1);
assign result2 = wdata_func2(mm0_out1, mm0_out2, const0_out1, const0_out2, const0_out1, const0_out2, add0_out, add1_out, add2_out, add3_out, add4_out, add5_out, add6_out, add7_out, wdata_s1);

always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		state <= 0;
		start <= 0;
		mode_const0 <= 3'b000;
		mode_const1 <= 3'b000;
		w1_n_reg <= 1;
		w2_n_reg <= 1;
		ram_mm0_wr_n0 <= 1;
        ram_mm0_wr_n1 <= 1;
        ram_const0_wr_n1 <= 1;
        ram_const0_wr_n2 <= 1;
        ram_const1_wr_n1 <= 1;
        ram_const1_wr_n2 <= 1;
		ram_add0_wr_n <= 1;
		ram_add1_wr_n <= 1;
		ram_add2_wr_n <= 1;
		ram_add3_wr_n <= 1;
		ram_add4_wr_n <= 1;
		ram_add5_wr_n <= 1;
		ram_add6_wr_n <= 1;
		ram_add7_wr_n <= 1;
	end
	else begin
		mm0_out1_reg <= mm0_out1;
		mm0_out2_reg <= mm0_out2;
        const0_out1_reg <= const0_out1;
        const0_out2_reg <= const0_out2;
        const1_out1_reg <= const1_out1;
        const1_out2_reg <= const1_out2;
		add0_out_reg <= add0_out;
		add1_out_reg <= add1_out;
		add2_out_reg <= add2_out;
		add3_out_reg <= add3_out;
		add4_out_reg <= add4_out;
		add5_out_reg <= add5_out;
		add6_out_reg <= add6_out;
		add7_out_reg <= add7_out;
		inv_out_reg <= inv_out;
		if (I_INPUTMODE == `EXEC_CORE) begin
			case (mode)
				`MODE_PDBL: begin
					`include "./include/ALU_mode/seq_PDBL.v"
				end 
				`MODE_PADD: begin
					`include "./include/ALU_mode/seq_PADD.v"
				end 
				`MODE_PMINUS: begin
					`include "./include/ALU_mode/seq_PMINUS.v"
				end 
				`MODE_FROB: begin
					`include "./include/ALU_mode/seq_FROB.v"
				end 
				`MODE_CONJ: begin
					`include "./include/ALU_mode/seq_CONJ.v"
				end 
				`MODE_SQR012345: begin
					`include "./include/ALU_mode/seq_SQR012345.v"
				end 
				`MODE_SPARSE_MUL: begin
					`include "./include/ALU_mode/seq_SPARSE.v"
				end 
				`MODE_SQUARE: begin
					`include "./include/ALU_mode/seq_SQR.v"
				end 
				`MODE_MUL: begin
					`include "./include/ALU_mode/seq_MUL.v"
				end 
				`MODE_MUL_CONJ: begin
					`include "./include/ALU_mode/seq_MUL_CONJ.v"
				end 
				`MODE_INV: begin
					`include "./include/ALU_mode/seq_INV.v"
				end 
			endcase
		end
	end
end
endmodule
