library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

entity ALU is
  
  generic(
    N: integer := 8     -- N bits register input
  );
  
  port(
  rs, rt: in std_logic_vector(N-1 downto 0);        -- 2 input register rs rt
  ALUop: in std_logic_vector(1 downto 0);           -- 2 bit ALU operation selector
  clk: in std_logic;
  
  
  rd: out std_logic_vector(N-1 downto 0)            -- 1 output register rd
  );
  
end ALU;

architecture data_flow of ALU is

  signal res_temp: std_logic_vector(N-1 downto 0);
  signal carry: std_logic_vector(N downto 0);
  
  begin
  process(clk)
    begin
      
      -- and
      if ALUop = "00" then
        res_temp <= rs and rt;
      
      -- or
      elsif ALUop = "01" then
        res_temp <= rs or rt;
      
      -- add
      elsif ALUop = "10" then
        adder: for i in 0 to N-1 loop
          res_temp(i) <= (rs(i) xor rt(i)) xor carry(i);
          carry(i+1) <= (rs(i) and rt(i)) or (carry(i) and (rs(i) xor rt(i)));
        end loop;
        
        
      end if;
      
      
      rd <= res_temp;
  end process;    

  
end data_flow;