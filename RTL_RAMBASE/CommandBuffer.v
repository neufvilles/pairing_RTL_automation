// `define MODE_PDBL_FIRST 4'b0000
// `define MODE_PDBL 4'b0001
// `define MODE_PADD 4'b0010
// `define MODE_PMINUS 4'b0011
// `define MODE_SQUARE 4'b0100
// `define MODE_SPARSE_MUL 4'b0101
// `define MODE_CONJ 4'b0110
// `define MODE_MUL 4'b0111
// `define MODE_FROB 4'b1000
// `define MODE_INV 4'b1001

module CommandBuffer (
    input wire clk,
    input wire rst_n,
    input wire [`I_INPUTMODE_SIZE-1: 0] I_INPUTMODE,
    input wire [`CMD_INSTTYPE-1: 0] I_INSTTYPE,
    input wire [`CMD_MEMSIZE-1: 0] I_MODE_WADDR,
    input wire [`CMD_SIZE-1: 0] I_MODE_WDATA,
    input wire finished_flag,
    output wire [`CMD_SIZE-1: 0] top_cmd,
    output wire is_busy
);

wire [`CMD_INSTTYPE-1: 0] insttype;
reg [`CMD_INSTTYPE-1: 0] insttype_exec_reg;

assign insttype = (I_INPUTMODE == `INPUT_CMD_CORE) ? I_INSTTYPE : ((I_INPUTMODE == `EXEC_CORE) ? insttype_exec_reg : 0);

wire [`CMD_MEMSIZE-1: 0] cmd_waddr;
reg [`CMD_MEMSIZE-1: 0] cmd_raddr;
wire [`CMD_SIZE-1: 0] cmd_data;
wire cmd_wen;

// I_INSTTYPE == inst_ML
wire cmd_wen_ml;
wire [`CMD_MEMSIZE_ML-1: 0] cmd_raddr_ml, cmd_waddr_ml;
wire [`CMD_SIZE-1: 0] cmd_data_ml, top_cmd_ml;

assign cmd_wen_ml = (I_INPUTMODE == `INPUT_CMD_CORE && insttype == `inst_ML) ? 0: 1;
assign cmd_raddr_ml = (I_INPUTMODE == `EXEC_CORE && insttype == `inst_ML) ? cmd_raddr[`CMD_MEMSIZE_ML-1: 0] : 0;
assign cmd_waddr_ml = (I_INPUTMODE == `INPUT_CMD_CORE && insttype == `inst_ML) ? I_MODE_WADDR[`CMD_MEMSIZE_ML-1: 0] : 0;
assign cmd_data_ml = (I_INPUTMODE == `INPUT_CMD_CORE && insttype == `inst_ML) ? I_MODE_WDATA : 0;

DW_ram_r_w_s_dff #(`CMD_SIZE, `CMD_MEMDEPTH_ML, 1'b0)
CMD_RAM_ML(
    .clk(clk), 
    .rst_n(rst_n), 
    .cs_n(1'b0), 
    .wr_n(cmd_wen_ml), 
    .rd_addr(cmd_raddr_ml), 
    .wr_addr(cmd_waddr_ml), 
    .data_in(cmd_data_ml), 
    .data_out(top_cmd_ml)
);

// I_INSTTYPE == inst_FE
wire cmd_wen_fe;
wire [`CMD_MEMSIZE_FE-1: 0] cmd_raddr_fe, cmd_waddr_fe;
wire [`CMD_SIZE-1: 0] cmd_data_fe, top_cmd_fe;

assign cmd_wen_fe = (I_INPUTMODE == `INPUT_CMD_CORE && insttype == `inst_FE) ? 0: 1;
assign cmd_raddr_fe = (I_INPUTMODE == `EXEC_CORE && insttype == `inst_FE) ? cmd_raddr[`CMD_MEMSIZE_FE-1: 0] : 0;
assign cmd_waddr_fe = (I_INPUTMODE == `INPUT_CMD_CORE && insttype == `inst_FE) ? I_MODE_WADDR[`CMD_MEMSIZE_FE-1: 0] : 0;
assign cmd_data_fe = (I_INPUTMODE == `INPUT_CMD_CORE && insttype == `inst_FE) ? I_MODE_WDATA : 0;

DW_ram_r_w_s_dff #(`CMD_SIZE, `CMD_MEMDEPTH_FE, 1'b0)
CMD_RAM_FE(
    .clk(clk), 
    .rst_n(rst_n), 
    .cs_n(1'b0), 
    .wr_n(cmd_wen_fe), 
    .rd_addr(cmd_raddr_fe), 
    .wr_addr(cmd_waddr_fe), 
    .data_in(cmd_data_fe), 
    .data_out(top_cmd_fe)
);

assign top_cmd = (I_INPUTMODE == `EXEC_CORE) ? ((insttype == `inst_ML) ? top_cmd_ml : top_cmd_fe) : {`CMD_SIZE{1'b0}};

reg is_busy_reg;
assign is_busy = is_busy_reg;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cmd_raddr <= 0;
        insttype_exec_reg <= `inst_ML;
        is_busy_reg <= 1;
    end
    else if (I_INPUTMODE == `EXEC_CORE) begin
        if (finished_flag) begin
            if (insttype == `inst_ML && cmd_raddr == `CMD_MEMDEPTH_ML - 1) begin
                cmd_raddr <= 0;
                insttype_exec_reg <= `inst_FE;
            end else if (insttype == `inst_FE && cmd_raddr == `CMD_MEMDEPTH_FE - 1) begin
                is_busy_reg <= 0;
            end else begin
                cmd_raddr <= cmd_raddr + 1;
            end
        end
    end
end
endmodule