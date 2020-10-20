LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

	ENTITY OperationOfMultiplier IS
		GENERIC ( N : integer:=7); --11 bit initial, for minimize area, we reduce the interior parallelism
		PORT (M_first,M_second: IN signed(N-1 DOWNTO 0);
				outM: out signed(N-1 downto 0));
	END OperationOfMultiplier;

	ARCHITECTURE Behavior OF OperationOfMultiplier is
	
		signal temp: signed(2*N-1 downto 0);
		
		begin
		
		temp<= M_first * M_second;
		
		outM<= temp(2*N-2 downto N-1);

	end Behavior;
