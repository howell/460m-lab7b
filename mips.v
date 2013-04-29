module MIPS(CLK, RST, CS, WE, Address, Mem_Bus, HALT, Reg_One_LSB);

    input CLK, RST, HALT;
    output CS, WE;
    output [31:0] Address;
    output [7:0] Reg_One_LSB;
    inout [31:0] Mem_Bus;

    reg CS, WE;

    // opcodes
    `define ADDI 6'b001000
    `define ANDI 6'b001100
    `define ORI  6'b001101
    `define LW   6'b100011
    `define SW   6'b101011
    `define BEQ  6'b000100
    `define BNE  6'b000101
    `define JUMP 6'b000010
    `define JAL  6'b000011
    `define LUI  6'b001111

    // F-Codes
    `define SHL  6'b000000
    `define SHR  6'b000010
    `define JR   6'b001000
    `define ADD  6'b100000
    `define SUB  6'b100010
    `define AND1 6'b100100
    `define OR1  6'b100101
    `define XOR1 6'b100110
    `define SLT  6'b101010
    `define MULT 6'b011000
    `define MFHI 6'b010000
    `define MFLO 6'b010010
    `define ADD8 6'b101101
    `define RBIT 6'b101111   // bits
    `define REV  6'b110000   // bytes
    `define SADD 6'b110001
    `define SSUB 6'b110010


    `define OPCODE     Instr[31:26]
    `define SR1        Instr[25:21]
    `define SR2        Instr[20:16]
    `define F_Code     Instr[ 5: 0]
    `define NumShift   Instr[10: 6]
    `define ImmField   Instr[15: 0]

    parameter op_and1 = 0;
    parameter op_or1  = 1;
    parameter op_add  = 2;
    parameter op_sub  = 3;
    parameter op_slt  = 4;
    parameter op_shr  = 5;
    parameter op_shl  = 6;
    parameter op_jr   = 7;
    parameter op_xor1 = 8;

    // Instruction formats
    parameter Instr_Format_R = 0;
    parameter Instr_Format_I = 1;
    parameter Instr_Format_J = 2;

    reg         ALUorMEM, RegW, FetchDorI, Writing, REGorIMM;
    reg         REGorIMM_Save, ALUorMEM_Save; 
    wire [ 1:0] Format;
    reg  [31:0] Instr;
    wire [31:0] Imm_Ext;
    reg  [31:0] PC, nPC;
    wire [31:0] ReadReg1, ReadReg2;
    wire [31:0] Reg_In;
    wire [31:0] ALU_InA, ALU_InB;
    reg  [31:0] ALU_Result;
    reg  [31:0] ALU_Result_Save;
    reg  [ 3:0] Op, OpSave;
    wire [ 4:0] DR;
    reg  [ 2:0] State, nState;

    initial
    begin
        Op = op_and1;
        OpSave = op_and1;
        ALUorMEM = 0;
        RegW = 0;
        FetchDorI = 0;
        Writing = 0;
        REGorIMM = 0;
        REGorIMM_Save = 0;
        ALUorMEM_Save = 0;
        State = 0;
        nState = 0;
        ALU_Result_Save = 0;
        Instr = 0;
        PC = 0;
    end

    REG reg_file(CLK, RegW, DR, `SR1, `SR2, Reg_In, ReadReg1, ReadReg2, Reg_One_LSB);
    
    assign Imm_Ext = (Instr[15]) ? {16'hFFFF, Instr[15:0]} : 
                                   {16'h0000, Instr[15:0]};

    assign DR = (Format == Instr_Format_R) ? Instr[15:11] : Instr[20:16];

    assign ALU_InA = ReadReg1; 
    assign ALU_InB = (REGorIMM_Save) ? Imm_Ext : ReadReg2;
    assign Reg_In  = (ALUorMEM_Save) ? Mem_Bus : ALU_Result_Save;
    assign Format  = (`OPCODE == 0)   ? Instr_Format_R : 
                     ((`OPCODE == 2) ? Instr_Format_J : Instr_Format_I);

    assign Mem_Bus = (Writing) ? ReadReg2 : 32'dZ;
    assign Address = (FetchDorI) ? PC : ALU_Result_Save;

    always @(*) begin
        FetchDorI <= 0;
        CS <= 0;
        WE <= 0;
        RegW <= 0;
        Writing <= 0;
        ALU_Result <= 0;
        nPC <= PC;
        Op <= op_jr;
        REGorIMM <= 0;
        ALUorMEM <= 0;
        case(State)
        0: begin
				if(HALT) begin
					nState <= 0; 
				end
				else begin
					nPC <= PC + 1;
					CS <= 1;
					nState <= 1;
					FetchDorI <= 1;
				end
        end
        1: begin
            nState <= 2;
            REGorIMM <= 0;
            ALUorMEM <= 0;
            case(Format)
                Instr_Format_R: begin
                    case(`F_Code)
                    `SHL: begin
                        Op <= op_shl;
                    end
                    `SHR: begin
                        Op <= op_shr;
                    end
                    `JR: begin
                        Op <= op_jr;
                    end
                    `ADD: begin
                        Op <= op_add;
                    end
                    `SUB: begin
                        Op <= op_sub;
                    end
                    `AND1: begin
                        Op <= op_and1;
                    end
                    `OR1: begin
                        Op <= op_or1;
                    end
                    `XOR1: begin
                        Op <= op_xor1;
                    end
                    `SLT: begin
                        Op <= op_slt;
                    end
                    default: begin
                    end
                    endcase
                end
                Instr_Format_I: begin
                    REGorIMM <= 1;
                    case(`OPCODE)
                        `ADDI: begin
                            Op <= op_add;
                        end
                        `ANDI: begin
                            Op <= op_and1;
                        end
                        `ORI: begin
                            Op <= op_or1;
                        end
                        `LW: begin
                            Op <= op_add;
                            ALUorMEM <= 1;
                        end
                        `SW: begin
                            Op <= op_add;
                        end
                        `BEQ: begin
                            Op <= op_sub;
                            REGorIMM <= 0;
                        end
                        `BNE: begin
                            Op <= op_sub;
                            REGorIMM <= 0;
                        end
                        default: begin
                        end
                    endcase
                end
                Instr_Format_J: begin
                    nPC <= {6'd0, Instr[25:0]};
                    nState <= 0;
                end
                default: begin
                end
            endcase
        end
        2: begin
            nState <= 3;
            case(OpSave)
                op_and1: begin
                    ALU_Result <= ALU_InA & ALU_InB;
                end
                op_or1: begin
                    ALU_Result <= ALU_InA | ALU_InB;
                end
                op_add: begin
                    ALU_Result <= ALU_InA + ALU_InB;
                end
                op_sub: begin
                    ALU_Result <= ALU_InA - ALU_InB;
                end
                op_shr: begin
                    ALU_Result <= ALU_InB >>  `NumShift;
                end
                op_shl: begin
                    ALU_Result <= ALU_InB << `NumShift;
                end
                op_slt: begin
                    ALU_Result <= (ALU_InA < ALU_InB) ? 1 : 0;
                end
                op_jr: begin
                    nPC <= ALU_InA;
                    nState <= 0;
                end
                op_xor1: begin
                    ALU_Result <= ALU_InA ^ ALU_InB;
                end
                default: begin
                end
            endcase
            if(`OPCODE == `BEQ) begin
                if(ALU_InA == ALU_InB) begin
                    nPC <= PC + Imm_Ext;
                end
                else begin
                end
                nState <= 0;
            end
            else if(`OPCODE == `BNE) begin
                if(ALU_InA != ALU_InB) begin
                    nPC <= PC + Imm_Ext;
                end
                else begin
                end
                nState <= 0;
            end
            else begin
            end
        end
        3: begin
            nState <= 2'd0;
            if((Format == Instr_Format_R) || (`OPCODE == `ADDI) 
                    || (`OPCODE == `ANDI) || (`OPCODE == `ORI)) begin
                RegW <= 1;
             end
             else if(`OPCODE == `SW) begin
                 CS <= 1;
                 WE <= 1;
                 Writing <= 1;
             end
             else if(`OPCODE == `LW) begin
                 CS <= 1;
                 nState <= 4;
             end
             else begin
             end
         end
        4: begin
            nState <= 0;
            CS <= 1;
            if(`OPCODE == `LW) begin
                RegW <= 1;
            end
            else begin
            end
        end
        default: begin
        end
        endcase
    end /* always */

    always @(posedge CLK, posedge RST) begin
        if(RST) begin
            State <= 0;
            PC <= 32'd0;
        end
        else begin
            State <= nState;
            PC <= nPC;
       
		 case(State)
            0: begin
                Instr <= Mem_Bus;
            end
            1: begin    
                OpSave <= Op;
                REGorIMM_Save <= REGorIMM;
                ALUorMEM_Save <= ALUorMEM;
            end
            2: begin
                ALU_Result_Save <= ALU_Result;
            end
            default: begin
            end
        endcase
		  
		   end
	
    end /* always */

endmodule /* two_input_mux */
