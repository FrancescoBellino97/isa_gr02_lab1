LIBRARY ieee;
USE ieee.std_logic_1164.all;

	Entity controlUnit is
		port(
			CLK: in std_logic;
			Reset_Asy_n: in std_logic;
			V_in: in std_logic;
			Res_sw0,Res_sw1: out std_logic;
			Load_sw0,Load_sw1: out std_logic;
			Load_input,Load_output: out std_logic;
			VOUT: out std_logic);
			
	end controlUnit;
	
	Architecture Behavior of controlUnit is
	
		TYPE S_TYPE IS (Idle,ComputeSamples,OutputValidLast,OutputValid);
		SIGNAL STATE : S_TYPE;
						
		
		Begin 
		
		STATE_PROCESS : PROCESS (Reset_Asy_n,CLK)
			BEGIN
			IF (Reset_Asy_n='0') THEN
						STATE <= Idle;
						
			ELSIF (CLK'EVENT AND CLK = '1') THEN
			
				 CASE STATE IS
				 
				 WHEN Idle =>  IF (V_in = '1') THEN 
								     STATE <= ComputeSamples;
									ELSE 
									  STATE <= Idle;
									END IF;	
								
				 WHEN ComputeSamples =>  IF (V_in = '1') THEN 
								     STATE <= OutputValid;
									ELSE 
									  STATE <= OutputValidLast;
									END IF;
									
				 WHEN OutputValidLast => STATE <= Idle;
					
									
				 WHEN OutputValid =>  IF (V_in = '1') THEN 
								     STATE <= ComputeSamples;
									ELSE 
									  STATE <= Idle;
									END IF;	
									
				END CASE;
			END IF;
		END PROCESS STATE_PROCESS;
	
		OUTPUT_PROCESS : PROCESS (STATE)
			BEGIN
     
			CASE STATE IS
	        WHEN Idle => Res_sw0 <= '1';
								Res_sw1<= '1';
								Load_input<= '1';		
								Load_sw0<= '0';
								Load_sw1 <= '0';
								Load_output <= '0';
								VOUT <= '0';
								
 	         WHEN ComputeSamples => Res_sw0 <= '0';
											  Res_sw1<= '0';
											  Load_sw0<= '1';
											  Load_sw1<= '1';
											  Load_output <= '1';
											  
				WHEN OutputValidLast =>    VOUT <= '1';
											  --Load_output <= '0';							  
 	         WHEN OutputValid => 	  
											  VOUT <= '1';
											  --Load_output <= '0';
			END CASE;
		END PROCESS OUTPUT_PROCESS;
				
	End Behavior;	
		
		