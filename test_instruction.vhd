library IEEE;
use IEEE.std_logic_1164.all;

entity test_instruction is

  generic(
    I: integer := 8;      -- I bits instruction
    N: integer := 8;      -- N bits register
    K: integer := 2       -- K bits register selector size
  );


  port(
    clk: in std_logic;
    instr: in std_logic_vector(I-1 downto 0);
    -- to assign value to register 
    wr: in std_logic;
    wr_data: in std_logic_vector(N-1 downto 0);
    --wr_addr: in std_logic_vector(K-1 downto 0);
    
    r1_reg: out std_logic_vector(N-1 downto 0);
    r2_reg: out std_logic_vector(N-1 downto 0);
    op: out std_logic_vector(1 downto 0);
    ALUout: out std_logic_vector(N-1 downto 0)
  );
  
end test_instruction;

architecture Structural of test_instruction is

  component Split_instruction is
    port(
      instr: in std_logic_vector(I-1 downto 0);   -- instruction input

      op: out std_logic_vector(1 downto 0);       -- 4 bits ALUop ??? add, sub, and, or, assign value to register, read register?
      rs: out std_logic_vector(1 downto 0);       -- select rs register
      rt: out std_logic_vector(1 downto 0);       -- select rt register
      rd: out std_logic_vector(1 downto 0)        -- select rd register
    );
  end component;
  
  component reg_file is
    port(
      clk: in std_logic;
      
      reg_in: in std_logic_vector(N-1 downto 0);     -- register in to write
      sel_wr: in std_logic_vector(K-1 downto 0);     -- select register location to write
      wr: in std_logic;                              -- wr control, 1 = write enable
      
      sel_r1: in std_logic_vector(K-1 downto 0);     -- register1 read control
      sel_r2: in std_logic_vector(K-1 downto 0);     -- register2 read control
      
      reg_out1: out std_logic_vector(N-1 downto 0);  -- register1 output
      reg_out2: out std_logic_vector(N-1 downto 0)   -- register2 output
    );
  end component;
  
  component ALU is
    port(
      rs, rt: in std_logic_vector(N-1 downto 0);        -- 2 input register rs rt
      ALUop: in std_logic_vector(K-1 downto 0);         -- 2 bit ALU operation selector
      clk: in std_logic;
      
      
      rd: out std_logic_vector(N-1 downto 0)            -- 1 output register rd
    );
  end component;
  
  
  signal rs_addr_temp: std_logic_vector(1 downto 0);
  signal rt_addr_temp: std_logic_vector(1 downto 0);
  signal rd_addr_temp: std_logic_vector(1 downto 0);
  signal op_temp: std_logic_vector(1 downto 0);

  signal rs_reg_temp: std_logic_vector(N-1 downto 0);
  signal rt_reg_temp: std_logic_vector(N-1 downto 0);
  signal rd_reg_temp: std_logic_vector(N-1 downto 0);
  
  begin
  
    U0: Split_instruction
      port map(instr, op_temp, rs_addr_temp, rt_addr_temp, rd_addr_temp);
    
    U1: reg_file
      port map(clk, wr_data, rd_addr_temp, wr, rs_addr_temp, rt_addr_temp, rs_reg_temp, rt_reg_temp);    
    
    U2: ALU
      port map(rs_reg_temp, rt_reg_temp, op_temp, clk, rd_reg_temp);
  
        
    op <= op_temp;
    r1_reg <= rs_reg_temp;
    r2_reg <= rt_reg_temp;
    ALUout <= rd_reg_temp;
    
end Structural;