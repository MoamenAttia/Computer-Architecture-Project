LIBRARY IEEE;
USE IEEE.std_logic_1164.all;


-- 3 2 1 0
-- N Z V C

ENTITY flagReg IS
  generic( n : integer := 16 );
  PORT( clk , Rst , En , C : IN  std_logic;
        A , B , C    : IN  std_logic_vector(n-1 DOWNTO 0);
        q            : OUT std_logic_vector(n-1 DOWNTO 0));
END flagReg;

architecture a_flagReg of flagReg is
  begin
    process( clk , en , rst )
      begin
        if rst = '1' then
          q <="0000";
        elsif rising_edge(clk) and rst = '0' and En = '1' then
          q(0) <= C;
          q(1) <= ( not(A(n-1)) and not(B(n-1)) and C(n-1) ) or ( A(n-1) and B(n-1) and not(C(n-1)) );
          q(2) <= '0' when Rst = '0' and C = (others => '0) else '1' when Rst = '0';
          q(3) <= C(n-1);
          q(n-1 downto 4) <= (others => '0');
        end if;
      end process;
end a_flagReg;
