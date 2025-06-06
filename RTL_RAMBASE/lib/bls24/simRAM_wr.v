`timescale 1ps/1ps

`include "../RTL_inputfix_fp24/include/parameter.vh"
`include "../RTL_inputfix_fp24/include/parameter_input.vh"
`include "../RTL_inputfix_fp24/include/gatesim_prefix.v"

module simTop;

parameter CLK_PERIOD = 50 * 1000;
parameter STEP = CLK_PERIOD * 2;

reg clk, rst_n;
reg [`I_INPUTMODE_SIZE-1: 0] I_INPUTMODE;
reg [`CMD_INSTTYPE-1: 0] I_INSTTYPE;

reg [`RAM_ADDR_SIZE-1: 0] I_WADDR, I_RADDR;
reg [`CMD_MEMSIZE-1: 0] I_MODE_WADDR;
reg [`CMD_SIZE-1: 0] I_MODE_WDATA;
reg [`WORD_SIZE-1: 0] I_WDATA0000, I_WDATA0001, I_WDATA0010, I_WDATA0011, I_WDATA0100, I_WDATA0101, I_WDATA0110, I_WDATA0111, I_WDATA0200, I_WDATA0201, I_WDATA0210, I_WDATA0211, I_WDATA1000, I_WDATA1001, I_WDATA1010, I_WDATA1011, I_WDATA1100, I_WDATA1101, I_WDATA1110, I_WDATA1111, I_WDATA1200, I_WDATA1201, I_WDATA1210, I_WDATA1211;

wire [`WORD_SIZE-1: 0] result0000, result0001, result0010, result0011, result0100, result0101, result0110, result0111, result0200, result0201, result0210, result0211, result1000, result1001, result1010, result1011, result1100, result1101, result1110, result1111, result1200, result1201, result1210, result1211;
wire is_busy;

top top(
    .clk(clk),
    .rst_n(rst_n),
    .I_INPUTMODE(I_INPUTMODE),
    .I_INSTTYPE(I_INSTTYPE),
    .I_MODE_WADDR(I_MODE_WADDR),
    .I_MODE_WDATA(I_MODE_WDATA),
    .I_WADDR(I_WADDR),
    .I_RADDR(I_RADDR),
    .I_WDATA0000(I_WDATA0000),
    .I_WDATA0001(I_WDATA0001),
    .I_WDATA0010(I_WDATA0010),
    .I_WDATA0011(I_WDATA0011),
    .I_WDATA0100(I_WDATA0100),
    .I_WDATA0101(I_WDATA0101),
    .I_WDATA0110(I_WDATA0110),
    .I_WDATA0111(I_WDATA0111),
    .I_WDATA0200(I_WDATA0200),
    .I_WDATA0201(I_WDATA0201),
    .I_WDATA0210(I_WDATA0210),
    .I_WDATA0211(I_WDATA0211),
    .I_WDATA1000(I_WDATA1000),
    .I_WDATA1001(I_WDATA1001),
    .I_WDATA1010(I_WDATA1010),
    .I_WDATA1011(I_WDATA1011),
    .I_WDATA1100(I_WDATA1100),
    .I_WDATA1101(I_WDATA1101),
    .I_WDATA1110(I_WDATA1110),
    .I_WDATA1111(I_WDATA1111),
    .I_WDATA1200(I_WDATA1200),
    .I_WDATA1201(I_WDATA1201),
    .I_WDATA1210(I_WDATA1210),
    .I_WDATA1211(I_WDATA1211),
    .result0000(result0000),
    .result0001(result0001),
    .result0010(result0010),
    .result0011(result0011),
    .result0100(result0100),
    .result0101(result0101),
    .result0110(result0110),
    .result0111(result0111),
    .result0200(result0200),
    .result0201(result0201),
    .result0210(result0210),
    .result0211(result0211),
    .result1000(result1000),
    .result1001(result1001),
    .result1010(result1010),
    .result1011(result1011),
    .result1100(result1100),
    .result1101(result1101),
    .result1110(result1110),
    .result1111(result1111),
    .result1200(result1200),
    .result1201(result1201),
    .result1210(result1210),
    .result1211(result1211),
    .is_busy(is_busy)
);

`include "./testbench/include/functions.v"

initial begin
    clk = 0;
    rst_n = 0;
    I_INPUTMODE = `INPUT_COORD_CORE;
    I_MODE_WADDR = 0;
    I_WDATA0000 = 0;
    I_WDATA0001 = 0;
    I_WDATA0010 = 0;
    I_WDATA0011 = 0;
    I_WDATA0100 = 0;
    I_WDATA0101 = 0;
    I_WDATA0110 = 0;
    I_WDATA0111 = 0;
    I_WDATA0200 = 0;
    I_WDATA0201 = 0;
    I_WDATA0210 = 0;
    I_WDATA0211 = 0;
    I_WDATA1000 = 0;
    I_WDATA1001 = 0;
    I_WDATA1010 = 0;
    I_WDATA1011 = 0;
    I_WDATA1100 = 0;
    I_WDATA1101 = 0;
    I_WDATA1110 = 0;
    I_WDATA1111 = 0;
    I_WDATA1200 = 0;
    I_WDATA1201 = 0;
    I_WDATA1210 = 0;
    I_WDATA1211 = 0;
    #(STEP) rst_n = 1;
    `include "./testbench/include/input_values.v" // 19 cycles
    I_INPUTMODE <= `REF_RESULT;
    I_RADDR <= `RAM_P_BT_0;
    #(STEP);
    #(STEP);
    #(STEP);
    $display("result0000: %h\n", result0000);
    $display("result0001: %h\n", result0001);
    $display("result0010: %h\n", result0010);
    $display("result0011: %h\n", result0011);
    $display("result0100: %h\n", result0100);
    $display("result0101: %h\n", result0101);
    $display("result0110: %h\n", result0110);
    $display("result0111: %h\n", result0111);
    $display("result0200: %h\n", result0200);
    $display("result0201: %h\n", result0201);
    $display("result0210: %h\n", result0210);
    $display("result0211: %h\n", result0211);
    $display("result1000: %h\n", result1000);
    $display("result1001: %h\n", result1001);
    $display("result1010: %h\n", result1010);
    $display("result1011: %h\n", result1011);
    $display("result1100: %h\n", result1100);
    $display("result1101: %h\n", result1101);
    $display("result1110: %h\n", result1110);
    $display("result1111: %h\n", result1111);
    $display("result1200: %h\n", result1200);
    $display("result1201: %h\n", result1201);
    $display("result1210: %h\n", result1210);
    $display("result1211: %h\n", result1211);
    #(STEP);
    $finish;
end

always #(CLK_PERIOD) clk = ~clk;
    
endmodule