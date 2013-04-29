module Memory(CS, WE, CLK, ADDR, Mem_Bus);
    input CS;
    input WE;
    input CLK;
    input [31:0] ADDR;
    inout [31:0] Mem_Bus;

    reg [31:0] data_out;
    reg [31:0] RAM [0:127];

    initial
    begin
        data_out = 0;
        $readmemh("mem.hex", RAM);
//        $readmemb("flash.mips", RAM);
    end

    assign Mem_Bus = ((CS == 1'b0) || (WE == 1'b1)) ? 32'bZ : data_out;

    always @(negedge CLK)
        begin
        if((CS == 1'b1) && (WE == 1'b1))
        RAM[ADDR[6:0]] <= Mem_Bus[31:0];

        data_out <= RAM[ADDR[6:0]];
    end
endmodule
