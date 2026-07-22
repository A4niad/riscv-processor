# Register File Module

Creates, stores, and handles read/write operations for all general purpose registers

## Ports

| Signal | Dir | Width | Description |
|---|---|---|---|
| clk | input | 1 bit | Processor Clock |
| rst | input | 1 bit | Active High Register Reset Control |
| rg_wren | input | 1 bit | Register Write Enable |
| rs1_addr | input | 5 bits | Address of RS1 |
| rs2_addr | input | 5 bits | Address of RS2 |
| rd_addr | input | 5 bits | Address of RD |
| rd_data | input | 5 bits | Data in RD |
| rs1_data | output | 5 bits | Data in RS1 |
| rs2_data | output | 5 bits | Data in RS2 |

## Functionality

This module creates the 32 general purpose registers stored in `registers`. The contents of these registers can be read and written to. They can also all be reset easily.  
Reading is done asynchronously and is immediately available upon passing the requested address in the necessary field.
Writing is done synchronously and occurs on every positive edge of the input clock signal. It is performed by using the `rd_addr` and `rd_data` variables.
A reset occurs on the next positive edge of the input clock signal if `reset` is held `HIGH`

## Design Notes

Reading the register `0x00` always returns 0, even if something else is written there.
Resetting is done synchronously.
