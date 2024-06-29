module top_level(
    input        Clk,
    input        start,
    output logic Done
);

    wire [5:0] Jump, PC;
    wire [2:0] Aluop, Ra, Rb, Wd, Jptr;
    wire [8:0] mach_code;
    wire [7:0] RdatA, RdatB, WdatR, WdatD, Rdat, Addr, R7;
    wire       Jen, WenR, WenD, Ldr, Str, useImm1, useImm2, Inc, nearEnd;
  	



    // Program Counter
    ProgCtr PC1(
        .Clk(Clk),
        .start(start),
        .Jen(Jen),
        .Jump(Jump),
      .PC(PC)

    );

    // Instruction ROM
    InstROM IR1(
        .PC(PC),
      .mach_code(mach_code),
      .nearEnd(nearEnd)
    );

    // Control Logic
    Ctrl C1(
        .mach_code(mach_code),
        .Aluop(Aluop),
        .Jptr(Jptr),
        .Ra(Ra),
        .Rb(Rb),
        .Wd(Wd),
        .WenR(WenR),
        .WenD(WenD),
        .Ldr(Ldr),
        .Str(Str),
        .useImm1(useImm1),
        .useImm2(useImm2),
        .Inc(Inc)
    );

    // Register File
    RegFile RF1(
        .Clk(Clk),
        .WenR(WenR),
        .Ra(Ra),
        .Rb(Rb),
        .Wd(Wd),
        .WdatR(WdatR),
        .useImm1(useImm1),
        .useImm2(useImm2),
        .RdatA(RdatA),
        .RdatB(RdatB),
        .Rdat(Rdat),
        .R7(R7),
        .start(start),
        .Ldr(Ldr),
      .Str(Str),
      .nearEnd(nearEnd)
    );

    // Data Memory
    DMem dm(
        .Clk(Clk),
        .WenD(WenD),
        .WdatD(WdatD),
        .RdatA(RdatA), 
      .RdatB(RdatB),
        .Rdat(Rdat)
    );

    // ALU 
    ALU AL1(
        .RdatA(RdatA),
        .RdatB(RdatB),
        .R7(R7),
        .WdatR(WdatR),
        .Aluop(Aluop),
      .Inc(Inc),
      .Jen(Jen)

    );

    // Jump Lookup Table
    JLUT JLU(
        .Jptr(Jptr),
        .Jump(Jump)
    );


    always @(posedge Clk) begin
     
        if (start) begin
            Done <= 0;
        end else if (PC == 6'd43) begin
            Done <= 1;
        end
    end
endmodule
