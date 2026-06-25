# RISC-V 32-bit Single Cycle Processor

This project implements a 32-bit single-cycle processor in SystemVerilog. The CPU executes one instruction per clock cycle and supports arithmetic, logical, memory access, and branch operations. 

#FIX-ME add isa subset

This is a walkthrough of the CPU starting with the full architecture then breaking it down by each component

## Program Counter (PC)

### Operation

The program counter stores the next address the CPU should go to. 

Input
Clk
Reset
PC
Output
PC’

### Block Diagram

![Program Counter Diagram](images/PC_Counter.png)





### Waveform





## Instruction Memory

### Operation

Stores instructions in from assembly ROM and outputs machine code of instruction

Input
Address

Output
Instruction

### Block Diagram

![Instruction Memory Diagram](images/Instruction_Memory.png)

### Waveform

## Register File

### Operation 

32 element 32-bit registers,  A1, A2, A3 is the address of each register, read is always  A1 = RD1 and A2 = RD2 with RD1 and RD2 being the value inside the specific register(A), if WE is enabled then the value in register A3 will get overwritten with WD3’s data

Input
Clk
Reset
WE3 
WD3 
A1
A2
A3

Output
RD1
RD2

### Block Diagram

![Register File Diagram](images/Register_File.png)



### Waveform




## Arithmetic Logic Unit (ALU)

### Operation
Picks which operation is performed on a & b based on the alu_select signal

### ALU OPERATIONS






Select
Definition
Assembly
0
Add
add
1
Subtract
sub
2
AND
and
3
OR
or
4
XOR
xor
5
Shift logical left
sll
6
Shift logical right
slr
7
Shift arithmetic right
sar
8
Set if less than signed
slt
9
Set if less than unsigned
sltu


Input
a
b
alu_select
Output
result


### Block Diagram

![ALU Diagram](images/ALU.png)


### Waveform

## Data Memory

### Operation

1024 element 32-bit RAM, takes valid address converts to bye-addressable then gets the value from that address in memory and outputs it

Inputs
clk
WE
address
WD

Output
RD

### Block Diagram

![Data Memory Diagram](images/Data_Memory.png)


### Waveform





## Control Unit

### Block Diagram

![Control Unit Diagram](images/Control_Unit.png)















Verification strategy

Instruction 




