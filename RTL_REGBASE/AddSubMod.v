`include "./include/parameter.vh"

module AddSubMod( inA, inB, issub, out );
    input	[`WORD_SIZE-1 : 0]		inA, inB;
    input					issub;
    output [`WORD_SIZE-1 : 0]                    out;
    wire [`WORD_SIZE : 0]                        cso0, cso1;
    wire [`WORD_SIZE : 0]                        res_org, res_alt;
    wire                                         alt;

    wire [`WORD_SIZE : 0]                        A, B, B_csa, P;
    assign	A = { 1'b0, inA }; // 1'b0 for extra margin
    assign	B = { 1'b0, inB }; // 1'b0 for extra margin

    // PATH 1: simple addsub result for A+B<p in add mode or A-B>0 in sub mode
    DW01_addsub	#(`WORD_SIZE+1) addsub1( .A( A ), .B( B ), .CI(1'b0), .ADD_SUB(issub), .SUM( res_org ), .CO( ) );

    // PATH 2: alternative addsub result for A+B>p in add mode or A-B<0 in sub mode
    assign B_csa = issub ? ~B : B;
    assign P = issub ? { 1'b0, `CHAR } : ~{ 1'b0, `CHAR };
    // CSA for alternative output. carry-in is always zero because -P for add and -B for sub.
    DW01_csa #(`WORD_SIZE+1) csa( .a( A ), .b( B_csa ), .c( P ), .ci(1'b1), .carry( cso0 ), .sum( cso1 ), .co( ) );
    DW01_addsub	#(`WORD_SIZE+1) addsub2( .A( cso0 ), .B( cso1 ), .CI(1'b0), .ADD_SUB(1'b0), .SUM( res_alt ), .CO( ) );

    // determining which of PATH 1 or PATH 2 is appropriate for the result
    assign alt = issub ? res_org[`WORD_SIZE] : !res_alt[`WORD_SIZE];
    assign out = alt ? res_alt[`WORD_SIZE-1:0] : res_org[`WORD_SIZE-1:0];
endmodule