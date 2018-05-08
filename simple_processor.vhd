-- simple processor with PC

-- PC size = 4 bit -> 2^4 instruction word


-- instruction word size = 16 bits
-- instruction memory size = 16 word of instruction
-----------------------------------------
-- instruction field| op | rs | rt | rd |
-- size             |  4 |  4 |  4 |  4 |
-----------------------------------------


-- register size 8 bits per word
-- 16 words register file r0: 0000 to r15: 1111


-- op = 00xx
-- assign user input data(rs & rt (8 bits)) to rd

-- op = 10xx, 11xx
-- do nothing use for read register

-- op = 11xx
-- ALU xx operation, and write result to rd
-------------------------------------------
-- ALU operation
--     00  rd = rs and rt
--     01  rd = rs or rt
--     10  rd = rs + rt
--     11  rd = rs - rt


library IEEE;
use IEEE.std_logic_1164.all;

entity simple_processor is
  generic(
    I: integer := 16;   -- I bits Instruction word
    N: integer := 8;    -- N bits register word
    K: integer := 4;    -- K bits reg selector 
    PC_Size: integer := 4
  );


  port(
    clk: in std_logic;
    
    -- output
    r1_reg: out std_logic_vector(N-1 downto 0);
    r2_reg: out std_logic_vector(N-1 downto 0);
    ALU_output: out std_logic_vector(N-1 downto 0)
  );
  
end simple_processor;
 

architecture Structural of simple_processor is

  component PC is
    port(
      clk: in std_logic;
      
      PC: out std_logic_vector(PC_Size-1 downto 0)
    );
  end component;


  component instruction_mem is
    port(
      PC: in std_logic_vector(PC_size-1 downto 0);
      
      instr: out std_logic_vector(I-1 downto 0)
    );

  end component;

  component control is 
    port(
      op: in std_logic_vector(3 downto 0);
      
      ALUop: out std_logic_vector(1 downto 0);
      sel_data: out std_logic;
      wr: out std_logic
    );
  end component;
  
  
  component Split_instruction is
    port(
      instr: in std_logic_vector(I-1 downto 0);   -- instruction input

      op: out std_logic_vector(3 downto 0);
      rs: out std_logic_vector(K-1 downto 0);
      rt: out std_logic_vector(K-1 downto 0);
      rd: out std_logic_vector(K-1 downto 0)
    );
  end component;
  
  component reg_file is
    port(
      clk: in std_logic;
      
      reg_in: in std_logic_vector(N-1 downto 0);
      sel_wr: in std_logic_vector(K-1 downto 0);
      wr: in std_logic;
      
      sel_r1: in std_logic_vector(K-1 downto 0);
      sel_r2: in std_logic_vector(K-1 downto 0);
      
      reg_out1: out std_logic_vector(N-1 downto 0);
      reg_out2: out std_logic_vector(N-1 downto 0)
    );
  end component;
  
  component ALU is
    port(
      rs, rt: in std_logic_vector(N-1 downto 0);
      ALUop: in std_logic_vector(1 downto 0);
      clk: in std_logic;
      
      rd: out std_logic_vector(N-1 downto 0)
    );
  end component;

  signal PC_temp: std_logic_vector(PC_Size-1 downto 0);
  signal instr_temp: std_logic_vector(I-1 downto 0);
  
  signal op_temp: std_logic_vector(3 downto 0);
  signal ALU_op: std_logic_vector(1 downto 0);
  
  signal rs_addr: std_logic_vector(K-1 downto 0);
  signal rt_addr: std_logic_vector(K-1 downto 0);
  signal rd_addr: std_logic_vector(K-1 downto 0);
  
  signal rs_reg: std_logic_vector(N-1 downto 0);
  signal rt_reg: std_logic_vector(N-1 downto 0);
  signal rd_reg: std_logic_vector(N-1 downto 0);
  
  signal select_data: std_logic;
  signal wr_temp: std_logic;
  signal data_temp: std_logic_vector(N-1 downto 0);
  
  
  begin
    
    data_temp <= (rs_addr & rt_addr) when select_data = '0' else            -- assign value from instruction
                 rd_reg;
    
    
    
    
    Program_counter: PC
      port map(clk, PC_temp);
    
    instruction_memory : instruction_mem  
      port map(PC_temp, instr_temp);
    
    control_unit: control
      port map(op_temp, ALU_op, select_data, wr_temp);
    
    U0: split_instruction
      port map(instr_temp, op_temp, rs_addr, rt_addr, rd_addr);
      
    register_file: reg_file
      port map(clk, data_temp, rd_addr, wr_temp, rs_addr, rt_addr, rs_reg, rt_reg);
      
    Arithmetic_logic_unit: ALU
      port map(rs_reg, rt_reg, ALU_op, clk, rd_reg);
    
  
  r1_reg <= rs_reg;
  r2_reg <= rt_reg;
  ALU_output <= rd_reg;
  
end Structural;