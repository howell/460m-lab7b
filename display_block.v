module display_block(iFClk, iSClk, iB0, iB1, iR2, iR3, oAN, oC);
    input iFClk;    // 1 ms clk
    input iSClk;    // cpu clock (slow)
    input iB0, iB1; // input buttons
    input [31:0] iR2, iR3;  // registers to conditionally display
    output [3:0] oAN;
    output [7:0] oC;

    wire wDBClk;    // 10 ms clk for debouncing
    wire wDB0, wDB1;    // debounce b0 and b1
    wire [15:0] wDisplayBits;   // bits to display on the 7seg

    clk_div db_clk(iFClk, 5, wDBClk); 
    debouncer db0(wDBClk, iB0, wDB0); 
    debouncer db1(wDBClk, iB1, wDB1); 

    assign wDisplayBits = (~wDB1 & ~wDB0) ? iR2[15:0]  :
                          (~wDB1 & wDB0)  ? iR2[31:16] :
                          (wDB1 & ~wDB0)  ? iR3[15:0]  :
                                            iR3[31:16];

    sevenseg_controller s(4'hF,iFClk,wDisplayBits[15:12],wDisplayBits[11:8],
                          wDisplayBits[7:4], wDisplayBits[3:0], oAN, oC);
    
endmodule   // display_block
