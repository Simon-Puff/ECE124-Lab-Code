LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY two_to_1_mux IS
	PORT
	(
		INPUT_adder, INPUT_hex		: in std_logic_vector(3 downto 0);      -- define inputs from adder and hex signal
		selector							: in std_logic;		                   -- define selector
		SUM								: out std_logic_vector(3 downto 0)      -- define the final out put
	);

END two_to_1_mux;

architecture selection of two_to_1_mux is

begin

with selector select


SUM	 <= 	INPUT_hex when '0',		-- define cases for multiplexer, when to output which input
				INPUT_adder when '1';
end selection;
