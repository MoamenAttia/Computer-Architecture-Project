library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;
use IEEE.math_real.all;

Entity real_ram is
  generic ( n : integer := 32; ramSize : integer := 64; MarAddressSize : integer := 6 );
    Port (
        clk         : in  std_logic;
        writeEnable : in  std_logic;
        address     : in  std_logic_vector(MarAddressSize-1 downto 0); -- assuming enha 64 byte y3ny.
        dataIn      : in  std_logic_vector(n-1 downto 0);
        dataOut     : out std_logic_vector(n-1 downto 0));
End entity real_ram;

Architecture a_ram of real_ram is
    type ramType is array(0 to ramSize-1) of std_logic_vector(n-1 downto 0);
    signal myRam : ramType;
begin
    process(clk)
        begin
            if rising_edge(clk) then
                if writeEnable = '1' then
                    myRam(to_integer(unsigned(address))) <= dataIn;
                end if;
            end if;
    end process;
    dataOut <= myRam(to_integer(unsigned(address)));
End a_ram;
