<!--[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0) [![UPRJ_CI](https://github.com/efabless/caravel_project_example/actions/workflows/user_project_ci.yml/badge.svg)](https://github.com/efabless/caravel_project_example/actions/workflows/user_project_ci.yml) [![Caravel Build](https://github.com/efabless/caravel_project_example/actions/workflows/caravel_build.yml/badge.svg)](https://github.com/efabless/caravel_project_example/actions/workflows/caravel_build.yml)-->

# License

This is licensed under GNU General Public License v3.0 . Presently the efabless mpw_precheck tool recognizes the GPL 3.0 license file as the AGPL-3.0 license file which is prohibited. However, the GPL 3.0 is in the approved license lists (```https://github.com/efabless/mpw_precheck/tree/mpw-5c/checks/license_check/_licenses/_approved_licenses```). Thus, we have changed the LICENSE to reflect the Apache 2.0 License for the purpose of passing the mpw_precheck only. Again, the license is GPL 3.0.

# Actuator Controller 

This design is to precisely control the timing sequence of 10 micro-motors. The SPI enterface allows a microcontroller to pass the required commands to adjust the firing order and width of the PWM pulses.

## Harding Design
```
make driver_core
make controller_core
make spi_controller
make user_project_wrappper
```
## RTL Simulation
```
make verify-system_10dot_test # run full system test with 10 dot configuation
```
 ## GL Simulation
```
make verify-system_10dot_test-gl # run full system test with 10 dot configuation
```
 ## GL+SDF Simulation
```
make verify-system_10dot_test-gl-sdf # run full system test with 10 dot configuation
```
## Spi Commuation Packet
```
[31:0]  spi data packet size
[31:30] system comtrol bits
[29:26] driver device select
[25:16] driver memroy address
[15:0]  memory data
```

## System Control 
```
00: run mode
01: system config write
10: N/A
11: driver memory write
```
## Config Register
```
00: CCR0 Lower 16 bits
01: CCR0 Higher 16 bits
02: CCR1 Lower 16 bits
03: CCR1 Lower 16 bits
04: number of activation lower 16 bits
05: number of activation higher 16 bits
06: row reset value
07: col reset value
08: driver inveter per driver select
09: row or col per driver select
```
## Driver Memory Mapped Registers
```
0-143: driver activation bit 48x48 bits, 144:16 bit registers
144-191: driver select sequence, 48:16 bit registers
192-164: driver output level, 3:16 bit registers
```
## Driver Output
```
-------        ------
       |      |
       |      |
        ------
0     CCR0   CCR1
For driver level 1
Driver outputs can be phase shiffed:
-------                          driver 0       
       |      
       |      
        ---------------------
               -------           driver 1     
              |       |         
              |       |      
--------------         -------

0    CCR0    CCR1    CCR0
```
## Driver configuation
```
For each driver
48 rows and 48 col, 2304 rounds
each activation bit is round in the globel counter. The activation bit say that the output is active in the current round
0xFFFFFF
0x000000
...
0x000000
is for row active output
0x800000
0x800000
...
0x800000
is for col active output
row and col congiuation can be uesd to limit the number of rounds per col and row
4 rows and 4 cols, 16 rounds
number of activations register needs to be set to NxM value  
```
