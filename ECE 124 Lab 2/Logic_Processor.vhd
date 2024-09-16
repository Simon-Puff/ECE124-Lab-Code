LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY Logic_Processor IS
	PORT
	(
		MUX_select	: in  std_logic_vector(1 downto 0);		-- define 2bit selector
		logic_in0	: in  std_logic_vector(3 downto 0);		-- define the input bottom port
		logic_in1	: in  std_logic_vector(3 downto 0);
		logic_out	: out std_logic_vector(3 downto 0)		-- define the output which controls leds
	);
END Logic_processor;

architecture mux_logic of Logic_Processor is

begin
	with mux_select(1 downto 0) select
	logic_out <=	logic_in0 AND  logic_in1 when "00",		-- defines conditions using the 2bit selector
						logic_in0 OR   logic_in1 when "01",
						logic_in0 XOR  logic_in1 when "10",
						logic_in0 XNOR logic_in1 when "11";

end mux_logic;