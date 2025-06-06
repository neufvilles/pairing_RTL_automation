`include "./include/parameter.vh"
// (inv,mode):    // A    B
// 0, 00: 1a      // a  + 0
// 0, 01: 2a      // a  + a
// 0, 10: 3a      // a  + 2a
// 0, 11: 4a (*)  // 4a + 0
// 1, 00:-1a      // ~a + 0
// 1, 01:-2a      // ~a + ~a
// 1, 10:-3a      // ~a + ~2a
// 1, 11: 6a (*)  // 4a + 2a

module ConstMultModCore6x(
		          input wire [1:0]              mode,
		          input wire                    invert,
		          input wire [`WORD_SIZE-1: 0]  a,
		          output wire [`WORD_SIZE-1: 0] c
	                  );
   // Const Multiplier with Inverter.
   // The module can calculate 2a modp, 3a modp, -a modp, -2a modp, -3a modp, or do nothing (output a).

   // real invert flag.
   wire                                                 _invert;
   assign _invert = (mode != 2'b11) && invert;

   // width is WORD_SIZE +3. 1bit for extra sign margin, 2bit for the consideration of the a << 2 path.
   // total margin is 4. thus 257bit is required.
   // 2p-3p: 255bit, 4p-7p:256bit, 8p:257bit.
   wire [(`WORD_SIZE+4)-1: 0]                           A,_B,B,PN,PN2,PN3,PN3p,PN4, PN5,
							C_NORMAL, C_MINUSP, C_MINUS2P, C_MINUS3P, C_MINUS4P, C_MINUS5P;
   wire [(`WORD_SIZE+4)-1: 0]                           cso_0, cso_1,
							cso_p0, cso_p1,
							cso_pp0, cso_pp1,
							cso_ppp0, cso_ppp1,
							cso_pppp0, cso_pppp1,
							cso_ppppp0, cso_ppppp1;
   assign PN  = _invert ? { 3'b000, `CHAR       } : ~{ 3'b000, `CHAR       };
   assign PN2 = _invert ? { 2'b00,  `CHAR, 1'b0 } : ~{ 2'b00,  `CHAR, 1'b0 };
   assign PN3 = _invert ? { 2'b00,  `CHAR_3X    } : 257'd0;
   // for 4x and 6x. there's no need to invert because -4 neither -6 mult is performed in the algo.
   assign PN3p =~{ 2'b00,  `CHAR_3X    };
   assign PN4 = ~{ 1'b0, `CHAR, 2'b0 };
   assign PN5 = ~{ 1'b0, `CHAR_5X };

   // if 4x mode: 4a + 0.
   // if 6x mode: 4a + 2a.
   assign A = _invert ? ~{3'b000, a} : (
					mode == 2'b11 ? {1'b0, a, 2'b00} : {3'b000, a}
				        );
   assign _B = mode == 2'b00 || (mode == 2'b11 && !invert) ? {257'd0} : (
					                                 mode == 2'b01 ? {3'b000, a} : {2'b00, a, 1'b0}
				                                         );
   assign B = _invert ? ~_B : _B;

   // _invert*2(ci*2) are coresspond to each inversion of A, B.

   // PATH 1: A+B+0 / 3P-(A+B)
   DW01_csa #(`WORD_SIZE+4) CSA_NORMAL( .a(A), .b(B), .c(PN3), .ci(_invert), .carry(cso_0), .sum(cso_1), .co() );
   DW01_add #(`WORD_SIZE+4) ADD_NORMAL( .A(cso_0), .B(cso_1), .CI(_invert), .SUM(C_NORMAL), .CO() );

   // PATH 2: A+B-P / -(A+B-P) = P-(A+B)
   DW01_csa #(`WORD_SIZE+4) CSA_MINUSP( .a(A), .b(B), .c(PN), .ci(1'b1), .carry(cso_p0), .sum(cso_p1), .co() );
   DW01_add #(`WORD_SIZE+4) ADD_MINUSP( .A(cso_p0), .B(cso_p1), .CI(_invert), .SUM(C_MINUSP), .CO() );

   // PATH 3: A+B-2P / -(A+B-2P) = 2P-(A+B)
   DW01_csa #(`WORD_SIZE+4) CSA_MINUS2P( .a(A), .b(B), .c(PN2), .ci(1'b1), .carry(cso_pp0), .sum(cso_pp1), .co() );
   DW01_add #(`WORD_SIZE+4) ADD_MINUS2P( .A(cso_pp0), .B(cso_pp1), .CI(_invert), .SUM(C_MINUS2P), .CO() );

   ////////////////////////////////// for 4x, 6x
   // PATH 4: A+B-3P
   DW01_csa #(`WORD_SIZE+4) CSA_MINUS3P( .a(A), .b(B), .c(PN3p), .ci(1'b1), .carry(cso_ppp0), .sum(cso_ppp1), .co() );
   DW01_add #(`WORD_SIZE+4) ADD_MINUS3P( .A(cso_ppp0), .B(cso_ppp1), .CI(1'b0), .SUM(C_MINUS3P), .CO() );

   // PATH 5: A+B-4P
   DW01_csa #(`WORD_SIZE+4) CSA_MINUS4P( .a(A), .b(B), .c(PN4), .ci(1'b1), .carry(cso_pppp0), .sum(cso_pppp1), .co() );
   DW01_add #(`WORD_SIZE+4) ADD_MINUS4P( .A(cso_pppp0), .B(cso_pppp1), .CI(1'b0), .SUM(C_MINUS4P), .CO() );

   // PATH 6: A+B-5P
   DW01_csa #(`WORD_SIZE+4) CSA_MINUS5P( .a(A), .b(B), .c(PN5), .ci(1'b1), .carry(cso_ppppp0), .sum(cso_ppppp1), .co() );
   DW01_add #(`WORD_SIZE+4) ADD_MINUS5P( .A(cso_ppppp0), .B(cso_ppppp1), .CI(1'b0), .SUM(C_MINUS5P), .CO() );


   // determining output
   wire                                                 FLG_MINUSP, FLG_MINUS2P, FLG_MINUS3P, FLG_MINUS4P, FLG_MINUS5P; // each path is negative or not, negative = 1, non-negative = 0
   assign	FLG_MINUSP	= C_MINUSP[(`WORD_SIZE+4)-1];
   assign	FLG_MINUS2P	= C_MINUS2P[(`WORD_SIZE+4)-1];
   assign	FLG_MINUS3P	= C_MINUS3P[(`WORD_SIZE+4)-1];
   assign	FLG_MINUS4P	= C_MINUS4P[(`WORD_SIZE+4)-1];
   assign	FLG_MINUS5P	= C_MINUS5P[(`WORD_SIZE+4)-1];

   assign c = mode != 2'b11 ?
	      ( FLG_MINUSP && FLG_MINUS2P ) ? C_NORMAL :
              (( _invert ? ( !FLG_MINUSP && !FLG_MINUS2P ) :
                FLG_MINUS2P && !FLG_MINUSP ) ? C_MINUSP :
               C_MINUS2P ) :
              ( !FLG_MINUS5P ? C_MINUS5P :
                ( !FLG_MINUS4P ? C_MINUS4P :
                  ( !FLG_MINUS3P ? C_MINUS3P :
                    ( !FLG_MINUS2P ? C_MINUS2P :
                      ( !FLG_MINUSP  ? C_MINUSP : C_NORMAL )))));
endmodule
