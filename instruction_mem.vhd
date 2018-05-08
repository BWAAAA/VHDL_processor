library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


package instruction_memory is
  constant N: integer := 16;   -- each instruction size
  type instructionMEM is array(natural range<>) of std_logic_vector(N-1 downto 0);
end instruction_memory;


library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.instruction_memory.all;


entity instruction_mem is
  generic(
    I: integer := 16;    -- I bit instruction word
    PC_size: integer := 4
  );

  port(
    PC: in std_logic_vector(PC_size-1 downto 0);
    
    instr: out std_logic_vector(I-1 downto 0)
  );
end instruction_mem;

architecture data_flow of instruction_mem is
  
  signal MEM: instructionMEM(0 to 15) := (
  "0000010100000001",     -- 0
  "0000010100000010",
  "0000000000011111",
  "0100000000100000",
  "0100000100110000",
  "0000010000000000",     -- 5
  "0000001000000000",     
  "0000000100000000",
  "0000000010000000",
  "0000000001000000",
  "0000000000100000",     -- 10
  "0000000000010000",     
  "0000000000001000",
  "0000000000000100",
  "0000010100000001",
  "0000010100000001"      -- 15
  );
  
  begin
  instr <= MEM( to_integer(unsigned(PC)) );

end data_flow;
  
  