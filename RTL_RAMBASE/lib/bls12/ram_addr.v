// for RAM -----------------------------------------------------------------------------

`define RAM_DEPTH 60
`define RAM_ADDR_SIZE 6


`define RAM_ZERO	`RAM_ADDR_SIZE'd0
`define RAM_ONE	    `RAM_ADDR_SIZE'd1
`define RAM_BT0	    `RAM_ADDR_SIZE'd2
`define RAM_BT1	    `RAM_ADDR_SIZE'd2
`define RAM_QX0	    `RAM_ADDR_SIZE'd3
`define RAM_QX1	    `RAM_ADDR_SIZE'd3
`define RAM_QY0	    `RAM_ADDR_SIZE'd4
`define RAM_QY1	    `RAM_ADDR_SIZE'd4
`define RAM_QY_0	`RAM_ADDR_SIZE'd5
`define RAM_QY_1	`RAM_ADDR_SIZE'd5
`define RAM_TX0	    `RAM_ADDR_SIZE'd6
`define RAM_TX1	    `RAM_ADDR_SIZE'd6
`define RAM_TY0	    `RAM_ADDR_SIZE'd7
`define RAM_TY1	    `RAM_ADDR_SIZE'd7
`define RAM_TZ0	    `RAM_ADDR_SIZE'd8
`define RAM_TZ1	    `RAM_ADDR_SIZE'd8

`define RAM_XI10	`RAM_ADDR_SIZE'd9
`define RAM_XI11	`RAM_ADDR_SIZE'd9
`define RAM_XI20	`RAM_ADDR_SIZE'd10
`define RAM_XI21	`RAM_ADDR_SIZE'd10
`define RAM_XI30	`RAM_ADDR_SIZE'd11
`define RAM_XI31	`RAM_ADDR_SIZE'd11
`define RAM_XI40	`RAM_ADDR_SIZE'd12
`define RAM_XI41	`RAM_ADDR_SIZE'd12
`define RAM_XI50	`RAM_ADDR_SIZE'd13
`define RAM_XI51	`RAM_ADDR_SIZE'd13

`define RAM_A	`RAM_ADDR_SIZE'd14
`define RAM_B	`RAM_ADDR_SIZE'd20
`define RAM_C	`RAM_ADDR_SIZE'd26
`define RAM_D	`RAM_ADDR_SIZE'd32
`define RAM_E	`RAM_ADDR_SIZE'd38
`define RAM_F	`RAM_ADDR_SIZE'd44
`define RAM_G	`RAM_ADDR_SIZE'd50
// RAM_ZERO is allocated on the RAM1 side
`define RAM_PX	    `RAM_ADDR_SIZE'd57 
`define RAM_PY_	    `RAM_ADDR_SIZE'd58
`define RAM_PX_	    `RAM_ADDR_SIZE'd59
`define RAM_PY      `RAM_ADDR_SIZE'd60
