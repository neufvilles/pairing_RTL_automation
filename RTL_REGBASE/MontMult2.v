`include "./include/parameter.vh"
module MontMult2(
	         input wire clk,
	         input wire rst,
	         input wire [`WORD_SIZE-1: 0] a0,
	         input wire [`WORD_SIZE-1: 0] a1,
	         input wire [`WORD_SIZE-1: 0] b0,
	         input wire [`WORD_SIZE-1: 0] b1,
	         output wire [`WORD_SIZE-1: 0] c0,
	         output wire [`WORD_SIZE-1: 0] c1
	         );

   parameter mult_stages = 2;				// usual 256 multiplier stages
   parameter halfmult_stages = 2;		// constant and half-width-result multiplier
   parameter constmult_stages = 2;			// full constant 256 multiplier

   /////////////////////////////////////// step 1
   wire [`WORD_SIZE*2-1:0]                     mulT0_out, mulT1_out;
   reg [`WORD_SIZE*2-1:0]                      T0, T1;
   wire [`WORD_SIZE-1:0]                       addmodt0_out, addmodt1_out;
   reg [`WORD_SIZE-1:0]                        t0, t1;

   // PATH A
   DW02_mult_2_stage #(`WORD_SIZE, `WORD_SIZE)
   mulT0(
	 .CLK(clk),
	 .TC(1'b0),
	 .A(a0),
	 .B(b0),
	 .PRODUCT(mulT0_out)
	 );
   // PATH B
   DW02_mult_2_stage #(`WORD_SIZE, `WORD_SIZE)
   mulT1(
	 .CLK(clk),
	 .TC(1'b0),
	 .A(a1),
	 .B(b1),
	 .PRODUCT(mulT1_out)
	 );
   // PATH C
   AddSubMod addmodt0(a0,a1,1'b0,addmodt0_out);
   AddSubMod addmodt1(b0,b1,1'b0,addmodt1_out);

   always @(posedge clk or negedge rst) begin
      if (!rst) begin
	 T0 <= 0;
	 T1 <= 0;
	 t0 <= 0;
	 t1 <= 0;
      end
      else begin
	 T0 <= mulT0_out;
	 T1 <= mulT1_out;
	 t0 <= addmodt0_out;
	 t1 <= addmodt1_out;

      end
   end

   ////////////////////////////////////////////// step 2
   wire [`WORD_SIZE*2-1:0] mulT2_out, addT3_out, subT4_out;
   reg [`WORD_SIZE*2-1:0]  T2, T3, T4;

   DW02_mult_2_stage #(`WORD_SIZE, `WORD_SIZE)
   mulT2(
	 .CLK(clk),
	 .TC(1'b0),
	 .A(t0),
	 .B(t1),
	 .PRODUCT(mulT2_out)
	 );
   AddSubModDP addmodDPT3(T0,T1,1'b0,addT3_out);
   AddSubModDP sudmodDPT4(T0,T1,1'b1,subT4_out);

   always @(posedge clk or negedge rst) begin
      if (!rst) begin
	 T2 <= 0;
	 T3 <= 0;
	 T4 <= 0;
      end
      else begin
	 T2 <= mulT2_out;
	 T3 <= addT3_out;
	 T4 <= subT4_out;
      end
   end

   ////////////////////////////////////////////// step 3
   wire [`WORD_SIZE*2-1:0] subT3p_out, XY1_pipeline_out, XY2_pipeline_out;
   wire [`WORD_SIZE-1:0]   XY1_half_pipeline_out, XY2_half_pipeline_out;

   AddSubModDP sudmodDPT3p(T2,T3,1'b1,subT3p_out);

   DW03_pipe_reg #(constmult_stages+halfmult_stages+1 ,`WORD_SIZE*2)
   XY1_pipeline( .clk(clk), .A(T4), .B(XY1_pipeline_out) );

   DW03_pipe_reg #(constmult_stages+halfmult_stages+1 ,`WORD_SIZE*2)
   XY2_pipeline( .clk(clk), .A(subT3p_out), .B(XY2_pipeline_out) );

   DW03_pipe_reg #(1, `WORD_SIZE)
   XY1_half_reg(
		.clk(clk),
		.A(T4[`WORD_SIZE-1:0]),
		.B(XY1_half_pipeline_out)
		);
   DW03_pipe_reg #(1, `WORD_SIZE)
   XY2_half_reg(
		.clk(clk),
		.A(subT3p_out[`WORD_SIZE-1:0]),
		.B(XY2_half_pipeline_out)
		);


   ///////////////////////////////// step 4: obtain t= XY*W modR with constant multiplication (CHAR_INV)
   wire [`WORD_SIZE*2-1: 0] mulXYW1_out, mulXYW2_out;
   reg [`WORD_SIZE-1: 0]    XYW1, XYW2;
   DW02_mult_2_stage #(`WORD_SIZE, `WORD_SIZE)
   mulXYW1(
	   .CLK(clk),
	   .TC(1'b0),
	   .A(XY1_half_pipeline_out),
	   .B(`CHAR_INV),
	   .PRODUCT(mulXYW1_out)
	   );
   DW02_mult_2_stage #(`WORD_SIZE, `WORD_SIZE)
   mulXYW2(
	   .CLK(clk),
	   .TC(1'b0),
	   .A(XY2_half_pipeline_out),
	   .B(`CHAR_INV),
	   .PRODUCT(mulXYW2_out)
	   );
   always @(posedge clk or negedge rst) begin
      if (!rst) begin
	 XYW1 <= 0;
	 XYW2 <= 0;
      end
      else begin
	 XYW1 <= mulXYW1_out[`WORD_SIZE-1:0];
	 XYW2 <= mulXYW2_out[`WORD_SIZE-1:0];
      end
   end

   ///////////////////////////////// step 5: obtain tN with constant multiplication (CHAR)
   wire [`WORD_SIZE*2-1: 0] multN1_out, multN2_out;
   reg [`WORD_SIZE*2-1: 0]  tN1, tN2;
   DW02_mult_2_stage #(`WORD_SIZE, `WORD_SIZE)
   multN1(
	  .CLK(clk),
	  .TC(1'b0),
	  .A(XYW1),
	  .B(`CHAR),
	  .PRODUCT(multN1_out)
	  );
   DW02_mult_2_stage #(`WORD_SIZE, `WORD_SIZE)
   multN2(
	  .CLK(clk),
	  .TC(1'b0),
	  .A(XYW2),
	  .B(`CHAR),
	  .PRODUCT(multN2_out)
	  );
   always @(posedge clk or negedge rst) begin
      if (!rst) begin
	 tN1 <= 0;
	 tN2 <= 0;
      end
      else begin
	 tN1 <= multN1_out;
	 tN2 <= multN2_out;
      end
   end

   ///////////////////////////////// step 6: final addition to get the answer
   wire alt1, alt2;

   //////// PATH A: original result
   wire [`WORD_SIZE*2-1: 0] res_org_out1;
   DW01_add	#(`WORD_SIZE*2)
   add_org1(
	    .A( XY1_pipeline_out ),
	    .B( tN1 ),
	    .CI(1'b0),
	    .SUM( res_org_out1 ),
	    .CO( )
	    );
   wire [`WORD_SIZE*2-1: 0] res_org_out2;
   DW01_add	#(`WORD_SIZE*2)
   add_org2(
	    .A( XY2_pipeline_out ),
	    .B( tN2 ),
	    .CI(1'b0),
	    .SUM( res_org_out2 ),
	    .CO( )
	    );

   //////// PATH B: characteristic-subtracted result. if this is larger than zero, this path should be output.
   wire [`WORD_SIZE*2: 0]   res_alt_out1, res_alt_out2;
   wire [`WORD_SIZE*2: 0]   csa1_out0, csa1_out1, csa2_out0, csa2_out1;

   // extra 1bit for sign (to determine the output is >0 or <0)
   DW01_csa #(`WORD_SIZE*2+1)
   csa_alt1(
	    .a( { 1'b0, XY1_pipeline_out } ),
	    .b( { 1'b0, tN1 } ),
	    .c( ~{ 1'b0, `CHAR, { `WORD_SIZE {1'b0} } } ), // -p
	    .ci( 1'b0 ),
	    .carry( csa1_out0 ),
	    .sum( csa1_out1 ),
	    .co( )
	    );
   DW01_add	#(`WORD_SIZE*2+1)
   add_alt1(
	    .A( csa1_out0 ),
	    .B( csa1_out1 ),
	    .CI(1'b1), // added to achieve -p (invert p and add 1)
	    .SUM( res_alt_out1 ),
	    .CO( )
	    );

   DW01_csa #(`WORD_SIZE*2+1)
   csa_alt2(
	    .a( { 1'b0, XY2_pipeline_out } ),
	    .b( { 1'b0, tN2 } ),
	    .c( ~{ 1'b0, `CHAR, { `WORD_SIZE {1'b0} } } ), // -p
	    .ci( 1'b0 ),
	    .carry( csa2_out0 ),
	    .sum( csa2_out1 ),
	    .co( )
	    );
   DW01_add	#(`WORD_SIZE*2+1)
   add_alt2(
	    .A( csa2_out0 ),
	    .B( csa2_out1 ),
	    .CI(1'b1), // added to achieve -p (invert p and add 1)
	    .SUM( res_alt_out2 ),
	    .CO( )
	    );

   // alt = A+B<P flag
   assign alt1 = res_alt_out1[`WORD_SIZE*2];
   assign alt2 = res_alt_out2[`WORD_SIZE*2];

   assign c0 = alt1 ?
	       res_org_out1[`WORD_SIZE*2-1:`WORD_SIZE] :
	       res_alt_out1[`WORD_SIZE*2-1:`WORD_SIZE];
   assign c1 = alt2 ?
	       res_org_out2[`WORD_SIZE*2-1:`WORD_SIZE] :
	       res_alt_out2[`WORD_SIZE*2-1:`WORD_SIZE];

   // always @(posedge clk or negedge rst) begin
   // 	$display(
   // 		"%h",
   // 		// t0 == (a0+a1) % `CHAR &&
   // 		// t1 == (b0+b1) % `CHAR &&
   // 		// T0 == a0*b0 && T1 == a1*b1 &&
   // 		// T2 == ((a0+a1) % `CHAR) * ((b0+b1) % `CHAR) &&
   // 		//subT3p_out % `CHAR == (T2-T3) % `CHAR
   // 		//T4 % `CHAR == (T0-T1) % `CHAR
   // 		XY1_pipeline
   // 	);
   // end

   //
   // always @(posedge clk or negedge rst) begin
   // 	if (!rst) begin
   // 		res_org1 <= 0;
   // 		res_org2 <= 0;
   // 		res_alt1 <= 0;
   // 		res_alt2 <= 0;
   // 	end
   // 	else begin
   // 		res_org <= res_org_out[`WORD_SIZE*2-1: `WORD_SIZE];
   // 		res_alt <= res_alt_out[`WORD_SIZE*2-1: `WORD_SIZE];
   // 		IsLessThanP <= res_alt_out[`WORD_SIZE*2]; // if A+B < P, then this flag is 1.
   // 	end
   // end


endmodule
