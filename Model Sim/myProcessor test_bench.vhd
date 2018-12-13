LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;
Entity myProcessorTestBench is
Generic ( n : integer := 16; ramSize : integer:= 2048; MarAddressSize : integer := 11 );
End myProcessorTestBench;

Architecture a_myProcessorTestBench of myProcessorTestBench is

  Signal clkNormal : std_logic := '0';
  Signal clkRam : std_logic := '1';
  Signal decoder_srcA_enable , decoder_srcB_enable , decoder_dist_enable , aluCarryIn , writeMem , readMem : std_logic := '0';
  Signal decoder_srcA_selector , decoder_srcB_selector, decoder_dist_selector , aluSelector : std_logic_vector(3 downto 0) := "0000";
  Signal busA , busB , busC : std_logic_vector(n-1 downto 0) := (others => 'Z');
  Signal rst : std_logic_vector(15 downto 0) := X"0000";

  Type selectorTypes is array (0 TO 8) of std_logic_vector( 3 downto 0 );
  Type registerType  is array (0 TO 8) of std_logic_vector(n-1 downto 0);
  Type addRegisterType  is array (0 TO 8) of std_logic_vector(n-1 downto 0);
  Type BitType is array (0 TO 8) of std_logic;

  Constant registersSelectors : selectorTypes   := ( "0001"  , "0010"  , "0011"  , "0100"  , "0101"  , "0110"  , "0111"  , "1001"   , "0000"  );
  Constant initialData   : registerType          := ( X"AC00" , X"A0A0" , X"BCD0" , X"0101" , X"0F01" , X"1FE0" , X"A126" ,  X"0115" , X"1015" );

  Constant inputAdd      : registerType          := ( X"AC00" , X"A0A0" , X"BCD0" , X"0101" , X"0F01" , X"1FE0" , X"A126" ,  X"0115", X"1015" );
  Constant outputAdd     : registerType          := ( X"BC15" , X"B0B5" , X"CCE5" , X"1116" , X"1F16" , X"2FF5" , X"B13B" ,  X"112A", X"202A" );

  Constant inputSub      : registerType          := ( X"AC00" , X"A0A0" , X"BCD0" , X"0101" , X"0F01" , X"1FE0" , X"A126" ,  X"0115", X"F0F0" );
  Constant outputSub     : registerType          := ( X"44F0" , X"5050" , X"3420" , X"EFEF" , X"E1EF" , X"D110" , X"4FCA" ,  X"EFDB", X"0000" );

  Constant inputAND      : registerType          := ( X"AC00" , X"A0A0" , X"BCD0" , X"0101" , X"0F01" , X"1FE0" , X"A126" ,  X"0115", X"F1F2" );
  Constant outputAND     : registerType          := ( X"A000" , X"A0A0" , X"B0D0" , X"0100" , X"0100" , X"11E0" , X"A122" ,  X"0110", X"F1F2" );

  Constant inputOR       : registerType          := ( X"AC00" , X"A0A0" , X"BCD0" , X"0101" , X"0F01" , X"1FE0" , X"A126" ,  X"0115" , X"F1F2" );
  Constant outputOR      : registerType          := ( X"FDF2" , X"F1F2" , X"FDF2" , X"F1F3" , X"FFF3" , X"FFF2" , X"F1F6" ,  X"F1F7" , X"F1F2" );

  Constant inputXOR      : registerType          := ( X"AC00" , X"A0A0" , X"BCD0" , X"0101" , X"0F01" , X"1FE0" , X"A126" ,  X"0115" , X"F1F2" );
  Constant outputXOR     : registerType          := ( X"5DF2" , X"5152" , X"4D22" , X"F0F3" , X"FEF3" , X"EE12" , X"50D4" ,  X"F0E7" , X"0000" );

  Constant inputNOT      : registerType          := ( X"AC00" , X"A0A0" , X"BCD0" , X"0101" , X"0F01" , X"1FE0" , X"A126" ,  X"0115" , X"F1F2" );
  Constant outputNOT     : registerType          := ( X"53FF" , X"5F5F" , X"432F" , X"FEFE" , X"F0FE" , X"E01F" , X"5ED9" ,  X"FEEA" , X"0E0D" );

  Constant inputROR      : registerType          := ( X"AC00" , X"A0A0" , X"BCD0" , X"0101" , X"0F01" , X"1FE0" , X"A126" ,  X"0115" , X"F1F2" );
  Constant outputROR     : registerType          := ( X"5600" , X"5050" , X"5E68" , X"8080" , X"8780" , X"0FF0" , X"5093" ,  X"808A" , X"78F9" );
  Constant outputRORCout : BitType               := ( '0'     , '0'     ,   '0'   ,  '1'    , '1'     ,  '0'    ,  '0'   ,     '1'   ,  '0'    );

  Constant inputROL      : registerType          := ( X"AC00" , X"A0A0" , X"BCD0" , X"0101" , X"0F01" , X"1FE0" , X"A126" ,  X"0115" , X"F1F2" );
  Constant outputROL     : registerType          := ( X"5801" , X"4141" , X"79A1" , X"0202" , X"1E02" , X"3FC0" , X"424D" ,  X"022A" , X"E3E5" );
  Constant outputROLCout : BitType               := ( '1'     ,  '1'    ,    '1'  ,  '0'    , '0'     ,  '0'     ,  '1'   ,    '0'   ,  '1'  );

  Constant inputSHR      : registerType          := ( X"AC00" , X"A0A0" , X"BCD0" , X"0101" , X"0F01" , X"1FE0" , X"A126" ,  X"0115" , X"F1F2" );
  Constant outputSHR     : registerType          := ( X"5600" , X"5050" , X"5E68" , X"0080" , X"0780" , X"0FF0" , X"5093" ,  X"008A" , X"78F9" );
  Constant outputSHRCout : BitType               := ( '0'     , '0'     ,   '0'   ,  '1'    , '1'     ,  '0'    ,  '0'   ,     '1'   ,  '0'    );

  Constant inputRORC      : registerType          := ( X"AC00" , X"A0A0" , X"BCD0" , X"0101" , X"0F01" , X"1FE0" , X"A126" ,  X"0115" , X"F1F2" );
  Constant outputRORC     : registerType          := ( X"D600" , X"D050" , X"DE68" , X"8080" , X"8780" , X"8FF0" , X"D093" ,  X"808A" , X"F8F9" );
  Constant inputRORC_Cin   : BitType              := ( '1'     , '1'     ,   '1'   ,  '1'    , '1'     ,  '1'    ,  '1'   ,     '1'   ,  '1'    );
  Constant outputRORC_Cout : BitType              := ( '0'     , '0'     ,   '0'   ,  '1'    , '1'     ,  '0'    ,  '0'   ,     '1'   ,  '0'    );

  Constant inputROLC      : registerType          := ( X"AC00" , X"A0A0" , X"BCD0" , X"0101" , X"0F01" , X"1FE0" , X"A126" ,  X"0115" , X"F1F2" );
  Constant outputROLC     : registerType          := ( X"5801" , X"4141" , X"79A1" , X"0203" , X"1E03" , X"3FC1" , X"424D" ,  X"022B" , X"E3E5" );
  Constant inputROLC_Cin   : BitType              := ( '1'     , '1'     ,   '1'   ,  '1'    , '1'     ,  '1'    ,  '1'   ,     '1'   ,  '1'    );
  Constant outputROLC_Cout : BitType              := ( '1'     ,  '1'    ,    '1'  ,  '0'    , '0'     ,  '0'     ,  '1'   ,    '0'   ,  '1'    );

  Constant inputASHR      : registerType          := ( X"AC00" , X"A0A0" , X"BCD0" , X"0101" , X"0F01" , X"1FE0" , X"A126" ,  X"0115" , X"F1F2" );
  Constant outputASHR     : registerType          := ( X"D600" , X"D050" , X"DE68" , X"0080" , X"0780" , X"0FF0" , X"D093" ,  X"008A" , X"F8F9" );
  Constant outputASHRCout : BitType               := ( '0'     , '0'     ,   '0'   ,  '1'    , '1'     ,  '0'    ,  '0'   ,     '1'   ,  '0'    );

  constant ClockFrequency : integer := 100e6;
  constant ClockPeriod    : time    := 1000 ms / ClockFrequency;

  Begin
    myProcessorTest: entity work.myProcessor generic map( n , ramSize , MarAddressSize ) port map ( decoder_srcA_enable, decoder_srcB_enable , decoder_dist_enable , aluCarryIn , clkRam , clkNormal , writeMem , readMem , decoder_srcA_selector , decoder_srcB_selector , decoder_dist_selector , aluSelector , busA , busB , busC , rst );
    -- Process for generating the clock
    clkRam <= not clkRam after ClockPeriod / 2;
    clkNormal <= not clkNormal after ClockPeriod / 2;

    process is
      Begin

          -- Initialize the signals
          decoder_srcA_selector <= "0000";
          decoder_srcB_selector <= "0000";
          decoder_srcB_enable <= '0';
          decoder_srcA_enable <= '0';
          decoder_dist_enable <= '1';
          aluSelector <= "0000";
          aluCarryIn <= '0';
          readMem <= '0';
          busA <= (others => '0');
          busB <= (others => '0');
          busC <= (others => 'Z');
          rst  <= (others => '0');

          -- Initialize The Ram with values begins with 100 to ..
          for i in 0 to ramSize-1 loop
            writeMem <= '0';
            busA <= std_logic_vector ( to_unsigned( integer(i) , busA'length ) );
            decoder_dist_selector <= "1000";
            wait for 10 ns;
            busA <= std_logic_vector ( to_unsigned( integer(i + 100) , busA'length ) );
            decoder_dist_selector <= "1001";
            wait for 10 ns;
            writeMem <= '1';
            wait for 10 ns;
          End loop;

          -- load Initial Data to all registers
          writeMem <= '0';
          busB <= (others => 'Z');
          busC <= (others => 'Z');
          for i in registersSelectors'range Loop
            busA <= initialData(i);
            decoder_dist_enable <= '1';
            decoder_dist_selector <= registersSelectors(i);
            wait for 10 ns;
            decoder_srcB_selector <= registersSelectors(i);
            decoder_srcB_enable <= '1';
            decoder_dist_enable <= '0';
            wait for 1 ns;
            assert(busB = busA)
            report  "BusB = "&integer'image(to_integer(unsigned(busB)))&" BusA = "&integer'image(to_integer(unsigned(busA)))
            severity error;
            wait for 9 ns;
          end loop;


          -- test add Ro , Rx
          busA <= (others => 'Z');
          busB <= (others => 'Z');
          busC <= (others => 'Z');
          writeMem <= '0';
          aluSelector <= "0001"; -- (A + B)
          for i in registersSelectors'range Loop
            decoder_srcB_selector <= registersSelectors(i);
            decoder_dist_selector <= registersSelectors(i);
            decoder_dist_enable   <= '1';
            decoder_srcA_selector <= "0000";
            decoder_srcB_enable <= '1';
            decoder_srcA_enable <= '1';
            wait for 10 ns;
            decoder_srcA_selector <= registersSelectors(i);
            decoder_srcA_enable <= '1';
            decoder_dist_enable <= '0';
            decoder_srcB_enable <= '0';
            wait for 1 ns;
            assert(busA = outputAdd(i))
            report  "BusA = "&integer'image(to_integer(unsigned(busA)))&" correct result = "&integer'image(to_integer(unsigned(outputAdd(i))))
            severity error;
            wait for 9 ns;
          end loop;



          -- test Sub Ro , Rx
          -- step 1 ----> Load Initial Data 34an bazt
          -- load Initial Data to all registers
          writeMem <= '0';
          busA <= (others => 'Z');
          busB <= (others => 'Z');
          busC <= (others => 'Z');
          decoder_srcA_enable <= '0';
          decoder_srcB_enable <= '0';
          aluSelector <= "0000";
          for i in registersSelectors'range Loop
            busA <= inputSub(i);
            decoder_dist_enable <= '1';
            decoder_dist_selector <= registersSelectors(i);
            wait for 10 ns;
            decoder_srcB_selector <= registersSelectors(i);
            decoder_srcB_enable <= '1';
            decoder_dist_enable <= '0';
            wait for 1 ns;
            assert(busB = busA)
            report  "BusB = "&integer'image(to_integer(unsigned(busB)))&" BusA = "&integer'image(to_integer(unsigned(busA)))
            severity error;
            wait for 9 ns;
          end loop;

          -- step 2 ----> test el subtraction
          busA <= (others => 'Z');
          busB <= (others => 'Z');
          busC <= (others => 'Z');
          writeMem <= '0';
          aluCarryIn <= '1';
          aluSelector <= "0010"; -- (A - B)
          for i in inputSub'range Loop
            decoder_srcB_selector <= registersSelectors(i);
            decoder_dist_selector <= registersSelectors(i);
            decoder_dist_enable   <= '1';
            decoder_srcA_selector <= "0000";
            decoder_srcB_enable <= '1';
            decoder_srcA_enable <= '1';
            wait for 10 ns;
            decoder_srcA_selector <= registersSelectors(i);
            decoder_srcA_enable <= '1';
            decoder_dist_enable <= '0';
            decoder_srcB_enable <= '0';
            wait for 1 ns;
            assert(busA = outputSub(i))
            report  "BusA = "&integer'image(to_integer(unsigned(busA)))&" correct result = "&integer'image(to_integer(unsigned(outputSub(i))))
            severity error;
            wait for 9 ns;
          End Loop;

          -- test And Ro , Rx
          -- step 1 ----> Load InputData To Registers 34an bazt
          -- load Initial Data to all registers
          writeMem <= '0';
          busA <= (others => 'Z');
          busB <= (others => 'Z');
          busC <= (others => 'Z');
          decoder_srcA_enable <= '0';
          decoder_srcB_enable <= '0';
          aluSelector <= "0000";
          aluCarryIn <= '0';
          for i in registersSelectors'range Loop
            busA <= inputAnd(i);
            decoder_dist_enable <= '1';
            decoder_dist_selector <= registersSelectors(i);
            wait for 10 ns;
            decoder_srcB_selector <= registersSelectors(i);
            decoder_srcB_enable <= '1';
            decoder_dist_enable <= '0';
            wait for 1 ns;
            assert(busB = busA)
            report  "BusB = "&integer'image(to_integer(unsigned(busB)))&" BusA = "&integer'image(to_integer(unsigned(busA)))
            severity error;
            wait for 9 ns;
          end loop;

          -- step 2 ----> test el and operation
          busA <= (others => 'Z');
          busB <= (others => 'Z');
          busC <= (others => 'Z');
          writeMem <= '0';
          aluCarryIn <= '0';
          aluSelector <= "0100"; -- (A And B)
          for i in inputAnd'range Loop
            decoder_srcB_selector <= registersSelectors(i);
            decoder_dist_selector <= registersSelectors(i);
            decoder_dist_enable   <= '1';
            decoder_srcA_selector <= "0000";
            decoder_srcB_enable <= '1';
            decoder_srcA_enable <= '1';
            wait for 10 ns;
            decoder_srcA_selector <= registersSelectors(i);
            decoder_srcA_enable <= '1';
            decoder_dist_enable <= '0';
            decoder_srcB_enable <= '0';
            wait for 1 ns;
            assert(busA = outputAnd(i))
            report  "BusA = "&integer'image(to_integer(unsigned(busA)))&" correct result = "&integer'image(to_integer(unsigned(outputAnd(i))))
            severity error;
            wait for 9 ns;
          End Loop;

          -- test OR Ro , Rx
          -- step 1 ----> Load InputData To Registers 34an bazt
          -- load Initial Data to all registers
          writeMem <= '0';
          busA <= (others => 'Z');
          busB <= (others => 'Z');
          busC <= (others => 'Z');
          decoder_srcA_enable <= '0';
          decoder_srcB_enable <= '0';
          aluSelector <= "0000";
          aluCarryIn <= '0';
          for i in registersSelectors'range Loop
            busA <= inputOR(i);
            decoder_dist_enable <= '1';
            decoder_dist_selector <= registersSelectors(i);
            wait for 10 ns;
            decoder_srcB_selector <= registersSelectors(i);
            decoder_srcB_enable <= '1';
            decoder_dist_enable <= '0';
            wait for 1 ns;
            assert(busB = busA)
            report  "BusB = "&integer'image(to_integer(unsigned(busB)))&" BusA = "&integer'image(to_integer(unsigned(busA)))
            severity error;
            wait for 9 ns;
          end loop;

          -- step 2 ----> test el OR operation
          busA <= (others => 'Z');
          busB <= (others => 'Z');
          busC <= (others => 'Z');
          writeMem <= '0';
          aluCarryIn <= '0';
          aluSelector <= "0101"; -- (A OR B)
          for i in inputOR'range Loop
            decoder_srcB_selector <= registersSelectors(i);
            decoder_dist_selector <= registersSelectors(i);
            decoder_dist_enable   <= '1';
            decoder_srcA_selector <= "0000";
            decoder_srcB_enable <= '1';
            decoder_srcA_enable <= '1';
            wait for 10 ns;
            decoder_srcA_selector <= registersSelectors(i);
            decoder_srcA_enable <= '1';
            decoder_dist_enable <= '0';
            decoder_srcB_enable <= '0';
            wait for 1 ns;
            assert(busA = outputOR(i))
            report  "BusA = "&integer'image(to_integer(unsigned(busA)))&" correct result = "&integer'image(to_integer(unsigned(outputOR(i))))
            severity error;
            wait for 9 ns;
          End Loop;

          -- test XOR Ro , Rx
          -- step 1 ----> Load InputData To Registers 34an bazt
          -- load Initial Data to all registers
          writeMem <= '0';
          busA <= (others => 'Z');
          busB <= (others => 'Z');
          busC <= (others => 'Z');
          decoder_srcA_enable <= '0';
          decoder_srcB_enable <= '0';
          aluSelector <= "0000";
          aluCarryIn <= '0';
          for i in registersSelectors'range Loop
            busA <= inputXOR(i);
            decoder_dist_enable <= '1';
            decoder_dist_selector <= registersSelectors(i);
            wait for 10 ns;
            decoder_srcB_selector <= registersSelectors(i);
            decoder_srcB_enable <= '1';
            decoder_dist_enable <= '0';
            wait for 1 ns;
            assert(busB = busA)
            report  "BusB = "&integer'image(to_integer(unsigned(busB)))&" BusA = "&integer'image(to_integer(unsigned(busA)))
            severity error;
            wait for 9 ns;
          end loop;

          -- step 2 ----> test el OR operation
          busA <= (others => 'Z');
          busB <= (others => 'Z');
          busC <= (others => 'Z');
          writeMem <= '0';
          aluCarryIn <= '0';
          aluSelector <= "0110"; -- (A XOR B)
          for i in inputXOR'range Loop
            decoder_srcB_selector <= registersSelectors(i);
            decoder_dist_selector <= registersSelectors(i);
            decoder_dist_enable   <= '1';
            decoder_srcA_selector <= "0000";
            decoder_srcB_enable <= '1';
            decoder_srcA_enable <= '1';
            wait for 10 ns;
            decoder_srcA_selector <= registersSelectors(i);
            decoder_srcA_enable <= '1';
            decoder_dist_enable <= '0';
            decoder_srcB_enable <= '0';
            wait for 1 ns;
            assert(busA = outputXOR(i))
            report  "BusA = "&integer'image(to_integer(unsigned(busA)))&" correct result = "&integer'image(to_integer(unsigned(outputXOR(i))))
            severity error;
            wait for 9 ns;
          End Loop;

          -- test NOT Rx
          -- step 1 ----> Load InputData To Registers 34an bazt
          -- load Initial Data to all registers
          writeMem <= '0';
          busA <= (others => 'Z');
          busB <= (others => 'Z');
          busC <= (others => 'Z');
          decoder_srcA_enable <= '0';
          decoder_srcB_enable <= '0';
          aluSelector <= "0000";
          aluCarryIn <= '0';
          for i in registersSelectors'range Loop
            busA <= inputNOT(i);
            decoder_dist_enable <= '1';
            decoder_dist_selector <= registersSelectors(i);
            wait for 10 ns;
            decoder_srcB_selector <= registersSelectors(i);
            decoder_srcB_enable <= '1';
            decoder_dist_enable <= '0';
            wait for 1 ns;
            assert(busB = busA)
            report  "BusB = "&integer'image(to_integer(unsigned(busB)))&" BusA = "&integer'image(to_integer(unsigned(busA)))
            severity error;
            wait for 9 ns;
          end loop;

          -- -- step 2 ----> test el NOT operation
          busA <= (others => 'Z');
          busB <= (others => 'Z');
          busC <= (others => 'Z');
          writeMem <= '0';
          aluCarryIn <= '0';
          aluSelector <= "0111"; -- (Not A)
          for i in inputNOT'range Loop
            decoder_srcA_selector <= registersSelectors(i);
            decoder_dist_selector <= registersSelectors(i);
            decoder_dist_enable   <= '1';
            decoder_srcB_enable <= '0';
            decoder_srcA_enable <= '1';
            wait for 10 ns;
            decoder_srcA_selector <= registersSelectors(i);
            decoder_srcA_enable <= '1';
            decoder_dist_enable <= '0';
            decoder_srcB_enable <= '0';
            wait for 1 ns;
            assert(busA = outputNOT(i))
            report  "BusA = "&integer'image(to_integer(unsigned(busA)))&" correct result = "&integer'image(to_integer(unsigned(outputNOT(i))))
            severity error;
            wait for 9 ns;
          End Loop;

          -- test ROR Rx
          -- step 1 ----> Load InputData To Registers 34an bazt
          -- load Initial Data to all registers
          writeMem <= '0';
          busA <= (others => 'Z');
          busB <= (others => 'Z');
          busC <= (others => 'Z');
          decoder_srcA_enable <= '0';
          decoder_srcB_enable <= '0';
          aluSelector <= "0000";
          aluCarryIn <= '0';
          for i in registersSelectors'range Loop
            busA <= inputROR(i);
            decoder_dist_enable <= '1';
            decoder_dist_selector <= registersSelectors(i);
            wait for 10 ns;
            decoder_srcB_selector <= registersSelectors(i);
            decoder_srcB_enable <= '1';
            decoder_dist_enable <= '0';
            wait for 1 ns;
            assert(busB = busA)
            report  "BusB = "&integer'image(to_integer(unsigned(busB)))&" BusA = "&integer'image(to_integer(unsigned(busA)))
            severity error;
            wait for 9 ns;
          end loop;

          -- -- step 2 ----> test el ROR operation
          busA <= (others => 'Z');
          busB <= (others => 'Z');
          busC <= (others => 'Z');
          writeMem <= '0';
          aluCarryIn <= '0';
          aluSelector <= "1001"; -- (ROR A)
          for i in inputROR'range Loop
            decoder_srcA_selector <= registersSelectors(i);
            decoder_dist_selector <= registersSelectors(i);
            decoder_dist_enable   <= '1';
            decoder_srcB_enable <= '0';
            decoder_srcA_enable <= '1';
            wait for 10 ns;
            decoder_srcA_selector <= registersSelectors(i);
            decoder_srcA_enable <= '1';
            decoder_dist_enable <= '0';
            decoder_srcB_enable <= '0';
            wait for 1 ns;
            assert(busA = outputROR(i))
            report  "BusA = "&integer'image(to_integer(unsigned(busA)))&" correct result = "&integer'image(to_integer(unsigned(outputROR(i))))
            severity error;
            wait for 9 ns;
          End Loop;

          -- test ROL Rx
          -- step 1 ----> Load InputData To Registers 34an bazt
          -- load Initial Data to all registers
          writeMem <= '0';
          busA <= (others => 'Z');
          busB <= (others => 'Z');
          busC <= (others => 'Z');
          decoder_srcA_enable <= '0';
          decoder_srcB_enable <= '0';
          aluSelector <= "0000";
          aluCarryIn <= '0';
          for i in registersSelectors'range Loop
            busA <= inputROL(i);
            decoder_dist_enable <= '1';
            decoder_dist_selector <= registersSelectors(i);
            wait for 10 ns;
            decoder_srcB_selector <= registersSelectors(i);
            decoder_srcB_enable <= '1';
            decoder_dist_enable <= '0';
            wait for 1 ns;
            assert(busB = busA)
            report  "BusB = "&integer'image(to_integer(unsigned(busB)))&" BusA = "&integer'image(to_integer(unsigned(busA)))
            severity error;
            wait for 9 ns;
          end loop;

          -- -- step 2 ----> test el ROL operation
          busA <= (others => 'Z');
          busB <= (others => 'Z');
          busC <= (others => 'Z');
          writeMem <= '0';
          aluCarryIn <= '0';
          aluSelector <= "1101"; -- (ROL A)
          for i in inputROL'range Loop
            decoder_srcA_selector <= registersSelectors(i);
            decoder_dist_selector <= registersSelectors(i);
            decoder_dist_enable   <= '1';
            decoder_srcB_enable <= '0';
            decoder_srcA_enable <= '1';
            wait for 10 ns;
            decoder_srcA_selector <= registersSelectors(i);
            decoder_srcA_enable <= '1';
            decoder_dist_enable <= '0';
            decoder_srcB_enable <= '0';
            wait for 1 ns;
            assert(busA = outputROL(i))
            report  "BusA = "&integer'image(to_integer(unsigned(busA)))&" correct result = "&integer'image(to_integer(unsigned(outputROL(i))))
            severity error;
            wait for 9 ns;
          End Loop;


          -- test SHR Rx
          -- step 1 ----> Load InputData To Registers 34an bazt
          -- load Initial Data to all registers
          writeMem <= '0';
          busA <= (others => 'Z');
          busB <= (others => 'Z');
          busC <= (others => 'Z');
          decoder_srcA_enable <= '0';
          decoder_srcB_enable <= '0';
          aluSelector <= "0000";
          aluCarryIn <= '0';
          for i in registersSelectors'range Loop
            busA <= inputSHR(i);
            decoder_dist_enable <= '1';
            decoder_dist_selector <= registersSelectors(i);
            wait for 10 ns;
            decoder_srcB_selector <= registersSelectors(i);
            decoder_srcB_enable <= '1';
            decoder_dist_enable <= '0';
            wait for 1 ns;
            assert(busB = busA)
            report  "BusB = "&integer'image(to_integer(unsigned(busB)))&" BusA = "&integer'image(to_integer(unsigned(busA)))
            severity error;
            wait for 9 ns;
          end loop;

          -- -- step 2 ----> test el SHR operation
          busA <= (others => 'Z');
          busB <= (others => 'Z');
          busC <= (others => 'Z');
          writeMem <= '0';
          aluCarryIn <= '0';
          aluSelector <= "1000"; -- (SHR A)
          for i in inputSHR'range Loop
            decoder_srcA_selector <= registersSelectors(i);
            decoder_dist_selector <= registersSelectors(i);
            decoder_dist_enable   <= '1';
            decoder_srcB_enable <= '0';
            decoder_srcA_enable <= '1';
            wait for 10 ns;
            decoder_srcA_selector <= registersSelectors(i);
            decoder_srcA_enable <= '1';
            decoder_dist_enable <= '0';
            decoder_srcB_enable <= '0';
            wait for 1 ns;
            assert(busA = outputSHR(i))
            report  "BusA = "&integer'image(to_integer(unsigned(busA)))&" correct result = "&integer'image(to_integer(unsigned(outputSHR(i))))
            severity error;
            wait for 9 ns;
          End Loop;


          -- test RORC Rx
          -- step 1 ----> Load InputData To Registers 34an bazt
          -- load Initial Data to all registers
          writeMem <= '0';
          busA <= (others => 'Z');
          busB <= (others => 'Z');
          busC <= (others => 'Z');
          decoder_srcA_enable <= '0';
          decoder_srcB_enable <= '0';
          aluSelector <= "0000";
          aluCarryIn <= '0';
          for i in registersSelectors'range Loop
            busA <= inputRORC(i);
            decoder_dist_enable <= '1';
            decoder_dist_selector <= registersSelectors(i);
            wait for 10 ns;
            decoder_srcB_selector <= registersSelectors(i);
            decoder_srcB_enable <= '1';
            decoder_dist_enable <= '0';
            wait for 1 ns;
            assert(busB = busA)
            report  "BusB = "&integer'image(to_integer(unsigned(busB)))&" BusA = "&integer'image(to_integer(unsigned(busA)))
            severity error;
            wait for 9 ns;
          end loop;

          -- -- step 2 ----> test el RORC operation
          busA <= (others => 'Z');
          busB <= (others => 'Z');
          busC <= (others => 'Z');
          writeMem <= '0';
          aluCarryIn <= '0';
          aluSelector <= "1010"; -- (RORC A)
          for i in inputRORC'range Loop
            decoder_srcA_selector <= registersSelectors(i);
            decoder_dist_selector <= registersSelectors(i);
            decoder_dist_enable   <= '1';
            decoder_srcB_enable <= '0';
            decoder_srcA_enable <= '1';
            aluCarryIn <= inputRORC_Cin(i);
            wait for 10 ns;
            decoder_srcA_selector <= registersSelectors(i);
            decoder_srcA_enable <= '1';
            decoder_dist_enable <= '0';
            decoder_srcB_enable <= '0';
            wait for 1 ns;
            assert(busA = outputRORC(i))
            report  "BusA = "&integer'image(to_integer(unsigned(busA)))&" correct result = "&integer'image(to_integer(unsigned(outputRORC(i))))
            severity error;
            wait for 9 ns;
          End Loop;


          -- test ROLC Rx
          -- step 1 ----> Load InputData To Registers 34an bazt
          -- load Initial Data to all registers
          writeMem <= '0';
          busA <= (others => 'Z');
          busB <= (others => 'Z');
          busC <= (others => 'Z');
          decoder_srcA_enable <= '0';
          decoder_srcB_enable <= '0';
          aluSelector <= "0000";
          aluCarryIn <= '0';
          for i in registersSelectors'range Loop
            busA <= inputROLC(i);
            decoder_dist_enable <= '1';
            decoder_dist_selector <= registersSelectors(i);
            wait for 10 ns;
            decoder_srcB_selector <= registersSelectors(i);
            decoder_srcB_enable <= '1';
            decoder_dist_enable <= '0';
            wait for 1 ns;
            assert(busB = busA)
            report  "BusB = "&integer'image(to_integer(unsigned(busB)))&" BusA = "&integer'image(to_integer(unsigned(busA)))
            severity error;
            wait for 9 ns;
          end loop;

          -- -- step 2 ----> test el ROLC operation
          busA <= (others => 'Z');
          busB <= (others => 'Z');
          busC <= (others => 'Z');
          writeMem <= '0';
          aluCarryIn <= '0';
          aluSelector <= "1110"; -- (ROLC A)
          for i in inputROLC'range Loop
            decoder_srcA_selector <= registersSelectors(i);
            decoder_dist_selector <= registersSelectors(i);
            decoder_dist_enable   <= '1';
            decoder_srcB_enable <= '0';
            decoder_srcA_enable <= '1';
            aluCarryIn <= inputROLC_Cin(i);
            wait for 10 ns;
            decoder_srcA_selector <= registersSelectors(i);
            decoder_srcA_enable <= '1';
            decoder_dist_enable <= '0';
            decoder_srcB_enable <= '0';
            wait for 1 ns;
            assert(busA = outputROLC(i))
            report  "BusA = "&integer'image(to_integer(unsigned(busA)))&" correct result = "&integer'image(to_integer(unsigned(outputROLC(i))))
            severity error;
            wait for 9 ns;
          End Loop;


          -- test ASHR Rx
          -- step 1 ----> Load InputData To Registers 34an bazt
          -- load Initial Data to all registers
          writeMem <= '0';
          busA <= (others => 'Z');
          busB <= (others => 'Z');
          busC <= (others => 'Z');
          decoder_srcA_enable <= '0';
          decoder_srcB_enable <= '0';
          aluSelector <= "0000";
          aluCarryIn <= '0';
          for i in registersSelectors'range Loop
            busA <= inputASHR(i);
            decoder_dist_enable <= '1';
            decoder_dist_selector <= registersSelectors(i);
            wait for 10 ns;
            decoder_srcB_selector <= registersSelectors(i);
            decoder_srcB_enable <= '1';
            decoder_dist_enable <= '0';
            wait for 1 ns;
            assert(busB = busA)
            report  "BusB = "&integer'image(to_integer(unsigned(busB)))&" BusA = "&integer'image(to_integer(unsigned(busA)))
            severity error;
            wait for 9 ns;
          end loop;

          -- -- step 2 ----> test el ASHR operation
          busA <= (others => 'Z');
          busB <= (others => 'Z');
          busC <= (others => 'Z');
          writeMem <= '0';
          aluCarryIn <= '0';
          aluSelector <= "1011"; -- (ASHR A)
          for i in inputASHR'range Loop
            decoder_srcA_selector <= registersSelectors(i);
            decoder_dist_selector <= registersSelectors(i);
            decoder_dist_enable   <= '1';
            decoder_srcB_enable <= '0';
            decoder_srcA_enable <= '1';
            wait for 10 ns;
            decoder_srcA_selector <= registersSelectors(i);
            decoder_srcA_enable <= '1';
            decoder_dist_enable <= '0';
            decoder_srcB_enable <= '0';
            wait for 1 ns;
            assert(busA = outputASHR(i))
            report  "BusA = "&integer'image(to_integer(unsigned(busA)))&" correct result = "&integer'image(to_integer(unsigned(outputASHR(i))))
            severity error;
            wait for 9 ns;
          End Loop;


          wait;
    End Process;
end Architecture;
