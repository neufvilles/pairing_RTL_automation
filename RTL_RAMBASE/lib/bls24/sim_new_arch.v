`timescale 1ps/1ps

`include "../RTL_inputfix_fp24/include/parameter.vh"
`include "../RTL_inputfix_fp24/include/parameter_input.vh"

`define START `RAM_F

module simTop;

parameter CLK_PERIOD = 50;
parameter STEP = CLK_PERIOD * 2;

reg clk, rst_n;
reg [`I_INPUTMODE_SIZE-1: 0] I_INPUTMODE;
reg [`CMD_INSTTYPE-1: 0] I_INSTTYPE;

reg [`RAM_ADDR_SIZE-1: 0] I_WADDR1, I_WADDR2, I_RADDR1, I_RADDR2;
reg [`CMD_MEMSIZE-1: 0] I_MODE_WADDR;
reg [`CMD_SIZE-1: 0] I_MODE_WDATA;
reg [`WORD_SIZE-1: 0] I_WDATA1, I_WDATA2;

wire [`WORD_SIZE-1: 0] outdata1, outdata2;
wire is_busy;

top top(
    .clk(clk),
    .rst_n(rst_n),
    .I_INPUTMODE(I_INPUTMODE),
    .I_INSTTYPE(I_INSTTYPE),
    .I_MODE_WADDR(I_MODE_WADDR),
    .I_MODE_WDATA(I_MODE_WDATA),
    .I_WADDR1(I_WADDR1),
    .I_WADDR2(I_WADDR2),
    .I_WDATA1(I_WDATA1),
    .I_WDATA2(I_WDATA2),
    .I_RADDR1(I_RADDR1),
    .I_RADDR2(I_RADDR2),
    .outdata1(outdata1),
    .outdata2(outdata2),
    .is_busy(is_busy)
);

`include "./testbench/include/functions.v"
integer f;
initial begin
    clk = 0;
    rst_n = 0;
    I_INPUTMODE = `INPUT_COORD_CORE;
    I_MODE_WADDR = 0;
    I_WDATA1 = 0;
    I_WDATA2 = 0;
    #(STEP) rst_n = 1;
    `include "./testbench/include/input_values.v" // 19 cycles

    I_INPUTMODE = `INPUT_CMD_CORE;
    I_INSTTYPE = `inst_ML;
    #(STEP);
    `include "./testbench/include/SQR_test.v" // 157 cycles

    I_INPUTMODE = `EXEC_CORE;
    // I_INSTTYPE = `inst_ML; // 36621 cycles 3732450ps
    // I_INSTTYPE = `inst_FE; // 88985 cycles (+2) 12630950ps
    // wait (is_busy == 0); // 125606 cycles (+2)
    #(STEP*1000);
    f = $fopen("./result.txt", "w");
    I_INPUTMODE <= `REF_RESULT;
    I_RADDR1 <= `START;
    I_RADDR2 <= `START + `RAM_ADDR_SIZE'd1;
    #(STEP);
    $fdisplay(f, "%h", outdata1);
    $fdisplay(f, "%h", outdata2);
    I_RADDR1 <= `START + `RAM_ADDR_SIZE'd2;
    I_RADDR2 <= `START + `RAM_ADDR_SIZE'd3;
    #(STEP);
    $fdisplay(f, "%h", outdata1);
    $fdisplay(f, "%h\n", outdata2);
    I_RADDR1 <= `START + `RAM_ADDR_SIZE'd4;
    I_RADDR2 <= `START + `RAM_ADDR_SIZE'd5;
    #(STEP);
    $fdisplay(f, "%h", outdata1);
    $fdisplay(f, "%h", outdata2);
    I_RADDR1 <= `START + `RAM_ADDR_SIZE'd6;
    I_RADDR2 <= `START + `RAM_ADDR_SIZE'd7;
    #(STEP);
    $fdisplay(f, "%h", outdata1);
    $fdisplay(f, "%h\n", outdata2);
    I_RADDR1 <= `START + `RAM_ADDR_SIZE'd8;
    I_RADDR2 <= `START + `RAM_ADDR_SIZE'd9;
    #(STEP);
    $fdisplay(f, "%h", outdata1);
    $fdisplay(f, "%h", outdata2);
    I_RADDR1 <= `START + `RAM_ADDR_SIZE'd10;
    I_RADDR2 <= `START + `RAM_ADDR_SIZE'd11;
    #(STEP);
    $fdisplay(f, "%h", outdata1);
    $fdisplay(f, "%h\n", outdata2);
    I_RADDR1 <= `START + `RAM_ADDR_SIZE'd12;
    I_RADDR2 <= `START + `RAM_ADDR_SIZE'd13;
    #(STEP);
    $fdisplay(f, "%h", outdata1);
    $fdisplay(f, "%h", outdata2);
    I_RADDR1 <= `START + `RAM_ADDR_SIZE'd14;
    I_RADDR2 <= `START + `RAM_ADDR_SIZE'd15;
    #(STEP);
    $fdisplay(f, "%h", outdata1);
    $fdisplay(f, "%h\n", outdata2);
    I_RADDR1 <= `START + `RAM_ADDR_SIZE'd16;
    I_RADDR2 <= `START + `RAM_ADDR_SIZE'd17;
    #(STEP);
    $fdisplay(f, "%h", outdata1);
    $fdisplay(f, "%h", outdata2);
    I_RADDR1 <= `START + `RAM_ADDR_SIZE'd18;
    I_RADDR2 <= `START + `RAM_ADDR_SIZE'd19;
    #(STEP);
    $fdisplay(f, "%h", outdata1);
    $fdisplay(f, "%h\n", outdata2);
    I_RADDR1 <= `START + `RAM_ADDR_SIZE'd20;
    I_RADDR2 <= `START + `RAM_ADDR_SIZE'd21;
    #(STEP);
    $fdisplay(f, "%h", outdata1);
    $fdisplay(f, "%h", outdata2);
    I_RADDR1 <= `START + `RAM_ADDR_SIZE'd22;
    I_RADDR2 <= `START + `RAM_ADDR_SIZE'd23;
    #(STEP);
    $fdisplay(f, "%h", outdata1);
    $fdisplay(f, "%h\n", outdata2);
    $finish;
end

always #(CLK_PERIOD) clk = ~clk;
    
endmodule