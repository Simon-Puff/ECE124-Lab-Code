library ieee;
use ieee.std_logic_1164.all;


entity holding_register is port (

			clk					: in std_logic; --Clock input
			reset					: in std_logic; --Reset input
			register_clr			: in std_logic; --Register clear input
			din					: in std_logic; --Data input
			dout					: out std_logic --Data output
  );
 end holding_register;
 
 architecture circuit of holding_register is

	Signal sreg				: std_logic; --Signal to hold the register value


BEGIN

DFF: process( clk ) is
begin
	if (rising_edge (clk)) then
		sreg <= ((sreg or din) and (not(register_clr or reset))); --Updating the register value based on inputs
	end if;

		dout <= sreg; --Output the current register value
	end process;
end;