library IEEE;
use IEEE.std_logic_1164.all;

-- register
entity regi is 
  
  generic(
    N: integer := 8
  );

  port(
    register_in: in std_logic_vector(N-1 downto 0);       -- N bit register input
    wr: in std_logic;                                     -- write enable
    clk: in std_logic;
    register_out: out std_logic_vector(N-1 downto 0)      -- register output
  );
  
end regi;

architecture structural of regi is
  
  component D_FF is
    port(
      d: in std_logic;
      s: in std_logic;
      clk: in std_logic;
      q: out std_logic
    );
  end component;
  
  signal register_tmp: std_logic_vector(N-1 downto 0);
  
  begin
    -- save logic to d_ff 1 bit per 1 d_ff
    loop_call_DFF: for i in 0 to N-1 generate
      -- call DFF
      save_to_DFF: D_FF
        port map(register_in(i), wr, clk, register_tmp(i));
    end generate;
    
    register_out <= register_tmp;
 
end structural; 