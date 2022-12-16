# simpleALU
*repo for ece550 project*


## Module Description
#### Check point 1
1. The Additon bases on the Carry Lookahead Adder. The 32-bit CLA consists of four 8-bit CLA Block.
2. Regarding the subtraction, 2-to-1 Muxes are used to calculate the 2's complement of the 2nd operand.
3. On the output side, the 32-bit sum is sent to the result port through tri-state buffers. 

#### Check point 2
4. isNotEqual: NOR all data_result of subtratction. 
5. isLessThan: TRUE if the MSB of data_result of subtratction is 1 when no overflow, or the MSB of data_result of subtratction is 0 when overflow occurs.
6. bitwise and: AND operands bit by bit.
7. bitwise or: OR operands bit by bit.
8. SLL: (32 x 5) Muxes are used to build a 32-bit barrel shifter with logical left shift.
9. SRA: (32 x 5 + 32 x 5 + 32) Muxes are used to build a 32-bit barrel shifter with arithmetic right shift.
10. Many tri-state buffers are used to select the right data_result corresponding to opcode.


#### ALU's fuctional structure is as follows:
```
ALU
│
├── Addition
│   ├── 32-bit CLA
│   │   └── 8-bit CLA Block
│   └── tri-state buffer
│
├── Subtraction
│   ├── 2-to-1 Mux
│   ├── 32-bit CLA
│   │   └── 8-bit CLA Block
│   └── tri-state buffer
│ 
├── Bitwise AND
│   ├── AND Gate
│   └── tri-state buffer
│
├── Bitwise OR
│   ├── OR Gate
│   └── tri-state buffer
│
├── SLL
│   ├── 2-to-1 Mux
│   └── tri-state buffer
│
└── SRA
    ├── 2-to-1 Mux
    └── tri-state buffer

```
