// sample top level design
module top_level(
  input        clk, reset, 
  output logic done);
  parameter D = 12,             // program counter width
    A = 3;             		  	  // ALU command bit width
  wire[D-1:0] target, 			  // jump 
              prog_ctr;
  wire        RegWrite;
  wire[7:0]   datA,datB,		  // from RegFile
              muxA, 				  // mux for dataOut vs rslt
				  rslt,				  // result from ALU
				  writeData;		  // write for dataOut
				  
  logic 		  sc_in,   				       // shift/carry out from/to ALU
				  pariQ,              	    // registered parity flag from ALU
		        zeroQ,							 // registered zero flag from ALU 
		        br_logic;                    
  wire        relj;                     // from control to PC; relative jump enable
  wire        pari,
              zero,
		        sc_clr,
		        sc_en,
              MemWrite,						// immediate switch
              ALUSrc,
				  MemtoReg, 
		        br_flag;
  wire[2:0]   alu_cmd;
  wire[8:0]   mach_code;          // machine code
  wire[2:0]   rd_addrA, rd_addrB;  // address pointers to reg_file CHANGING TO 2 BITS FOR SOURCE REGISTER
  wire[1:0]   immed;					//immed command
// fetch subassembly
  PC #(.D(D)) 					  // D sets program counter width
     pc1 (.reset           ,
       .clk              ,
		 .reljump_en (relj),
		 .target     (target),
		 .prog_ctr          );

// lookup table to facilitate jumps/branches
  PC_LUT #(.D(D))
    pl1 (.addr  (mach_code[5:0]), //how_high
         .target (target));   

// contains machine code
  instr_ROM ir1(.prog_ctr (prog_ctr),
               .mach_code (mach_code));

// control decoder
  Control ctl1(.instr	 (mach_code[8:6]), 
					.Branch   (relj), 
					.MemWrite , 
					.ALUSrc   ,
				   .br_logic ,
					.RegWrite ,
					.MemtoReg ,
					.ALUOp (alu_cmd));
					

  assign rd_addrA = mach_code[5:3];
  assign rd_addrB = mach_code[2:0];
  assign alu_cmd  = mach_code[8:6];
  assign immed    = mach_code[1:0];

  reg_file #(.pw(3)) rf1(.dat_in(muxA),	   // loads, most ops
              .clk         ,
              .wr_en   (RegWrite),
              .rd_addrA(rd_addrA),
              .rd_addrB(rd_addrB),
              .wr_addr (rd_addrA),      // in place operation
              .datA_out(datA),
              .datB_out(datB)); 
				  
  assign muxA = MemtoReg? writeData : rslt;

  alu alu1(.alu_cmd(alu_cmd),
		 .immed      (immed),
		 .direct	    (mach_code[2]),
		 .moveControl(mach_code[2]),
       .inA        (datA),
		 .inB        (datB),
		 .rslt       ,
		 .br_logic   (br_flag));  
	
  dat_mem dm1(.dat_in(datA)  ,  // from reg_file
             .clk           ,
			    .wr_en  (MemWrite), // stores
			    .addr   (rslt), //store result data //was initially given as datA??? 
             .dat_out(writeData));

// registered flags from ALU
  always_ff @(posedge clk) begin
//  pariQ <= pari;
//	 zeroQ <= zero;
	 br_logic <= br_flag;
	 
 
  end

  assign done = prog_ctr == 128;
 
endmodule
