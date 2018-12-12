LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;
Entity myProcessorTestBench is
Generic ( n : integer := 16; ramSize : integer:= 128; MarAddressSize : integer := 10 );
End myProcessorTestBench;

Architecture a_myProcessorTestBench of myProcessorTestBench is

  Signal clkNormal : std_logic := '0';
  Signal clkRam : std_logic := '1';
  Signal decoder_srcA_enable , decoder_srcB_enable , decoder_dist_enable , aluCarryIn , writeMem , readMem : std_logic := '0';
  Signal decoder_srcA_selector , decoder_srcB_selector, decoder_dist_selector , aluSelector : std_logic_vector(3 downto 0) := "0000";
  Signal busA , busB , busC : std_logic_vector(n-1 downto 0) := X"0000";
  Signal rst : std_logic_vector(15 downto 0) := X"0000";

  Type selectorTypes is array (0 TO 8) of std_logic_vector( 3 downto 0 );
  Type registerType  is array (0 TO 8) of std_logic_vector(n-1 downto 0);
  Constant registersSelectors : selectorTypes   := ( "0000"  , "0001"  , "0010"  , "0011"  , "0100"  , "0101"  , "0110"  , "0111"  , "1001" );
  Constant initialData : registerType           := ( X"AABB" , X"BBCC" , X"F0F0" , X"ECED" , X"0101" , X"EAC1" , X"DED1" , X"A126" ,  X"0115" );

  constant ClockFrequency : integer := 100e6;
  constant ClockPeriod    : time    := 1000 ms / ClockFrequency;

  Begin
    myProcessorTest: entity work.myProcessor generic map( n , ramSize , MarAddressSize ) port map ( decoder_srcA_enable, decoder_srcB_enable , decoder_dist_enable , aluCarryIn , clkRam , clkNormal , writeMem , readMem , decoder_srcA_selector , decoder_srcB_selector , decoder_dist_selector , aluSelector , busA , busB , busC , rst );
    -- Process for generating the clock
    clkRam <= not clkRam after ClockPeriod / 2;
    clkNormal <= not clkNormal after ClockPeriod / 2;

    process is
      Begin
          -- Initialize The Ram with values begins with 100 to ..
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
          wait;
    End Process;
end Architecture;
