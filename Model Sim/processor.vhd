LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

Entity myProcessor is
    Generic (n : integer := 16);
    port(
           decoder_src_selector , decoder_dist_selector , aluSelector              : in    std_logic_vector(3 downto 0);
           decoder_src_enable   , decoder_dist_enable  , aluCarryIn                : in    std_logic;
           clkRam , clkNormal   , readRam , writeRam , rst , writeMem , readMem    : in    std_logic;
           busA , busB , busC                                                      : inout std_logic_vector(n-1 downto 0);
           distBus                                                                 : in std_logic_vector(1 downto 0)
        );
End myProcessor;

Architecture a_myProcessor of myProcessor is
    signal src_enable  : std_logic_vector(n-1 downto 0);
    signal dist_enable : std_logic_vector(n-1 downto 0);
    signal RoOut   : std_logic_vector(n-1 downto 0);
    signal R1Out   : std_logic_vector(n-1 downto 0);
    signal R2Out   : std_logic_vector(n-1 downto 0);
    signal R3Out   : std_logic_vector(n-1 downto 0);
    signal R4Out   : std_logic_vector(n-1 downto 0);
    signal R5Out   : std_logic_vector(n-1 downto 0);
    signal R6Out   : std_logic_vector(n-1 downto 0);
    signal R7Out   : std_logic_vector(n-1 downto 0);
    signal MAROut  : std_logic_vector(5 downto 0);
    signal MDROut  : std_logic_vector(n-1 downto 0);
    signal readBus : std_logic;
    signal dataMemory : std_logic_vector(n-1 downto 0); 
    signal tempCarryOut   : std_logic;
    begin

    decoder_dist : entity work.decoder4x16 port map ( decoder_dist_selector , dist_enable , decoder_dist_enable );    -- elly gaylak mn el left
    decoder_src  : entity work.decoder4x16 port map ( decoder_src_selector  , src_enable  , decoder_src_enable  );    -- elly gaylak mn el left

    Ro : entity work.nDFF generic map (n) port map ( clkNormal , rst , dist_enable(0) , busC , RoOut );
    R1 : entity work.nDFF generic map (n) port map ( clkNormal , rst , dist_enable(1) , busC , R1Out );
    R2 : entity work.nDFF generic map (n) port map ( clkNormal , rst , dist_enable(2) , busC , R2Out );
    R3 : entity work.nDFF generic map (n) port map ( clkNormal , rst , dist_enable(3) , busC , R3Out );
    R4 : entity work.nDFF generic map (n) port map ( clkNormal , rst , dist_enable(4) , busC , R4Out );
    R5 : entity work.nDFF generic map (n) port map ( clkNormal , rst , dist_enable(5) , busC , R5Out );
    R6 : entity work.nDFF generic map (n) port map ( clkNormal , rst , dist_enable(6) , busC , R6Out );
    R7 : entity work.nDFF generic map (n) port map ( clkNormal , rst , dist_enable(7) , busC , R7Out );


    myMAR : entity work.mar generic map (6) port map ( clkNormal , rst , busC(5 downto 0) , MAROut , dist_enable(8) );

    myMDR : entity work.mdr generic map (n) port map ( clkNormal , rst , readBus , readMem , dataMemory , busC , MDROut );

    myRama : entity work.real_ram generic map(n) port map ( clkRam , writeMem , MAROut , MDROut , dataMemory ) ;

    tri_state_Ro_BusA : entity work.tri_state generic map(n) port map ( src_enable(0) , distBus(0) , RoOut , busA ); -- distBus(0) -- bewadyek l A
    tri_state_Ro_BusB : entity work.tri_state generic map(n) port map ( src_enable(0) , distBus(1) , RoOut , busB ); -- distBus(1) -- bewadyek l B
    
    tri_state_R1_BusA : entity work.tri_state generic map(n) port map ( src_enable(1) , distBus(0) , R1Out , busA ); -- distBus(0) -- bewadyek l A
    tri_state_R1_BusB : entity work.tri_state generic map(n) port map ( src_enable(1) , distBus(1) , R1Out , busB ); -- distBus(1) -- bewadyek l B
    
    tri_state_R2_BusA : entity work.tri_state generic map(n) port map ( src_enable(2) , distBus(0) , R2Out , busA ); -- distBus(0) -- bewadyek l A
    tri_state_R2_BusB : entity work.tri_state generic map(n) port map ( src_enable(2) , distBus(1) , R2Out , busB ); -- distBus(1) -- bewadyek l B
    
    tri_state_R3_BusA : entity work.tri_state generic map(n) port map ( src_enable(3) , distBus(0) , R3Out , busA ); -- distBus(0) -- bewadyek l A
    tri_state_R3_BusB : entity work.tri_state generic map(n) port map ( src_enable(3) , distBus(1) , R3Out , busB ); -- distBus(1) -- bewadyek l B
    
    tri_state_R4_BusA : entity work.tri_state generic map(n) port map ( src_enable(4) , distBus(0) , R4Out , busA ); -- distBus(0) -- bewadyek l A
    tri_state_R4_BusB : entity work.tri_state generic map(n) port map ( src_enable(4) , distBus(1) , R4Out , busB ); -- distBus(1) -- bewadyek l B
    
    tri_state_R5_BusA : entity work.tri_state generic map(n) port map ( src_enable(5) , distBus(0) , R5Out , busA ); -- distBus(0) -- bewadyek l A
    tri_state_R5_BusB : entity work.tri_state generic map(n) port map ( src_enable(5) , distBus(1) , R5Out , busB ); -- distBus(1) -- bewadyek l B

    tri_state_R6_BusA : entity work.tri_state generic map(n) port map ( src_enable(6) , distBus(0) , R6Out , busA ); -- distBus(0) -- bewadyek l A
    tri_state_R6_BusB : entity work.tri_state generic map(n) port map ( src_enable(6) , distBus(1) , R6Out , busB ); -- distBus(1) -- bewadyek l B

    tri_state_R7_BusA : entity work.tri_state generic map(n) port map ( src_enable(7) , distBus(0) , R7Out , busA ); -- distBus(0) -- bewadyek l A
    tri_state_R7_BusB : entity work.tri_state generic map(n) port map ( src_enable(7) , distBus(1) , R7Out , busB ); -- distBus(1) -- bewadyek l B
    
    
    tri_state_MDR_BusA : entity work.tri_state generic map(n) port map ( src_enable(9) , distBus(0) , MDROut , busA ); -- distBus(0) -- bewadyek l A
    tri_state_MDR_BusB : entity work.tri_state generic map(n) port map ( src_enable(9) , distBus(1) , MDROut , busB ); -- distBus(1) -- bewadyek l B
    
    

    myALU : entity work.ALU generic map(n) port map( busA , busB , aluSelector , aluCarryIn , busC , tempCarryOut );


    readBus <= '0' when readMem='1'
    else '1' and dist_enable(9) when readMem='0';


End a_myProcessor;