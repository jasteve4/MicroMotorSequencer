
user-rtl:
	vcs -Mupdate -RPP \
	  -sverilog \
	  ./user_wrapper_test.v \
	  ../rtl/async_reg.v \
	  ../rtl/backend_cycle_controller.v \
	  ../rtl/controller_core.v \
	  ../rtl/dot_driver.v \
	  ../rtl/driver_sequencer.v \
	  ../rtl/driver_core.v \
	  ../rtl/HBrigeDriver.v \
	  ../rtl/impulse.v \
	  ../rtl/spi_controller.v \
	  ../rtl/system_controller.v \
	  ../rtl/user_project_wrapper.v \
	  +vcs+initreg+random \
	  -debug_access+all 


user-gl:
	vcs -Mupdate -RPP \
	  -sverilog \
	  ../../dependencies/pdks/volare/sky130/versions/41c0908b47130d5675ff8484255b43f66463a7d6/sky130B/libs.ref/sky130_fd_sc_hd/verilog/primitives.v \
	  ../../dependencies/pdks/volare/sky130/versions/41c0908b47130d5675ff8484255b43f66463a7d6/sky130B/libs.ref/sky130_fd_sc_hd/verilog/sky130_fd_sc_hd.v \
	  ./user_wrapper_test.v \
	  ../gl/spi_controller.v \
	  ../gl/controller_core.v \
	  ../gl/driver_core.v \
	  ../gl/user_project_wrapper.v \
	  +define+SIM \
	  +define+GL \
	  +define+FUNCTIONAL \
	  +define+USE_POWER_PINS \
	  +define+UNIT_DELAY=#1 \
	  +vcs+initreg+random \
	  -debug_access+all 

user-sdf:
	vcs -Mupdate -RPP \
	  -sverilog \
	  ../../mgmt_core_wrapper/verilog/cvc-pdk/primitives_hd.v \
	  ../../mgmt_core_wrapper/verilog/cvc-pdk/sky130_fd_sc_hd.v \
	  ./user_wrapper_test.v \
	  ../gl/spi_controller.v \
	  ../gl/controller_core.v \
	  ../gl/driver_core.v \
	  ../gl/user_project_wrapper.v \
	  ./decap.v \
	  +define+SIM \
	  +define+GL \
	  +define+FUNCTIONAL \
	  +define+USE_POWER_PINS \
	  +define+UNIT_DELAY \
	  +define+ENABLE_SDF \
	  +neg_tchk \
	  +vcs+initreg+random \
	  -debug_access+all 


