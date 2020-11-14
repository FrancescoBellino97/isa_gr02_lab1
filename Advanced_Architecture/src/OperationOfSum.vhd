LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

	ENTITY OperationOfSum IS
		GENERIC ( N : integer:=7);
		PORT (Add_first,Add_second: IN signed(N-1 DOWNTO 0);
				outSum: out signed(N-1 downto 0));
	END OperationOfSum;

	ARCHITECTURE Behavior OF OperationOfSum is
	
		begin
		
		outSum<= Add_first + Add_second;

	end Behavior;
