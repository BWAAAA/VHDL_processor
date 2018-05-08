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
  "0000001100010000",     -- 0  --r0 = 49
  "0000000100000001",           --r1 = 16
  "0000011000110010",           --r2 = 99
  "0000100000110011",           --r3 = -125
  "1000000000010000",           --read r0 r1      // should be 49 16  XX
  "1000001000110000",     -- 5  --read r2 r3      // should be 99 -125 XX
  "1110000100011111",           --r15 = r1 + r1   // should be 16 16 32
  "1000111111110000",           --read r15        // should be 32 32 XX
  "1101000100001110",           --r14 = r1 and r0 
  "1000111011100000",           --read r14
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
  
  