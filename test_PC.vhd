library IEEE;
use IEEE.std_logic_1164.all;

entity test_PC is
  
  generic(
    PC_Size: integer := 4;
    I: integer := 16
  );
  
  
  port(
    clk: in std_logic;
    
    op: out std_logic_vector(3 downto 0);
    rs: out std_logic_vector(3 downto 0);
    rt: out std_logic_vector(3 downto 0);
    rd: out std_logic_vector(3 downto 0)
  );
end test_PC;

architecture structural of test_PC is

  component PC is
    port(
      clk: in std_logic;
      
      PC: out std_logic_vector(PC_Size-1 downto 0)
    );
  end component;


  component instruction_mem is
    port(
      PC: in std_logic_vector(PC_Size-1 downto 0);
      
      instr: out std_logic_vector(I-1 downto 0)
    );
  end component;
  
  component Split_instruction is
    port(
      instr: in std_logic_vector(I-1 downto 0);

      op: out std_logic_vector(3 downto 0);
      rs: out std_logic_vector(3 downto 0);       
      rt: out std_logic_vector(3 downto 0);       
      rd: out std_logic_vector(3 downto 0)        
    );
  end component;
  
  signal instruction_temp: std_logic_vector(I-1 downto 0);
  signal PC_temp: std_logic_vector(PC_Size-1 downto 0);
  
  begin
    U0: PC
      port map(clk, PC_temp);
    U1: instruction_mem
      port map(PC_temp, instruction_temp);
    U2: Split_instruction
      port map(instruction_temp, op, rs, rt, rd);
  


end structural;