library IEEE;
use IEEE.std_logic_1164.all;

-- D flip flop
entity D_FF is
  port(
    d: in std_logic;
    s: in std_logic;
    clk: in std_logic;
    q: out std_logic
  );
end D_FF;

architecture Behavioral of D_FF is
  begin
    process(clk)
      begin
        -- if (rising edge) of clock and s = 1(store is enable) then
        -- output = input (mem input logic)
        if rising_edge(clk) and (s='1') then
          q <= d;
        end if;
    end process;
    
end Behavioral;