library ieee;
use ieee.std_logic_1164.all;


entity synchronizer is port (

			clk					: in std_logic;
			reset					: in std_logic;
			din					: in std_logic;
			dout					: out std_logic
  );
 end synchronizer;
 
 
architecture circuit of synchronizer is

	Signal sreg				: std_logic_vector(1 downto 0); --Signal which stores the synchronized value

BEGIN

--DFF1: process( clk, reset ) is
--begin
--	if (reset = '1') then
--		sreg = '0';
--	elsif (rising_edge(clk)) then
--		sreg <= data;
--	end if;
--end process;

--DFF2: process( clk, reset) is
--begin
--	if (reset = '1') then
--		dout = '0';
--	elsif (rising_edge (clk)) then
--		dout <= sreg;
--	end if;
--end process;

DFF: process (clk) is
begin

if (rising_edge(clk)) then
	if (reset = '1') then
		sreg <= "00"; --Resets the sreg to 00 when reset is high
	else
		sreg(1) <= sreg(0); -- Stores sreg(0) in sreg(1)
		sreg(0) <= din; --Assigns the input din to sreg(0)
	end if;
end if;
	dout <= sreg(1); --Output sreg(1)
end process;


end;