# regfile
*ece550 project checkpoint3: regfile*

- name: **Xu (Jordan) Han**
- netID: **xh123**

## Module Description
1. Use dffes to build 32-bit register with writing enable control
2. Combine ctrl_writeReg and ctrl_writeEnable with a decoder and AND gates to enable the written register
3. Process ctrl_readRegA ctrl_readRegB with decoders to enable tristate buffers in order to select the read registers
4. Always force the 32'h00000000 as the input data for the r0 register
5. Control all registers with the same clock and reset

Add dqwoifn wenqfi