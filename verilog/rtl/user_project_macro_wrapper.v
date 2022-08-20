// SPDX-FileCopyrightText: 2020 Efabless Corporation
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
// SPDX-License-Identifier: Apache-2.0

`default_nettype none
/*
 *-------------------------------------------------------------
 *
 * user_project_wrapper
 *
 * This wrapper enumerates all of the pins available to the
 * user for the user project.
 *
 * An example user project is provided in this wrapper.  The
 * example should be removed and replaced with the actual
 * user project.
 *
 *-------------------------------------------------------------
 */

`ifndef MPRJ_IO_PADS
`define MPRJ_IO_PADS 38
`endif

module user_project_wrapper #(
    parameter BITS = 32
) (
`ifdef USE_POWER_PINS
    inout wire vdda1,	// User area 1 3.3V supply
    inout wire vdda2,	// User area 2 3.3V supply
    inout wire vssa1,	// User area 1 analog ground
    inout wire vssa2,	// User area 2 analog ground
    inout wire vccd1,	// User area 1 1.8V supply
    inout wire vccd2,	// User area 2 1.8v supply
    inout wire vssd1,	// User area 1 digital ground
    inout wire vssd2,	// User area 2 digital ground
`endif

    // Wishbone Slave ports (WB MI A)
    input wire wb_clk_i,
    input wire wb_rst_i,
    input wire wbs_stb_i,
    input wire wbs_cyc_i,
    input wire wbs_we_i,
    input wire [3:0] wbs_sel_i,
    input wire [31:0] wbs_dat_i,
    input wire [31:0] wbs_adr_i,
    output wire wbs_ack_o,
    output wire [31:0] wbs_dat_o,

    // Logic Analyzer Signals
    input  wire [127:0] la_data_in,
    output wire [127:0] la_data_out,
    input  wire [127:0] la_oenb,

    // IOs
    input  wire [`MPRJ_IO_PADS-1:0] io_in,
    output wire [`MPRJ_IO_PADS-1:0] io_out,
    output wire [`MPRJ_IO_PADS-1:0] io_oeb,

    // Analog (direct connection to GPIO pad---use with caution)
    // Note that analog I/O is not available on the 7 lowest-numbered
    // GPIO pads, and so the analog_io indexing is offset from the
    // GPIO indexing by 7 (also upper 2 GPIOs do not have analog_io).
    inout wire [`MPRJ_IO_PADS-10:0] analog_io,

    // Independent clock (on independent integer divider)
    input  wire   user_clock2,

    // User maskable interrupt signals
    output wire [2:0] user_irq
);

/*--------------------------------------*/
/* User project is instantiated  here   */
/*--------------------------------------*/
    localparam NUM_OF_DRIVERS = 8;
    localparam MEM_ADDRESS_LENGTH =6;
    localparam MEM_LENGTH = 48;



    wire io_reset_n_in;
    wire io_reset_n_oeb;
    wire io_control_trigger_in;
    wire io_control_trigger_oeb;
    wire io_latch_data_in;
    wire io_latch_data_oeb;
    wire io_miso_out;
    wire io_miso_oeb;
    wire io_mosi_in;
    wire io_mosi_oeb;
    wire io_ss_n_in;
    wire io_ss_n_oeb;
    wire io_sclk_in;
    wire io_sclk_oeb;
    wire io_update_cycle_complete_out;
    wire io_update_cycle_complete_oeb;

    wire [NUM_OF_DRIVERS-1:0]   io_driver_io_oeb;
    wire [NUM_OF_DRIVERS*2-1:0] driver_io;



    wire [2:0]                 mask_select;
    wire [6:0]                 mem_address_out;
    wire [5:0]                 mem_address;
    wire [NUM_OF_DRIVERS-1:0]  mem_write_n;
    wire [NUM_OF_DRIVERS-1:0]  mem_dot_write_n;
    wire [MEM_ADDRESS_LENGTH-1:0]   row_select;
    wire [MEM_ADDRESS_LENGTH-1:0]   col_select;
    wire [6:0]                 mem_sel_col_address_out;
    wire [5:0]                 mem_sel_col_address;
    wire [15:0]                data_out;
    wire [NUM_OF_DRIVERS-1:0]  mem_sel_write_n;
    wire [NUM_OF_DRIVERS-1:0]  row_col_select;
    wire                       output_active;
    wire [NUM_OF_DRIVERS-1:0]  inverter_select;

    assign mem_address = mem_address_out[5:0];
    assign mem_sel_col_address = mem_sel_col_address_out[5:0];

    assign io_reset_n_in              = io_in[37];
    assign io_oeb[37]                 = io_reset_n_oeb;

    assign io_control_trigger_in      = io_in[36];
    assign io_oeb[36]                 = io_control_trigger_oeb;

    assign io_latch_data_in           = io_in[35];
    assign io_oeb[35]                 = io_latch_data_oeb;

    assign io_out[34]                 = io_miso_out;
    assign io_oeb[34]                 = io_miso_oeb;

    assign io_mosi_in                 = io_in[33];
    assign io_oeb[33]                 = io_mosi_oeb;

    assign io_ss_n_in                 = io_in[32];
    assign io_oeb[32]                 = io_ss_n_oeb;

    assign io_sclk_in                 = io_in[31];
    assign io_oeb[31]                 = io_sclk_oeb;

    assign io_out[30]                 = io_update_cycle_complete_out;
    assign io_oeb[30]                 = io_update_cycle_complete_oeb;

    
    assign io_out[29]                 = io_driver_io_oeb[0];
    assign io_oeb[29]                 = driver_io[0];
    assign io_out[28]                 = io_driver_io_oeb[0];
    assign io_oeb[28]                 = driver_io[1];

    assign io_out[27]                 = io_driver_io_oeb[1];
    assign io_oeb[27]                 = driver_io[2];
    assign io_out[26]                 = io_driver_io_oeb[1];
    assign io_oeb[26]                 = driver_io[3];

    assign io_out[25]                 = io_driver_io_oeb[2];
    assign io_oeb[25]                 = driver_io[4];
    assign io_out[24]                 = io_driver_io_oeb[2];
    assign io_oeb[24]                 = driver_io[5];

    assign io_out[23]                 = io_driver_io_oeb[3];
    assign io_oeb[23]                 = driver_io[6];
    assign io_out[22]                 = io_driver_io_oeb[3];
    assign io_oeb[22]                 = driver_io[7];




    assign io_out[15]                 = io_driver_io_oeb[4];
    assign io_oeb[15]                 = driver_io[8];
    assign io_out[14]                 = io_driver_io_oeb[4];
    assign io_oeb[14]                 = driver_io[9];

    assign io_out[13]                 = io_driver_io_oeb[5];
    assign io_oeb[13]                 = driver_io[10];
    assign io_out[12]                 = io_driver_io_oeb[5];
    assign io_oeb[12]                 = driver_io[11];

    assign io_out[11]                 = io_driver_io_oeb[6];
    assign io_oeb[11]                 = driver_io[12];
    assign io_out[10]                 = io_driver_io_oeb[6];
    assign io_oeb[10]                 = driver_io[13];

    assign io_out[9]                 = io_driver_io_oeb[7];
    assign io_oeb[9]                 = driver_io[14];
    assign io_out[8]                 = io_driver_io_oeb[7];
    assign io_oeb[8]                 = driver_io[15];


  controller_unit
  #(
    //.MEM_LENGTH                     (MEM_LENGTH                    ),
    //.MEM_ADDRESS_LENGTH             (MEM_ADDRESS_LENGTH            ),
    //.NUM_OF_DRIVERS                 (NUM_OF_DRIVERS                )
  )
  controller_unit_mod
  (
`ifdef USE_POWER_PINS
     .vccd1                          (vccd1                        ),	// User area 1 1.8V supply
     .vssd1                          (vssd1                        ),	// User area 1 1.8V supply
`endif
    
    .la_data_in                      (la_data_in                    ),
    //.la_data_out                     (la_data_out                   ),
    .la_oenb                         (la_oenb                       ),
    .user_clock2                     (user_clock2                   ),
    .io_reset_n_in                   (io_reset_n_in                 ),
    .io_reset_n_oeb                  (io_reset_n_oeb                ),
    .io_latch_data_in                (io_latch_data_in              ),
    .io_latch_data_oeb               (io_latch_data_oeb             ),
    .io_control_trigger_in           (io_control_trigger_in         ),
    .io_control_trigger_oeb          (io_control_trigger_oeb        ),
    .io_driver_io_oeb                (io_driver_io_oeb              ),
    .io_update_cycle_complete_out    (io_update_cycle_complete_out  ),
    .io_update_cycle_complete_oeb    (io_update_cycle_complete_oeb  ),
    .io_sclk_in                      (io_sclk_in                    ),
    .io_sclk_oeb                     (io_sclk_oeb                   ),
    .io_mosi_in                      (io_mosi_in                    ),
    .io_mosi_oeb                     (io_mosi_oeb                   ),
    .io_ss_n_in                      (io_ss_n_in                    ),
    .io_ss_n_oeb                     (io_ss_n_oeb                   ),
    .io_miso_out                     (io_miso_out                   ),
    .io_miso_oeb                     (io_miso_oeb                   ),
    .mask_select                     (mask_select                   ),
    .mem_address                     (mem_address_out               ),
    .mem_write_n                     (mem_write_n                   ),
    .mem_dot_write_n                 (mem_dot_write_n               ),
    .row_select                      (row_select                    ),
    .col_select                      (col_select                    ),
    .mem_sel_col_address             (mem_sel_col_address_out       ),
    .data_out                        (data_out                      ),
    .mem_sel_write_n                 (mem_sel_write_n               ),
    .row_col_select                  (row_col_select                ),
    .output_active                   (output_active                 ),
    .inverter_select                 (inverter_select               )
  );

  driver_core
  #(

    //.MEM_LENGTH                     (MEM_LENGTH                   ),
    //.MEM_ADDRESS_LENGTH             (MEM_ADDRESS_LENGTH           )
  )
  driver_core_0
  (
`ifdef USE_POWER_PINS
     .vccd1                          (vccd1                        ),	// User area 1 1.8V supply
     .vssd1                          (vssd1                        ),	// User area 1 1.8V supply
`endif
    .clock                          (user_clock2                  ),
    .clock_a                        (user_clock2                  ),
    .mask_select_a                  (mask_select                  ),
    .mem_address_a                  (mem_address                  ),
    .mem_write_n_a                  (mem_write_n[0]               ),
    .mem_dot_write_n_a              (mem_dot_write_n[0]           ),
    .row_select_a                   (row_select                   ),
    .col_select_a                   (col_select                   ),
    .mem_sel_col_address_a          (mem_sel_col_address          ),
    .data_in_a                      (data_out                     ),
    .mem_sel_write_n_a              (mem_sel_write_n[0]           ),
    .row_col_select_a               (row_col_select[0]            ), 
    .output_active_a                (output_active                ),
    .inverter_select_a              (inverter_select[0]           ),
    .driver_io                      (driver_io[1:0]               )
  );

  driver_core
  #(

    //.MEM_LENGTH                     (MEM_LENGTH                   ),
    //.MEM_ADDRESS_LENGTH             (MEM_ADDRESS_LENGTH           )
  )
  driver_core_1
  (
`ifdef USE_POWER_PINS
     .vccd1                          (vccd1                        ),	// User area 1 1.8V supply
     .vssd1                          (vssd1                        ),	// User area 1 1.8V supply
`endif
    .clock                          (user_clock2                  ),
    .clock_a                        (user_clock2                  ),
    .mask_select_a                  (mask_select                  ),
    .mem_address_a                  (mem_address                  ),
    .mem_write_n_a                  (mem_write_n[1]               ),
    .mem_dot_write_n_a              (mem_dot_write_n[1]           ),
    .row_select_a                   (row_select                   ),
    .col_select_a                   (col_select                   ),
    .mem_sel_col_address_a          (mem_sel_col_address          ),
    .data_in_a                      (data_out                     ),
    .mem_sel_write_n_a              (mem_sel_write_n[1]           ),
    .row_col_select_a               (row_col_select[1]            ), 
    .output_active_a                (output_active                ),
    .inverter_select_a              (inverter_select[1]           ),
    .driver_io                      (driver_io[3:2]               )
  );

  driver_core
  #(

    //.MEM_LENGTH                     (MEM_LENGTH                   ),
    //.MEM_ADDRESS_LENGTH             (MEM_ADDRESS_LENGTH           )
  )
  driver_core_2
  (
`ifdef USE_POWER_PINS
     .vccd1                          (vccd1                        ),	// User area 1 1.8V supply
     .vssd1                          (vssd1                        ),	// User area 1 1.8V supply
`endif
    .clock                          (user_clock2                  ),
    .clock_a                        (user_clock2                  ),
    .mask_select_a                  (mask_select                  ),
    .mem_address_a                  (mem_address                  ),
    .mem_write_n_a                  (mem_write_n[2]               ),
    .mem_dot_write_n_a              (mem_dot_write_n[2]           ),
    .row_select_a                   (row_select                   ),
    .col_select_a                   (col_select                   ),
    .mem_sel_col_address_a          (mem_sel_col_address          ),
    .data_in_a                      (data_out                     ),
    .mem_sel_write_n_a              (mem_sel_write_n[2]           ),
    .row_col_select_a               (row_col_select[2]            ), 
    .output_active_a                (output_active                ),
    .inverter_select_a              (inverter_select[2]           ),
    .driver_io                      (driver_io[5:4]               )
  );

  driver_core
  #(

    //.MEM_LENGTH                     (MEM_LENGTH                   ),
    //.MEM_ADDRESS_LENGTH             (MEM_ADDRESS_LENGTH           )
  )
  driver_core_3
  (
`ifdef USE_POWER_PINS
     .vccd1                          (vccd1                        ),	// User area 1 1.8V supply
     .vssd1                          (vssd1                        ),	// User area 1 1.8V supply
`endif
    .clock                          (user_clock2                  ),
    .clock_a                        (user_clock2                  ),
    .mask_select_a                  (mask_select                  ),
    .mem_address_a                  (mem_address                  ),
    .mem_write_n_a                  (mem_write_n[3]               ),
    .mem_dot_write_n_a              (mem_dot_write_n[3]           ),
    .row_select_a                   (row_select                   ),
    .col_select_a                   (col_select                   ),
    .mem_sel_col_address_a          (mem_sel_col_address          ),
    .data_in_a                      (data_out                     ),
    .mem_sel_write_n_a              (mem_sel_write_n[3]           ),
    .row_col_select_a               (row_col_select[3]            ), 
    .output_active_a                (output_active                ),
    .inverter_select_a              (inverter_select[3]           ),
    .driver_io                      (driver_io[7:6]               )
  );

  driver_core_mirror
  #(

    //.MEM_LENGTH                     (MEM_LENGTH                   ),
    //.MEM_ADDRESS_LENGTH             (MEM_ADDRESS_LENGTH           )
  )
  driver_core_4
  (
`ifdef USE_POWER_PINS
     .vccd1                          (vccd1                        ),	// User area 1 1.8V supply
     .vssd1                          (vssd1                        ),	// User area 1 1.8V supply
`endif
    .clock                          (user_clock2                  ),
    .clock_a                        (user_clock2                  ),
    .mask_select_a                  (mask_select                  ),
    .mem_address_a                  (mem_address                  ),
    .mem_write_n_a                  (mem_write_n[4]               ),
    .mem_dot_write_n_a              (mem_dot_write_n[4]           ),
    .row_select_a                   (row_select                   ),
    .col_select_a                   (col_select                   ),
    .mem_sel_col_address_a          (mem_sel_col_address          ),
    .data_in_a                      (data_out                     ),
    .mem_sel_write_n_a              (mem_sel_write_n[4]           ),
    .row_col_select_a               (row_col_select[4]            ), 
    .output_active_a                (output_active                ),
    .inverter_select_a              (inverter_select[4]           ),
    .driver_io                      (driver_io[9:8]               )
  );

  driver_core_mirror
  #(

    //.MEM_LENGTH                     (MEM_LENGTH                   ),
    //.MEM_ADDRESS_LENGTH             (MEM_ADDRESS_LENGTH           )
  )
  driver_core_5
  (
`ifdef USE_POWER_PINS
     .vccd1                          (vccd1                        ),	// User area 1 1.8V supply
     .vssd1                          (vssd1                        ),	// User area 1 1.8V supply
`endif
    .clock                          (user_clock2                  ),
    .clock_a                        (user_clock2                  ),
    .mask_select_a                  (mask_select                  ),
    .mem_address_a                  (mem_address                  ),
    .mem_write_n_a                  (mem_write_n[5]               ),
    .mem_dot_write_n_a              (mem_dot_write_n[5]           ),
    .row_select_a                   (row_select                   ),
    .col_select_a                   (col_select                   ),
    .mem_sel_col_address_a          (mem_sel_col_address          ),
    .data_in_a                      (data_out                     ),
    .mem_sel_write_n_a              (mem_sel_write_n[5]           ),
    .row_col_select_a               (row_col_select[5]            ), 
    .output_active_a                (output_active                ),
    .inverter_select_a              (inverter_select[5]           ),
    .driver_io                      (driver_io[11:10]             )
  );

  driver_core_mirror
  #(

    //.MEM_LENGTH                     (MEM_LENGTH                   ),
    //.MEM_ADDRESS_LENGTH             (MEM_ADDRESS_LENGTH           )
  )
  driver_core_6
  (
`ifdef USE_POWER_PINS
     .vccd1                          (vccd1                        ),	// User area 1 1.8V supply
     .vssd1                          (vssd1                        ),	// User area 1 1.8V supply
`endif
    .clock                          (user_clock2                  ),
    .clock_a                        (user_clock2                  ),
    .mask_select_a                  (mask_select                  ),
    .mem_address_a                  (mem_address                  ),
    .mem_write_n_a                  (mem_write_n[6]               ),
    .mem_dot_write_n_a              (mem_dot_write_n[6]           ),
    .row_select_a                   (row_select                   ),
    .col_select_a                   (col_select                   ),
    .mem_sel_col_address_a          (mem_sel_col_address          ),
    .data_in_a                      (data_out                     ),
    .mem_sel_write_n_a              (mem_sel_write_n[6]           ),
    .row_col_select_a               (row_col_select[6]            ), 
    .output_active_a                (output_active                ),
    .inverter_select_a              (inverter_select[6]           ),
    .driver_io                      (driver_io[13:12]             )
  );

  driver_core_mirror
  #(

    //.MEM_LENGTH                     (MEM_LENGTH                   ),
    //.MEM_ADDRESS_LENGTH             (MEM_ADDRESS_LENGTH           )
  )
  driver_core_7
  (
`ifdef USE_POWER_PINS
     .vccd1                          (vccd1                        ),	// User area 1 1.8V supply
     .vssd1                          (vssd1                        ),	// User area 1 1.8V supply
`endif
    .clock                          (user_clock2                  ),
    .clock_a                        (user_clock2                  ),
    .mask_select_a                  (mask_select                  ),
    .mem_address_a                  (mem_address                  ),
    .mem_write_n_a                  (mem_write_n[7]               ),
    .mem_dot_write_n_a              (mem_dot_write_n[7]           ),
    .row_select_a                   (row_select                   ),
    .col_select_a                   (col_select                   ),
    .mem_sel_col_address_a          (mem_sel_col_address          ),
    .data_in_a                      (data_out                     ),
    .mem_sel_write_n_a              (mem_sel_write_n[7]           ),
    .row_col_select_a               (row_col_select[7]            ), 
    .output_active_a                (output_active                ),
    .inverter_select_a              (inverter_select[7]           ),
    .driver_io                      (driver_io[15:14]             )
  );


endmodule	// user_project_wrapper

`default_nettype wire
