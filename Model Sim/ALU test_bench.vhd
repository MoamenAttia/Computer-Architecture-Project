LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

Entity aluTestBench is
Generic (n : integer := 16);
End aluTestBench;

Architecture a_aluTestBench of aluTestBench is
  Signal Inp1, Inp2 , res : std_logic_vector(n-1 downto 0);
  Signal selector : std_logic_vector(3 downto 0);
  Signal carryIn , c_cout : std_logic;
  Type registerType    is array (0 TO  22) of std_logic_vector(n-1 downto 0);
  Type selectorTypes   is array (0 TO  22) of std_logic_vector(3 downto 0);
  Type bitType         is array (0 TO  22) of std_logic;

  Constant inputCasesA  : registerType    := ( X"0F0F" , X"0F0F" , X"0F0F" , X"0F0F" , X"0F0F" , X"0F0F" , X"0F0F" , X"0F0F" , X"0F0F" , X"F0F0" , X"F0F0" , X"F0F0" , X"F0F0" , X"F0F0" , X"0F0F" , X"0F0F" , X"FFFF" , X"FFFF" , X"FFFF" , X"0F0E" , X"FFFF" , X"0F0F" , X"0F0F" );
  Constant inputCasesB  : registerType    := ( X"000A" , X"000A" , X"000A" , X"000A" , X"000A" , X"000A" , X"000A" , X"000A" , X"000A" , X"000A" , X"000A" , X"000A" , X"F0F0" , X"F0F0" , X"000A" , X"0001" , X"0001" , X"0001" , X"FFFF" , X"0F0E" , X"0001" , X"0001" , X"0F0F" );
  Constant carryInCases : bitType         := ( '0'     , '0'     , '0'     , '0'     , '0'     , '0'     , '0'     , '1'     , '0'     , '0'     , '0'      ,'1'      ,'0'     ,'0'      , '0'     , '0'     , '0'     , '0'     , '0'     , '1'     , '1'     , '1'     , '1'     );
  Constant Selectors    : selectorTypes   := ( "0100"  , "0101"  , "0110"  , "0111"  , "1000"  , "1001"  , "1010"  , "1010"  , "1100"  , "1101"  , "1110"  , "1110"  , "1111" , "1011"   , "0000"  , "0001"  , "0001"  , "0010"  , "0011"  , "0000"  , "0001"  , "0010"  , "0011"   );
  Constant carryOutCases : bitType        := ( '0'     , '0'     , '0'     , '0'     , '1'     , '1'     , '1'     , '1'     , '0'     , '1'     , '1'      ,'1'      ,'0'     ,'0'      , '0'     , '0'     , '1'     , '1'     , '1'     , '0'     ,  '1'    , '1'     , '0'     );
  Constant outputCases  : registerType    := ( X"000A" , X"0F0F" , X"0F05" , X"F0F0" , X"0787" , X"8787" , X"0787" , X"8787" , X"1E1E" , X"E1E1" , X"E1E0" , X"E1E1" , X"0000" , X"F878" , X"0F0F" , X"0F10" , X"0000" , X"FFFD" , X"FFFE" , X"0F0F" , X"0001" , X"0F0E" , X"0000" );

    Begin
    Process
      Begin
          -- test for partB partC partD
        	for i in inputCasesA'range Loop
            Inp1 <= inputCasesA(i);
    				Inp2 <= inputCasesB(i);
            carryIn <= carryInCases(i);
            selector <= Selectors(i);
    				wait for 10 ns;
				    assert(res = outputcases(i))      report  ("error in Result")    severity error;
            assert(c_cout = carryoutcases(i)) report  ("Error in Carry out") severity error;
    			end loop;



          wait;
    End Process;
  myALU: entity work.ALU generic map(n) port map (Inp1, Inp2,selector,carryIn,res,c_cout);
end a_aluTestBench;
