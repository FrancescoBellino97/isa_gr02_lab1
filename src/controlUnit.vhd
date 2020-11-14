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
	
		-- state and signal declaration of new type TYPE_STATE

		TYPE S_TYPE IS (Idle,FirstSample,OutputValid,OutputValidLast);
		ATTRIBUTE enum_encoding : string;
		ATTRIBUTE enum_encoding of S_TYPE: TYPE is "00 01 10 11";
		signal STATE: S_TYPE;
						
		
		Begin 
		-- process for current state update

		STATE_PROCESS : PROCESS (Reset_Asy_n,CLK)
			BEGIN
			IF (Reset_Asy_n='0') THEN
				STATE <= Idle;
						
			ELSIF (CLK'EVENT AND CLK = '1') THEN
	
			  CASE STATE IS
				 
				 WHEN Idle =>  IF (V_in = '1') THEN 
						  STATE <= FirstSample;
					       ELSIF (V_in = '0') THEN
						  STATE <= Idle;
					       END IF;	
								
				 WHEN FirstSample =>  STATE <= OutputValid;
									
				 WHEN OutputValid =>  IF (V_in = '1') THEN 
						 	 STATE <= OutputValid;
						      ELSIF (V_in = '0') THEN 
							 STATE <= OutputValidLast;
						      END IF;
				
                                 WHEN OutputValidLast =>  STATE <= Idle;
									
			  END CASE;
                       END IF;
		END PROCESS STATE_PROCESS;
	
		P_OUTPUTS: PROCESS (STATE)
		   BEGIN
			-- assignment by default	
			VOUT <= '0';
			Res_sw0 <= '0';
			Res_sw1<= '0';
			Load_input<= '1';		
			Load_sw0<= '0';
			Load_sw1 <= '0';
			Load_output <= '0';
     
			CASE STATE IS

	        		WHEN Idle => Res_sw0 <= '1';
					     Res_sw1<= '1';
					     --Load_input<= '1';		
					     --Load_sw0<= '0';
                        		     --Load_sw1 <= '0';
                                             --Load_output <= '0';
					     --VOUT<='0';
		
 	         		WHEN FirstSample =>-- Res_sw0 <= '0';
						   -- Res_sw1<= '0';
						    Load_sw0<= '1';
						    Load_sw1<= '1';
						    Load_output <= '1';
						   -- VOUT <= '0';
							  
 	         		WHEN OutputValid =>    VOUT <= '1';
						       Load_sw0<= '1';
						       Load_sw1<= '1';
						       Load_output <= '1';

                                WHEN OutputValidLast =>VOUT <= '1';
                                                       Load_sw0<= '1';
                                                       Load_sw1<= '1';
                                                       Load_output <= '1';

			END CASE;
		END PROCESS P_OUTPUTS;
				
	End behavior;	
		
		
