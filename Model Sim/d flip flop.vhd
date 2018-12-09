library ieee;
use ieee.std_logic_1164.all;

Entity dff is
     port ( d , clk , rst , en : in  std_logic;
            q                  : out std_logic);
End dff;

Architecture a_dff of dff is
  Begin
    Process(clk,rst,en)
      Begin
        if(rst = '1') then
           q <= '0';
        elsif rising_edge(clk) and en = '1' then     
          q <= d;
        End if;
    End process;
End a_dff;
