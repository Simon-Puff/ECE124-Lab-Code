library ieee;
use ieee.std_logic_1164.all;



entity hex_mux is
port (
	hex_num3,hex_num2,hex_num1,hex_num0			:	in	std_logic_vector(3 downto 0);	-- define 4 4bit input values
	mux_select											:	in std_logic_vector(1 downto 0);	-- define the selector
	hex_out												:	out std_logic_vector(3 downto 0)	-- define the 4bit output
);

end hex_mux;

architecture mux_logic of hex_mux is

begin

	with mux_select(1 downto 0) select			-- define the selector cases
	hex_out <=	hex_num0 when "00",				-- the selector is corresponding to what the index behind each input
					hex_num1 when "01",			
					hex_num2 when "10",
					hex_num3 when "11";

end mux_logic;