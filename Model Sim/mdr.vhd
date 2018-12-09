library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mdr is
  generic ( n : integer := 32);
  port( clk , rst , enBus , enMem : in std_logic;
      dataMemory , dataBus        : in std_logic_vector(n-1 downto 0);    
      q                           : out std_logic_vector(n-1 downto 0)  
  );
 end mdr;

Architecture a_mdr of mdr is
begin
   process(clk , rst , enBus , enMem)
      begin
         if rst = '1' then
            q <= (OTHERS=>'0');
         elsif (rising_edge(clk) and enBus = '1') then
            q <= dataBus;
         elsif (rising_edge(clk) and enMem = '1') then
            q <= dataMemory;
         end if;
   end process;
End a_mdr;