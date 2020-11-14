LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
 
	Entity IIR_filter_order2 is
		port(
				Clk: in std_logic;
				DIN: in signed(10 downto 0);
				VIN: in std_logic;
				Rst_n: in std_logic;
				Vout: out std_logic;
				DOUT: out signed(10 downto 0)
				);
				
	end IIR_filter_order2;

	Architecture Structural of IIR_filter_order2 is
	
	--declaration of the signal Output of CU and Input of Datapath
	signal R_sw0_FIR,L_sw0_FIR,R_sw1_FIR,L_sw1_FIR,R_sw2_FIR,L_sw2_FIR: std_logic;
	signal R_sw0_IIR,L_sw0_IIR,R_sw1_IIR,L_sw1_IIR,R_sw2_IIR,L_sw2_IIR: std_logic;
	signal R_PIPE0_FIR,L_PIPE0_FIR,R_PIPE1_FIR,L_PIPE1_FIR,R_PIPE2_FIR,L_PIPE2_FIR,R_PIPE3_FIR,L_PIPE3_FIR: std_logic;
	signal L_in,L_out: std_logic;
	
	--component declaration
		Component datapath_IIR is
		GENERIC ( N : integer:=11;
					N_internal: integer :=7);
			port(
				Clk: in std_logic;
				DIN: in signed(N-1 downto 0);
				Reset_sw0_FIR: in std_logic;	
				Load_sw0_FIR: in std_logic;
				Reset_sw1_FIR: in std_logic;
				Load_sw1_FIR: in std_logic;
				Reset_sw2_FIR: in std_logic;
				Load_sw2_FIR: in std_logic;
				Reset_sw0_IIR: in std_logic;				
				Load_sw0_IIR: in std_logic;
				Reset_sw1_IIR: in std_logic;
				Load_sw1_IIR: in std_logic;
				Reset_sw2_IIR: in std_logic;
				Load_sw2_IIR: in std_logic;
				Reset_PIPE0_FIR: in std_logic;	
				Load_PIPE0_FIR: in std_logic;
				Reset_PIPE1_FIR: in std_logic;
				Load_PIPE1_FIR: in std_logic;
				Reset_PIPE2_FIR: in std_logic;		
				Load_PIPE2_FIR: in std_logic;
				Reset_PIPE3_FIR: in std_logic;
				Load_PIPE3_FIR: in std_logic;
				Load_in: in std_logic;
				Load_out: in std_logic;
				DOUT: out signed(N-1 downto 0)
				);
		end component;
		
		Component controlUnit is
			port(
			CLK: in std_logic;
			Reset_Asy_n: in std_logic;
			V_in: in std_logic;
			Res_sw0_FIR: out std_logic;	
			Ld_sw0_FIR: out std_logic;
			Res_sw1_FIR: out std_logic;
			Ld_sw1_FIR: out std_logic;
			Res_sw2_FIR: out std_logic;
			Ld_sw2_FIR: out std_logic;
			Res_sw0_IIR: out std_logic;				
			Ld_sw0_IIR: out std_logic;
			Res_sw1_IIR: out std_logic;
			Ld_sw1_IIR: out std_logic;
			Res_sw2_IIR: out std_logic;
			Ld_sw2_IIR: out std_logic;
			Res_PIPE0_FIR: out std_logic;	
			Ld_PIPE0_FIR: out std_logic;
			Res_PIPE1_FIR: out std_logic;
			Ld_PIPE1_FIR: out std_logic;
			Res_PIPE2_FIR: out std_logic;		
			Ld_PIPE2_FIR: out std_logic;
			Res_PIPE3_FIR: out std_logic;
			Ld_PIPE3_FIR: out std_logic;
			Load_input,Load_output: out std_logic;
			VOUT: out std_logic);
		end component;
				
		BEGIN
			
			CU: controlUnit PORT MAP(Clk,Rst_n,VIN,
												R_sw0_FIR,	
												L_sw0_FIR,
												R_sw1_FIR,
												L_sw1_FIR,
												R_sw2_FIR,
												L_sw2_FIR,
												R_sw0_IIR,				
												L_sw0_IIR,
												R_sw1_IIR,
												L_sw1_IIR,
												R_sw2_IIR,
												L_sw2_IIR,
												R_PIPE0_FIR,
												L_PIPE0_FIR,
												R_PIPE1_FIR,
												L_PIPE1_FIR,
												R_PIPE2_FIR,		
												L_PIPE2_FIR,
												R_PIPE3_FIR,
												L_PIPE3_FIR,
											 L_in,L_out,Vout);

			Execution_unit: datapath_IIR PORT MAP(Clk,DIN,
																R_sw0_FIR,	
																L_sw0_FIR,
																R_sw1_FIR,
																L_sw1_FIR,
																R_sw2_FIR,
																L_sw2_FIR,
																R_sw0_IIR,				
																L_sw0_IIR,
																R_sw1_IIR,
																L_sw1_IIR,
																R_sw2_IIR,
																L_sw2_IIR,
																R_PIPE0_FIR,
																L_PIPE0_FIR,
																R_PIPE1_FIR,
																L_PIPE1_FIR,
																R_PIPE2_FIR,		
																L_PIPE2_FIR,
																R_PIPE3_FIR,
																L_PIPE3_FIR,
																L_in,L_out,DOUT);
		


	End Structural;
		
