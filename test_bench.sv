// program 1    CSE141L   min & max Hamming distances in double precision data pairs
module test_bench;

// connections to DUT: clock, start (request), done (acknowledge) 
  bit  clk,
       start = 'b1;
  wire done;

  logic[ 4:0] Dist, Min, Max;	// current, min, max Hamming distances
  logic[ 4:0] Min1, Min2;	 	// addresses of pair w/ smallest Hamming distance
  logic[ 4:0] Max1, Max2;		// addresses of pair w/ largest Hamming distance
  logic[15:0] Tmp[32];		    // cache of 16-bit values assembled from data_mem

  top_level D1(.Clk  (clk  ),	        // your design goes here
		 .start(start),
		 .Done(done )); 

  always begin
    #50ns clk = 'b1;
	#50ns clk = 'b0;
  end

  initial begin
    $dumpfile("dump.vcd"); $dumpvars;
// load operands for program 1 into data memory
// 32 double-precision operands go into data_mem [0:63]
// first operand = {data_mem[0],data_mem[1]}  
//   endian order doesn't matter for program 1, as long as consistent for all values (why?)
    #100ns;
	Min = 'd16;						         // start test bench Min at max value
	Max = 'd0;						         // start test bench Max at min value
    for(int i=0; i<32; i++) begin
      {D1.dm.core[2*i],D1.dm.core[2*i+1]} = $random;  
      Tmp[i] = {D1.dm.core[2*i],D1.dm.core[2*i+1]};
      $display("%d:  %b",i,Tmp[i]);
	end


    D1.dm.core[66] = 'd0;		             // preset DUT final Min to max possible
    D1.dm.core[67] = 'd64;

// 	compute correct answers
    for(int j=0; j<32; j++) begin
      for(int k=j+1; k<32; k++) begin
	    #1ns Dist = ham(Tmp[j],Tmp[k]);
        if(Dist<Min) begin                   // update Hamming minimum
          Min = Dist;						 //   value
		  Min2 = j;							 //	  location of data pair
		  Min1 = k;							 //         "
		end  
		if(Dist>Max) begin 			         // update Hamming maximum
		  Max = Dist;						 //   value
		  Max2 = j;							 //   location of data pair
		  Max1 = k;							 //			"
        end
	  end
    end   
	#200ns start = 'b0; 
    #200ns wait (done);						 // avoid false done signals on startup
    $display("Found Min: %d", D1.dm.core[64]);
    $display("Found Max: %d", D1.dm.core[65]);

// check results in data_mem[64] and [65] (Minimum and Maximum distances, respectively)
    if(Min == D1.dm.core[64]) $display("good Min = %d",Min);
	else                      $display("fail Min = %d",Min);
                              $display("Min addr = %d, %d",Min1, Min2);
							  $display("Min valu = %b, %b",Tmp[Min1],Tmp[Min2]);//{D1.dm.core[2*Min1],D1.dm.core[2*Min1+1]},{D1.dm.core[2*Min2],D1.dm.core[2*Min2+1]});
	if(Max == D1.dm.core[65]) $display("good Max = %d",Max);
	else                      $display("MAD  Max = %d",Max);
	                          $display("Max pair = %d, %d",Max1, Max2);
							  $display("Max valu = %b, %b",Tmp[Max1],Tmp[Max2]);//{D1.dm.core[2*Max1],D1.dm.core[2*Max1+1]},{D1.dm.core[2*Max2],D1.dm.core[2*Max2+1]});
    #200ns start = 'b1;
// to do: load operands for program 2 into data memory (reuse program 1 operands is fine here)
	#200ns start = 'b0;
	$stop;
  end

// Hamming distance (anticorrelation) between two 16-bit numbers 
  function[4:0] ham(input[15:0] a, b);
    ham = 'b0;
    for(int q=0;q<16;q++)
      if(a[q]^b[q]) ham++;	                // count number of bits for which a[i] = !b[i]
  endfunction

endmodule