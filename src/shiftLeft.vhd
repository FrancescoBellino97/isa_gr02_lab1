LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
 
	Entity shiftLeft is
		GENERIC ( N : integer:=11;
					 N_internal: integer :=6);
		port(
				d_in: in signed(N_internal-1 downto 0);
				out_extended: out signed(N-1 downto 0)
				);
				
	end shiftLeft;
	
	
	Architecture Structural of shiftLeft is
	
	signal temp: signed(N-1 downto 0);
	
	BEGIN
	
	temp<=d_in(N_internal-1)&d_in(N_internal-1)&d_in(N_internal-1)&d_in(N_internal-1)&d_in(N_internal-1)&d_in;
	
	out_extended<= shift_left(temp,N-N_internal);
	
	End Structural;