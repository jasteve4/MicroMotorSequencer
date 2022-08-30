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
  localparam NUM_OF_DRIVERS = 10;
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

  wire [31:0]                 spi_data;
  wire                        spi_data_clock;

  wire [NUM_OF_DRIVERS-1:0]   io_driver_io_oeb;
  wire [NUM_OF_DRIVERS*2-1:0] driver_io;

  wire  [9:0]                    mem_address_right;
  wire  [9:0]                    mem_address_left;
  wire  [NUM_OF_DRIVERS-1:0]     mem_write_n;
  wire  [MEM_ADDRESS_LENGTH-1:0] row_select_right;
  wire  [MEM_ADDRESS_LENGTH-1:0] row_select_left;
  wire  [MEM_ADDRESS_LENGTH-1:0] col_select_right;
  wire  [MEM_ADDRESS_LENGTH-1:0] col_select_left;
  wire  [15:0]                   data_out_right;
  wire  [15:0]                   data_out_left;
  wire  [NUM_OF_DRIVERS-1:0]     row_col_select;
  wire                           output_active_right;
  wire                           output_active_left;
  wire  [NUM_OF_DRIVERS-1:0]     inverter_select;
  // clock fanout reduction
  wire [NUM_OF_DRIVERS-1:0]      clock_out;

  assign io_reset_n_in              = io_in[37];
  assign io_oeb[37]                 = io_reset_n_oeb;
//  assign io_out[37]                 =0;

  assign io_control_trigger_in      = io_in[36];
  assign io_oeb[36]                 = io_control_trigger_oeb;
//  assign io_out[36]                 =0;

  assign io_latch_data_in           = io_in[35];
  assign io_oeb[35]                 = io_latch_data_oeb;
//  assign io_out[35]                 =0;

  assign io_oeb[34]                 = io_miso_oeb;
  assign io_out[34]                 = io_miso_out;

  assign io_mosi_in                 = io_in[33];
  assign io_oeb[33]                 = io_mosi_oeb;

  assign io_ss_n_in                 = io_in[32];
  assign io_oeb[32]                 = io_ss_n_oeb;

  assign io_sclk_in                 = io_in[31];
  assign io_oeb[31]                 = io_sclk_oeb;

  assign io_out[30]                 = io_update_cycle_complete_out;
  assign io_oeb[30]                 = io_update_cycle_complete_oeb;

  
  assign io_oeb[29]                 = io_driver_io_oeb[0];
  assign io_oeb[28]                 = io_driver_io_oeb[0];
  assign io_oeb[27]                 = io_driver_io_oeb[1];
  assign io_oeb[26]                 = io_driver_io_oeb[1];
  assign io_oeb[25]                 = io_driver_io_oeb[2];
  assign io_oeb[24]                 = io_driver_io_oeb[2];
  assign io_oeb[23]                 = io_driver_io_oeb[3];
  assign io_oeb[22]                 = io_driver_io_oeb[3];
  assign io_oeb[21]                 = io_driver_io_oeb[4];
  assign io_oeb[20]                 = io_driver_io_oeb[4];
//  assign io_oeb[19]                 = 0;
//  assign io_oeb[18]                 = 0;
  assign io_oeb[17]                 = io_driver_io_oeb[5];
  assign io_oeb[16]                 = io_driver_io_oeb[5];
  assign io_oeb[15]                 = io_driver_io_oeb[6];
  assign io_oeb[14]                 = io_driver_io_oeb[6];
  assign io_oeb[13]                 = io_driver_io_oeb[7];
  assign io_oeb[12]                 = io_driver_io_oeb[7];
  assign io_oeb[11]                 = io_driver_io_oeb[8];
  assign io_oeb[10]                 = io_driver_io_oeb[8];
  assign io_oeb[9]                  = io_driver_io_oeb[9];
  assign io_oeb[8]                  = io_driver_io_oeb[9];
//  assign io_oeb[7]                 = 0;
//  assign io_oeb[6]                 = 0;
//  assign io_oeb[5]                 = 0;
//  assign io_oeb[4]                 = 0;
//  assign io_oeb[3]                 = 0;
//  assign io_oeb[2]                 = 0;
//  assign io_oeb[1]                 = 0;
//  assign io_oeb[0]                 = 0;

  assign io_out[29]                 = driver_io[0];
  assign io_out[28]                 = driver_io[1];
  assign io_out[27]                 = driver_io[2];
  assign io_out[26]                 = driver_io[3];
  assign io_out[25]                 = driver_io[4];
  assign io_out[24]                 = driver_io[5];
  assign io_out[23]                 = driver_io[6];
  assign io_out[22]                 = driver_io[7];
  assign io_out[21]                 = driver_io[8];
  assign io_out[20]                 = driver_io[9];
//  assign io_out[19]                 = 0;
//  assign io_out[18]                 = 0;
  assign io_out[17]                 = driver_io[10];
  assign io_out[16]                 = driver_io[11];
  assign io_out[15]                 = driver_io[12];
  assign io_out[14]                 = driver_io[13];
  assign io_out[13]                 = driver_io[14];
  assign io_out[12]                 = driver_io[15];
  assign io_out[11]                 = driver_io[16];
  assign io_out[10]                 = driver_io[17];
  assign io_out[9]                  = driver_io[18];
  assign io_out[8]                  = driver_io[19];
//  assign io_out[7]                 = 0;
//  assign io_out[6]                 = 0;
//  assign io_out[5]                 = 0;
//  assign io_out[4]                 = 0;
//  assign io_out[3]                 = 0;
//  assign io_out[2]                 = 0;
//  assign io_out[1]                 = 0;
//  assign io_out[0]                 = 0;

  spi_controller spi_controller_mod(
`ifdef USE_POWER_PINS
    .vccd1                           (vccd1                         ),
    .vssd1                           (vssd1                         ),
`endif
    .clock            (user_clock2),
    .data_out         (spi_data),
    .clock_out        (spi_data_clock),
    .miso             (io_miso_out),
    .miso_oeb         (io_miso_oeb),
    .mosi             (io_mosi_in),
    .mosi_oeb         (io_mosi_oeb),
    .ss_n             (io_ss_n_in),
    .ss_n_oeb         (io_ss_n_oeb),
    .sclk             (io_sclk_in),
    .sclk_oeb         (io_sclk_oeb),
    .la_oenb          (la_data_in[35:32]),
    .la_data_in       (la_oenb[35:32]   )
  );

  controller_core
  #(
`ifndef SYNTHESIS
    .MEM_LENGTH                     (MEM_LENGTH                    ),
    .MEM_ADDRESS_LENGTH             (MEM_ADDRESS_LENGTH            ),
    .NUM_OF_DRIVERS                 (NUM_OF_DRIVERS                )
`endif
  )
  controller_core_mod
  (
`ifdef USE_POWER_PINS
    .vccd1                           (vccd1                         ),
    .vssd1                           (vssd1                         ),
`endif
    .la_data_in                      (la_data_in[7+NUM_OF_DRIVERS:0] ),
    .la_oenb                         (la_oenb[7+NUM_OF_DRIVERS:0]    ),
    .clock                           (user_clock2                   ),
    .io_reset_n_in                   (io_reset_n_in                 ),
    .io_reset_n_oeb                  (io_reset_n_oeb                ),
    .io_latch_data_in                (io_latch_data_in              ),
    .io_latch_data_oeb               (io_latch_data_oeb             ),
    .io_control_trigger_in           (io_control_trigger_in         ),
    .io_control_trigger_oeb          (io_control_trigger_oeb        ),
    .io_driver_io_oeb                (io_driver_io_oeb              ),
    .io_update_cycle_complete_out    (io_update_cycle_complete_out  ),
    .io_update_cycle_complete_oeb    (io_update_cycle_complete_oeb  ),

    .mem_address_right               (mem_address_right             ),                                       
    .mem_address_left                (mem_address_left              ),                                      
    .mem_write_n                     (mem_write_n                   ),                                 
    .row_select_right                (row_select_right              ),                                      
    .row_select_left                 (row_select_left               ),                                     
    .col_select_right                (col_select_right              ),                                      
    .col_select_left                 (col_select_left               ),                                     
    .data_out_right                  (data_out_right                ),                                    
    .data_out_left                   (data_out_left                 ),                                   
    .row_col_select                  (row_col_select                ),                                    
    .output_active_right             (output_active_right           ),                                         
    .output_active_left              (output_active_left            ),                                        
    .inverter_select                 (inverter_select               ),                                     
    .clock_out                       (clock_out                     ),

    .spi_data_clock                  (spi_data_clock                ),
    .spi_data                        (spi_data                      )
     
  );

  driver_core
  #(
`ifndef SYNTHESIS
    .MEM_LENGTH                     (MEM_LENGTH                   ),
    .MEM_ADDRESS_LENGTH             (MEM_ADDRESS_LENGTH           )
 `endif
  )
  driver_core_0
  (
`ifdef USE_POWER_PINS
    .vccd1                           (vccd1                         ),
    .vssd1                           (vssd1                         ),
`endif
    .clock                          (clock_out[0]                 ),
    .clock_a                        (clock_out[0]                 ),
    .mem_address_a                  (mem_address_left             ),
    .mem_write_n_a                  (mem_write_n[0]               ),
    .row_select_a                   (row_select_left              ),
    .col_select_a                   (col_select_left              ),
    .data_in_a                      (data_out_left                ),
    .row_col_select_a               (row_col_select[0]            ), 
    .output_active_a                (output_active_left           ),
    .inverter_select_a              (inverter_select[0]           ),
    .driver_io                      (driver_io[1:0]               )
  );

  driver_core
  #(
`ifndef SYNTHESIS
    .MEM_LENGTH                     (MEM_LENGTH                   ),
    .MEM_ADDRESS_LENGTH             (MEM_ADDRESS_LENGTH           )
 `endif
  )
  driver_core_1
  (
`ifdef USE_POWER_PINS
    .vccd1                           (vccd1                         ),
    .vssd1                           (vssd1                         ),
`endif
    .clock                          (clock_out[1]                 ),
    .clock_a                        (clock_out[1]                 ),
    .mem_address_a                  (mem_address_left             ),
    .mem_write_n_a                  (mem_write_n[1]               ),
    .row_select_a                   (row_select_left              ),
    .col_select_a                   (col_select_left              ),
    .data_in_a                      (data_out_left                ),
    .row_col_select_a               (row_col_select[1]            ), 
    .output_active_a                (output_active_left           ),
    .inverter_select_a              (inverter_select[1]           ),
    .driver_io                      (driver_io[3:2]               )
  );

  driver_core
  #(
`ifndef SYNTHESIS
    .MEM_LENGTH                     (MEM_LENGTH                   ),
    .MEM_ADDRESS_LENGTH             (MEM_ADDRESS_LENGTH           )
 `endif
  )
  driver_core_2
  (
`ifdef USE_POWER_PINS
    .vccd1                           (vccd1                         ),
    .vssd1                           (vssd1                         ),
`endif
    .clock                          (clock_out[2]                 ),
    .clock_a                        (clock_out[2]                 ),
    .mem_address_a                  (mem_address_left             ),
    .mem_write_n_a                  (mem_write_n[2]               ),
    .row_select_a                   (row_select_left              ),
    .col_select_a                   (col_select_left              ),
    .data_in_a                      (data_out_left                ),
    .row_col_select_a               (row_col_select[2]            ), 
    .output_active_a                (output_active_left           ),
    .inverter_select_a              (inverter_select[2]           ),
    .driver_io                      (driver_io[5:4]               )
  );

  driver_core
  #(
`ifndef SYNTHESIS
    .MEM_LENGTH                     (MEM_LENGTH                   ),
    .MEM_ADDRESS_LENGTH             (MEM_ADDRESS_LENGTH           )
 `endif
  )
  driver_core_3
  (
`ifdef USE_POWER_PINS
    .vccd1                           (vccd1                         ),
    .vssd1                           (vssd1                         ),
`endif
    .clock                          (clock_out[3]                 ),
    .clock_a                        (clock_out[3]                 ),
    .mem_address_a                  (mem_address_left             ),
    .mem_write_n_a                  (mem_write_n[3]               ),
    .row_select_a                   (row_select_left              ),
    .col_select_a                   (col_select_left              ),
    .data_in_a                      (data_out_left                ),
    .row_col_select_a               (row_col_select[3]            ), 
    .output_active_a                (output_active_left           ),
    .inverter_select_a              (inverter_select[3]           ),
    .driver_io                      (driver_io[7:6]               )
  );

  driver_core
  #(
`ifndef SYNTHESIS
    .MEM_LENGTH                     (MEM_LENGTH                   ),
    .MEM_ADDRESS_LENGTH             (MEM_ADDRESS_LENGTH           )
 `endif
  )
  driver_core_4
  (
`ifdef USE_POWER_PINS
    .vccd1                           (vccd1                         ),
    .vssd1                           (vssd1                         ),
`endif
    .clock                          (clock_out[4]                 ),
    .clock_a                        (clock_out[4]                 ),
    .mem_address_a                  (mem_address_left             ),
    .mem_write_n_a                  (mem_write_n[4]               ),
    .row_select_a                   (row_select_left              ),
    .col_select_a                   (col_select_left              ),
    .data_in_a                      (data_out_left                ),
    .row_col_select_a               (row_col_select[4]            ), 
    .output_active_a                (output_active_left           ),
    .inverter_select_a              (inverter_select[4]           ),
    .driver_io                      (driver_io[9:8]               )
  );

  driver_core
  #(
`ifndef SYNTHESIS
    .MEM_LENGTH                     (MEM_LENGTH                   ),
    .MEM_ADDRESS_LENGTH             (MEM_ADDRESS_LENGTH           )
 `endif
  )
  driver_core_5
  (
`ifdef USE_POWER_PINS
    .vccd1                           (vccd1                         ),
    .vssd1                           (vssd1                         ),
`endif
    .clock                          (clock_out[5]                 ),
    .clock_a                        (clock_out[5]                 ),
    .mem_address_a                  (mem_address_right             ),
    .mem_write_n_a                  (mem_write_n[5]               ),
    .row_select_a                   (row_select_right              ),
    .col_select_a                   (col_select_right              ),
    .data_in_a                      (data_out_right                ),
    .row_col_select_a               (row_col_select[5]            ), 
    .output_active_a                (output_active_right           ),
    .inverter_select_a              (inverter_select[5]           ),
    .driver_io                      (driver_io[11:10]             )
  );

  driver_core
  #(
`ifndef SYNTHESIS
    .MEM_LENGTH                     (MEM_LENGTH                   ),
    .MEM_ADDRESS_LENGTH             (MEM_ADDRESS_LENGTH           )
 `endif
  )
  driver_core_6
  (
`ifdef USE_POWER_PINS
    .vccd1                           (vccd1                         ),
    .vssd1                           (vssd1                         ),
`endif
    .clock                          (clock_out[6]                 ),
    .clock_a                        (clock_out[6]                 ),
    .mem_address_a                  (mem_address_right             ),
    .mem_write_n_a                  (mem_write_n[6]               ),
    .row_select_a                   (row_select_right              ),
    .col_select_a                   (col_select_right              ),
    .data_in_a                      (data_out_right                ),
    .row_col_select_a               (row_col_select[6]            ), 
    .output_active_a                (output_active_right           ),
    .inverter_select_a              (inverter_select[6]           ),
    .driver_io                      (driver_io[13:12]             )
  );

  driver_core
  #(
`ifndef SYNTHESIS
    .MEM_LENGTH                     (MEM_LENGTH                   ),
    .MEM_ADDRESS_LENGTH             (MEM_ADDRESS_LENGTH           )
 `endif
  )
  driver_core_7
  (
`ifdef USE_POWER_PINS
    .vccd1                           (vccd1                         ),
    .vssd1                           (vssd1                         ),
`endif
    .clock                          (clock_out[7]                 ),
    .clock_a                        (clock_out[7]                 ),
    .mem_address_a                  (mem_address_right             ),
    .mem_write_n_a                  (mem_write_n[7]               ),
    .row_select_a                   (row_select_right              ),
    .col_select_a                   (col_select_right              ),
    .data_in_a                      (data_out_right                ),
    .row_col_select_a               (row_col_select[7]            ), 
    .output_active_a                (output_active_right           ),
    .inverter_select_a              (inverter_select[7]           ),
    .driver_io                      (driver_io[15:14]             )
  );

  driver_core
  #(
`ifndef SYNTHESIS
    .MEM_LENGTH                     (MEM_LENGTH                   ),
    .MEM_ADDRESS_LENGTH             (MEM_ADDRESS_LENGTH           )
 `endif
  )
  driver_core_8
  (
`ifdef USE_POWER_PINS
    .vccd1                           (vccd1                         ),
    .vssd1                           (vssd1                         ),
`endif
    .clock                          (clock_out[8]                 ),
    .clock_a                        (clock_out[8]                 ),
    .mem_address_a                  (mem_address_right             ),
    .mem_write_n_a                  (mem_write_n[8]               ),
    .row_select_a                   (row_select_right              ),
    .col_select_a                   (col_select_right              ),
    .data_in_a                      (data_out_right                ),
    .row_col_select_a               (row_col_select[8]            ), 
    .output_active_a                (output_active_right           ),
    .inverter_select_a              (inverter_select[8]           ),
    .driver_io                      (driver_io[17:16]             )
  );

  driver_core
  #(
`ifndef SYNTHESIS
    .MEM_LENGTH                     (MEM_LENGTH                   ),
    .MEM_ADDRESS_LENGTH             (MEM_ADDRESS_LENGTH           )
 `endif
  )
  driver_core_9
  (
`ifdef USE_POWER_PINS
    .vccd1                           (vccd1                         ),
    .vssd1                           (vssd1                         ),
`endif
    .clock                          (clock_out[9]                 ),
    .clock_a                        (clock_out[9]                 ),
    .mem_address_a                  (mem_address_right             ),
    .mem_write_n_a                  (mem_write_n[9]               ),
    .row_select_a                   (row_select_right              ),
    .col_select_a                   (col_select_right              ),
    .data_in_a                      (data_out_right                ),
    .row_col_select_a               (row_col_select[9]            ), 
    .output_active_a                (output_active_right           ),
    .inverter_select_a              (inverter_select[9]           ),
    .driver_io                      (driver_io[19:18]             )
  );

endmodule	// user_project_wrapper

`default_nettype wire
