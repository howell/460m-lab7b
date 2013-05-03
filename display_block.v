module display_block(iFClk, iSClk, iB0, iB1, iR2, iR3);
    input iFClk;    // 1 ms clk
    input iSClk;    // cpu clock (slow)
    input iB0, iB1; // input buttons
    input [31:0] iR2, iR3;  // registers to conditionally display

    wire wDBClk;    // 10 ms clk for debouncing
    wire wDB0, wDB1;    // debounce b0 and b1

    clk_div db_clk(iFClk, 5, wDBClk); 
    debouncer db0(wDBClk, iB0, wDB0); 
    debouncer db1(wDBClk, iB1, wDB1); 
    
endmodule   // display_block
