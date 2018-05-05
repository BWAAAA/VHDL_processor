library IEEE;
use IEEE.std_logic_1164.all;

entity test_ALU_REG is 

  generic(
    N: integer := 8;
    K: integer := 2
  );


  port(
    clk: in std_logic;
    rs: in std_logic_vector(K-1 downto 0);
    rt: in std_logic_vector(K-1 downto 0);
    sel_wr: in std_logic_vector(K-1 downto 0);    -- select register to write
    data: in std_logic_vector(N-1 downto 0);      -- data to write in register
    wr: in std_logic;   -- write enable logic
    
    st: in std_logic; -- start ALU operation
    
    ALUop: in std_logic_vector(K-1 downto 0);
  
    aluOUT: out std_logic_vector(N-1 downto 0)
  );
end test_ALU_REG;


architecture test of test_ALU_REG is

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
  
  signal r1_temp: std_logic_vector(N-1 downto 0);
  signal r2_temp: std_logic_vector(N-1 downto 0);
  signal out_temp: std_logic_vector(N-1 downto 0);
  
  signal reg_data: std_logic_vector(N-1 downto 0);
  
  begin
      
      reg_data <= out_temp when st = '1' and wr = '1' else
                  data;
                  
      aluOUT <= out_temp when st = '1';
      
      U0: reg_file
        port map(clk, reg_data, sel_wr, wr, rs, rt, r1_temp, r2_temp);
      U1: ALU
        port map(r1_temp, r2_temp, ALUop, clk, out_temp);  

end test;