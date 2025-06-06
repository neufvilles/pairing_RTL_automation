`include "./include/parameter.vh"

module top (
    input wire clk,
    input wire rst_n,
    input wire [`I_INPUTMODE_SIZE-1: 0] I_INPUTMODE,
    input wire [`CMD_INSTTYPE-1: 0] I_INSTTYPE,
    input wire [`CMD_MEMSIZE-1: 0] I_MODE_WADDR,
    input wire [`CMD_SIZE-1: 0] I_MODE_WDATA,
    input wire [`RAM_ADDR_SIZE-1: 0] I_WADDR1, I_WADDR2,
    input wire [`WORD_SIZE-1: 0] I_WDATA1, I_WDATA2, 
    input wire [`RAM_ADDR_SIZE-1: 0] I_RADDR1, I_RADDR2,
    output wire [`WORD_SIZE-1: 0] outdata1, outdata2,
    output wire is_busy
);

wire [`CMD_SIZE-1: 0] top_cmd;

wire finished_flag;
reg pre_finished_flag;


CalculationCore calc_core(
    .clk(clk), 
    .rst_n(rst_n), 
    .I_INPUTMODE(I_INPUTMODE),
    .top_cmd(top_cmd),  
    .I_WADDR1(I_WADDR1), .I_WADDR2(I_WADDR2),
    .I_WDATA1(I_WDATA1), .I_WDATA2(I_WDATA2),
    .I_RADDR1(I_RADDR1), .I_RADDR2(I_RADDR2),
    .outdata1(outdata1), .outdata2(outdata2),
    .finished_flag(finished_flag)
);


CommandBuffer CommandBuffer0(
    .clk(clk),
    .rst_n(rst_n),
    .I_INPUTMODE(I_INPUTMODE),
    .I_INSTTYPE(I_INSTTYPE),
    .I_MODE_WADDR(I_MODE_WADDR),
    .I_MODE_WDATA(I_MODE_WDATA),
    .finished_flag(finished_flag),
    .top_cmd(top_cmd),
    .is_busy(is_busy)
);


assign ram_wr_n = !pre_finished_flag; //TODO: 確認


always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        pre_finished_flag <= 0;
    end
    else if (I_INPUTMODE == `EXEC_CORE) begin
        pre_finished_flag <= finished_flag;
        
    end
end

endmodule