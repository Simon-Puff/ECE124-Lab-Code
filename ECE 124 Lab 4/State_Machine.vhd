library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

Entity State_Machine IS Port
(
 clk_input, reset, enable, ns, ew, blink_sig		                    : IN std_logic;
 NS_Led, EW_Led, ns_hold_clr, ew_hold_clr			  			: OUT std_logic;
 output_NS, output_EW					        				: OUT std_logic_vector (6 downto 0);
 led4_7															: OUT std_logic_vector (3 downto 0)
 );
END ENTITY;
 

 Architecture SM of State_Machine is
 
 
 TYPE STATE_NAMES IS (S0, S1, S2, S3, S4, S5, S6, S7, S8, S9, S10, S11, S12, S13, S14, S15);   -- list all the STATE_NAMES values

 
 SIGNAL current_state, next_state	:  STATE_NAMES;     	-- signals of type STATE_NAMES
 



 BEGIN

 -------------------------------------------------------------------------------
 --State Machine:
 -------------------------------------------------------------------------------

 -- REGISTER_LOGIC PROCESS EXAMPLE
 
Register_Section: PROCESS (clk_input)  -- this process updates with a clock
BEGIN
	IF(rising_edge(clk_input)) THEN
		IF (reset = '1') THEN
			current_state <= S0; --Initialize the current state to S0 on reset
		ELSIF (reset = '0' and enable = '1') THEN
			current_state <= next_state; --Update the current state with the next state value
		END IF;
	END IF;
END PROCESS;	



-- TRANSITION LOGIC PROCESS EXAMPLE

Transition_Section: PROCESS (current_state)  

BEGIN
  CASE current_state IS
        WHEN S0 =>								-- NS green light flashing
			led4_7 <= "0000"; --Set led4_7 to 0000
			if (ew = '1' and ns = '0') then --If ew is high and ns is low
				next_state <= S6; --Transition to state S6
				
			else
				next_state <= S1; -- Transition to state S1
				
			end if;

        WHEN S1 =>								-- NS green light flashing
			led4_7 <= "0001"; --Set led4_7 to 0001
			if (ew = '1' and ns = '0') then --If ew is high and ns is low
				next_state <= S6; --Transition to state S6
				
			else
				next_state <= S2; --Transition to state S2
				
			end if;

        WHEN S2 =>
			led4_7 <= "0010"; --Set led4_7 to 0010		
			next_state <= S3; --Transition to state S3
			
        WHEN S3 =>
			led4_7 <= "0011"; --Set led4_7 to 0011		
		    next_state <= S4; --Transition to state S4
			
				
         WHEN S4 =>
		 	led4_7 <= "0100"; --Set led4_7 to 0100		
		    next_state <= S5; --Transition to state S5
			

         WHEN S5 =>		
			led4_7 <= "0101"; --Set led4_7 to 0101
		    next_state <= S6; --Transition to state S6
			
				
         WHEN S6 =>	
			led4_7 <= "0110";		-- Jump Target, Set led4_7 to 0110
		    next_state <= S7; --Transition to state S7
			

         WHEN S7 =>		
			led4_7 <= "0111"; --Set led4_7 to 0111
		    next_state <= S8; --Transition to state S8
			

         WHEN S8 =>								-- EW green light flashing
		 	led4_7 <= "1000"; --Set led4_7 to 1000
			if (ew = '0' and ns = '1') then --If ew is low and ns is high
				next_state <= S14; --Transition to state S14
				
			else
				next_state <= S9; --Transition to state S9
				
			end if;		
			
				
         WHEN S9 =>								-- EW green light flashing
		 	led4_7 <= "1001"; --Set led4_7 to 1001
			if (ew = '0' and ns = '1') then
				next_state <= S14; --Transition to state S14
				
			else
				next_state <= S10; --Transition to state S10
				
			end if;		
			
				
         WHEN S10 =>		
			led4_7 <= "1010"; --Set led4_7 to 1010
		    next_state <= S11; --Transition to state S11
			
				
         WHEN S11 =>		
			led4_7 <= "1011"; --Set led4_7 to 1011
		    next_state <= S12; --Transition to state S12
			
	
         WHEN S12 =>		
			led4_7 <= "1100"; --Set led4_7 to 1100
		    next_state <= S13; --Transition to state S13
			
		
         WHEN S13 =>		
			led4_7 <= "1101"; --Set led4_7 to 1101
		   next_state <= S14; --Transition to state S14
			
				
         WHEN S14 =>		
			led4_7 <= "1110";		-- Jump Target, Set led4_7 to 1110
		    next_state <= S15; --Transition to state S15
			
				
         WHEN S15 =>		
			led4_7 <= "1111"; --Set led4_7 to 1111
		    next_state <= S0; --Transition to state S0
			

	  END CASE;
 END PROCESS;
 

-- DECODER SECTION PROCESS EXAMPLE (MOORE FORM SHOWN)

Decoder_Section: PROCESS (current_state) 

BEGIN
     CASE current_state IS
	  
         WHEN S0 =>		
			output_NS <= "000" & blink_sig & "000"; --Set output_NS according to the value of blink_sig
			output_EW <= "0000001"; --Set output_EW to 0000001
			ns_hold_clr <= '0'; --Set ns_hold_clr to 0
			ew_hold_clr <= '0'; --Set ew_hold_clr to 0
			NS_Led <= '0'; --Set NS_Led to 0
			EW_Led <= '0'; --Set EW_Led to 0
			
         WHEN S1 =>		
			output_NS <= "000" & blink_sig & "000"; --Set output_NS according to the value of blink_sig
			output_EW <= "0000001"; --Set output_EW to 0000001
			ns_hold_clr <= '0'; --Set ns_hold_clr to 0
			ew_hold_clr <= '0'; --Set ew_hold_clr to 0
			NS_Led <= '0'; --Set NS_Led to 0
			EW_Led <= '0'; --Set EW_Led to 0
			
         WHEN S2 =>		
			output_NS <= "0001000"; --Set output_NS to 0001000
			output_EW <= "0000001"; --Set output_EW to 0000001
			ns_hold_clr <= '0'; --Set ns_hold_clr to 0
			ew_hold_clr <= '0'; --Set ew_hold_clr to 0
			NS_Led <= '1'; --Set NS_Led to 1
			EW_Led <= '0'; --Set EW_Led to 0
            			
         WHEN S3 =>		
			output_NS <= "0001000"; --Set output_NS to 0001000
			output_EW <= "0000001"; --Set output_EW to 0000001
			ns_hold_clr <= '0'; --Set ns_hold_clr to 0
			ew_hold_clr <= '0'; --Set ew_hold_clr to 0
			NS_Led <= '1'; --Set NS_Led to 1
			EW_Led <= '0'; --Set EW_Led to 0
            			
         WHEN S4 =>		
			output_NS <= "0001000"; --Set output_NS to 0001000
			output_EW <= "0000001"; --Set output_EW to 0000001
			ns_hold_clr <= '0'; --Set ns_hold_clr to 0
			ew_hold_clr <= '0'; --Set ew_hold_clr to 0
			NS_Led <= '1'; --Set NS_Led to 1
			EW_Led <= '0'; --Set EW_Led to 0
            			
         WHEN S5 =>		
			output_NS <= "0001000"; --Set output_NS to 0001000
			output_EW <= "0000001"; --Set output_EW to 0000001
			ns_hold_clr <= '0'; --Set ns_hold_clr to 0
			ew_hold_clr <= '0'; --Set ew_hold_clr to 0
			NS_Led <= '1'; --Set NS_Led to 1
			EW_Led <= '0'; --Set EW_Led to 0

         WHEN S6 =>		
			output_NS <= "1000000"; --Set output_NS to 1000000
			output_EW <= "0000001"; --Set output_EW to 0000001
			ns_hold_clr <= '0'; --Set ns_hold_clr to 0
			ew_hold_clr <= '1'; --Set ew_hold_clr to 1
			NS_Led <= '0'; --Set NS_Led to 0
			EW_Led <= '0'; --Set EW_Led to 0
            			
         WHEN S7 =>		
			output_NS <= "1000000"; --Set output_NS to 1000000
			output_EW <= "000" & blink_sig & "000";--Set output_EW according to the value of blink_sig
			ns_hold_clr <= '0'; --Set ns_hold_clr to 0
			ew_hold_clr <= '0'; --Set ew_hold_clr to 0
			NS_Led <= '0'; --Set NS_Led to 0
			EW_Led <= '0'; --Set EW_Led to 0
            			
         WHEN S8 =>		
			output_NS <= "0000001"; --Set output_NS to 0000001
			output_EW <= "000" & blink_sig & "000"; --Set output_EW according to the value of blink_sig
			ns_hold_clr <= '0'; --Set ns_hold_clr to 0
			ew_hold_clr <= '0'; --Set ew_hold_clr to 0
			NS_Led <= '0'; --Set NS_Led to 0
			EW_Led <= '0'; --Set EW_Led to 0
            			
         WHEN S9 =>		
			output_NS <= "0000001"; --Set output_NS to 0000001
			output_EW <= "0001000"; --Set output_EW to 0001000
			ns_hold_clr <= '0'; --Set ns_hold_clr to 0
			ew_hold_clr <= '0'; --Set ew_hold_clr to 0
			NS_Led <= '0'; --Set NS_Led to 0
			EW_Led <= '0'; --Set EW_Led to 0
            			
         WHEN S10 =>		
			output_NS <= "0000001"; --Set output_NS to 0000001
			output_EW <= "0001000"; --Set output_EW to 0001000
			ns_hold_clr <= '0'; --Set ns_hold_clr to 0
			ew_hold_clr <= '0'; --Set ew_hold_clr to 0
			NS_Led <= '0'; --Set NS_Led to 0
			EW_Led <= '1'; --Set EW_Led to 1
            			
         WHEN S11 =>		
			output_NS <= "0000001"; --Set output_NS to 0000001
			output_EW <= "0001000"; --Set output_EW to 0001000
			ns_hold_clr <= '0'; --Set ns_hold_clr to 0
			ew_hold_clr <= '0'; --Set ew_hold_clr to 0
			NS_Led <= '0'; --Set NS_Led to 0
			EW_Led <= '1'; --Set EW_Led to 1
            			
         WHEN S12 =>		
			output_NS <= "0000001"; --Set output_NS to 0000001
			output_EW <= "0001000"; --Set output_EW to 0001000
			ns_hold_clr <= '0'; --Set ns_hold_clr to 0
			ew_hold_clr <= '0'; --Set ew_hold_clr to 0
			NS_Led <= '0'; --Set NS_Led to 0
			EW_Led <= '1'; --Set EW_Led to 1
            			
         WHEN S13 =>		
			output_NS <= "0000001"; --Set output_NS to 0000001
			output_EW <= "0001000"; --Set output_EW to 0001000
			ns_hold_clr <= '0'; --Set ns_hold_clr to 0
			ew_hold_clr <= '0'; --Set ew_hold_clr to 0
			NS_Led <= '0'; --Set NS_Led to 0
			EW_Led <= '1'; --Set EW_Led to 1
            			
         WHEN S14 =>		
			output_NS <= "0000001"; --Set output_NS to 0000001
			output_EW <= "1000000"; --Set output_EW to 1000000
			ns_hold_clr <= '1'; --Set ns_hold_clr to 1
			ew_hold_clr <= '0'; --Set ew_hold_clr to 0
			NS_Led <= '0'; --Set NS_Led to 0
			EW_Led <= '0'; --Set EW_Led to 0
            			
         WHEN S15 =>		
			output_NS <= "0000001"; --Set output_NS to 0000001
			output_EW <= "1000000"; --Set output_EW to 1000000
			ns_hold_clr <= '0'; --Set ns_hold_clr to 0
			ew_hold_clr <= '0'; --Set ew_hold_clr to 0
			NS_Led <= '0'; --Set NS_Led to 0
			EW_Led <= '0'; --Set EW_Led to 0
            
	  END CASE;
 END PROCESS;

 END ARCHITECTURE SM;
