module Complete_MIPS(CLK, RST, iHalt, oReg_One_LSB);
/* Will need to be modified to add functionality */
    input CLK;
    input RST;
    input iHalt;

    output [7:0] oReg_One_LSB;

    wire CS, WE, wCLK_DIV;
    wire [31:0] ADDR, Mem_Bus;
 
	 clk_div div(CLK, 250000,wCLK_DIV);
    MIPS CPU(wCLK_DIV, RST, CS, WE, ADDR, Mem_Bus, iHalt, oReg_One_LSB);
    Memory MEM(CS, WE, wCLK_DIV, ADDR, Mem_Bus);

endmodule
