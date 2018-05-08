library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;

entity PC is
  generic(
    PC_Size: integer := 4
  );
  
  port(
    clk: in std_logic;
    
    PC: out std_logic_vector(PC_Size-1 downto 0)
  );
  
end PC;

architecture behavioral of PC is

  Signal Program_counter: std_logic_vector(PC_Size-1 downto 0) := "0000";

  begin
    process(clk)
      begin
        if rising_edge(clk) then
          Program_counter <= Program_counter + 1;
          
        end if;
        
        PC <= Program_counter;
    end process;
    
end behavioral;