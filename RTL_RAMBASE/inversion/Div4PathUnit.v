`include "./include/parameter.vh"
// Path Unit. 4-parallel is needed to faster calculation
module Div4PathUnit(
   input wire [`WORD_SIZE: 0]		a, // 1bit is shift headroom
   input wire [`WORD_SIZE: 0]		b, // 1bit is shift headroom
   input wire [`WORD_SIZE+2: 0]	pp, // need to adapt to internal bit length, thus +3
   input wire [`WORD_SIZE-1: 0]	p,
   output wire 			         sign_flag,
   output wire [`WORD_SIZE-1: 0]	c
);

// 1bit: sign, 3bit: headroom because (A'-B'+P'+P'') < 5p
wire [`WORD_SIZE+2: 0]                               ap, bp;
assign ap = {3'b0, a};
assign bp = ~{3'b0, b};

// if P' is minus (MSB=1), add extra carry-in
wire                                                 extra_ci;
assign extra_ci = pp[`WORD_SIZE+2];

wire [`WORD_SIZE+2: 0]                               cso_a0, cso_a1, cso_a2, cso_a3, out_a;

// PATH A: calc (A'-B'+P')/4 mod p
wire [`WORD_SIZE+2: 0]                               aug_p;
wire [1:0]                                           lsb0, lsb1, lsbp;
wire [1:0]                                           mode; // p augumentation mode, 0, 2p, 3p or p.
wire [1:0]                                           mcso0,mcso1, mode_flag0;
wire                                                 mode_flag1;

DW01_csa #(`WORD_SIZE+3) CSA_PATHA_1(
   .a( ap ), .b( bp ), .c( pp ),
   .ci(1'b1), .carry( cso_a0 ), .sum( cso_a1 ), .co()
);

// sub-path: determine p augmentation mode
assign lsb0 = cso_a0[1:0];
assign lsb1 = cso_a1[1:0];
assign lsbp = p[1:0];

// prepare 2 mode flags
DW01_add #(2) CPA_PATHA_1(
   .A( lsb0 ), .B( lsb1 ),
   .CI(extra_ci), .SUM( mode_flag0 ), .CO( ) // see above;forced ci is for -B. if p<0, extra ci is needed for both path here and right below
);

DW01_csa #(2) CSA_PATHA_2(
   .a( lsb0 ), .b( lsb1 ), .c( lsbp ),
   .ci(extra_ci), .carry( mcso0 ), .sum( mcso1 ), .co() // need extra ci if p<0
);
// DW01_add #(2)
// 	CPA_PATHA_2(
// 		.A( mcso0 ), .B( mcso1 ),
// 		.CI(1'b0), .SUM( mode_flag1 ), .CO( )
// 	);
assign mode_flag1 =
   (mcso0 == 2'b00 && mcso1 == 2'b10) ||
   (mcso0 == 2'b01 && mcso1 == 2'b01) ||
   (mcso0 == 2'b00 && mcso1 == 2'b00) ||
   (mcso0 == 2'b11 && mcso1 == 2'b11);

// NOTE: check the bit width of `CHAR_3X
assign aug_p = mode_flag0 == 2'b00 ? {4'b0000, {`WORD_SIZE{1'b0}} } : (
   mode_flag0 == 2'b10 ? {3'b000, `CHAR, 1'b0} : (mode_flag1 ? {2'b000, `CHAR_3X} : {4'b0000, `CHAR}
));
// why does function fail???
// function [`WORD_SIZE+3:0] CalculatePaug;
// 	input [1:0] mode_flag0;
// 	input [1:0] mode_flag1;
//
// 	begin
// 		if(mode_flag0 == 2'b00) begin
// 			CalculatePaug = {4'b0000, {`WORD_SIZE{1'b0}} };
// 		end if(mode_flag0 == 2'b10) begin
// 			CalculatePaug = {3'b000, `CHAR, 1'b0};
// 		end if(mode_flag1 == 2'b10) begin
// 			CalculatePaug = {3'b000, `CHAR_3X};
// 		end else begin
// 			CalculatePaug = {4'b0000, `CHAR};
// 		end
// 	end
// endfunction

// sum all to obtain X. after that, omit 2 LSB to get X/4.
DW01_csa #(`WORD_SIZE+3) CSA_PATHA3(
   .a( cso_a0 ), .b( cso_a1 ), .c( aug_p ),
   .ci(extra_ci), .carry( cso_a2 ), .sum( cso_a3 ), .co()
);
DW01_add #(`WORD_SIZE+3) CPA_PATHA_3(
   .A( cso_a2 ), .B( cso_a3 ),
   .CI(1'b0), .SUM( out_a ), .CO( ) // 2 LSB must be 00
);
assign c = out_a[`WORD_SIZE+1:2];

// PATH B: calc A'-B'+P' to obtain MSB (sign flag)
wire [`WORD_SIZE+2: 0]                               cso_b0, cso_b1, out_b;
DW01_csa #(`WORD_SIZE+3) CSA_PATHB_1(
   .a( ap ), .b( bp ), .c( pp ),
   .ci(extra_ci), .carry( cso_b0 ), .sum( cso_b1 ), .co()
);
DW01_add #(`WORD_SIZE+3) CPA_PATHB_1(
   .A( cso_b0 ), .B( cso_b1 ),
   .CI(1'b1), .SUM( out_b ), .CO( )
);
assign sign_flag = out_b[`WORD_SIZE+2];

endmodule
