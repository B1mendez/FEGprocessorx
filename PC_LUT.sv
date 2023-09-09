module PC_LUT #(parameter D=12)(
  input       [4:0] addr,	   // target 4 values
  output logic[D-1:0] target);

  always_comb case(addr)
   5'd0: target = 13;   
	5'd1: target = 20;   
	5'd2: target = 1;   
	5'd3: target = 7;
	5'd4: target = 7;
	5'd5: target = 117;
	5'd6: target = 59;
	5'd7: target = 132;
	default: target = 'b0;  // hold PC  
  endcase

endmodule

/*

LookUp table for PROG_2
	module PC_LUT #(parameter D=12)(
  input       [4:0] addr,	   // target 4 values
  output logic[D-1:0] target);

  always_comb case(addr)
   5'd0: target = 16;   // start for loop
	5'd1: target = 408;  // SEC
	5'd2: target = 693;  // DED
	5'd3: target = 720;	// p3END 
	5'd4: target = 428;		// d10
	5'd5: target = 448;		// d9
	5'd6: target = 468;		// d8
	5'd7: target = 484;		// d7
	5'd8: target = 503;		// d6
	5'd9: target = 522;		// d5
	5'd10: target = 540;		// p8
	5'd11: target = 553;		// d4
	5'd12: target = 572;		// d3
	5'd13: target = 589;		// d2
	5'd14: target = 609;		// p4
	5'd15: target = 622;		// d1
	5'd16: target = 638;		// p2
	5'd17: target = 651;		// p1
	5'd18: target = 659;		// ENDSEC
	default: target = 'b0;  // hold PC  
  endcase

endmodule
  */

