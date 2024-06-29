module DMem(
  input Clk,WenD,
  input[7:0] WdatD,
             RdatA,
  			 RdatB,
  output logic[7:0] Rdat);

  logic[7:0] core[256];

  always_ff @(posedge Clk)
    if(WenD) core[RdatB] <= RdatA;


  assign Rdat = core[RdatB];

      always_ff @(posedge Clk) begin
       // $display("Time: %t, Memory Read: Addr = %d, Data = %d", $time, RdatB, Rdat);
    end

endmodule


