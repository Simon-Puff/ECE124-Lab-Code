SLIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY  full_adder_1bit IS
	PORT
	(
		INPUT_B							: in std_logic;		-- define input ports, this is the signal from switches
		INPUT_A							: in std_logic;
		CARRY_IN							: in std_logic;		-- define carry in value, this is used for constructing a full adder
		FULL_ADDER_CARRY_OUTPUT 	: out std_logic;		-- define remainder value and sum value output, this is a preparation
		FULL_ADDER_SUM_OUTPUT		: out std_logic		--	for connecting to another 1bit full adder	
													
	);

END full_adder_1bit;

architecture adder of full_adder_1bit is

begin
	FULL_ADDER_CARRY_OUTPUT <=  (INPUT_B and INPUT_A) or ( (INPUT_B xor INPUT_A) and CARRY_IN);      -- define the logic of calculating the remainder
	FULL_ADDER_SUM_OUTPUT     <=  (INPUT_B xor INPUT_A) xor CARRY_IN;                              	 -- define the logic of calculating the sum

end adder;
