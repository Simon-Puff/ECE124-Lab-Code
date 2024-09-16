library ieee;
use ieee.std_logic_1164.all;


entity PB_inverters is port (
	rst_n_filtered			: in std_logic; --Input signal
	rst	: out std_logic; --Output signal
 	pb_n			: in  std_logic_vector (3 downto 0); --Input pb_n signal (4-bit)
	pb				: out	std_logic_vector(3 downto 0) --Output pb signal	(4-bit)						 
	); 
end PB_inverters;

architecture ckt of PB_inverters is

begin
pb <= NOT(pb_n); --Invert pb_n input and assign it to pb output
rst <= NOT(rst_n_filtered); --Invert rst_n_filtered input and assign it to rst output

end ckt;