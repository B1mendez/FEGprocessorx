// sample top level design
module top_level(
  input        clk, reset, 
  output logic done);
  parameter D = 12,             // program counter width
    A = 3;             		  // ALU command bit width
  wire[D-1:0] target, 			  // jump 
              prog_ctr;
  wire        RegWrite;
  wire[7:0]   datA,datB,		  // from RegFile
              muxB, 
					rslt,				// result from ALU
              immed,
				  writeData;
				  
  logic sc_in,   				  // shift/carry out from/to ALU
   		pariQ,              	  // registered parity flag from ALU
		zeroQ;                    // registered zero flag from ALU 
  wire  relj;                     // from control to PC; relative jump enable
  wire  pari,
        zero,
		sc_clr,
		sc_en,
        MemWrite,
        ALUSrc;		              // immediate switch
  wire[A-1:0] alu_cmd;
  wire[8:0]   mach_code;          // machine code
  wire[1:0] rd_addrA, rd_adrB;    // address pointers to reg_file CHANGING TO 2 BITS FOR SOURCE REGISTER
// fetch subassembly
  PC #(.D(D)) 					  // D sets program counter width
     pc1 (.reset            ,
         .clk              ,
		 .reljump_en (relj),
		 .absjump_en (absj),
		 .target     (target),
		 .prog_ctr          );

// lookup table to facilitate jumps/branches
  PC_LUT #(.D(D))
    pl1 (.addr  (mach_code[8:0]), //how_high
         .target (target));   

// contains machine code
  instr_ROM ir1(.prog_ctr,
               .mach_code);

// control decoder
  Control ctl1(.instr(mach_code[8:6]), 
  .Branch  (relj)  , 
  .MemWrite , 
  .ALUSrc   , 
  .RegWrite);

  assign rd_addrA = mach_code[2:0];
  assign rd_addrB = mach_code[5:3];
  assign alu_cmd  = mach_code[8:6];

  reg_file #(.pw(3)) rf1(.dat_in(writeData),	   // loads, most ops
              .clk         ,
              .wr_en   (RegWrite),
              .rd_addrA(rd_addrA),
              .rd_addrB(rd_addrB),
              .wr_addr (rd_addrB),      // in place operation
              .datA_out(datA),
              .datB_out(datB)); 

  alu alu1(.alu_cmd(alu_cmd),
         .inA    (datA),
		 .inB    (datB),
		 .sc_i   (sc),   // output from sc register
		 .rslt   (rslt),
		 .sc_o   (sc_o), // input to sc register
		 .pari  );  
	
  dat_mem dm1(.dat_in(datB)  ,  // from reg_file
             .clk           ,
			 .wr_en  (MemWrite), // stores
			 .addr   (rslt), //store result data //was initially given as datA??? 
             .dat_out(writeData));

// registered flags from ALU
  always_ff @(posedge clk) begin
    pariQ <= pari;
	zeroQ <= zero;
    if(sc_clr)
	  sc_in <= 'b0;
    else if(sc_en)
      sc_in <= sc_o;
  end

  assign done = prog_ctr == 128;
 
endmodule