LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

Entity control_unit is
generic (n : integer := 16);
  port(
    IR : in std_logic_vector(n-1 downto 0);
    flagRegister : in std_logic_vector(n-1 downto 0);
    clk : in std_logic);
End entity control_unit;

Architecture a_control_unit of control_unit is
  signal external , mpcRst , romRead : std_logic;
  signal externalAddress , addressCW : std_logic_vector(n-1 downto 0);
  signal addressROM : std_logic_vector(7 downto 0);
  signal CW : std_logic_vector(24 downto 0);
  Begin
    process(clk)
      Begin
        if(rising_edge(clk) and CW=(others => "0000000000000000000000000"))


    End process;

    myMPC : entity work.mpc generic map(n) port map( mpcRst , clk , external , externalAddress , addressCW );
    myRom : entity work.real_rom port map( romRead , addressROM , CW  );
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
