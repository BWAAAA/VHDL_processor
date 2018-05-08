library IEEE;
use IEEE.std_logic_1164.all;

entity control is
  port(
    op: in std_logic_vector(3 downto 0);
    
    ALUop: out std_logic_vector(1 downto 0);
    sel_data: out std_logic;
    wr: out std_logic
  );
end control;

architecture data_flow of control is

  begin
    
    wr <= '1' when op(3 downto 2) = "00" else     -- assign register value from instruction
          '1' when op(3 downto 2) = "11" else     -- assign register value from ALU output
          '0';
          
    ALUop <= op(1 downto 0) when op(3 downto 2) = "11" else   -- do xx ALU operation when 11xx
          "00";
          
    sel_data <= '1' when op(3 downto 2) = "11" else      -- select data from ALU output
                '0';                                          -- select data from instruction
  
  
  
  
end data_flow;
