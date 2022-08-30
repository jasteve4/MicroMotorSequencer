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
 * driver_core
 *
 *
 *-------------------------------------------------------------
 */
module driver_core
#(

  parameter MEM_LENGTH           =48,
  parameter MEM_ADDRESS_LENGTH   =6
)
(
`ifdef USE_POWER_PINS
    inout wire vssd1,	// User area 2 analog ground
    inout wire vccd1,	// User area 1 1.8V supply
`endif
  input wire                           clock,
  input wire                           clock_a,
  input   wire [9:0]                   mem_address_a,
  input wire                           mem_write_n_a,
  input wire  [MEM_ADDRESS_LENGTH-1:0] row_select_a,
  input wire  [MEM_ADDRESS_LENGTH-1:0] col_select_a,
  input wire  [15:0]                   data_in_a,
  input wire                           row_col_select_a, 
  input wire                           output_active_a,
  input wire                           inverter_select_a,
  output wire [1:0]                    driver_io
);

  wire [9:0]                     mem_address;
  wire                           mem_write_n;
  wire  [MEM_ADDRESS_LENGTH-1:0] row_select;
  wire  [MEM_ADDRESS_LENGTH-1:0] col_select;
  wire  [15:0]                   data_in;
  wire                           row_col_select; 
  wire                           output_active;
  wire                           inverter_select;
  reg	[3:0]                    output_active_hold;

  wire firing_data;
  wire firing_bit;
  wire data;
  wire enable;

  always@(posedge clock)
  begin
    output_active_hold = {output_active_hold[2:0],output_active};
  end


  async_reg  mem_address_trans[9:0](
    .clock_async        (clock_a),
    .clock_sync         (clock),
    .data_async         (mem_address_a),
    .data_sync          (mem_address)
  );

  async_reg  mem_write_n_trans(
    .clock_async        (clock_a),
    .clock_sync         (clock),
    .data_async         (mem_write_n_a),
    .data_sync          (mem_write_n)
  );


  async_reg  row_select_trans[MEM_ADDRESS_LENGTH-1:0](
    .clock_async        (clock_a),
    .clock_sync         (clock),
    .data_async         (row_select_a),
    .data_sync          (row_select)
  );

  async_reg  col_select_trans[MEM_ADDRESS_LENGTH-1:0](
    .clock_async        (clock_a),
    .clock_sync         (clock),
    .data_async         (col_select_a),
    .data_sync          (col_select)
  );


  async_reg  data_in_trans[15:0](
    .clock_async        (clock_a),
    .clock_sync         (clock),
    .data_async         (data_in_a),
    .data_sync          (data_in)
  );

  async_reg  row_col_select_trans(
    .clock_async        (clock_a),
    .clock_sync         (clock),
    .data_async         (row_col_select_a),
    .data_sync          (row_col_select)
  );
  
  async_reg  output_active_trans(
    .clock_async        (clock_a),
    .clock_sync         (clock),
    .data_async         (output_active_a),
    .data_sync          (output_active)
  );

  async_reg  inverter_select_trans(
    .clock_async        (clock_a),
    .clock_sync         (clock),
    .data_async         (inverter_select_a),
    .data_sync          (inverter_select)
  );



  driver_sequencer
  #(
    .MEM_LENGTH           (MEM_LENGTH           ),
    .MEM_ADDRESS_LENGTH   (MEM_ADDRESS_LENGTH   )
  )
    u2
  (
    .clock                (clock               ),
    .mem_address          (mem_address         ),
    .mem_write_n          (mem_write_n         ),
    .row_select           (row_select          ),
    .col_select           (col_select          ),
    .data_in              (data_in             ),
    .row_col_select       (row_col_select      ),
    .driver_data          (firing_data         ),
    .driver_enable        (firing_bit          )
  );

  dot_driver u3(          
    .clock                (clock                ),
    .dot_enable           (firing_bit           ),
    .output_enable        (&output_active_hold  ),
    .dot_state            (firing_data          ),
    .dot_invert           (inverter_select      ),
    .data                 (data                 ),
    .enable               (enable               )
  );                      

  HBrigeDriver u4(
    .p_out                (driver_io[1]),
    .n_out                (driver_io[0]),
    .en_n                 (~enable),
    .in                   (data)
  );




endmodule
