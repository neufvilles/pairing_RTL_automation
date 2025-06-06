`include "./include/parameter.vh"

// X, Y (モンゴメリ変換済み)について Z = XYR^-1 mod p を求める

module MontMul (
    input wire clk,
    input wire rst_n,
    input wire [`WORD_SIZE-1: 0] X,
    input wire [`WORD_SIZE-1: 0] Y,
    output wire [`WORD_SIZE-1: 0] Z
);

    wire [`WORD_SIZE*2: 0] XY_tn;
    wire [`WORD_SIZE*2-1: 0] mulXY_out, mulTp_out, XY_pipe, mulT_out;
    // wire [`WORD_SIZE-1: 0] mulT_out;
    reg [`WORD_SIZE*2-1: 0] XY, Tp;
    reg [`WORD_SIZE-1: 0] T;

    assign XY_tn = Tp + XY_pipe;
    assign Z = (XY_tn[2*`WORD_SIZE: `WORD_SIZE] >= `CHAR) ? XY_tn[`WORD_SIZE*2: `WORD_SIZE] - `CHAR : XY_tn[`WORD_SIZE*2-1: `WORD_SIZE];

    DW02_mult_2_stage #(`WORD_SIZE, `WORD_SIZE)
    mulXY(.A(X), .B(Y), .TC(1'b0), .CLK(clk), .PRODUCT(mulXY_out));

    DW02_mult_2_stage #(`WORD_SIZE, `WORD_SIZE)
    mulT(.A(XY[`WORD_SIZE-1: 0]), .B(`CHAR_INV), .TC(1'b0), .CLK(clk), .PRODUCT(mulT_out));

    DW02_mult_2_stage #(`WORD_SIZE, `WORD_SIZE)
    mulTp(.A(T), .B(`CHAR), .TC(1'b0), .CLK(clk), .PRODUCT(mulTp_out));

    DW03_pipe_reg #(4, 2*`WORD_SIZE)
    XY_pipe_reg(.A(XY), .clk(clk), .B(XY_pipe));

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            XY <= 'b0;
            Tp <= 'b0;
            T <= 'b0;
        end
        else begin
            XY <= mulXY_out;
            T <= mulT_out[`WORD_SIZE-1: 0];
            Tp <= mulTp_out;
        end
    end


endmodule