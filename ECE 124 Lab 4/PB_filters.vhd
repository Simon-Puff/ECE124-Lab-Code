library ieee;
use ieee.std_logic_1164.all;


entity PB_filters is port (
	clkin				: in std_logic; --Clock input
	rst_n				: in std_logic; --Active-low reset input
	rst_n_filtered	: out std_logic; --Filtered reset output
 	pb_n				: in  std_logic_vector (3 downto 0); --Pass-Band input
	pb_n_filtered	: out	std_logic_vector(3 downto 0) --Filtered Pass-Band output							 
	); 
end PB_filters;

architecture ckt of PB_filters is

	Signal sreg0, sreg1, sreg2, sreg3, sreg4	: std_logic_vector(3 downto 0); --Signals to hold register values

BEGIN

process (clkin) is

begin
	if (rising_edge(clkin)) then --Shifting register operations
	
		
		sreg4(3 downto 0) <= sreg4(2 downto 0) & rst_n; --Shifting the reset value into sreg4
				
		sreg3(3 downto 0) <= sreg3(2 downto 0) & pb_n(3); --Shifting pb_n(3) into sreg3
		sreg2(3 downto 0) <= sreg2(2 downto 0) & pb_n(2); --Shifting pb_n(2) into sreg2
 		sreg1(3 downto 0) <= sreg1(2 downto 0) & pb_n(1); --Shifting pb_n(1) into sreg1
		sreg0(3 downto 0) <= sreg0(2 downto 0) & pb_n(0); --Shifting pb_n(0) into sreg0
				
		
	end if;
	--Outputs
		rst_n_filtered   <= sreg4(3) OR sreg4(2) OR sreg4(1); --Generating the filtered reset outputs
		
		pb_n_filtered(3) <= sreg3(3) OR sreg3(2) OR sreg3(1); --Generates pb_n(3) output
		pb_n_filtered(2) <= sreg2(3) OR sreg2(2) OR sreg2(1); --Generating pb_n(2) output
		pb_n_filtered(1) <= sreg1(3) OR sreg1(2) OR sreg1(1); --Generating pb_n(1) output
		pb_n_filtered(0) <= sreg0(3) OR sreg0(2) OR sreg0(1); --Generating pb_n(0) output
		
end process;
end ckt;
