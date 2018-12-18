LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

Entity myProcessor is
    Generic ( n : integer := 16; ramSize: integer := 64 ; MarAddressSize : integer := 6 );
    port(
           decoder_srcA_enable   , decoder_srcB_enable   , decoder_dist_enable   , aluCarryIn  , clkRam , clkNormal , writeMem , readMem : in std_logic;
           decoder_srcA_selector , decoder_srcB_selector , decoder_dist_selector , aluSelector : in std_logic_vector(3 downto 0);
           srcA_R6Enable , srcA_R7Enable , srcA_TempXEnable , srcA_TempYEnable , srcA_MDRoutEnable , srcA_IRoutEnable : in std_logic;
           srcB_R6Enable , srcB_R7Enable , srcB_TempXEnable , srcB_TempYEnable , srcB_MDRoutEnable , srcB_IRoutEnable : in std_logic;
           R6InEnable ,R7InEnable , IRinEnable : in std_logic;
           TempXinEnable , TempYinEnable : in std_logic;
           MDRinEnable , MARinEnable : in std_logic;


           busA , busB , busC : inout std_logic_vector(n-1 downto 0);
           rst : in std_logic_vector(15 downto 0)   -- 16 registers
        );
End myProcessor;

Architecture a_myProcessor of myProcessor is
    signal srcA_enable , srcB_enable , dist_enable , RoOut , R1Out , R2Out , R3Out , R4Out , R5Out , R6Out , R7Out , MDROut , dataMemory , tempRegXOut , tempRegYOut , tempRegZOut ,  flagRegOut , IRout , offsetIROut : std_logic_vector(n-1 downto 0);
    signal readBus , tempCarryOut , flagRegEnable : std_logic := '1';
    signal MAROut : std_logic_vector(MarAddressSize-1 downto 0);
    signal controlWord : std_logic_vector(24 downto 0);
    begin

    decoder_dist  : entity work.decoder4x16 port map ( decoder_dist_selector , dist_enable , decoder_dist_enable );    -- elly gaylak mn el left
    decoder_srcA  : entity work.decoder4x16 port map ( decoder_srcA_selector  , srcA_enable  , decoder_srcA_enable  );    -- elly raye7 3la tri_state elly btro7 l bus A
    decoder_srcB  : entity work.decoder4x16 port map ( decoder_srcB_selector  , srcB_enable  , decoder_srcB_enable  );    -- elly raye7 3la tri_state elly btro7 l bus B

    Ro : entity work.nDFF generic map (n) port map ( clkNormal , rst(0) , dist_enable(0) , busC , RoOut );
    R1 : entity work.nDFF generic map (n) port map ( clkNormal , rst(1) , dist_enable(1) , busC , R1Out );
    R2 : entity work.nDFF generic map (n) port map ( clkNormal , rst(2) , dist_enable(2) , busC , R2Out );
    R3 : entity work.nDFF generic map (n) port map ( clkNormal , rst(3) , dist_enable(3) , busC , R3Out );
    R4 : entity work.nDFF generic map (n) port map ( clkNormal , rst(4) , dist_enable(4) , busC , R4Out );
    R5 : entity work.nDFF generic map (n) port map ( clkNormal , rst(5) , dist_enable(5) , busC , R5Out );
    R6 : entity work.nDFF generic map (n) port map ( clkNormal , rst(6) , R6InEnable , busC , R6Out );
    R7 : entity work.nDFF generic map (n) port map ( clkNormal , rst(7) , R7InEnable , busC , R7Out );

    myMAR : entity work.mar generic map (MarAddressSize) port map ( clkNormal , rst(8) , busC(MarAddressSize-1 downto 0) , MAROut , MARinEnable );
    myMDR : entity work.mdr generic map (n) port map ( clkNormal , rst(9) , readBus , readMem , dataMemory , busC , MDROut );

    tempRegX : entity work.nDFF generic map (n) port map ( clkNormal , rst(10) , TempXinEnable , busC , tempRegXOut );
    tempRegY : entity work.nDFF generic map (n) port map ( clkNormal , rst(11) , TempYinEnable , busC , tempRegYOut );

    myFlagReg  : entity work.flagReg generic map (n) port map ( clkNormal , rst(13) , flagRegEnable , tempCarryOut , busA , busB , busC , flagRegOut );

    IR_Register : entity work.nDFF generic map(n) port map ( clkNormal , rst(14) , IRinEnable , busC , IROut);

    myRama : entity work.real_ram generic map( n , ramSize , MarAddressSize  ) port map ( clkRam , writeMem , MAROut , MDROut , dataMemory ) ;


    tri_state_Ro_BusA : entity work.tri_state generic map(n) port map ( srcA_enable(0) , RoOut , busA );
    tri_state_Ro_BusB : entity work.tri_state generic map(n) port map ( srcB_enable(0)  , RoOut , busB );

    tri_state_R1_BusA : entity work.tri_state generic map(n) port map ( srcA_enable(1) , R1Out , busA );
    tri_state_R1_BusB : entity work.tri_state generic map(n) port map ( srcB_enable(1) , R1Out , busB );

    tri_state_R2_BusA : entity work.tri_state generic map(n) port map ( srcA_enable(2) , R2Out , busA );
    tri_state_R2_BusB : entity work.tri_state generic map(n) port map ( srcB_enable(2) , R2Out , busB );

    tri_state_R3_BusA : entity work.tri_state generic map(n) port map ( srcA_enable(3) , R3Out , busA );
    tri_state_R3_BusB : entity work.tri_state generic map(n) port map ( srcB_enable(3) , R3Out , busB );

    tri_state_R4_BusA : entity work.tri_state generic map(n) port map ( srcA_enable(4) , R4Out , busA );
    tri_state_R4_BusB : entity work.tri_state generic map(n) port map ( srcB_enable(4) , R4Out , busB );

    tri_state_R5_BusA : entity work.tri_state generic map(n) port map ( srcA_enable(5) , R5Out , busA );
    tri_state_R5_BusB : entity work.tri_state generic map(n) port map ( srcB_enable(5) , R5Out , busB );




    tri_state_R6_BusA : entity work.tri_state generic map(n) port map ( srcA_R6Enable , R6Out , busA );
    tri_state_R6_BusB : entity work.tri_state generic map(n) port map ( srcB_R6Enable , R6Out , busB );

    tri_state_R7_BusA : entity work.tri_state generic map(n) port map ( srcA_R7Enable , R7Out , busA );
    tri_state_R7_BusB : entity work.tri_state generic map(n) port map ( srcB_R7Enable , R7Out , busB );

    tri_state_MDR_BusA : entity work.tri_state generic map(n) port map ( srcA_MDRoutEnable , MDROut , busA );
    tri_state_MDR_BusB : entity work.tri_state generic map(n) port map (srcB_MDRoutEnable , MDROut , busB );

    tri_state_tempRegX_BusA : entity work.tri_state generic map(n) port map ( srcA_TempXEnable , tempRegXOut , busA );
    tri_state_tempRegX_BusB : entity work.tri_state generic map(n) port map ( srcB_TempXEnable , tempRegXOut , busB );

    tri_state_tempRegY_BusA : entity work.tri_state generic map(n) port map ( srcA_TempYEnable , tempRegYOut , busA );
    tri_state_tempRegY_BusB : entity work.tri_state generic map(n) port map ( srcB_TempYEnable , tempRegYOut , busB );

    tri_state_flagReg_BusA  : entity work.tri_state generic map(n) port map ( srcA_enable(13) , flagRegOut , busA );
    tri_state_flagReg_BusB  : entity work.tri_state generic map(n) port map ( srcB_enable(13) , flagRegOut , busB );

    tri_state_IR_Register_BusA : entity work.tri_state generic map(n) port map ( srcA_IRoutEnable , offsetIROut , busA );
    tri_state_IR_Register_BusB : entity work.tri_state generic map(n) port map ( srcB_IRoutEnable , offsetIROut , busB );

    myALU : entity work.ALU generic map( n ) port map( busA , busB , aluSelector , aluCarryIn , busC , tempCarryOut );

    readBus <= '0' when readMem='1' else MDRinEnable;

    offsetIROut <= "0000011111111111" and IROut when srcA_enable(14) = '1' or srcB_enable(14) = '1';
    flagRegEnable <= '1';
End a_myProcessor;
