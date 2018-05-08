library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

package mymatrix is
  constant N: integer := 8;   -- each input size
  type matrix is array(natural range<>) of std_logic_vector(N-1 downto 0);
end mymatrix;


-----------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.mymatrix.all;

-----------------------------------------


entity N_bit_selector_MUX is
  
  generic(
    K: integer := 4;  -- selector size, 2**K input
    N: integer := 8   -- each input size
  );
  
  port(
    mux_in: in matrix(0 to (2**K)-1);
    sel: in std_logic_vector(K-1 downto 0);
  
    mux_out: out std_logic_vector(N-1 downto 0)
  );
  
end N_bit_selector_MUX;

architecture data_flow of  N_bit_selector_MUX is
  begin
    mux_out <= mux_in( to_integer(unsigned(sel)) ); 
    
end data_flow;