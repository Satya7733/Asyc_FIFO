# Asyc_FIFO
## Top Level Block Diagram
<img src="https://github.com/user-attachments/assets/676c429c-f9b6-41c8-93a9-ad315fd33a3b" width="900" />


## Overview
This FIFO (First-In-First-Out) design is a fully parameterized and synchronous module that supports independent clock domains for Read and Write ports. It is designed to be highly configurable while being limited only by the simulator and hardware constraints.

## Features
- **Configurable Data Width**: Supports data widths up to \([2^{64} - 1]\) bits, parameterized by `DATASIZE`.
- **Configurable Memory Depth**: Supports memory depths up to \([2^{64} - 1]\) locations, parameterized by `DEPTH`.
- **Fully Synchronous**: Ensures reliable operation with independent clock domains for Read and Write ports.
- **Status Flags**:
  - `FULL` flag to indicate when the FIFO is full.
  - `EMPTY` flag to indicate when the FIFO is empty.
- **Optional Output Signals**:
  - `Write-Full` signal to indicate when the write port is full.
  - `Read-Empty` signal to indicate when the read port is empty.

