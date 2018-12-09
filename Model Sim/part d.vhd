LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

Entity partD is
    port( A,B :in std_logic_vector (15 downto 0);
          S   :in std_logic_vector ( 3 downto 0);
          Cin :in std_logic;
          F   :out std_logic_vector(15 downto 0);
		  Cout:out std_logic);
		  
end entity partD;

architecture a_partD of partD is
    begin
        F <=  A(14 downto 0)&'0'     when S="1100"
        Else  A(14 downto 0)&A(15)   when S="1101"
        Else  A(14 downto 0)&Cin     when S="1110"
        Else  (others=>'0')          when S="1111";
		Cout <= A(15);
    end a_partD;