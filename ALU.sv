module ALU(
    input [2:0] Aluop,     // ALU opcode
    input [7:0] RdatA,      // Input RdatA A (R0 to R7)
    input [7:0] RdatB,      // Input RdatA B (R0 to R7)
    input [7:0] R7,        // Branch register R7
    input  logic  Inc,
  	
  output logic [7:0] WdatR, // Result of ALU operation
  output logic 	Jen
  

);
  

    

always_comb begin
    WdatR = 8'b0;  // Default result is zero
	Jen = 1'b0;

    case (Aluop)
        3'b000: // AND operation
            WdatR = RdatA & RdatB;
        
        3'b001: // ADD operation
            if (Inc) begin
                WdatR = RdatA + 8'd1;  // Increment RdatA by 1 
            end else begin
                WdatR = RdatA + RdatB;  // Normal ADD operation
            end
        3'b010: // BLTE operation
          Jen = (R7 <= RdatA) ? 1'b1 : 1'b0;  // Branch if R7 <= RdatA
        
        3'b011: // Xor operation
            WdatR = RdatA ^ RdatB;

        3'b100: // CNT operation (Count set bits in RdatB)
            WdatR = count_set_bits(RdatB);
        
        3'b101: // LDM operation
            WdatR = RdatB; // Pass through
        
        3'b110: // STM operation
            WdatR = RdatA; // Pass through
        
        3'b111: // BGTE operation
            Jen = (R7 >= RdatA) ? 1'b1 : 1'b0;  // Branch if R7 >= RdatA

        default:
            WdatR = 8'b0;
    endcase
end

function [7:0] count_set_bits(input [7:0] value);
  
    integer i;
    begin
        count_set_bits = 0;
        for (i = 0; i < 8; i++) begin
            count_set_bits = count_set_bits + value[i];
        end
    end
endfunction


endmodule
