`include "./include/parameter.vh"
module Div4(
   input wire [`WORD_SIZE-1: 0]	a,
   input wire [`WORD_SIZE-1: 0]	b,
   input wire 						flg2x_a,
   input wire 						flg2x_b,
   output wire [`WORD_SIZE-1: 0]	c
);

wire [`WORD_SIZE: 0]                         _a, _b;
assign _a = flg2x_a ? {a, 1'b0} : {1'b0, a};
assign _b = flg2x_b ? {b, 1'b0} : {1'b0, b};

wire [`WORD_SIZE-1: 0]                       c1,c2,c3,c4;
wire                                         s1,s2,s3; // 1 if the path is negative

wire [`WORD_SIZE+2: 0] 			pp_minusP, pp_zero, pp_plusP, pp_plus2P;
wire [`WORD_SIZE-1: 0] 			p;
assign pp_minusP = ~{3'b0, `CHAR };
assign pp_zero = {3'b0, {`WORD_SIZE{1'b0}}};
assign pp_plusP = {3'b0, `CHAR };
assign pp_plus2P = {2'b0, `CHAR, 1'b0 };
assign p = `CHAR;


Div4PathUnit path_minusP(
   .a( _a ), .b( _b ), .pp( pp_minusP ),
   .p( p ), .sign_flag( s1 ), .c( c1 )
);

Div4PathUnit path_zero(
   .a( _a ), .b( _b ), .pp( pp_zero ),
   .p( p ), .sign_flag( s2 ), .c( c2 )
);

Div4PathUnit path_plusP(
   .a( _a ), .b( _b ), .pp( pp_plusP ),
   .p( p ), .sign_flag( s3 ), .c( c3 )
);

Div4PathUnit path_plus2P(
   .a( _a ), .b( _b ), .pp( pp_plus2P ),
   .p( p ), .sign_flag(  ), .c( c4 )
);

/*
function [`WORD_SIZE-1:0] MUX_OUT;
   input                                     s_minusp, s_zero, s_plusp;
   input [`WORD_SIZE-1:0]                    c1,c2,c3,c4;

   begin
   if(s_minusp == 1'b0) begin
      MUX_OUT = c1;
   end else if(s_zero == 1'b0) begin
      MUX_OUT = c2;
   end else if(s_plusp == 1'b0) begin
      MUX_OUT = c3;
   end else begin
      MUX_OUT = c4;
   end
   end
endfunction

assign c = MUX_OUT(s1,s2,s3,c1,c2,c3,c4);
   */
assign c = ( s1 == 1'b0 ) ? c1
            : (( s2 == 1'b0 ) ? c2
               : (( s3 == 1'b0 ) ? c3
                  : c4 ));

endmodule
