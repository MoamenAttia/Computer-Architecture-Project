LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

Entity partA is
    generic(n:integer :=16);
    port( A,B :in std_logic_vector (n-1 downto 0);
          S   :in std_logic_vector ( 3 downto 0);
          Cin :in std_logic;
          F   :out std_logic_vector(n-1 downto 0);
          Cout:out std_logic);
end entity partA;

architecture a_partA of partA is
      signal temp1   :std_logic_vector(n-1 downto 0);
      signal temp2   :std_logic_vector(n-1 downto 0);
      signal output1 :std_logic_vector(n-1 downto 0);
      signal carryIN :std_logic;
      signal carryOUT:std_logic;
    begin
        u0:entity work.my_nadder generic map (n) port map ( temp1 , temp2 , carryIN , output1 , carryOUT );
        process(A,B,S,Cin)
            begin
                If(S="0000") then
                    temp1<=A;
                    temp2<=(others=>'0');
                    carryIN<=cin;
                elsif (S="0001") then
                    temp1<=A;
                    temp2<=B;
                    carryIN<=cin;
                elsif (S="0010") then
                    temp1<=A;
                    temp2<=not(B);
                    carryIN<=not(cin);
                elsif (S="0011" and cin='0') then
                    temp1<=A;
                    temp2<=(others=>'1');
                    carryIN<=cin;
                else
                    temp1<=(others=>'0');
                    temp2<=(others=>'0');
                    carryIN<='0';
          	end if;
            end process;
		        F<=output1;
                Cout<=carryOut;
    end a_partA;
