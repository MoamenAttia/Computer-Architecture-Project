LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

Entity partB is
    Generic (n : integer := 16);
    port( A,B :in std_logic_vector (n-1 downto 0);
          S   :in std_logic_vector ( 3 downto 0);
          F   :out std_logic_vector(n-1 downto 0));
end entity partB;

architecture a_partB of partB is
    begin
        F <= (A And B)  when S="0100"
        Else (A or  B)  when S="0101"
        Else (A xor B)  when S="0110"
        Else (Not(A))   when S="0111";
    end a_partB;
