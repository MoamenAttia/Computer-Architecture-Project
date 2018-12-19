LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;
Entity control_unit is
generic (n : integer := 16);
  port(
    IR : in std_logic_vector(n-1 downto 0);
    flagRegister : in std_logic_vector(n-1 downto 0));

End entity control_unit;

Architecture a_control_unit of control_unit is
  signal clkNormal  : std_logic := '0';
  signal clkRam : std_logic := '1';
  signal external , mpcRst , pcCoutnerRst , pcExternal : std_logic := '0';
  signal decoder_srcA_enable   , decoder_srcB_enable   , decoder_dist_enable   , aluCarryIn  , writeMem , readMem : std_logic;
  signal decoder_srcA_selector , decoder_srcB_selector , decoder_dist_selector , aluSelector : std_logic_vector(3 downto 0);
  signal srcA_R6Enable , srcA_R7Enable , srcA_TempXEnable , srcA_TempYEnable , srcA_MDRoutEnable , srcA_IRoutEnable : std_logic;
  signal srcB_R6Enable , srcB_R7Enable , srcB_TempXEnable , srcB_TempYEnable , srcB_MDRoutEnable , srcB_IRoutEnable : std_logic;
  signal R6InEnable ,R7InEnable , IRinEnable : std_logic;
  signal TempXinEnable , TempYinEnable : std_logic;
  signal MDRinEnable , MARinEnable : std_logic;
  signal rst : std_logic_vector(15 downto 0) := (others=>'0');   -- 16 registers
  signal busA,busB,busC : std_logic_vector(n-1 downto 0) := X"0000";
  signal externalAddress , pcAddressExternal , pcAddress : std_logic_vector(n-1 downto 0);
  signal addressROM : std_logic_vector(n-1 downto 0);
  signal CW : std_logic_vector(24 downto 0);
  signal addInt : integer := 0;
  signal romRead : std_logic := '1';
  Begin
    process(clkNormal)
      Begin
          external <= '0'; pcCoutnerRst <= '0'; pcExternal <= '1'; readMem <= '1'; writeMem <= '0';
          decoder_srcA_enable <= '0'; decoder_srcB_enable <= '0'; decoder_dist_enable <= '0';
          srcA_R6Enable <= '0'; srcA_R7Enable <= '0'; srcA_TempXEnable <= '0'; srcA_TempYEnable <= '0'; srcA_MDRoutEnable <= '0'; srcA_IRoutEnable <= '0';
          srcB_R6Enable <= '0'; srcB_R7Enable <= '0'; srcB_TempXEnable <= '0'; srcB_TempYEnable <= '0'; srcB_MDRoutEnable <= '0'; srcB_IRoutEnable <= '0';
          R6InEnable <= '0'; R7InEnable <= '0'; IRinEnable <= '0';
          TempXinEnable <= '0'; TempYinEnable <= '0';
          MDRinEnable <= '0'; MARinEnable <= '0';     
          pcAddressExternal <= std_logic_vector(unsigned(pcAddressExternal));
        if(rising_edge(clkNormal) and CW = "0000000000000000000000000") then
              external <= '1';
              
               -- Branches Instructtions
              if ( addInt = 3  and IR(15 downto 14) = "11" ) then
                -- BR
                if ( IR(13 downto 11) = "000" ) then
                  externalAddress <= std_logic_vector( to_unsigned( 144 , externalAddress'length ));
                  R7InEnable <= '1'; srcA_IRoutEnable <= '1';
                end if ;

              -- if two operand and after fetching the IR -- Ro7 Geeb EL SOURCE.
              elsif ((addInt = 3 and IR(15) = '0') or (IR(15 downto 12) = "1000") ) then
                    if(IR( 11 downto 9 ) = "000") then
                      externalAddress <= std_logic_vector( to_unsigned( 4 , externalAddress'length ));  
                    elsif(IR( 11 downto 9 ) = "001") then
                      externalAddress <= std_logic_vector( to_unsigned( 6 , externalAddress'length ));  
                    elsif(IR( 11 downto 9 ) = "010") then
                      externalAddress <= std_logic_vector( to_unsigned( 10 , externalAddress'length ));
                    elsif(IR( 11 downto 9 ) = "011") then
                      externalAddress <= std_logic_vector( to_unsigned( 14 , externalAddress'length ));
                    elsif(IR( 11 downto 9 ) = "100") then
                      externalAddress <= std_logic_vector( to_unsigned( 19 , externalAddress'length ));
                    elsif(IR( 11 downto 9 ) = "101") then
                      externalAddress <= std_logic_vector( to_unsigned( 22 , externalAddress'length ));
                    elsif(IR( 11 downto 9 ) = "110") then
                      externalAddress <= std_logic_vector( to_unsigned( 27 , externalAddress'length ));
                    elsif(IR( 11 downto 9 ) = "111") then
                      externalAddress <= std_logic_vector( to_unsigned( 32 , externalAddress'length ));
                    end if;

              -- if One operand and after fetching the IR -- Ro7 Geeb EL Destination.
              elsif ( (addInt = 3 and IR(15 downto 12) = "1001") or (addInt = 5 or addInt = 9 or addInt = 13 or addInt = 18 or addInt = 21 or addInt = 26 or addInt = 31 or addInt = 37) ) then
                if (IR(5 downto 3) = "000") then
                  externalAddress <= std_logic_vector( to_unsigned( 38 , externalAddress'length ));  
                elsif (IR(5 downto 3) = "001") then
                    externalAddress <= std_logic_vector( to_unsigned( 40 , externalAddress'length ));
                elsif (IR(5 downto 3) = "010") then
                    externalAddress <= std_logic_vector( to_unsigned( 44 , externalAddress'length ));
                elsif (IR(5 downto 3) = "011") then
                    externalAddress <= std_logic_vector( to_unsigned( 48 , externalAddress'length ));
                elsif (IR(5 downto 3) = "100") then
                    externalAddress <= std_logic_vector( to_unsigned( 53 , externalAddress'length ));
                elsif (IR(5 downto 3) = "101") then
                    externalAddress <= std_logic_vector( to_unsigned( 56 , externalAddress'length ));
                elsif (IR(5 downto 3) = "110") then
                    externalAddress <= std_logic_vector( to_unsigned( 61 , externalAddress'length ));
                elsif (IR(5 downto 3) = "111") then
                    externalAddress <= std_logic_vector( to_unsigned( 66 , externalAddress'length ));
                end if;

              elsif ( addInt = 39 or addInt = 43 or addInt = 47 or addInt = 52 or addInt = 55 or addInt = 60 or addInt = 65 or addInt = 71 ) then
                  -- MOV
                  if ( IR(15 downto 12) = "0000" and IR(5 downto 3) = "000" ) then
                    externalAddress <= std_logic_vector( to_unsigned( 72 , externalAddress'length ));
                  elsif ( IR(15 downto 12) = "0000") then
                    externalAddress <= std_logic_vector( to_unsigned( 74 , externalAddress'length ));
                  
                  -- ADD
                  elsif ( IR(15 downto 12) = "0001" and IR(5 downto 3) = "000" ) then
                    externalAddress <= std_logic_vector( to_unsigned( 72 , externalAddress'length ));
                  elsif ( IR(15 downto 12) = "0001") then
                    externalAddress <= std_logic_vector( to_unsigned( 74 , externalAddress'length ));
                  
                  -- ADDC
                  elsif ( IR(15 downto 12) = "0010" and IR(5 downto 3) = "000" ) then
                    externalAddress <= std_logic_vector( to_unsigned( 76 , externalAddress'length ));
                  elsif ( IR(15 downto 12) = "0010") then
                    externalAddress <= std_logic_vector( to_unsigned( 78 , externalAddress'length ));
                  
                  -- SUB
                  elsif ( IR(15 downto 12) = "0011" and IR(5 downto 3) = "000" ) then
                    externalAddress <= std_logic_vector( to_unsigned( 80 , externalAddress'length )); 
                  elsif ( IR(15 downto 12) = "0011") then
                    externalAddress <= std_logic_vector( to_unsigned( 82 , externalAddress'length ));

                  -- SUBC
                  elsif ( IR(15 downto 12) = "0100" and IR(5 downto 3) = "000" ) then
                    externalAddress <= std_logic_vector( to_unsigned( 84 , externalAddress'length ));
                  elsif ( IR(15 downto 12) = "0100") then
                    externalAddress <= std_logic_vector( to_unsigned( 86 , externalAddress'length ));
                  
                  -- AND
                  elsif ( IR(15 downto 12) = "0101" and IR(5 downto 3) = "000" ) then
                    externalAddress <= std_logic_vector( to_unsigned( 88 , externalAddress'length ));
                  elsif ( IR(15 downto 12) = "0101") then
                    externalAddress <= std_logic_vector( to_unsigned( 90 , externalAddress'length ));
                  
                  -- OR
                  elsif ( IR(15 downto 12) = "0110" and IR(5 downto 3) = "000" ) then
                    externalAddress <= std_logic_vector( to_unsigned( 92 , externalAddress'length ));
                  elsif ( IR(15 downto 12) = "0110") then
                    externalAddress <= std_logic_vector( to_unsigned( 94 , externalAddress'length ));
                  
                  -- XNOR
                  elsif ( IR(15 downto 12) = "0111" and IR(5 downto 3) = "000" ) then
                    externalAddress <= std_logic_vector( to_unsigned( 96 , externalAddress'length ));
                  elsif ( IR(15 downto 12) = "0111") then
                    externalAddress <= std_logic_vector( to_unsigned( 98 , externalAddress'length ));
                  
                  -- One Operand Instructions.

                  -- INC -- to be edited (address)
                  elsif ( IR(15 downto 12) = "1001" and IR(11 downto 8) = "0000" and IR(5 downto 3) = "000" ) then
                    externalAddress <= std_logic_vector( to_unsigned( 136 , externalAddress'length ));
                  elsif ( IR(15 downto 12) = "1001" and IR(11 downto 8) = "0000" ) then
                    externalAddress <= std_logic_vector( to_unsigned( 138 , externalAddress'length ));

                  -- DEC -- to be edited (address)
                  elsif ( IR(15 downto 12) = "1001" and IR(11 downto 8) = "0001" and IR(5 downto 3) = "000" ) then
                    externalAddress <= std_logic_vector( to_unsigned( 140 , externalAddress'length ));
                  elsif ( IR(15 downto 12) = "1001" and IR(11 downto 8) = "0001" ) then
                    externalAddress <= std_logic_vector( to_unsigned( 142 , externalAddress'length ));                  

                  -- CLR -- to be edited (address)
                  elsif (  IR(15 downto 12) = "1001" and IR(11 downto 8) = "0010" and IR(5 downto 3) = "000" ) then
                    externalAddress <= std_logic_vector( to_unsigned( 132 , externalAddress'length ));
                  elsif (  IR(15 downto 12) = "1001" and IR(11 downto 8) = "0010" ) then
                    externalAddress <= std_logic_vector( to_unsigned( 134 , externalAddress'length ));
                  
                  -- INV -- to be edited (address)
                  elsif ( IR(15 downto 12) = "1001" and IR(11 downto 8) = "0011" and IR(5 downto 3) = "000" ) then
                    externalAddress <= std_logic_vector( to_unsigned( 100 , externalAddress'length ));
                  elsif ( IR(15 downto 12) = "1001" and IR(11 downto 8) = "0011" ) then
                    externalAddress <= std_logic_vector( to_unsigned( 102 , externalAddress'length ));
                   
                  -- LSR -- to be edited (address)
                  elsif ( IR(15 downto 12) = "1001" and IR(11 downto 8) = "0100" and IR(5 downto 3) = "000" ) then
                    externalAddress <= std_logic_vector( to_unsigned( 108 , externalAddress'length ));
                  elsif ( IR(15 downto 12) = "1001" and IR(11 downto 8) = "0100" ) then
                    externalAddress <= std_logic_vector( to_unsigned( 110 , externalAddress'length ));
                  
                   -- ROR -- to be edited (address)
                  elsif ( IR(15 downto 12) = "1001" and IR(11 downto 8) = "0101" and IR(5 downto 3) = "000" ) then
                    externalAddress <= std_logic_vector( to_unsigned( 112 , externalAddress'length ));
                  elsif ( IR(15 downto 12) = "1001" and IR(11 downto 8) = "0101" ) then
                    externalAddress <= std_logic_vector( to_unsigned( 114 , externalAddress'length ));
                  
                   -- RRC -- to be edited (address)
                   elsif ( IR(15 downto 12) = "1001" and IR(11 downto 8) = "0110" and IR(5 downto 3) = "000" ) then
                    externalAddress <= std_logic_vector( to_unsigned( 124 , externalAddress'length ));
                  elsif ( IR(15 downto 12) = "1001" and IR(11 downto 8) = "0110" ) then
                    externalAddress <= std_logic_vector( to_unsigned( 126 , externalAddress'length ));
                  
                   -- ASR -- to be edited (address)
                   elsif ( IR(15 downto 12) = "1001" and IR(11 downto 8) = "0111" and IR(5 downto 3) = "000" ) then
                    externalAddress <= std_logic_vector( to_unsigned( 120 , externalAddress'length ));
                  elsif ( IR(15 downto 12) = "1001" and IR(11 downto 8) = "0111" ) then
                    externalAddress <= std_logic_vector( to_unsigned( 122 , externalAddress'length ));
                  
                   -- LSL -- to be edited (address)
                  elsif ( IR(15 downto 12) = "1001" and IR(11 downto 8) = "1000" and IR(5 downto 3) = "000" ) then
                    externalAddress <= std_logic_vector( to_unsigned( 104 , externalAddress'length ));
                  elsif ( IR(15 downto 12) = "1001" and IR(11 downto 8) = "1000" ) then
                    externalAddress <= std_logic_vector( to_unsigned( 106 , externalAddress'length ));
                  
                   -- ROL -- to be edited (address)
                  elsif ( IR(15 downto 12) = "1001" and IR(11 downto 8) = "1001" and IR(5 downto 3) = "000" ) then
                    externalAddress <= std_logic_vector( to_unsigned( 116 , externalAddress'length ));
                  elsif ( IR(15 downto 12) = "1001" and IR(11 downto 8) = "1001" ) then
                    externalAddress <= std_logic_vector( to_unsigned( 118 , externalAddress'length ));
                  
                   -- RLC -- to be edited (address)
                  elsif ( IR(15 downto 12) = "1001" and IR(11 downto 8) = "1010" and IR(5 downto 3) = "000" ) then
                    externalAddress <= std_logic_vector( to_unsigned( 128 , externalAddress'length ));
                  elsif ( IR(15 downto 12) = "1001" and IR(11 downto 8) = "1010" ) then
                    externalAddress <= std_logic_vector( to_unsigned( 130 , externalAddress'length ));
                  end if;
                    
              -- if instruction exectued then mpc = 0000
              elsif( addInt = 73 or addInt = 75 or addInt = 77 or addInt = 79 or addInt = 81 or addInt = 83 or addInt = 85 or addInt = 87 or addInt = 89 or addInt = 91  or addInt = 93 or addInt = 95 or addInt = 97 or addInt = 99 or addInt = 101 or addInt = 103 or addInt = 105 or addInt = 107 or addInt = 109 or addInt = 111 or addInt = 113 or addInt = 115 or addInt = 117 or addInt = 119 or addInt = 121 or addInt = 123 or addInt = 125 or addInt = 127 or addInt = 129 or addInt = 131 or addInt = 133 or addInt = 135 or addInt = 137 or addInt = 139 or addInt = 141 or addInt = 143 or addInt = 145) then
                externalAddress <= std_logic_vector( to_unsigned( 0 , externalAddress'length ));
                pcExternal <= '1';
                pcAddressExternal <= std_logic_vector(unsigned(pcAddressExternal) + 1);
                MARinEnable <= '1';
              end if;
                
        elsif(rising_edge(clkNormal)) then
          
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
          
          -- to write on busB
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
    addInt <= to_integer( unsigned(addressROM) );


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

    myMPC : entity work.mpc generic map(n) port map( mpcRst , clkNormal , external , externalAddress , addressROM );
    myRom : entity work.real_rom port map( romRead , addressROM(7 downto 0) , CW  );
    myPC_Coutnter : entity work.mpc generic map(n) port map ( pcCoutnerRst , clkNormal , pcExternal , pcAddressExternal , pcAddress );
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
-- 132 -> # CLR Dest if Dest is Register
-- 134 -> # CLR Dest if Dest Memory 
-- 136 -> # INC Dest if Dest is Register
-- 138 -> # INC Dest if Dest Memory 
-- 140 -> # DEC Dest if Dest is Register
-- 142 -> # DEC Dest if Dest Memory
-- 144 -> # BR Offset