# SPDX-FileCopyrightText: 2020 Efabless Corporation
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# SPDX-License-Identifier: Apache-2.0

# Base Configurations. Don't Touch
# section begin

set ::env(PDK) $::env(PDK)
set ::env(STD_CELL_LIBRARY) "sky130_fd_sc_hd"

# YOU ARE NOT ALLOWED TO CHANGE ANY VARIABLES DEFINED IN THE FIXED WRAPPER CFGS 
source $::env(DESIGN_DIR)/fixed_dont_change/fixed_wrapper_cfgs.tcl

# YOU CAN CHANGE ANY VARIABLES DEFINED IN THE DEFAULT WRAPPER CFGS BY OVERRIDING THEM IN THIS CONFIG.TCL
source $::env(DESIGN_DIR)/fixed_dont_change/default_wrapper_cfgs.tcl

set script_dir [file dirname [file normalize [info script]]]
set proj_dir [file dirname [file normalize [info script]]]

set ::env(DESIGN_NAME) user_project_wrapper
set verilog_root $::env(DESIGN_DIR)/../../verilog/
set lef_root $::env(DESIGN_DIR)/../../lef/
set gds_root $::env(DESIGN_DIR)/../../gds/
#section end

# User Configurations

## Source Verilog Files
set ::env(VERILOG_FILES) "\
	$::env(CARAVEL_ROOT)/verilog/rtl/defines.v \
	$script_dir/../../verilog/rtl/user_project_wrapper.v"

## Clock configurations
set ::env(CLOCK_PORT) "user_clock2"
set ::env(CLOCK_NET) "controller_unit_mod.clock_out\[0\] controller_unit_mod.clock_out\[1\] controller_unit_mod.clock_out\[2\] controller_unit_mod.clock_out\[3\] clock_out\[4\] clock_out\[5\] clock_out\[6\] clock_out\[7\]"

set ::env(CLOCK_PERIOD) "20"

### Macro Placement
set ::env(MACRO_PLACEMENT_CFG) $script_dir/macro.cfg

## Internal Macros
### Macro PDN Connections
#set ::env(FP_PDN_MACRO_HOOKS) "\
	mprj vccd1 vssd1 vccd1 vssd1"

#set ::env(SDC_FILE) $::env(DESIGN_DIR)/base.sdc
#set ::env(BASE_SDC_FILE) $::env(DESIGN_DIR)/base.sdc

### Black-box verilog and views
set ::env(VERILOG_FILES_BLACKBOX) "\
	$::env(CARAVEL_ROOT)/verilog/rtl/defines.v \
	$::env(DESIGN_DIR)/../../verilog/gl/controller_unit.v \
	$::env(DESIGN_DIR)/../../verilog/gl/driver_core.v \
	$::env(DESIGN_DIR)/../../verilog/gl/driver_core_mirror.v"

set ::env(EXTRA_LEFS) "\
	$::env(DESIGN_DIR)/../../lef/controller_unit.lef \
	$::env(DESIGN_DIR)/../../lef/driver_core.lef \
	$::env(DESIGN_DIR)/../../lef/driver_core_mirror.lef"

set ::env(EXTRA_GDS_FILES) "\
	$::env(DESIGN_DIR)/../../gds/controller_unit.gds \
	$::env(DESIGN_DIR)/../../gds/driver_core.gds \
	$::env(DESIGN_DIR)/../../gds/driver_core_mirror.gds"

set ::env(SYNTH_DEFINES) [list SYNTHESIS ]

# set ::env(GLB_RT_MAXLAYER) 5
set ::env(RT_MAX_LAYER) {met4}


set ::env(ROUTING_CORES) 8

# disable pdn check nodes becuase it hangs with multiple power domains.
# any issue with pdn connections will be flagged with LVS so it is not a critical check.
set ::env(FP_PDN_CHECK_NODES) 0

## Internal Macros
### Macro PDN Connections
set ::env(FP_PDN_ENABLE_MACROS_GRID) "1"
#set ::env(FP_PDN_ENABLE_GLOBAL_CONNECTIONS) "1"


set ::env(FP_PDN_MACRO_HOOKS) " \
	 controller_unit_mod    vccd1 vssd1 vccd1 vssd1, \
	 driver_core_0   	vccd1 vssd1 vccd1 vssd1, \
	 driver_core_1   	vccd1 vssd1 vccd1 vssd1, \
	 driver_core_2   	vccd1 vssd1 vccd1 vssd1, \
	 driver_core_3   	vccd1 vssd1 vccd1 vssd1, \
	 driver_core_4   	vccd1 vssd1 vccd1 vssd1, \
	 driver_core_5   	vccd1 vssd1 vccd1 vssd1, \
	 driver_core_6   	vccd1 vssd1 vccd1 vssd1, \
	 driver_core_7   	vccd1 vssd1 vccd1 vssd1"

#set ::env(LVS_CONNECT_BY_LABEL) 1

set ::env(GLB_RT_ADJUSTMENT) 0.70

set ::env(GLB_RT_L2_ADJUSTMENT) 0.6
set ::env(GLB_RT_L3_ADJUSTMENT) 0.5

# The following is because there are no std cells in the example wrapper project.
set ::env(SYNTH_TOP_LEVEL) 1
set ::env(PL_RANDOM_GLB_PLACEMENT) 1
set ::env(PL_RESIZER_DESIGN_OPTIMIZATIONS) 0
set ::env(PL_RESIZER_TIMING_OPTIMIZATIONS) 0
set ::env(PL_RESIZER_BUFFER_INPUT_PORTS) 0
set ::env(PL_RESIZER_BUFFER_OUTPUT_PORTS) 0
set ::env(FP_PDN_ENABLE_RAILS) 0
set ::env(DIODE_INSERTION_STRATEGY) 0
set ::env(FILL_INSERTION) 0
set ::env(TAP_DECAP_INSERTION) 0
set ::env(CLOCK_TREE_SYNTH) 0
set ::env(QUIT_ON_LVS_ERROR) "1"
set ::env(QUIT_ON_MAGIC_DRC) "1"
set ::env(QUIT_ON_NEGATIVE_WNS) "0"
set ::env(QUIT_ON_SLEW_VIOLATIONS) "1"
set ::env(QUIT_ON_TIMING_VIOLATIONS) "1"

set ::env(FP_PDN_IRDROP) "1"
#set ::env(FP_PDN_HORIZONTAL_HALO) "10"
#set ::env(FP_PDN_VERTICAL_HALO) "10"

#

#set ::env(FP_PDN_VOFFSET) "5"
#set ::env(FP_PDN_VPITCH) "180"
#set ::env(FP_PDN_HOFFSET) "5"
#set ::env(FP_PDN_HPITCH) "180"



