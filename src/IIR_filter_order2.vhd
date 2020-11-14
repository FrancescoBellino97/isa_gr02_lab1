LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
 
	Entity IIR_filter_order2 is
		--GENERIC ( N : integer:=11);
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
	signal R_sw0,R_sw1,L_sw0,L_sw1,L_in,L_out: std_logic;

	
	--component declaration
		Component datapath_IIR is
		GENERIC ( N : integer:=11;
					 N_internal: integer :=6);
			port(
				Clk: in std_logic;
				DIN: in signed(N-1 downto 0);
				Reset_sw0: in std_logic;
				Reset_sw1: in std_logic;
				Load_sw1: in std_logic;
				Load_sw0: in std_logic;
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
			Res_sw0,Res_sw1: out std_logic;
			Load_sw0,Load_sw1: out std_logic;
			Load_input,Load_output: out std_logic;
			VOUT: out std_logic);
		end component;
				
		BEGIN
			
			CU: controlUnit PORT MAP(Clk,Rst_n,VIN,R_sw0,R_sw1,L_sw0,L_sw1,L_in,L_out,Vout);

			Execution_unit: datapath_IIR PORT MAP(Clk,DIN,R_sw0,R_sw1,L_sw1,L_sw0,L_in,L_out,DOUT);
		


	End Structural;
		