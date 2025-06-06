`include "./include/parameter.vh"
module ConstMultMod(
		    input wire [1:0]				mode,
		    input wire 						invert,
		    input wire [`WORD_SIZE-1: 0]	a0,
		    input wire [`WORD_SIZE-1: 0]	a1,
		    output wire [`WORD_SIZE-1: 0]	c0,
		    output wire [`WORD_SIZE-1: 0]	c1
	            );

   ConstMultModCore6x ACMC0( .mode(mode), .invert(invert), .a(a0), .c(c0) );
   ConstMultModCore6x ACMC1( .mode(mode), .invert(invert), .a(a1), .c(c1) );

endmodule
