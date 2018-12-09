LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY nDFF IS
GENERIC ( n : integer := 32);
  PORT( Clk,Rst,En  : IN  std_logic;
        d           : IN  std_logic_vector(n-1 DOWNTO 0);
        q           : OUT std_logic_vector(n-1 DOWNTO 0)
      );
END nDFF;

architecture a_nDFF of ndff is
  begin
    loop1: for i in 0 to n-1 
      Generate
        fx:entity work.DFF port map( d(i) , clk , rst , en , q(i) );
      end Generate;
end a_nDFF;

