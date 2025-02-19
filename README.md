# Asyc_FIFO
## Top Level Block Diagram
![unnamed](https://github.com/user-attachments/assets/676c429c-f9b6-41c8-93a9-ad315fd33a3b)



## Design Features
1. Theoretically unbounded, but in practice, limited by the simulator and hardware constraints supports data widths upto [2^64 -1] bits;
Parameterized by ‘DATASIZE’.
2. Theoretically unbounded, but in practice, limited by the simulator and hardware constraints supports memory depths upto [2^64 -1] bits;
Parameterized by ‘DEPTH’
3. Fully synchronous, and independent clock domains for the Read and Write ports
4. Supports FULL and EMPTY status flags
5. Two optional output signals for indicating Write-Full and Read-Empty of the memory port.


