LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

	ENTITY regIn_out IS
		GENERIC ( N : integer:=11);
		PORT ( Clock,Load: IN STD_LOGIC;
				 datoInput: in signed(N-1 downto 0);
				 datoOutput : OUT signed(N-1 DOWNTO 0));
	END regIn_out;

	ARCHITECTURE Behavior OF regIn_out IS

	BEGIN
		
		PROCESS (Clock)
			BEGIN
				IF (Clock'EVENT AND Clock = '1') THEN	
					IF (Load='1') THEN
						datoOutput <= datoInput;
					END IF;
				END IF;
		END PROCESS;
		
	END Behavior;
