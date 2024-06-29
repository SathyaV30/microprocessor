module InstROM(
  input[5:0] PC,
  output logic nearEnd,
  output logic[8:0] mach_code);

  logic[8:0] core[64];

  initial begin
	$readmemb("mach_code.txt", core);
  end

  always_comb mach_code = core[PC];
  
  assign nearEnd = PC == 33 ;
  

endmodule