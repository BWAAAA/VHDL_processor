library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
--use IEEE.numeric_std.all;
--use IEEE.std_logic_unsigned.all;

-------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use work.mymatrix.all;  

-------------------------------------------------------------


entity reg_file is

  generic(
    K: integer := 2;         -- K bit selector, 2^K words register
    N: integer := 8          -- N bit register word
  );

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

end reg_file;

architecture Structural of reg_file is

  component regi is
    port(
      register_in: in std_logic_vector(N-1 downto 0);
      wr: in std_logic;
      clk: in std_logic;
      register_out: out std_logic_vector(N-1 downto 0)
    );
  end component;
  
  component generic_decoder is
    port(
      sel: in std_logic_vector(k-1 downto 0);
      d_out: out std_logic_vector((2**k)-1 downto 0)
    );
  end component;
    
  component N_bit_selector_MUX is
    port(
      mux_in: in matrix(0 to (2**K)-1);
      sel: in std_logic_vector(K-1 downto 0);
      mux_out: out std_logic_vector(N-1 downto 0)
    );
  end component;  
  
  signal selector_temp: std_logic_vector(2**K - 1 downto 0);
  signal register_file_temp: matrix(0 to (2**K)-1);
  signal mux1_out: std_logic_vector(N-1 downto 0);
  signal mux2_out: std_logic_vector(N-1 downto 0);
    
  begin
    -- decode the k-bits selector input
    decode: generic_decoder
      port map(sel_wr, selector_temp);
    save: for i in 0 to ((2**K) - 1) generate
      U0: regi
        port map(reg_in, (wr and selector_temp(i)), clk, register_file_temp(i));
    end generate;
    
    mux1_output: N_bit_selector_MUX
      port map(register_file_temp, sel_r1, mux1_out);
    mux2_output: N_bit_selector_MUX
      port map(register_file_temp, sel_r2, mux2_out);

    reg_out1 <= mux1_out;
    reg_out2 <= mux2_out;
  
end structural;