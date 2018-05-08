library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


entity generic_decoder is
  
  generic(
    k: integer := 4     -- selector bit
  );
  
  port(
    sel: in std_logic_vector(k-1 downto 0);     -- selector input
  
    d_out: out std_logic_vector((2**k)-1 downto 0)    -- output = 1 for write enable
  );
  
end generic_decoder;


architecture data_flow of generic_decoder is 
  signal out_tmp: std_logic_vector((2**k)-1 downto 0);
  
  begin
    out_tmp <= std_logic_vector( to_unsigned( 2**to_integer(unsigned(sel)), 2**k ) );
    d_out <= out_tmp;

    
end data_flow;