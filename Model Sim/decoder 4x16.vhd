library ieee;
use ieee.std_logic_1164.all;

entity decoder4x16 is
    port ( decoder_selector  : in  std_logic_vector (3 downto 0); 
           decoder_output    : out std_logic_vector (15 downto 0); 
           decoder_enable    : in  std_logic);                    
end decoder4x16;

architecture a_decoder4x16 of decoder4x16 is
  begin
    process(decoder_enable,decoder_selector)
      begin
        if decoder_enable = '0' then 
          decoder_output <= "0000000000000000";     -- Disabled
        elsif decoder_enable = '1' and decoder_selector = "0000" then
          decoder_output <= "0000000000000001";     -- R0
        elsif decoder_enable = '1' and decoder_selector = "0001" then
          decoder_output <= "0000000000000010";     -- R1 
        elsif decoder_enable = '1' and decoder_selector = "0010" then
          decoder_output <= "0000000000000100";     -- R2 
        elsif decoder_enable = '1' and decoder_selector = "0011" then
          decoder_output <= "0000000000001000";     -- R3
        elsif decoder_enable = '1' and decoder_selector = "0100" then
          decoder_output <= "0000000000010000";     -- R4
        elsif decoder_enable = '1' and decoder_selector = "0101" then
          decoder_output <= "0000000000100000";     -- R5
        elsif decoder_enable = '1' and decoder_selector = "0110" then
          decoder_output <= "0000000001000000";     -- R6
        elsif decoder_enable = '1' and decoder_selector = "0111" then
          decoder_output <= "0000000010000000";     -- R7
        elsif decoder_enable = '1' and decoder_selector = "1000" then
          decoder_output <= "0000000100000000";     -- X (Temp1)
        elsif decoder_enable = '1' and decoder_selector = "1001" then
          decoder_output <= "0000001000000000";     -- Y (Temp2)
        elsif decoder_enable = '1' and decoder_selector = "1010" then
          decoder_output <= "0000010000000000";     -- MDR
        elsif decoder_enable = '1' and decoder_selector = "1011" then
          decoder_output <= "0000100000000000";     -- MAR 
        elsif decoder_enable = '1' and decoder_selector = "1100" then
          decoder_output <= "0001000000000000";     -- IR
        elsif decoder_enable = '1' and decoder_selector = "1101" then
          decoder_output <= "0010000000000000";
        elsif decoder_enable = '1' and decoder_selector = "1110" then
          decoder_output <= "0100000000000000";
        elsif decoder_enable = '1' and decoder_selector = "1111" then
          decoder_output <= "1000000000000000";
        end if;
      end process;
end a_decoder4x16;