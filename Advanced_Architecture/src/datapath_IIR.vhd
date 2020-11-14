LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
 
	Entity datapath_IIR is
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
				
	end datapath_IIR;

	Architecture Structural of datapath_IIR is
	--constant coefficient of the filter with order 2
	constant coeff_m0_FIR_int : integer := 211;--=b0
	constant coeff_m1_FIR_int : integer := 502; --=b1-((a1*b0)>>(N-1))
	constant coeff_m2_FIR_int : integer := 368; --=b2-((a1*b1)>>(N-1))
	constant coeff_m3_FIR_int : integer :=  79; --=-((a1*b2)>>(N-1))
	constant coeff_m0_IIR_int : integer := -60; --=((a1*a1)>>(N-1))-a2
	constant coeff_m1_IIR_int : integer := -75; --= ((a2*a1)>>(N-1))
	--declaration of the signal connection
	signal d_loaded: signed(N-1 downto 0);
	signal m0_FIR,m1_FIR,m2_FIR,m3_FIR,s0_FIR,s1_FIR,s2_FIR:signed(N_internal-1 downto 0); --signals output from operations(3 SUM + 4 Multiplier) of FIR part
	signal w0_FIR,w1_FIR,w2_FIR,wPIPE0_FIR,wPIPE1_FIR,wPIPE2_FIR,wPIPE3_FIR: signed (N_internal-1 downto 0); --signals output from registers(3R+4PIPE) of FIR part
	signal m0_IIR,m1_IIR,s0_IIR,s1_IIR: signed (N_internal-1 downto 0); --signals output from operations(2SUM+2Multiplier) of IIR part
	signal w0_IIR,w1_IIR,w2_IIR: signed(N_internal-1 downto 0); --signals output from registers(3R) of IIR part
	signal coeff_m0_FIR,coeff_m1_FIR,coeff_m2_FIR,coeff_m3_FIR,coeff_m0_IIR,coeff_m1_IIR: signed (N-1 downto 0);
	signal d_reduced: signed (N_internal-1 downto 0);
	signal y_extended: signed (N-1 downto 0);
	signal coeff_m0_FIR_reduced,coeff_m1_FIR_reduced,coeff_m2_FIR_reduced,coeff_m3_FIR_reduced,coeff_m0_IIR_reduced,coeff_m1_IIR_reduced:signed (N_internal-1 downto 0);
	
	--component declaration
		Component OperationOfMultiplier is
			GENERIC ( N : integer:=7);
			PORT (M_first,M_second: in signed(N-1 DOWNTO 0);
					outM: out signed(N-1 downto 0));
		end component;
		
		Component OperationOfSum is
			GENERIC ( N : integer:=7);
			PORT (Add_first,Add_second: IN signed(N-1 DOWNTO 0);
				outSum: out signed(N-1 downto 0));
		end component;
		
		Component register_data is
			GENERIC ( N : integer:=7);
			PORT ( Clock,Load,Reset: IN STD_LOGIC;
				 datoInput: in signed(N-1 downto 0);
				 datoOutput : OUT signed(N-1 DOWNTO 0));
		end component;
		
		Component regIn_out is
			GENERIC ( N : integer:=11);
			PORT ( Clock,Load: IN STD_LOGIC;
				 datoInput: in signed(N-1 downto 0);
				 datoOutput : OUT signed(N-1 DOWNTO 0));
		end component;
		
		Component shiftRight is
		GENERIC ( N : integer:=11;
					 N_internal: integer :=7);
			port(
				d_in: in signed(N-1 downto 0);
				out_reduced: out signed(N_internal-1 downto 0));
		end component;
		
		Component shiftLeft is
		GENERIC ( N : integer:=11;
					 N_internal: integer :=7);
		port(
				d_in: in signed(N_internal-1 downto 0);
				out_extended: out signed(N-1 downto 0)
				);
		end component;
		
		BEGIN
		
			coeff_m0_FIR <= to_signed(coeff_m0_FIR_int, coeff_m0_FIR'length);
			coeff_m1_FIR <= to_signed(coeff_m1_FIR_int, coeff_m1_FIR'length);
			coeff_m2_FIR <= to_signed(coeff_m2_FIR_int, coeff_m2_FIR'length);
			coeff_m3_FIR <= to_signed(coeff_m3_FIR_int, coeff_m3_FIR'length);
			coeff_m0_IIR <= to_signed(coeff_m0_IIR_int, coeff_m0_IIR'length);
			coeff_m1_IIR <= to_signed(coeff_m1_IIR_int, coeff_m1_IIR'length);

			--reduced the coefficient to the new data bit
			Reduced_coeff_m0FIR: shiftRight PORT MAP(coeff_m0_FIR,coeff_m0_FIR_reduced);
			Reduced_coeff_m1FIR: shiftRight PORT MAP(coeff_m1_FIR,coeff_m1_FIR_reduced);
			Reduced_coeff_m2FIR: shiftRight PORT MAP(coeff_m2_FIR,coeff_m2_FIR_reduced);
			Reduced_coeff_m3FIR: shiftRight PORT MAP(coeff_m3_FIR,coeff_m3_FIR_reduced);
			Reduced_coeff_m0IIR: shiftRight PORT MAP(coeff_m0_IIR,coeff_m0_IIR_reduced);			
			Reduced_coeff_m1IIR: shiftRight PORT MAP(coeff_m1_IIR,coeff_m1_IIR_reduced);
			--input Loaded on architecture
			LoadedInput: regIn_out PORT MAP(Clk,Load_in,DIN,d_loaded);

			--reduced the input to the new data bit
			Input_reduced: shiftRight PORT MAP(d_loaded,d_reduced);
			
			FirstSUM_FIR: OperationOfSum PORT MAP(m0_FIR,m1_FIR,s0_FIR);
			
			SecondSUM_FIR: OperationOfSum PORT MAP(wPIPE0_FIR,wPIPE1_FIR,s1_FIR);
			
			ThirdSUM_FIR: OperationOfSum PORT MAP(s1_FIR,wPIPE2_FIR,s2_FIR);
			
			FirstMultiplier_FIR: OperationOfMultiplier PORT MAP (coeff_m0_FIR_reduced,d_reduced,m0_FIR);
			
			SecondMultiplier_FIR: OperationOfMultiplier PORT MAP (coeff_m1_FIR_reduced,w0_FIR,m1_FIR);
			
			ThirdMultiplier_FIR: OperationOfMultiplier PORT MAP (coeff_m2_FIR_reduced,w1_FIR,m2_FIR);
			
			FourthMultiplier_FIR: OperationOfMultiplier PORT MAP (coeff_m3_FIR_reduced,w2_FIR,m3_FIR);
			
			SW0_FIR: register_data PORT MAP(Clk,Load_sw0_FIR,Reset_sw0_FIR,d_reduced,w0_FIR);
			
			SW1_FIR: register_data PORT MAP(Clk,Load_sw1_FIR,Reset_sw1_FIR,w0_FIR,w1_FIR);
			
			SW2_FIR: register_data PORT MAP(Clk,Load_sw2_FIR,Reset_sw2_FIR,w1_FIR,w2_FIR);
			
			Pipe0_FIR: register_data PORT MAP(Clk,Load_PIPE0_FIR,Reset_PIPE0_FIR,s0_FIR,wPIPE0_FIR);

			Pipe1_FIR: register_data PORT MAP(Clk,Load_PIPE1_FIR,Reset_PIPE1_FIR,m2_FIR,wPIPE1_FIR);
			
			Pipe2_FIR: register_data PORT MAP(Clk,Load_PIPE2_FIR,Reset_PIPE2_FIR,m3_FIR,wPIPE2_FIR);
			
			Pipe3_FIR: register_data PORT MAP(Clk,Load_PIPE3_FIR,Reset_PIPE3_FIR,s2_FIR,wPIPE3_FIR);
			
			FirstSUM_IIR: OperationOfSum PORT MAP(wPIPE3_FIR,s1_IIR,s0_IIR);
			
			SecondSUM_IIR: OperationOfSum PORT MAP(w2_IIR,w1_IIR,s1_IIR);
			
			FirstMultiplier_IIR: OperationOfMultiplier PORT MAP (coeff_m0_IIR_reduced,w0_IIR,m0_IIR);
			
			SecondMultiplier_IIR: OperationOfMultiplier PORT MAP (coeff_m1_IIR_reduced,w0_IIR,m1_IIR);
			
			SW0_IIR: register_data PORT MAP(Clk,Load_sw0_IIR,Reset_sw0_IIR,s0_IIR,w0_IIR);
			
			SW1_IIR: register_data PORT MAP(Clk,Load_sw1_IIR,Reset_sw1_IIR,m0_IIR,w1_IIR);
			
			SW2_IIR: register_data PORT MAP(Clk,Load_sw2_IIR,Reset_sw2_IIR,m1_IIR,w2_IIR);
			
			--extended the output to the initial data bit
			Output_extended: shiftLeft PORT MAP (s0_IIR,y_extended);
					
			--Output value compute loaded on register
			LoadedOutput: regIn_out PORT MAP(Clk,Load_out,y_extended,DOUT);

	End Structural;
		
