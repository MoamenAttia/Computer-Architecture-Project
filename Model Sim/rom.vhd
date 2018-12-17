library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;
use IEEE.math_real.all;

Entity real_rom is
  Port (
        rd          : in std_logic;
        address     : in  std_logic_vector(7 downto 0);
        dataOut     : out std_logic_vector(23 downto 0));
End entity real_rom;

Architecture a_rom of real_rom is
    type ramType is array(0 to 255) of std_logic_vector(23 downto 0);
    signal myROM : ramType;
begin
    dataOut <= myROM(to_integer(unsigned(address))) when rd = '1' else (others => 'Z');
End a_rom;
