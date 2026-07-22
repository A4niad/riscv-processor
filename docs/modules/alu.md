# Arithemetic Logic Unit (ALU) Module

Performs the requested arithmetic/logical operation to two number and returns the answer

## Ports

| Signal | Dir | Width | Description |
| a | input | 32 bits | First operand |
| b | input | 32 bits | Second operand |
| alu_op | input | 4 bits | Operation Code that decides which operation is performed |
| result | output | 32 bits | Result of operation |
| zero | output | 1 bit | Zero flag |

## Functionality

The module performs an operation as decided from alu_op on two numbers a and b. The operation performed is decided according to the following table

| alu_op | Operation |
| 0000 | Addition |
| 0001 | Subtraction |
| 0010 | Logical AND |
| 0011 | Logical OR |
| 0100 | Logical XOR |
| 0101 | Logical Left Shift |
| 0110 | Logical Right Shift |
| 0111 | Arithmetic Right Shift |
| 1000 | Set on Less Than Signed |
| 1001 | Set on Less Than Unsigned |

The result of the operation is stored in result. 

## Design Notes

The zero flag simply checks if result == 0.
In case of an invalid alu_op code, the result is set to 0