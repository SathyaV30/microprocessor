module RegFile(
    input        Clk,      // Clock signal
    input        WenR,     // Write enable signal
    input  [2:0] Ra,       // Read register address for port A
    input  [2:0] Rb,       // Read register address for port B
    input  [2:0] Wd,       // Write register address
    input  [7:0] WdatR,    // Data to write
    input        start,
    input        useImm1,   // Wheter to use immediate for Register A
    input        useImm2, //Whether to use immediate for Register B
    input  [7:0] Rdat,
    input        Ldr,
    input        Str,
  	input	     nearEnd, // TEMP VARIABLE FOR DEBUG
    output [7:0] RdatA,    // Data read from address Ra
    output [7:0] RdatB,    // Data read from address Rb
    output [7:0] R7        // Data from register R7
  
);

    parameter NUM_REGS = 8;   // Total number of registers
    parameter REG_WIDTH = 8;  // Width of each register
    parameter NUM_IMM = 4;    // Number of immediate values

    // Register array
    reg [REG_WIDTH-1:0] registers[NUM_REGS-1:0];
    // Immediate values array
   // reg [REG_WIDTH-1:0] immediates[NUM_IMM-1:0] = {8'd62, 8'd66, 8'd67}; 
   logic [7:0] immediate;
   assign immediate = (Rb == 3'b010) ? 8'd66 :
                   (Rb == 3'b011) ? 8'd67 :
     (Ra == 3'b101) ? 8'd60 : 8'd0;  



    // only 1 immediate per instruction
    assign RdatA = useImm1 ? immediate : registers[Ra];
    assign RdatB = useImm2 ? immediate : registers[Rb];
    assign R7 = registers[7]; 

    always_ff @(posedge Clk) begin
      
      /* if (nearEnd) begin
           $display("Time: %t, R0: %d, R1: %d, R2: %d, R3: %d, R4: %d, R5: %d, R6: %d, R7: %d",$time, registers[0], registers[1], registers[2], registers[3],
          registers[4], registers[5], registers[6], registers[7]);
        
                    end
                    
                    */

        if (start) begin
            registers[0] <= 8'd0;  
            registers[1] <= 8'd0;
            registers[2] <= 8'd16;
            registers[3] <= 8'd0;
            registers[4] <= 8'd0;
            registers[5] <= 8'd0;
            registers[6] <= 8'd0;
            registers[7] <= 8'd0;
        end else
        if (WenR && !Ldr) begin
            registers[Wd] <= WdatR;
        end else if (Ldr) begin
            registers[Wd] <= Rdat;
         // $display("Time: %t, Loaded Data (Rdat): %d into register %0d", $time, Rdat, Wd);
        end 
    end

endmodule
