LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;
Entity control_unit is
generic (n : integer := 16);
  port(
    IR : in std_logic_vector(n-1 downto 0);
    flagRegister : in std_logic_vector(n-1 downto 0);
    clkNormal , clkRam : in std_logic;
    busA,busB,busC : inout std_logic_vector(n-1 downto 0);
    rst : in std_logic_vector(15 downto 0)   -- 16 registers

    );

End entity control_unit;

Architecture a_control_unit of control_unit is
  signal external , mpcRst , romRead : std_logic;
  signal decoder_srcA_enable   , decoder_srcB_enable   , decoder_dist_enable   , aluCarryIn  , writeMem , readMem : std_logic;
  signal decoder_srcA_selector , decoder_srcB_selector , decoder_dist_selector , aluSelector : std_logic_vector(3 downto 0);
  signal srcA_R6Enable , srcA_R7Enable , srcA_TempXEnable , srcA_TempYEnable , srcA_MDRoutEnable , srcA_IRoutEnable : std_logic;
  signal srcB_R6Enable , srcB_R7Enable , srcB_TempXEnable , srcB_TempYEnable , srcB_MDRoutEnable , srcB_IRoutEnable : std_logic;
  signal R6InEnable ,R7InEnable , IRinEnable : std_logic;
  signal TempXinEnable , TempYinEnable : std_logic;
  signal MDRinEnable , MARinEnable : std_logic;


  signal externalAddress , addressCW : std_logic_vector(n-1 downto 0);
  signal addressROM : std_logic_vector(7 downto 0) := "00000100";
  signal CW : std_logic_vector(24 downto 0);
  signal addInt : integer := 0;
  Begin
    process(clkNormal)
      Begin
        external <= '0';
        if(rising_edge(clkNormal) and CW = "0000000000000000000000000") then
          
              -- if two operand and after fetching the IR -- Ro7 Geeb EL SOURCE.
              if ((addInt = 3 and IR(15) = '0') or (IR(15 downto 12) = "1000") ) then
                    if(IR( 11 downto 9 ) = "000") then
                      externalAddress <= std_logic_vector( to_unsigned( 4 , externalAddress'length ));  external <= '1';
                    elsif(IR( 11 downto 9 ) = "001") then
                      externalAddress <= std_logic_vector( to_unsigned( 6 , externalAddress'length ));  external <= '1';
                    elsif(IR( 11 downto 9 ) = "010") then
                      externalAddress <= std_logic_vector( to_unsigned( 10 , externalAddress'length )); external <= '1';
                    elsif(IR( 11 downto 9 ) = "011") then
                      externalAddress <= std_logic_vector( to_unsigned( 14 , externalAddress'length )); external <= '1';
                    elsif(IR( 11 downto 9 ) = "100") then
                      externalAddress <= std_logic_vector( to_unsigned( 19 , externalAddress'length )); external <= '1';
                    elsif(IR( 11 downto 9 ) = "101") then
                      externalAddress <= std_logic_vector( to_unsigned( 22 , externalAddress'length )); external <= '1';
                    elsif(IR( 11 downto 9 ) = "110") then
                      externalAddress <= std_logic_vector( to_unsigned( 27 , externalAddress'length )); external <= '1';
                    elsif(IR( 11 downto 9 ) = "111") then
                      externalAddress <= std_logic_vector( to_unsigned( 32 , externalAddress'length )); external <= '1';
                    end if;

              -- if One operand and after fetching the IR -- Ro7 Geeb EL Destination.
              elsif ( (addInt = 3 and IR(15 downto 12) = "1001") or (addInt = 5 or addInt = 9 or addInt = 13 or addInt = 18 or addInt = 21 or addInt = 26 or addInt = 31 or addInt = 37) ) then
                if (IR(5 downto 3) = "000") then
                  externalAddress <= std_logic_vector( to_unsigned( 38 , externalAddress'length ));   external <= '1';
                elsif (IR(5 downto 3) = "001") then
                    externalAddress <= std_logic_vector( to_unsigned( 40 , externalAddress'length )); external <= '1';
                elsif (IR(5 downto 3) = "010") then
                    externalAddress <= std_logic_vector( to_unsigned( 44 , externalAddress'length )); external <= '1';
                elsif (IR(5 downto 3) = "011") then
                    externalAddress <= std_logic_vector( to_unsigned( 48 , externalAddress'length )); external <= '1';
                elsif (IR(5 downto 3) = "100") then
                    externalAddress <= std_logic_vector( to_unsigned( 53 , externalAddress'length )); external <= '1';
                elsif (IR(5 downto 3) = "101") then
                    externalAddress <= std_logic_vector( to_unsigned( 56 , externalAddress'length )); external <= '1';
                elsif (IR(5 downto 3) = "110") then
                    externalAddress <= std_logic_vector( to_unsigned( 61 , externalAddress'length )); external <= '1';
                elsif (IR(5 downto 3) = "111") then
                    externalAddress <= std_logic_vector( to_unsigned( 66 , externalAddress'length )); external <= '1';
                end if;

              -- 96  -> # XNOR Src , Dest  if Dest is Register
              -- 98  -> # XNOR Src , Dest  if Dest is Memory
              
              -- 100 -> # INV Dest if Dest is Register Mode
              -- 102 -> # INV Dest if Dest is Memory
              
              -- 104 -> # LSL Dest if Dest is Register
              -- 106 -> # LSL Dest if Dest is Memory
              
              -- 108 -> # LSR Dest if Dest is Register
              -- 110 -> # LSR Dest if Dest is Memory
              
              -- 112 -> # ROR Dest if Dest is Register
              -- 114 -> # ROR Dest if Dest is Memory
              
              -- 116 -> # ROL Dest if Dest is Register
              -- 118 -> # ROL Dest if Dest is Memory
              
              -- 120 -> # ASR Dest if Dest is Register
              -- 122 -> # ASR Dest if Dest is Memory
              
              -- 124 -> # RRC Dest if Dest is Register
              -- 126 -> # RRC Dest if Dest is Memory
              
              -- 128 -> # RLC Dest if Dest is Register
              -- 130 -> # RLC Dest if Dest is Memory


              elsif ( addInt = 39 or addInt = 43 or addInt = 47 or addInt = 52 or addInt = 55 or addInt = 60 or addInt = 65 or addInt = 71 ) then
                  -- MOV
                  if ( IR(15 downto 12) = "0000" and IR(5 downto 3) = "000" ) then
                    externalAddress <= std_logic_vector( to_unsigned( 72 , externalAddress'length ));   external <= '1';
                  elsif ( IR(15 downto 12) = "0000") then
                    externalAddress <= std_logic_vector( to_unsigned( 74 , externalAddress'length ));   external <= '1';
                  
                  -- ADD
                  elsif ( IR(15 downto 12) = "0001" and IR(5 downto 3) = "000" ) then
                    externalAddress <= std_logic_vector( to_unsigned( 72 , externalAddress'length ));   external <= '1';
                  elsif ( IR(15 downto 12) = "0001") then
                    externalAddress <= std_logic_vector( to_unsigned( 74 , externalAddress'length ));   external <= '1';
                  
                  -- ADDC
                  elsif ( IR(15 downto 12) = "0010" and IR(5 downto 3) = "000" ) then
                    externalAddress <= std_logic_vector( to_unsigned( 76 , externalAddress'length ));   external <= '1';
                  elsif ( IR(15 downto 12) = "0010") then
                    externalAddress <= std_logic_vector( to_unsigned( 78 , externalAddress'length ));   external <= '1';
                  
                  -- SUB
                  elsif ( IR(15 downto 12) = "0011" and IR(5 downto 3) = "000" ) then
                    externalAddress <= std_logic_vector( to_unsigned( 80 , externalAddress'length ));   external <= '1';
                  elsif ( IR(15 downto 12) = "0011") then
                    externalAddress <= std_logic_vector( to_unsigned( 82 , externalAddress'length ));   external <= '1';

                  -- SUBC
                  elsif ( IR(15 downto 12) = "0100" and IR(5 downto 3) = "000" ) then
                    externalAddress <= std_logic_vector( to_unsigned( 84 , externalAddress'length ));   external <= '1';
                  elsif ( IR(15 downto 12) = "0100") then
                    externalAddress <= std_logic_vector( to_unsigned( 86 , externalAddress'length ));   external <= '1';
                  
                  -- AND
                  elsif ( IR(15 downto 12) = "0101" and IR(5 downto 3) = "000" ) then
                    externalAddress <= std_logic_vector( to_unsigned( 88 , externalAddress'length ));   external <= '1';
                  elsif ( IR(15 downto 12) = "0101") then
                    externalAddress <= std_logic_vector( to_unsigned( 90 , externalAddress'length ));   external <= '1';
                  
                  -- OR
                  elsif ( IR(15 downto 12) = "0110" and IR(5 downto 3) = "000" ) then
                    externalAddress <= std_logic_vector( to_unsigned( 92 , externalAddress'length ));   external <= '1';
                  elsif ( IR(15 downto 12) = "0110") then
                    externalAddress <= std_logic_vector( to_unsigned( 94 , externalAddress'length ));   external <= '1';
                  
                  -- XNOR
                  elsif ( IR(15 downto 12) = "0111" and IR(5 downto 3) = "000" ) then
                    externalAddress <= std_logic_vector( to_unsigned( 96 , externalAddress'length ));   external <= '1';
                  elsif ( IR(15 downto 12) = "0111") then
                    externalAddress <= std_logic_vector( to_unsigned( 98 , externalAddress'length ));   external <= '1';
                  end if;
              end if;
                
        elsif(rising_edge(clkNormal)) then
          external <= '0';
          decoder_srcA_enable <= '0'; decoder_srcB_enable <= '0'; decoder_dist_enable <= '0';
          srcA_R6Enable <= '0'; srcA_R7Enable <= '0'; srcA_TempXEnable <= '0'; srcA_TempYEnable <= '0'; srcA_MDRoutEnable <= '0'; srcA_IRoutEnable <= '0';
          srcB_R6Enable <= '0'; srcB_R7Enable <= '0'; srcB_TempXEnable <= '0'; srcB_TempYEnable <= '0'; srcB_MDRoutEnable <= '0'; srcB_IRoutEnable <= '0';
          R6InEnable <= '0'; R7InEnable <= '0'; IRinEnable <= '0';
          TempXinEnable <= '0'; TempYinEnable <= '0';
          MDRinEnable <= '0'; MARinEnable <= '0';
          -- to write on busA
          if( CW(24 downto 21) = "0000") then
              decoder_srcA_enable <= '0'; -- do nothing
          elsif ( CW(24 downto 21) = "0001" ) then
             decoder_srcA_enable <= '1';
             decoder_srcA_selector <= '0'&IR(8 downto 6);
          elsif ( CW(24 downto 21) = "0010" ) then
            decoder_srcA_enable <= '1';
            decoder_srcA_selector <= '0'&IR(2 downto 0);
          elsif ( CW(24 downto 21) = "0011" ) then
            srcA_R6Enable <= '1';
          elsif ( CW(24 downto 21) = "0100" ) then
            srcA_R7Enable <= '1';
          elsif ( CW(24 downto 21) = "0101" ) then
            srcA_TempXEnable <= '1';
          elsif ( CW(24 downto 21) = "0110" ) then
            srcA_TempYEnable <= '1';
          elsif ( CW(24 downto 21) = "0111" ) then
            srcA_MDRoutEnable <= '1';
          elsif ( CW(24 downto 21) = "1000" ) then
            srcA_IRoutEnable <= '1';
          end if;

          -- to write on busA
          if( CW(20 downto 17) = "0000") then
              decoder_srcB_enable <= '0'; -- do nothing
          elsif ( CW(20 downto 17) = "0001" ) then
             decoder_srcB_enable <= '1';
             decoder_srcB_selector <= '0'&IR(8 downto 6);
          elsif ( CW(20 downto 17) = "0010" ) then
            decoder_srcB_enable <= '1';
            decoder_srcB_selector <= '0'&IR(2 downto 0);
          elsif ( CW(20 downto 17) = "0011" ) then
            srcB_R6Enable <= '1';
          elsif ( CW(20 downto 17) = "0100" ) then
            srcB_R7Enable <= '1';
          elsif ( CW(20 downto 17) = "0101" ) then
            srcB_TempXEnable <= '1';
          elsif ( CW(20 downto 17) = "0110" ) then
            srcB_TempYEnable <= '1';
          elsif ( CW(20 downto 17) = "0111" ) then
            srcB_MDRoutEnable <= '1';
          elsif ( CW(20 downto 17) = "1000" ) then
            srcB_IRoutEnable <= '1';
          end if;

          -- to read from busC
          if( CW(16 downto 14) = "000") then
              decoder_dist_enable <= '0'; -- do nothing
          elsif ( CW(16 downto 14) = "001" ) then
             decoder_dist_enable <= '1';
             decoder_dist_selector <= '0'&IR(8 downto 6);
          elsif ( CW(16 downto 14) = "010" ) then
            decoder_dist_enable <= '1';
            decoder_dist_selector <= '0'&IR(2 downto 0);
          elsif ( CW(16 downto 14) = "011" ) then
            R6InEnable <= '1';
          elsif ( CW(16 downto 14) = "100" ) then
            R7InEnable <= '1';
          elsif ( CW(16 downto 14) = "101" ) then
            IRinEnable <= '1';
          end if;

          -- To fetch data to temp Registers
          if( CW(13 downto 12) = "00") then
              TempXinEnable <= '0'; -- do nothing
          elsif ( CW(13 downto 12) = "01" ) then
             TempXinEnable <= '1';
          elsif ( CW(13 downto 12) = "10" ) then
            TempYinEnable <= '1';
          end if;

          -- To fetch data to Memory Registers
          if( CW(11 downto 10) = "00") then
              MDRinEnable <= '0'; -- do nothing
          elsif ( CW(11 downto 10) = "01" ) then
              MDRinEnable <= '1';
          elsif ( CW(11 downto 10) = "10" ) then
              MARinEnable <= '1';
          end if;

          -- to set aluSelector
          aluSelector <= CW(9 downto 6);

          -- to setALUCarryIN
          aluCarryIn <= CW(1);

          -- to set read write
          if( CW(3 downto 2) = "00" ) then
            readMem <= '0';
            writeMem <= '0';
          elsif ( CW(3 downto 2) = "01" ) then
            readMem <= '1';
          elsif ( CW(3 downto 2) = "10" ) then
            writeMem <= '1';
          end if;

      end if;
    End process;
    addInt <= to_integer(unsigned(addressCW));


    myProcessorElGamed : entity work.myProcessor generic map(16 , 2048 , 11) port map
        (
          decoder_srcA_enable   , decoder_srcB_enable   , decoder_dist_enable   , aluCarryIn  , clkRam , clkNormal , writeMem , readMem ,
          decoder_srcA_selector , decoder_srcB_selector , decoder_dist_selector , aluSelector,
          srcA_R6Enable , srcA_R7Enable , srcA_TempXEnable , srcA_TempYEnable , srcA_MDRoutEnable , srcA_IRoutEnable,
          srcB_R6Enable , srcB_R7Enable , srcB_TempXEnable , srcB_TempYEnable , srcB_MDRoutEnable , srcB_IRoutEnable,
          R6InEnable ,R7InEnable , IRinEnable,
          TempXinEnable , TempYinEnable,
          MDRinEnable , MARinEnable ,
          busA , busB , busC,
          rst
        );

    myMPC : entity work.mpc generic map(n) port map( mpcRst , clkNormal , external , externalAddress , addressCW );
    myRom : entity work.real_rom port map( romRead , addressCW(7 downto 0) , CW  );
end a_control_unit;

-- 0   -> # Fetch and Decode
-- 4   -> # Fetch Source Register Mode
-- 6   -> # Fetch Source Auto Increment Mode
-- 10  -> # Fetch Source Auto Decrement Mode
-- 14  -> # Fetch Source Indexed Mode
-- 19  -> # Fetch Source Register Indirect
-- 22  -> # Fetch Source Auto Increment Indirect
-- 27  -> # Fetch Source Auto Decrement Indirect
-- 32  -> # Fetch Source Indexed Indirect
-- 38  -> # Fetch Destination Register Direct
-- 40  -> # Fetch Destination Auto Increment
-- 44  -> # Fetch Destination Auto Decrement
-- 48  -> # Fetch Destination Indexed
-- 53  -> # Fetch Destination Register Indirect
-- 56  -> # Fetch Destination Auto Increment Indirect
-- 61  -> # Fetch Destination Auto Decrement Indirect
-- 66  -> # Fetch Destination Indexed Indirect
-- 72  -> # Add Src , Dest  if Dest is Register Mode
-- 74  -> # Add Src , Dest  if Dest is Memory
-- 76  -> # ADDC Src , Dest if Dest is Register Mode
-- 78  -> # ADDC Src , Dest  if Dest is Memory
-- 80  -> # SUB Src , Dest if Dest is Register Mode
-- 82  -> # SUB Src , Dest if Dest is Memory
-- 84  -> # SUBC Src , Dest if Dest is Register Mode
-- 86  -> # SUBC Src , Dest if Dest is Memory
-- 88  -> # And Src , Dest if Dest is Register
-- 90  -> # And Src , Dest if Dest is Memory
-- 92  -> # OR Src , Dest if Dest is Register
-- 94  -> # OR Src , Dest if Dest is Memory
-- 96  -> # XNOR Src , Dest  if Dest is Register
-- 98  -> # XNOR Src , Dest  if Dest is Memory
-- 100 -> # INV Dest if Dest is Register Mode
-- 102 -> # INV Dest if Dest is Memory
-- 104 -> # LSL Dest if Dest is Register
-- 106 -> # LSL Dest if Dest is Memory
-- 108 -> # LSR Dest if Dest is Register
-- 110 -> # LSR Dest if Dest is Memory
-- 112 -> # ROR Dest if Dest is Register
-- 114 -> # ROR Dest if Dest is Memory
-- 116 -> # ROL Dest if Dest is Register
-- 118 -> # ROL Dest if Dest is Memory
-- 120 -> # ASR Dest if Dest is Register
-- 122 -> # ASR Dest if Dest is Memory
-- 124 -> # RRC Dest if Dest is Register
-- 126 -> # RRC Dest if Dest is Memory
-- 128 -> # RLC Dest if Dest is Register
-- 130 -> # RLC Dest if Dest is Memory

