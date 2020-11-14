LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
 
	Entity shiftRight is
		GENERIC ( N : integer:=11;
					 N_internal: integer :=7);
		port(
				d_in: in signed(N-1 downto 0);
				out_reduced: out signed(N_internal-1 downto 0)
				);
				
	end shiftRight;
	
	
	Architecture Structural of shiftRight is
	
	signal temp: signed(N-1 downto 0);
	
	BEGIN
	
	temp<=shift_right(d_in,N-N_internal);
	
	out_reduced<= temp(N_internal-1 downto 0);
	
	End Structural;
