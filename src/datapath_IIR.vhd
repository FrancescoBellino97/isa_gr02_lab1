LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
 
	Entity datapath_IIR is
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
				
	end datapath_IIR;

	Architecture Structural of datapath_IIR is
	--constant coefficient of the filter with order 2
	constant a1_int : integer := 379;--"00101111011";
	constant a2_int : integer := -200; --"11100111000";
	constant b0_int : integer := 211; --"00011010011";
	constant b1_int : integer := 423; --"00110100111"; 
	constant b2_int : integer := 211; --"00011010011";
	
	--declaration of the signal connection
	signal a1_reduced,a2_reduced,b0_reduced,b1_reduced,b2_reduced: signed (N_internal-1 downto 0);
	signal d_reduced: signed(N_internal-1 downto 0);
	signal d_loaded: signed(N-1 downto 0);
	signal fb,w,m1_fb,m2_fb,w_1,w_2,m0_ff,m1_ff,m2_ff,y,ff :signed(N_internal-1 downto 0);
	signal y_extended: signed(N-1 downto 0);
	signal a1,a2,b0,b1,b2: signed (N-1 downto 0);
	
	--component declaration
		Component OperationOfMultiplier is
			GENERIC ( N : integer:=6);
			PORT (M_first,M_second: in signed(N-1 DOWNTO 0);
					outM: out signed(N-1 downto 0));
		end component;
		
		Component OperationOfSum is
			GENERIC ( N : integer:=6);
			PORT (Add_first,Add_second: IN signed(N-1 DOWNTO 0);
				outSum: out signed(N-1 downto 0));
		end component;
		
		Component register_data is
			GENERIC ( N : integer:=6);
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
					 N_internal: integer :=6);
			port(
				d_in: in signed(N-1 downto 0);
				out_reduced: out signed(N_internal-1 downto 0));
		end component;
		
		Component shiftLeft is
		GENERIC ( N : integer:=11;
					 N_internal: integer :=6);
		port(
				d_in: in signed(N_internal-1 downto 0);
				out_extended: out signed(N-1 downto 0)
				);
		end component;
		
		BEGIN
		
			a1 <= to_signed(a1_int, a1'length);
			a2 <= to_signed(a2_int, a2'length);
			b0 <= to_signed(b0_int, b0'length);
			b1 <= to_signed(b1_int, b1'length);
			b2 <= to_signed(b2_int, b2'length);
			
			--reduced the coefficient to the new data bit
			Reduced_a1: shiftRight PORT MAP(a1,a1_reduced);
			Reduced_a2: shiftRight PORT MAP(a2,a2_reduced);
			Reduced_b0: shiftRight PORT MAP(b0,b0_reduced);
			Reduced_b1: shiftRight PORT MAP(b1,b1_reduced);
			Reduced_b2: shiftRight PORT MAP(b2,b2_reduced);
			
			--input Loaded on architecture
			LoadedInput: regIn_out PORT MAP(Clk,Load_in,DIN,d_loaded);
			
			--reduced the input to the new data bit
			Input_reduced: shiftRight PORT MAP(d_loaded,d_reduced);
			
			FirstSUM_fb: OperationOfSum PORT MAP(d_reduced,fb,w);
			
			SecondSUM_fb: OperationOfSum PORT MAP(m1_fb,m2_fb,fb);
			
			FirstMultiplier_fb: OperationOfMultiplier PORT MAP (a1_reduced,w_1,m1_fb);
			
			SecondMultiplier_fb: OperationOfMultiplier PORT MAP (a2_reduced,w_2,m2_fb);
			
			SW_0: register_data PORT MAP(Clk,Load_sw0,Reset_sw0,w,w_1);
			
			SW_1: register_data PORT MAP(Clk,Load_sw1,Reset_sw1,w_1,w_2);
			
			FirstSUM_ff: OperationOfSum PORT MAP(m0_ff,ff,y);
			
			SecondSUM_ff: OperationOfSum PORT MAP(m1_ff,m2_ff,ff);
			
			FirstMultiplier_ff: OperationOfMultiplier PORT MAP (w,b0_reduced,m0_ff);
			
			SecondMultiplier_ff: OperationOfMultiplier PORT MAP (w_1,b1_reduced,m1_ff);

			ThirdMultiplier_ff: OperationOfMultiplier PORT MAP (w_2,b2_reduced,m2_ff);	
			
			--extended the output to the initial data bit
			Output_extended: shiftLeft PORT MAP (y,y_extended);
			
			--Output value compute loaded on register
			LoadedOutput: regIn_out PORT MAP(Clk,Load_out,y_extended,DOUT);

	End Structural;
		