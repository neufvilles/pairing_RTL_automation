// for wrapper -------------------------------------------------------------------------------------------------

// modes for the wrapper
`define I_INPUTMODE_SIZE    2
`define REF_RESULT                       2'd0
`define INPUT_COORD_CORE                 2'd1
`define EXEC_CORE                        2'd2
`define INPUT_CMD_CORE                   2'd3

// modes for the calculation core -------------------------------------------------------------------------------------------------
`define MODE_SIZE 'd4

// `define MODE_PDBL_FIRST 4'b0000
`define MODE_PDBL 4'b0001
`define MODE_PADD 4'b0010
`define MODE_PMINUS 4'b0011
`define MODE_SQUARE 4'b0100
`define MODE_SPARSE_MUL 4'b0101
`define MODE_CONJ 4'b0110
`define MODE_MUL 4'b0111
`define MODE_FROB 4'b1000
`define MODE_INV 4'b1001
`define MODE_MUL_CONJ 4'b1010
`define MODE_SQR012345 4'b1011

// modes for ConstMulMod -------------------------------------------------------------------------------------------------
`define CONST_MODE 'd3

`define MODEONE 3'b000
`define MODETWO 3'b001
`define MODETHREE 3'b010
`define MODEFOUR 3'b011
`define MODEONE_ 3'b100
`define MODETWO_ 3'b101
`define MODETHREE_ 3'b110
`define MODESIX 3'b111

// for command buffer -----------------------------------------------------------------------------
// modes for the core 
`define CMD_SIZE   `MODE_SIZE + `RAM_ADDR_SIZE * 3

`define CMD_INSTTYPE 'd1
`define inst_ML 'b0
`define inst_FE 'b1
// for RAM -----------------------------------------------------------------------------

`define RAM_DEPTH 114
`define RAM_ADDR_SIZE 7


`define RAM_PX	    `RAM_ADDR_SIZE'd0
`define RAM_PY_	    `RAM_ADDR_SIZE'd1
`define RAM_BT0	    `RAM_ADDR_SIZE'd2
`define RAM_BT1	    `RAM_ADDR_SIZE'd3
`define RAM_PX_	    `RAM_ADDR_SIZE'd4
`define RAM_PY      `RAM_ADDR_SIZE'd5
`define RAM_QX0	    `RAM_ADDR_SIZE'd6
`define RAM_QX1	    `RAM_ADDR_SIZE'd7
`define RAM_QY0	    `RAM_ADDR_SIZE'd8
`define RAM_QY1	    `RAM_ADDR_SIZE'd9
`define RAM_QY_0	`RAM_ADDR_SIZE'd10
`define RAM_QY_1	`RAM_ADDR_SIZE'd11
`define RAM_TX0	    `RAM_ADDR_SIZE'd12
`define RAM_TX1	    `RAM_ADDR_SIZE'd13
`define RAM_TY0	    `RAM_ADDR_SIZE'd14
`define RAM_TY1	    `RAM_ADDR_SIZE'd15
`define RAM_TZ0	    `RAM_ADDR_SIZE'd16
`define RAM_TZ1	    `RAM_ADDR_SIZE'd17

`define RAM_XI10	`RAM_ADDR_SIZE'd18
`define RAM_XI11	`RAM_ADDR_SIZE'd19
`define RAM_XI20	`RAM_ADDR_SIZE'd20
`define RAM_XI21	`RAM_ADDR_SIZE'd21
`define RAM_XI30	`RAM_ADDR_SIZE'd22
`define RAM_XI31	`RAM_ADDR_SIZE'd23
`define RAM_XI40	`RAM_ADDR_SIZE'd24
`define RAM_XI41	`RAM_ADDR_SIZE'd25
`define RAM_XI50	`RAM_ADDR_SIZE'd26
`define RAM_XI51	`RAM_ADDR_SIZE'd27
`define RAM_ZERO	`RAM_ADDR_SIZE'd28
`define RAM_ONE	    `RAM_ADDR_SIZE'd29

`define RAM_A	`RAM_ADDR_SIZE'd30
`define RAM_B	`RAM_ADDR_SIZE'd42
`define RAM_C	`RAM_ADDR_SIZE'd54
`define RAM_D	`RAM_ADDR_SIZE'd66
`define RAM_E	`RAM_ADDR_SIZE'd78
`define RAM_F	`RAM_ADDR_SIZE'd90
`define RAM_G	`RAM_ADDR_SIZE'd102

// constants -------------------------------------------------------------------------------------------------
`define WORD_SIZE 'd381
`define CHAR 381'h1a0111ea397fe69a4b1ba7b6434bacd764774b84f38512bf6730d2a0f6b0f6241eabfffeb153ffffb9feffffffffaaab
`define CHAR_INV 381'heb06106feaafc9468b316fee268cf5819ecca0e8eb2db4c16ef2ef0c8e30b48286adb92d9d113e889f3fffcfffcfffd
`define INVERSION_INITIAL_VALUE 381'h12f7271fef9f194d9065c5851732ca8f85d56c6a35561b889462ac81628187c54a357b99a79ba4139582c47cd0709308
`define CHAR_3X 383'h4e0335beac7fb3cee152f722c9e306862d65e28eda8f383e359277e2e412e26c5c03fffc13fbffff2dfcffffffff0001

`define CHAR_5X 384'h820559931f7f8103778a468f507a6034f6547998c1995dbd03f41d24d174ceb4995bfff976a3fffea1fafffffffe5557

// parameters for twisted curve (Ep2)
`define BT0 381'h80447a8e5ff9a692c6e9ed90d2eb35d91dd2e13ce144afd9cc34a83dac3d8907aaffffac54ffffee7fbfffffffeaaac
`define BT1 381'h80447a8e5ff9a692c6e9ed90d2eb35d91dd2e13ce144afd9cc34a83dac3d8907aaffffac54ffffee7fbfffffffeaaac
// // constants independent from elliptic curve
`define ZERO 381'd0
`define ONE 381'h5feee15c6801965b4e45849bcb453289b88b47b0c7aed4098cf2d5f094f09dbe15400014eac00004601000000005555

// Frobenius pre-calculated coefficients
`define XI10 381'h45e667f3d4f69b0acffe774141ecf64a0fa5f49f4cc2795bfe321edb8f903167ca2abf22ccbd0625820f2aa56632fe2
`define XI11 381'h15a2ab6afc307ce99e1bc0422f2cdd72c37cec3afeb8eb29a74db0b33db7f30da209540c84882f9d61de0d55a99c7ac9
`define XI20 381'h0
`define XI21 381'h135eaf3f0e7c61088f70787fba895620f0a1510ad86a852b6b8c8bfa949f3d493ee0e447f2ce34ba2ddfd93c90ce08b9
`define XI30 381'h845b45845dfaaa0d87b351a63acc2b9935716f2382fdf44bfad46634b161567432dfbd7d1a74fcf7df9b4f44b544ca6
`define XI31 381'h845b45845dfaaa0d87b351a63acc2b9935716f2382fdf44bfad46634b161567432dfbd7d1a74fcf7df9b4f44b544ca6
`define XI40 381'h195d9d54d4fc7a6e4454d0c9773da9498c2a0585e4e5726c045bb9599dee47252034e449417a34ba73e0d93c90ce5e0e
`define XI41 381'h0
`define XI50 381'hca41ad7832f1451857b1c8e77cb921e3451763c2cfc06da7f906851040f187dbfd0a7c9fe732031d61aa79ea1b77c88
`define XI51 381'hd5cf712b650d248c5a08b27cb801ab93025d548c6890be4e7a06a4ff2a1dda65edb5834b2e0dfcde3e458615e482e23
`define CMD_MEMDEPTH_ML 200
`define CMD_MEMSIZE_ML 8

`define CMD_MEMDEPTH_FE 373
`define CMD_MEMSIZE_FE 9

`define CMD_MEMSIZE 9
