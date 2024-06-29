module Ctrl(
    input        [8:0] mach_code, // 9-bit machine code input
    output logic [2:0] Aluop,     // ALU operation code
    output logic [2:0] Jptr,      // Jump pointer (for branches)
    output logic [2:0] Ra,        // Register address A for reading
    output logic [2:0] Rb,        // Register address B for reading
    output logic [2:0] Wd,        // Write register address
    output logic       WenR,      // Write enable for the register file
    output logic       WenD,      // Write enable for data memory
    output logic       Ldr,       // Load from memory to reg
    output logic       Str,       // Store from reg to memory
    output logic       Inc,       // Increment flag
    output logic       useImm1,   // Whether to use the immediate for register A
    output logic       useImm2    // Whether to use the immediate for register B
);

    
    always_comb begin
        // Default assignments
        Aluop = 3'b0;
        Jptr = 3'b0;
        Ra = 3'b0;
        Rb = 3'b0;
        Wd = 3'b0;
        WenR = 1'b0;
        WenD = 1'b0;
        Ldr = 1'b0;
        Str = 1'b0;
        Inc = 1'b0;
        useImm1 = 1'b0;
        useImm2 = 1'b0;

        case (mach_code[8:6])
            3'b000: begin // AND
                Aluop = 3'b000;
                Ra = mach_code[5:3];
                Rb = mach_code[2:0];
                Wd = Ra;
                WenR = 1;
            end
            3'b001: begin // ADD
                Aluop = 3'b001;
                Ra = mach_code[5:3];
                Rb = mach_code[2:0];
                Wd = Ra;
                WenR = 1;
                Inc = (Ra == Rb);  // Set increment flag if Ra == Rb
            end
            3'b010: begin // BLTE
                Aluop = 3'b010;
                Ra = mach_code[5:3];
                Rb = mach_code[2:0];
                Jptr = Rb;
                useImm1 = (Ra == 3'b101);
            end
            3'b011: begin // XOR
                Aluop = 3'b011;
                Ra = mach_code[5:3];
                Rb = mach_code[2:0];
                Wd = Ra;
                WenR = 1;
            end
            3'b100: begin // CNT
                Aluop = 3'b100;
                Ra = mach_code[5:3];
              	Rb = mach_code[2:0];
                Wd = Ra;
                WenR = 1;
            end
            3'b101: begin // LDM (Load from Memory)
                Ldr = 1;
                Ra = mach_code[5:3];
                Rb = mach_code[2:0];
                Wd = Ra;
                useImm2 = (Rb == 3'b011 || Rb == 3'b010);
                WenR = 1;
               	Aluop = 3'b101;
            end
            3'b110: begin // STM (Store to Memory)
                Str = 1;
                Rb = mach_code[5:3];
                Ra = mach_code[2:0];
                WenD = 1;
              	Aluop = 3'b110;
            end
            3'b111: begin // BGTE
                Aluop = 3'b111;
                Ra = mach_code[5:3];
                Rb = mach_code[2:0];
                Jptr = Rb;
                useImm1 = (Ra == 3'b101);
            end
        endcase
    end
endmodule
