LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

Entity ALU is
    Generic (n : integer := 16);
    port( Inp1 , Inp2 : in  std_logic_vector ( n-1 downto 0 );
          selector     : in  std_logic_vector ( 3 downto 0 );
          carryIn      : in  std_logic;
          res     : out std_logic_vector ( n-1 downto 0 );
          c_cout    : out std_logic);
end entity ALU;

architecture a_ALU of ALU is
      signal F1 , F2 , F3 , F4 : std_logic_vector(n-1 downto 0);
      signal tempCarryOutPartA , tempCarryOutPartC , tempCarryOutPartD : std_logic;

   Begin
      a_partA:entity work.partA generic map (n) port map ( Inp1 , Inp2 , selector , carryIn , F1 , tempCarryOutPartA );
      a_partB:entity work.partB generic map (n) port map ( Inp1 , Inp2 , selector , F2 );
      a_partC:entity work.partC generic map (n) port map ( Inp1 , Inp2 , selector , carryIn , F3 , tempCarryOutPartC );
      a_partD:entity work.partD generic map (n) port map ( Inp1 , Inp2 , selector , carryIn , F4 , tempCarryOutPartD );

      res <= F1 when selector="0000" or selector="0001" or selector="0010" or selector="0011"
      Else F2 when selector="0100" or selector="0101" or selector="0110" or selector="0111"
      Else F3 when selector="1000" or selector="1001" or selector="1010" or selector="1011"
      Else F4;

      c_cout<= tempCarryOutPartA when selector="0000" or selector="0001" or selector="0010" or selector="0011" else
               '0'               when selector="0100" or selector="0101" or selector="0110" or selector="0111" else
               tempCarryOutPartC when selector="1000" or selector="1001" or selector="1010" or selector="1011" else
               tempCarryOutPartD when selector="1100" or selector="1101" or selector="1110" or selector="1111";
end a_ALU;
