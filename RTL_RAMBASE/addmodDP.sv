`include "./include/parameter.vh"
module addmodDP( inA, inB, res );
   input	[`WORD_SIZE*2-1 : 0]		inA, inB;
   output [`WORD_SIZE*2-1 : 0]                  res;
   wire [`WORD_SIZE*2 : 0]                      cso0, cso1;
   wire [`WORD_SIZE*2 : 0]                      res_org, res_alt;
   wire                                         alt;

   wire [`WORD_SIZE*2 : 0]                      A, B, B_csa, P;
   assign	A = { 1'b0, inA }; // 1'b0 for extra margin
   assign	B = { 1'b0, inB }; // 1'b0 for extra margin

   // PATH 1: simple addsub result for A+B<p in add mode or A-B>0 in sub mode
   DW01_add	#(`WORD_SIZE*2+1)		addsub1( .A( A ), .B( B ), .CI(1'b0), .SUM( res_org ), .CO( ) );

   // PATH 2: alternative addsub result for A+B>p in add mode or A-B<0 in sub mode
   assign	B_csa		= B;
   assign	P			= ~{ 1'b0, {`BLS381_CHAR, {`WORD_SIZE{1'b0}} }};
   // CSA for alternative output. carry-in is always zero because -P for add and -B for sub.
   DW01_csa #(`WORD_SIZE*2+1)			csa( .a( A ), .b( B_csa ), .c( P ), .ci(1'b1), .carry( cso0 ), .sum( cso1 ), .co( ) );
   DW01_add	#(`WORD_SIZE*2+1)		addsub2( .A( cso0 ), .B( cso1 ), .CI(1'b0), .SUM( res_alt ), .CO( ) );

   // determining which of PATH 1 or PATH 2 is appropriate for the result
   assign alt		= !res_alt[`WORD_SIZE*2];
   assign res 		= alt ? res_alt[`WORD_SIZE*2-1:0] : res_org[`WORD_SIZE*2-1:0] ;
endmodule
