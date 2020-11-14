//`timescale 1ns

module testbench ();

   wire CLK_i;
   wire RST_n_i;
   wire [10:0] DIN_i;
   wire VIN_i;
   wire [10:0] DOUT_i;
   wire VOUT_i;
   wire END_SIM_i;

   clk_gen CG(.END_SIM(END_SIM_i),
  	      .CLK(CLK_i),
	      .RST_n(RST_n_i));

   data_maker SM(.CLK(CLK_i),
	         .RST_n(RST_n_i),
		 .VOUT(VIN_i),
		 .DOUT(DIN_i),
		 //.H0(H0_i),
		 //.H1(H1_i),
		 //.H2(H2_i),
		 //.H3(H3_i),
		 .END_SIM(END_SIM_i));

   IIR_filter_order2 UUT(.Clk(CLK_i),
	     .Rst_n(RST_n_i),
	     .DIN(DIN_i),
             .VIN(VIN_i),
             .DOUT(DOUT_i),
             .Vout(VOUT_i));

   data_sink DS(.CLK(CLK_i),
		.RST_n(RST_n_i),
		.VIN(VOUT_i),
		.DIN(DOUT_i));   

endmodule

		   