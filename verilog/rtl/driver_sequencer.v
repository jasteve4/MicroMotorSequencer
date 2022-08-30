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
 * dot_sequencer
 *
 *
 *-------------------------------------------------------------
 */
module driver_sequencer
#(
  parameter MEM_LENGTH = 48,
  parameter MEM_ADDRESS_LENGTH=6
)
(
  input   wire                            clock,
  input   wire [9:0] mem_address,
  input   wire                            mem_write_n,
  input   wire [MEM_ADDRESS_LENGTH-1:0]   row_select,
  input   wire [MEM_ADDRESS_LENGTH-1:0]   col_select,
  input   wire [15:0]                     data_in,
  input   wire                            row_col_select,
  output  wire                            driver_data,
  output  reg                             driver_enable
);

  //localparam NUM_OF_DOTS_PER_MEM    = $clog2(MEM_LENGTH/16);
  localparam NUM_OF_DOTS_PER_MEM    = 3;
  localparam ACTIVE_MEM_LOWER_BOUND = 0;
  localparam ACTIVE_MEM_UPPER_BOUND = ACTIVE_MEM_LOWER_BOUND + NUM_OF_DOTS_PER_MEM * MEM_LENGTH - 1 ;
  localparam SELECT_MEM_LOWER_BOUND = ACTIVE_MEM_UPPER_BOUND + 1 ;
  localparam SELECT_MEM_UPPER_BOUND = SELECT_MEM_LOWER_BOUND + MEM_LENGTH -1 ;
  localparam DOT_MEM_LOWER_BOUND    = SELECT_MEM_UPPER_BOUND + 1 ; 
  localparam DOT_MEM_UPPER_BOUND    = DOT_MEM_LOWER_BOUND + NUM_OF_DOTS_PER_MEM - 1 ;
  localparam SYS_MEM_BOUND          = DOT_MEM_UPPER_BOUND;
  localparam SYS_MEM_ADDRESS_LENGTH = 2*MEM_ADDRESS_LENGTH;

  wire [MEM_LENGTH-1:0]                   current_row;
  reg  [15:0]                             firing_mem ;
  reg  [15:0]                             select_mem;
  reg  [15:0]                             dot_mem;
  wire                                    current_bit;
  wire [MEM_ADDRESS_LENGTH-1:0]           current_data_idx;


  wire [9:0]         mem_offset;
  wire [9:0]         active_mem_offset;
  wire [MEM_ADDRESS_LENGTH-1:0]           driver_mem_offset;
  reg [15:0]                              mem [0:SYS_MEM_BOUND];
  reg [15:0]                              active_mem;
  reg [15:0]                              select_mem_col;
  reg [15:0]                              select_mem_row;
  reg [15:0]                              driver_mem;

  genvar I;
  generate
    for(I=0;I<SYS_MEM_BOUND+1;I=I+1) begin : mem_gen
      always@(posedge clock) begin
        //mem[I] <= (I==mem_address) ? mem_write_n ? mem[I] : data_in : mem[I];
        mem[I] <= (I==mem_address) && (mem_write_n == 0) ? data_in : mem[I];
      end
    end
  endgenerate

  assign mem_offset  = ((row_select<<MEM_ADDRESS_LENGTH) - (row_select<<4))  + col_select; 
  assign active_mem_offset = ACTIVE_MEM_LOWER_BOUND+mem_offset[9:4];

  always@(posedge clock) begin
    active_mem <= mem[active_mem_offset]; // should output be active 
  end

  always@(posedge clock)
    driver_enable = active_mem[mem_offset[3:0]];

  always@(posedge clock) begin
    select_mem_col = mem[SELECT_MEM_LOWER_BOUND+col_select]; // which one to activate
    select_mem_row = mem[SELECT_MEM_LOWER_BOUND+row_select]; // which one to activate
  end

  assign driver_mem_offset = row_col_select ? select_mem_col : select_mem_row;

  always@(posedge clock) begin
    driver_mem = mem[DOT_MEM_LOWER_BOUND+driver_mem_offset[MEM_ADDRESS_LENGTH-1:4]]; // holds the element
  end

  assign driver_data = driver_mem[driver_mem_offset[3:0]]; 

endmodule
