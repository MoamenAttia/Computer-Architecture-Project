LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY mar IS
GENERIC ( n : integer := 8);
PORT(  Clk , Rst : IN std_logic;
		   d         : IN std_logic_vector(n-1 DOWNTO 0);
		   q         : OUT std_logic_vector(n-1 DOWNTO 0);
	     En        : in std_logic);
END mar;

ARCHITECTURE a_mar OF mar IS
  BEGIN
    loop1: FOR i IN 0 TO n-1 
      GENERATE
        fx:entity work.DFF PORT MAP( d(i) , Clk , Rst , En , q(i) );
      END GENERATE;
END a_mar;

