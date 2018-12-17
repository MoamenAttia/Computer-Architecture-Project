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
  signal CW : std_logic_vector(23 downto 0);
  Begin
    myMPC : entity work.mpc generic map(n) port map( mpcRst , clk , external , externalAddress , addressCW );
    myRom : entity work.real_rom port map( romRead , addressROM , CW  );
  
end a_control_unit;
