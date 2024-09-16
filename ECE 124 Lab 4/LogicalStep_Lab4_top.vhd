
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY LogicalStep_Lab4_top IS
   PORT
	(
   clkin_50		: in	std_logic;							-- The 50 MHz FPGA Clockinput
	rst_n			: in	std_logic;							-- The RESET input (ACTIVE LOW)
	pb_n			: in	std_logic_vector(3 downto 0); -- The push-button inputs (ACTIVE LOW)
 	sw   			: in  std_logic_vector(7 downto 0); -- The switch inputs
   leds			: out std_logic_vector(7 downto 0);	-- for displaying the the lab4 project details
	-------------------------------------------------------------
	-- you can add temporary output ports here if you need to debug your design 
	-- or to add internal signals for your simulations
	-------------------------------------------------------------
	
   seg7_data 	: out std_logic_vector(6 downto 0); -- 7-bit outputs to a 7-segment
	seg7_char1  : out	std_logic;							-- seg7 digi selectors
	seg7_char2  : out	std_logic							-- seg7 digi selectors
	);
END LogicalStep_Lab4_top;

ARCHITECTURE SimpleCircuit OF LogicalStep_Lab4_top IS

   component segment7_mux port (
          clk        : in  std_logic := '0'; --Input clock signal
			 DIN2 		: in  std_logic_vector(6 downto 0);	--bits 6 to 0 represent segments G,F,E,D,C,B,A
			 DIN1 		: in  std_logic_vector(6 downto 0); --bits 6 to 0 represent segments G,F,E,D,C,B,A
			 DOUT			: out	std_logic_vector(6 downto 0); --Output data for 7-segment display
			 DIG2			: out	std_logic; --Selector for the second display
			 DIG1			: out	std_logic --Selector for the first display
   );
   end component;

   component clock_generator port (
			sim_mode			: in boolean; --Simulation mode indicator
			reset				: in std_logic; --Reset signal input
         clkin      		: in  std_logic; --Input clock signal
			sm_clken			: out	std_logic; --Output clock enable signal for State_Machine
			blink		  		: out std_logic --Output blink signal
  );
   end component;

   component pb_filters port (
			clkin				: in std_logic; --Input clock signal
			rst_n				: in std_logic; --Input reset signal
			rst_n_filtered		: out std_logic; --Filtered reset signal output
			pb_n				: in std_logic_vector (3 downto 0); --Input push-button signals
			pb_n_filtered		: out std_logic_vector(3 downto 0) --Output filtered push-button signals
   );
   end component;

   component pb_inverters port (
			 rst_n_filtered				: in std_logic; --Input filtered reset signal
			 rst	: out std_logic; --Output reset signal
			 pb_n					: in std_logic_vector(3 downto 0); --Input filtered push-button signals
			 pb			  		: out std_logic_vector(3 downto 0) --Output inverted push-button signals
  );
   end component;

	
	component synchronizer port(
			clk					: in std_logic; --Input clock signal
			reset					: in std_logic; --Input reset signal
			din					: in std_logic; --Input data signal
			dout					: out std_logic --Output data signal
  );
   end component;
 
   component holding_register port (
			clk					: in std_logic; --Input clock signal
			reset					: in std_logic; --Input reset signal
			register_clr			: in std_logic; --Register clear signal input
			din					: in std_logic; --Input data signal
			dout					: out std_logic --Output data signal
  );
  end component;
	
	component State_Machine Port (
 		clk_input, reset, enable, ns, ew, blink_sig		                : IN std_logic; --Input signals
 		NS_Led, EW_Led, ns_hold_clr, ew_hold_clr			  			: OUT std_logic; --Output signals
 		output_NS, output_EW					        				: OUT std_logic_vector (6 downto 0); --Output signals
 		led4_7															: OUT std_logic_vector (3 downto 0) --LED control signals
 );
  end component;		
	
----------------------------------------------------------------------------------------------------
	CONSTANT	sim_mode						: boolean := FALSE; -- set to FALSE for LogicalStep board downloads
	                                                     -- set to TRUE for SIMULATIONS
	
	SIGNAL sm_clken, blink_sig			: std_logic; 

	SIGNAL rst, rst_n_filtered, synch_rst: std_logic;

	SIGNAL synch_EW_out					: std_logic;
	SIGNAL synch_NS_out					: std_logic;

	SIGNAL holdreg_1, holdreg_2			: std_logic;

	SIGNAL ns_hold_clr, ew_hold_clr		: std_logic;

	SIGNAL ns_cross_sign, ew_cross_sign : std_logic;
	
	SIGNAL NS_7, EW_7					: std_logic_vector (6 downto 0);

	SIGNAL pb, pb_n_filtered			: std_logic_vector(3 downto 0); -- pb(3) is used as an active-high reset for all registers
	
	
BEGIN
----------------------------------------------------------------------------------------------------
INST0: pb_filters  --Instantiating pb_filters module	
	port map (clkin_50, pb_n(3), rst_n_filtered, pb_n, pb_n_filtered);
INST1: pb_inverters	 --Instantiating pb_inverters module	
	port map (rst_n_filtered, rst, pb_n_filtered, pb);

INST3: synchronizer  --Instantiating synchronizer module
	port map (clkin_50, synch_rst, rst, synch_rst);
INST4: synchronizer  --Instantiating synchronizer module
	port map (clkin_50, synch_rst, pb(1), synch_EW_out);
INST5: synchronizer  --Instantiating synchronizer module
	port map (clkin_50, synch_rst, pb(0), synch_NS_out);

INST6: clock_generator  --Instantiating clock_generator module
	port map (sim_mode, synch_rst, clkin_50, sm_clken, blink_sig);

INST7: holding_register  --Instantiating holding_register module
	port map (clkin_50, synch_rst, ns_hold_clr, synch_NS_out, holdreg_1);
INST8: holding_register  --Instantiating holding_register module
	port map (clkin_50, synch_rst, ew_hold_clr, synch_EW_out, holdreg_2);

INST9: State_Machine  --Instantiating State_Machine module
	port map (clkin_50, synch_rst, sm_clken, holdreg_1, holdreg_2, blink_sig, ns_cross_sign, ew_cross_sign, ns_hold_clr, ew_hold_clr, NS_7, EW_7, leds(7 downto 4));
INST10:segment7_mux  --Instantiating segment7_mux module
	port map (clkin_50, EW_7, NS_7, seg7_data, seg7_char2, seg7_char1);

leds(3) <= holdreg_2; --Assign value of holdreg_2 to leds(3)
leds(2) <= ew_cross_sign; --Assign value of ew_cross_sign to leds(2)
leds(1) <= holdreg_1; --Assign value of holdreg_1 to leds(1)
leds(0) <= ns_cross_sign; --Assign value of ns_cross_sign to leds(0)


END SimpleCircuit;
