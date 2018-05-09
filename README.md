# VHDL_processor
Computer Organization : implement simple processor from VHDL &amp; FPGA

## 16 bits simple processor specification
- 16 bits Instruction word
- 4 bits program counter -> 0-15 Instruction word
- 8 bits register word
- 4 bits register selector

## Instruction field
16 bits instruction word

when ```op = 00xx```: assign data to rd register

| op  | data   | rd  |
|:---:|:------:|:---:|
| 4   | 8      | 4   | 

when ```op = 11xx```: do ALU xx op and save result to rd register

| op  | rs  | rt  | rd  |
|:---:|:---:|:---:|:---:|
| 4   | 4   | 4   | 4   | 

when ```op = 01xx, 10xx```: do nothing, can use for read rs, rt register

| op  | rs  | rt  | rd  |
|:---:|:---:|:---:|:---:|
| 4   | 4   | 4   | 4   | 

## ALU op
ALU op from the least 2 bits of op

| ALU op  | data   | 
|:-------:|:-------|
| 00       | rd = rs AND rt    |
| 01       | rd = rs OR rt     |
| 10       | rd = rs + rt      |
| 11       | rd = rs - rt      |