LIBRARY ieee;
USE ieee.std_logic_1164.all;

	Entity controlUnit is
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
			
	end controlUnit;
	
	Architecture Behavior of controlUnit is
	
		TYPE S_TYPE IS (Idle,WaitPipe1,WaitPipe2,FirstSample,OutputValid,WaitPipe1Last,WaitPipe2Last,OutputValidLast);
		SIGNAL STATE : S_TYPE;
						
		
		Begin 
		
		STATE_PROCESS : PROCESS (Reset_Asy_n,CLK)
			BEGIN
			-- process for current state update

			IF (Reset_Asy_n='0') THEN
						STATE <= Idle;
						
			ELSIF (CLK'EVENT AND CLK = '1') THEN
			
				 CASE STATE IS
				 
				 WHEN Idle =>  IF (V_in = '1') THEN 
						  STATE <= WaitPipe1;
					       ELSIF (V_in = '0') THEN
						  STATE <= Idle;
					       END IF;	
								
				 WHEN WaitPipe1 =>  STATE<= WaitPipe2;
				 
				 WHEN WaitPipe2 => STATE<= FirstSample;
				 
				 WHEN FirstSample => STATE <= OutputValid;

				 WHEN OutputValid => IF (V_in = '1') THEN 
							STATE <= OutputValid;
						     ELSIF (V_in = '0') THEN
							STATE <= WaitPipe1Last;
		             			     END IF;
	
				 WHEN WaitPipe1Last =>  STATE <= WaitPipe2Last;

				 WHEN WaitPipe2Last =>  STATE <= OutputValidLast;

				 WHEN OutputValidLast => STATE <= Idle;
					
									
	
				END CASE;
			END IF;
		END PROCESS STATE_PROCESS;
	
		OUTPUT_PROCESS : PROCESS (STATE)

			BEGIN
			Res_sw0_FIR <='0';	
			Ld_sw0_FIR <='0';
			Res_sw1_FIR<='0';
			Ld_sw1_FIR<='0';
			Res_sw2_FIR<='0';
			Ld_sw2_FIR<='0';
			Res_sw0_IIR<='0';				
			Ld_sw0_IIR<='0';
			Res_sw1_IIR<='0';
			Ld_sw1_IIR<='0';
			Res_sw2_IIR<='0';
			Ld_sw2_IIR<='0';
			Res_PIPE0_FIR<='0';	
			Ld_PIPE0_FIR<='0';
			Res_PIPE1_FIR<='0';
			Ld_PIPE1_FIR<='0';
			Res_PIPE2_FIR<='0';		
			Ld_PIPE2_FIR<='0';
			Res_PIPE3_FIR<='0';
			Ld_PIPE3_FIR<='0';
			Load_input<='1';
			Load_output<='0';
			VOUT<='0';
			
			CASE STATE IS
	                    WHEN Idle => 		
					Res_sw0_FIR<= '1';	
					Res_sw1_FIR<='1';
					Res_sw2_FIR<= '1';
					Res_sw0_IIR<= '1';				
					Res_sw1_IIR<= '1';
					Res_sw2_IIR<= '1';
					Res_PIPE0_FIR<= '1';
					Res_PIPE1_FIR<= '1';
					Res_PIPE2_FIR<= '1';		
					Res_PIPE3_FIR<= '1';
								
 	                     WHEN WaitPipe1  => 	
						Ld_sw0_FIR<= '1';
						Ld_sw1_FIR<= '1';
						Ld_sw2_FIR<= '1';				
						Ld_sw0_IIR<= '1';
						Ld_sw1_IIR<= '1';
						Ld_sw2_IIR<= '1';
						Ld_PIPE0_FIR<= '1';
						Ld_PIPE1_FIR<= '1';	
						Ld_PIPE2_FIR<= '1';
						Ld_PIPE3_FIR<= '1';
				
			    WHEN WaitPipe2 => 
						Ld_sw0_FIR<= '1';
						Ld_sw1_FIR<= '1';
						Ld_sw2_FIR<= '1';				
						Ld_sw0_IIR<= '1';
						Ld_sw1_IIR<= '1';
						Ld_sw2_IIR<= '1';
						Ld_PIPE0_FIR<= '1';
						Ld_PIPE1_FIR<= '1';	
						Ld_PIPE2_FIR<= '1';
						Ld_PIPE3_FIR<= '1';


			    WHEN FirstSample => Load_output <= '1';
						Ld_sw0_FIR<= '1';
						Ld_sw1_FIR<= '1';
						Ld_sw2_FIR<= '1';				
						Ld_sw0_IIR<= '1';
						Ld_sw1_IIR<= '1';
						Ld_sw2_IIR<= '1';
						Ld_PIPE0_FIR<= '1';
						Ld_PIPE1_FIR<= '1';	
						Ld_PIPE2_FIR<= '1';
						Ld_PIPE3_FIR<= '1';	

 	                 WHEN OutputValid => 	VOUT <= '1';
						Load_output <= '1';
						Ld_sw0_FIR<= '1';
						Ld_sw1_FIR<= '1';
						Ld_sw2_FIR<= '1';				
						Ld_sw0_IIR<= '1';
						Ld_sw1_IIR<= '1';
						Ld_sw2_IIR<= '1';
						Ld_PIPE0_FIR<= '1';
						Ld_PIPE1_FIR<= '1';	
						Ld_PIPE2_FIR<= '1';
						Ld_PIPE3_FIR<= '1'; 

			  WHEN WaitPipe1Last => VOUT <= '1';
						Load_output <= '1';
						Ld_sw0_FIR<= '1';
						Ld_sw1_FIR<= '1';
						Ld_sw2_FIR<= '1';				
						Ld_sw0_IIR<= '1';
						Ld_sw1_IIR<= '1';
						Ld_sw2_IIR<= '1';
						Ld_PIPE0_FIR<= '1';
						Ld_PIPE1_FIR<= '1';	
						Ld_PIPE2_FIR<= '1';
						Ld_PIPE3_FIR<= '1';

			  WHEN WaitPipe2Last => VOUT <= '1';
						Load_output <= '1';
						Ld_sw0_FIR<= '1';
						Ld_sw1_FIR<= '1';
						Ld_sw2_FIR<= '1';				
						Ld_sw0_IIR<= '1';
						Ld_sw1_IIR<= '1';
						Ld_sw2_IIR<= '1';
						Ld_PIPE0_FIR<= '1';
						Ld_PIPE1_FIR<= '1';	
						Ld_PIPE2_FIR<= '1';
						Ld_PIPE3_FIR<= '1';
				
			  WHEN OutputValidLast => VOUT <= '1';
						Load_output <= '1';
						Ld_sw0_FIR<= '1';
						Ld_sw1_FIR<= '1';
						Ld_sw2_FIR<= '1';				
						Ld_sw0_IIR<= '1';
						Ld_sw1_IIR<= '1';
						Ld_sw2_IIR<= '1';
						Ld_PIPE0_FIR<= '1';
						Ld_PIPE1_FIR<= '1';	
						Ld_PIPE2_FIR<= '1';
						Ld_PIPE3_FIR<= '1'; 					
											 
			END CASE;
		END PROCESS OUTPUT_PROCESS;
				
	End Behavior;	
		
		
