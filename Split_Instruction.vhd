library IEEE;
use IEEE.std_logic_1164.all;

entity Split_Instruction is
  
  generic(
    I: integer := 10;     -- I bit insturction word
    N: integer := 8
  );
  
  port(
    instr: in std_logic_vector(I-1 downto 0);   -- instruction input

    op: out std_logic_vector(3 downto 0);       -- 4 bits ALUop ??? add, sub, and, or, assign value to register, read register?
    rs: out std_logic_vector(1 downto 0);       -- select rs register
    rt: out std_logic_vector(1 downto 0);       -- select rt register
    rd: out std_logic_vector(1 downto 0)        -- select rd register
  );
end Split_Instruction;

architecture data_flow of Split_Instruction is
  begin
    
    op <= instr(I-1 downto I-4);
    rs <= instr(I-5 downto I-6);
    rt <= instr(I-7 downto I-8);
    rd <= instr(I-9 downto I-10);
    
    
end data_flow;
