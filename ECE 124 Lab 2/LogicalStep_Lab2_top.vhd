library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity LogicalStep_Lab2_top is port (
   clkin_50			: in	std_logic;
	pb_n				: in	std_logic_vector(3 downto 0);
 	sw   				: in  std_logic_vector(7 downto 0); -- The switch inputs
   leds				: out std_logic_vector(7 downto 0); -- for displaying the switch content
   seg7_data 		: out std_logic_vector(6 downto 0); -- 7-bit outputs to a 7-segment
	seg7_char1  	: out	std_logic;				    		-- seg7 digit1 selector
	seg7_char2  	: out	std_logic				    		-- seg7 digit2 selector
	
); 
end LogicalStep_Lab2_top;

architecture SimpleCircuit of LogicalStep_Lab2_top is
--
-- Components Used ---
------------------------------------------------------------------- 
  component SevenSegment port (
   hex   		:  in  std_logic_vector(3 downto 0);   -- The 4 bit data to be displayed
   sevenseg 	:  out std_logic_vector(6 downto 0)    -- 7-bit outputs to a 7-segment
   ); 
   end component;
	
	component segment7_mux port(												-- this component takes two 7 digit signal from SevenSegement and display it to the display
				clk			: in  std_logic	:= '0';						-- clk is the selector, which changes in a very short period of time
				DIN2			: in  std_logic_vector(6 downto 0);			-- inputs
				DIN1			: in  std_logic_vector(6 downto 0);			-- inputs
				DOUT			: out std_logic_vector(6 downto 0);			 
				DIG2			: out std_logic;
				DIG1			: out std_logic
);
	end component;
	
	component PB_Inverters port(												--This is trying to reset the default value of the bottoms from active low to active high
				pb_n			: in  std_logic_vector(3 downto 0);		
				pb				: out std_logic_vector(3 downto 0)
	);
	end component;
	
	component Logic_Processor port(											-- This is controlling the on and off of leds
				MUX_select	: in  std_logic_vector(1 downto 0);
				logic_in0	: in  std_logic_vector(3 downto 0);
				logic_in1	: in  std_logic_vector(3 downto 0);
				logic_out	: out std_logic_vector(3 downto 0)
	);
	end component;

	component full_adder_4bit PORT											-- this is the adder that takes two 4bit data and add them up, it will output a carry out value
	(																					-- as a remainder, and a sum as the result but with out the remainder
		INPUT_0, INPUT_1	: in std_logic_vector(3 downto 0);
		CARRY_IN			: in std_logic;
		SUM					: out std_logic_vector(3 downto 0);
		CARRY_OUT3			: out std_logic
	);
	end component;

	component two_to_1_mux PORT												-- this is the mux where takes the input from adder and switch, it will select between two inputs
	(
		INPUT_adder, INPUT_hex		: in std_logic_vector(3 downto 0);
		selector							: in std_logic;			
		SUM								: out std_logic_vector(3 downto 0)
	);

	end component;

	
	
-- Create any signals, or temporary variables to be used
--
--  std_logic_vector is a signal which can be used for logic operations such as OR, AND, NOT, XOR
--
	signal hex_A		: std_logic_vector(3 downto 0);
	signal hex_B		: std_logic_vector(3 downto 0);
	
	signal seg7_A		: std_logic_vector(6 downto 0);
	signal seg7_B		: std_logic_vector(6 downto 0);
	
	signal pb			: std_logic_vector(3 downto 0);

	signal to_2_to_1_mux	: std_logic_vector(3 downto 0);
	signal carry_from_adder	: std_logic;

	signal ground		: std_logic:='0';

	signal concat     : std_logic_vector(3 downto 0);

	signal twoto1_hexB : std_logic_vector(3 downto 0);
	signal twoto1_hexA : std_logic_vector(3 downto 0);





	
-- Here the circuit begins

begin

	hex_A <= sw(3 downto 0);
	hex_B <= sw(7 downto 4);
	
	
--COMPONENT HOOKUP
--
-- generate the seven segement coding

	concat <= "000" & carry_from_adder;
	
	INST1: SevenSegment port map(twoto1_hexA, seg7_A);							-- decode the input 4bit value from the 2-to-1 mux into 7-bit data
	INST2: SevenSegment port map(twoto1_hexB, seg7_B);							-- same
	INST3: segment7_mux port map(Clkin_50, seg7_A, seg7_B, seg7_data, seg7_char2, seg7_char1); 		-- it is used to output data and control the display
	INST4: PB_Inverters port map(pb_n, pb);										-- it inverts the default value of bottoms
	INST5: Logic_Processor port map(pb(1 downto 0), hex_A, hex_B, leds(3 downto 0));						-- it controlls the light on leds
	INST6: full_adder_4bit port map(hex_A, hex_B, ground, to_2_to_1_mux, carry_from_adder);			-- it takes two 4-bit values and add them up, if the value exceeds 4 bit, then it will output as carryout value
	INST7: two_to_1_mux port map(concat, hex_B, pb(2), twoto1_hexB);		-- this is the upper 2-to-1 mux in the overall project 
	INST8: two_to_1_mux port map(to_2_to_1_mux, hex_A, pb(2), twoto1_hexA);--this is the lower 2-to-1 mux in the overall project
	
	
 
end SimpleCircuit;

