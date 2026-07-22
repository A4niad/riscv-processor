# Immediate Generator Module

Returns the sign-extended immediate number extracted from the input instruction word

## Ports

| Signal | Dir | Width | Description |
|---|---|---|---|
| inst | input | 32 bits | Input instruction word |
| imm_out | input | 32 bits | Sign-extended Generated Immediate |

## Functionality

The module extracts an appropriately sign-extended from the instruction word. Relevant source bits are chosen according to the instruction type decided by bits `[31:0]` of the instruction word. 

| Instruction Type | Source Bits | Output Immediate Size |
|---|---|---|
| I-Type | `inst[31:20]` | 12-bit sign-extended to 32 bits |
| S-Type | `inst[31:25] + inst[11:7]` | 12 bit sign-extended to 32 bits |
| B-Type | `inst[31] + inst [7] + inst[30:25] + inst[11:8]` | 12 bit sign-extended to 32 bits |
| U-Type | `inst[31:12]` | 32 bit (placed in upper 20 bits, lower 12 bits zeroed) |
| J-Type | `inst[31] + inst[19:12] + inst[20] + inst[30:21]` | 21 bit sigh-extended to 32 (w/ LSB as 0) |

The immediate is stored in `imm_out`. 

## Design Notes

In case if an invalid instruction word, 0 is returned