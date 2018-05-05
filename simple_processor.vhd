-- simple processor without PC

-- instruction word size = 10 bits
-----------------------------------------
-- instruction field| op | rs | rt | rd |
-- size             |  4 |  2 |  2 |  2 |
-----------------------------------------

-- op = 00xx
-- assign user input data to rd when write = 1

-- op = 11xx
-- ALU xx operation, and write result to rd
--    00  rd = rs and rt
--    01  rd = rs or rt
--    10  rd = rs + rt
--    11  rd = rs - rt

library IEEE;
use IEEE.std_logic_1164.all;


entity simple_processor is
  generic(
    I: integer := 10;   -- I bits Instruction word
    N: integer := 8;    -- N bits register word
    K: integer := 2    -- K bits reg selector 
  );


  port(
    clk: in std_logic;
    instr: in std_logic_vector(I-1 downto 0);
    
    --write
    wr: in std_logic;      -- enable to write data to rd register
    wr_data: in std_logic_vector(N-1 downto 0);     -- data
    
    -- output
    r1_reg: out std_logic_vector(N-1 downto 0);
    r2_reg: out std_logic_vector(N-1 downto 0);
    ALU_output: out std_logic_vector(N-1 downto 0)
  );
  
end simple_processor;
 

architecture Structural of simple_processor is

  component Split_instruction is
    port(
      instr: in std_logic_vector(I-1 downto 0);   -- instruction input

      op: out std_logic_vector(3 downto 0);
      rs: out std_logic_vector(1 downto 0);
      rt: out std_logic_vector(1 downto 0);
      rd: out std_logic_vector(1 downto 0)
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
      ALUop: in std_logic_vector(K-1 downto 0);
      clk: in std_logic;
      
      rd: out std_logic_vector(N-1 downto 0)
    );
  end component;

  signal op_temp: std_logic_vector(3 downto 0);
  signal ALU_op: std_logic_vector(1 downto 0);
  
  signal rs_addr: std_logic_vector(1 downto 0);
  signal rt_addr: std_logic_vector(1 downto 0);
  signal rd_addr: std_logic_vector(1 downto 0);
  
  signal rs_reg: std_logic_vector(N-1 downto 0);
  signal rt_reg: std_logic_vector(N-1 downto 0);
  signal rd_reg: std_logic_vector(N-1 downto 0);
  
  signal select_data: std_logic;
  signal wr_temp: std_logic;
  signal data_temp: std_logic_vector(N-1 downto 0);
  
  
  begin
  
    ALU_op <= op_temp(1 downto 0) when op_temp(3 downto 2) = "11" else
              "00";
    
    select_data <= '1' when op_temp(3 downto 2)  = "11" else      -- select data from ALU
                   '0';                                           -- select data from user input assign 

    wr_temp <= wr when op_temp(3 downto 2) = "00" else            -- when user want to assign data to register - manual enable write
               '1' when op_temp(3 downto 2) = "11";               -- when ALU mode always write data to rd
    
    data_temp <= wr_data when select_data = '0' else
                 rd_reg;
    
    
    U0: split_instruction
      port map(instr, op_temp, rs_addr, rt_addr, rd_addr);
      
    U1: reg_file
      port map(clk, data_temp, rd_addr, wr_temp, rs_addr, rt_addr, rs_reg, rt_reg);
      
    U2: ALU
      port map(rs_reg, rt_reg, ALU_op, clk, rd_reg);
    
  
  r1_reg <= rs_reg;
  r2_reg <= rt_reg;
  ALU_output <= rd_reg;
  
end Structural;