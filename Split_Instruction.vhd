library IEEE;
use IEEE.std_logic_1164.all;

entity Split_Instruction is
  
  generic(
    I: integer := 16;     -- I bit insturction word
    K: integer := 4        -- selector size
  );
  
  port(
    instr: in std_logic_vector(I-1 downto 0);   -- instruction input

    op: out std_logic_vector(3 downto 0);       -- 4 bits ALUop ??? add, sub, and, or, assign value to register, read register?
    rs: out std_logic_vector(K-1 downto 0);       -- select rs register
    rt: out std_logic_vector(K-1 downto 0);       -- select rt register
    rd: out std_logic_vector(K-1 downto 0)        -- select rd register
  );
end Split_Instruction;

architecture data_flow of Split_Instruction is
  begin
    
    op <= instr(I-1 downto I-4);
    rs <= instr(I-5 downto I-8);
    rt <= instr(I-9 downto I-12);
    rd <= instr(I-13 downto I-16);
    
end data_flow;
