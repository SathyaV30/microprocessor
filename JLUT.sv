module JLUT(
    input [2:0] Jptr,
    output reg [5:0] Jump
);

    localparam ADDR_LOOP_I   = 8'd0;  
    localparam ADDR_LOOP_J   = 8'd4;
    localparam ADDR_UPDATE_MAX = 8'd24;
    localparam ADDR_UPDATE_MIN = 8'd27;
    localparam ADDR_END_J     = 8'd29;
    localparam ADDR_X         = 8'd255; // error address

    always @(*) begin
        case(Jptr)
            3'b000: Jump = ADDR_LOOP_I;    // Mapping to Loop_i
            3'b001: Jump = ADDR_LOOP_J;    // Mapping to Loop_j
            3'b010: Jump = ADDR_UPDATE_MAX;// Mapping to Update_max
            3'b011: Jump = ADDR_UPDATE_MIN;// Mapping to Update_min
            3'b100: Jump = ADDR_END_J;     // Mapping to End_j
            3'b110: Jump = ADDR_X;         // Undefined, mapped to error or default
            3'b111: Jump = ADDR_X;         // Undefined, mapped to error or default
            default: Jump= ADDR_X;        // Fallback to an undefined address
        endcase
    end
endmodule
