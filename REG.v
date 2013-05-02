module REG(CLK, RegW, DR, SR1, SR2, Reg_In, ReadReg1, ReadReg2, 
           iSW0, iSW1, iSW2, oR2, oR3);
    input CLK;
    input RegW;
    input [4:0] DR;
    input [4:0] SR1;
    input [4:0] SR2;
    input [31:0] Reg_In;
    input iSW0, iSW1, iSW2;
    output [31:0] oR2, oR3;
    output reg [31:0] ReadReg1;
    output reg [31:0] ReadReg2;
    reg [31:0] REG [0:31];
    integer i;

    initial
    begin
        ReadReg1 = 0;
        ReadReg2 = 0;
          for(i = 0; i < 32; i = i + 1) begin
            REG[i] = 0;
          end                     
    end
    
    assign oR2 = REG[2];
    assign oR3 = REG[3];

    always @(posedge CLK)
    begin
        REG[1][2:0] = {iSW2, iSW1, iSW0};
        if(RegW == 1'b1)
            if(DR != 1) begin
                REG[DR] <= Reg_In[31:0];
            end else begin
                REG[DR][31:3] = Reg_In[31:3];
            end
        ReadReg1 <= REG[SR1];
        ReadReg2 <= REG[SR2];
    end
endmodule
