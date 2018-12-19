LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.numeric_std.ALL;

Entity mpc is
generic (n : integer := 16);
  port(
      rst , clk , external : in std_logic;
      d : in std_logic_vector(n-1 downto 0);
      q : inout std_logic_vector(n-1 downto 0));
end entity mpc;

Architecture a_mpc of mpc is
  Begin
    process (clk , rst , external)
      Begin

        if(rst='1') then
          q <= (others=>'0');
        elsif external = '1' then
            q <= d;
          elsif rising_edge(clk) and external = '0' then
          q <= std_logic_vector(unsigned(q) + 1);
        end if;
      end process;
end a_mpc;
