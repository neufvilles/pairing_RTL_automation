task writeValues;
    input [`RAM_ADDR_SIZE-1: 0] addr1, addr2;
    input [`WORD_SIZE-1: 0] data1, data2;
    begin
        I_WADDR1 = addr1;
        I_WADDR2 = addr2;
        I_WDATA1 = data1;
        I_WDATA2 = data2;
        #(STEP);
    end
endtask

task writeCommands;
    input [`CMD_MEMSIZE-1: 0] addr;
    input [`CMD_SIZE-1: 0] mode;
    begin
        I_MODE_WADDR = addr;
        I_MODE_WDATA = mode;
        #(STEP);
    end
endtask