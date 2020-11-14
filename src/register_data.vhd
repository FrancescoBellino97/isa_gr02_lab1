
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

	ENTITY register_data IS
		GENERIC ( N : integer:=6);
		PORT ( Clock,Load,Reset: IN STD_LOGIC;
				 datoInput: in signed(N-1 downto 0);
				 datoOutput : OUT signed(N-1 DOWNTO 0));
	END register_data;

	ARCHITECTURE Behavior OF register_data IS

	BEGIN
		
		PROCESS (Clock)
			BEGIN
				IF (Clock'EVENT AND Clock = '1') THEN
					IF (Reset ='1') THEN
						datoOutput <= (OTHERS => '0');	
					ELSIF (Load='1') THEN
						datoOutput <= datoInput;
					END IF;
				END IF;
		END PROCESS;
		
	END Behavior;