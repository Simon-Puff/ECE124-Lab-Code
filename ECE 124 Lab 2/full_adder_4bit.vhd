LIBRARY ieee;
USE ieee.std_logic_1164.all;



ENTITY full_adder_4bit IS
	PORT
	(
		INPUT_0, INPUT_1		: in std_logic_vector(3 downto 0);		-- define inputs from two parts of switches
		CARRY_IN					: in std_logic;								-- define the carry in value from previous adder
		SUM						: out std_logic_vector(3 downto 0);		-- define the output sum value
		CARRY_OUT3				: out std_logic								-- define the final remainder
	);

END full_adder_4bit;

architecture behavior of full_adder_4bit is

component  full_adder_1bit port(

		INPUT_B			: in std_logic;										-- introduce the component being used to construct a 4bit full adder
		INPUT_A			: in std_logic;	
		CARRY_IN			: in std_logic;	
		FULL_ADDER_CARRY_OUTPUT, FULL_ADDER_SUM_OUTPUT	: out std_logic -- introduce the output
		
	);
end component;

signal carry_out_0, carry_out_1, carry_out_2	: std_logic;

begin

inst1: full_adder_1bit port map(INPUT_0(0), INPUT_1(0), CARRY_IN, carry_out_0, SUM(0));      -- the first instance takes charge of calculation of the first bit
inst2: full_adder_1bit port map(INPUT_0(1), INPUT_1(1), carry_out_0, carry_out_1, SUM(1));   -- the second instance takes charge of calculation of the second bit
inst3: full_adder_1bit port map(INPUT_0(2), INPUT_1(2), carry_out_1, carry_out_2, SUM(2));   -- the third instance takes charge of calculation of the third bit 
inst4: full_adder_1bit port map(INPUT_0(3), INPUT_1(3), carry_out_2, CARRY_OUT3, SUM(3)); 	-- the last instance takes charge of calculation of the last bit


end behavior;

