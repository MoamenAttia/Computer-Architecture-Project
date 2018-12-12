LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;
Entity myProcessorTestBench is
Generic ( n : integer := 16; ramSize : integer:= 128; MarAddressSize : integer := 10 );
End myProcessorTestBench;

Architecture a_myProcessorTestBench of myProcessorTestBench is

  Signal decoder_srcA_enable , decoder_srcB_enable , decoder_dist_enable , aluCarryIn , clkRam , clkNormal , writeMem , readMem : std_logic;
  Signal decoder_srcA_selector , decoder_srcB_selector, decoder_dist_selector , aluSelector : std_logic_vector(3 downto 0);
  Signal busA , busB , busC : std_logic_vector(n-1 downto 0);
  Signal rst : std_logic_vector(9 downto 0);

    Begin
    Process
      Begin
          -- Initialize The Ram with values begins with 100 to ..
          decoder_srcA_selector <= "0000";
          decoder_srcB_selector <= "0000";
          decoder_srcB_enable <= '0';
          decoder_srcA_enable <= '0';
          decoder_dist_enable <= '1';
          aluSelector <= "0000";
          aluCarryIn <= '0';
          clkNormal <= '1';
          readMem <= '0';
          clkRam <= '0';
          busA <= (others => '0');
          busB <= (others => '0');
          busC <= (others => 'Z');
          rst  <= (others => '0');

          for i in 0 to ramSize-1 loop
            writeMem <= '0';
            busA <= std_logic_vector ( to_unsigned( i , busA'length ) );
            decoder_dist_selector <= "1000";
            clkNormal <= '0';
            wait for 1 ns;
            clkNormal <= '1';
            wait for 1 ns;

            busA <= std_logic_vector ( to_unsigned( integer(i + 100) , busA'length ) );
            decoder_dist_selector <= "1001";
            clkNormal <= '0';
            wait for 1 ns;
            clkNormal <= '1';
            wait for 1 ns;

            writeMem <= '1';
            clkNormal <= '0';
            clkRam <= '1';
            wait for 1 ns;
            clkNormal <= '1';
            clkRam <= '0';
            wait for 1 ns;

          End loop;
          wait;

    End Process;

  myProcessorTest: entity work.myProcessor generic map( n , ramSize , MarAddressSize ) port map ( decoder_srcA_enable, decoder_srcB_enable , decoder_dist_enable , aluCarryIn , clkRam , clkNormal , writeMem , readMem , decoder_srcA_selector , decoder_srcB_selector , decoder_dist_selector , aluSelector , busA , busB , busC , rst );
end a_myProcessorTestBench;

