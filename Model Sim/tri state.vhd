library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

Entity tri_state is
  Generic ( n : integer := 32);
    Port ( 
           tri_enable : in  STD_LOGIC;
           bus_select : in  STD_LOGIC; -- 0 no output 3la bus , 1  yb2a output 3la bus B or A  
           tri_input  : in  STD_LOGIC_VECTOR (n-1 downto 0);
           tri_output : out STD_LOGIC_VECTOR (n-1 downto 0)
         );
End tri_state;

Architecture a_tri_state of tri_state is
Begin
    tri_output <= tri_input when (tri_enable = '1' and bus_select = '1') 
                  else (others => 'Z');
End a_tri_state;