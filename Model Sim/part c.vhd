LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

Entity partC is
    Generic (n : integer := 16);
    port( A,B :in std_logic_vector (n-1 downto 0);
          S   :in std_logic_vector ( 3 downto 0);
          Cin :in std_logic;
          F   :out std_logic_vector(n-1 downto 0);
		  Cout : out std_logic);
end entity partC;

architecture a_partC of partC is
    begin
        F <=  '0'&A(n-1 downto 1)    when S="1000"
        Else  A(0)&A(n-1 downto 1)   when S="1001"
        Else  Cin&A(n-1 downto 1)    when S="1010"
        Else  A(n-1)&A(n-1 downto 1)  when S="1011";
    Cout <= A(0);
end a_partC;
