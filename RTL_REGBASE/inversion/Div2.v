`include "./include/parameter.vh"
module Div2(
    input wire [`WORD_SIZE-1: 0] a,
    input wire bypass,
    output wire [`WORD_SIZE-1: 0] c
);

wire u;
assign u = a[0];

wire [`WORD_SIZE-1: 0] _c;
wire co;

DW01_add #(`WORD_SIZE) CPA(
    .A( a ), .B( `CHAR ),
    .CI(1'b0), .SUM( _c ), .CO( co )
);

assign c = bypass ? a : (u == 1'b0 ? {1'b0, a[`WORD_SIZE-1:1]} : {co, _c[`WORD_SIZE-1:1]} );

endmodule
