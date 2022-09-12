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
make user_project_wrrappper
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

## Memory Mapped Registers

