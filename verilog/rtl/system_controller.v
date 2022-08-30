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
 * system_controller
 *
 *
 *-------------------------------------------------------------
 */



`define IDLE_STATE              4'b0001 
`define ACTIVE_STATE            4'b0010
`define TRIGGERED_WAIT_STATE    4'b0011
`define TRIGGRED_NO_WAIT_STATE  4'b0100
`define CONTINUOUS_EXE_STATE    4'b0101
`define ONESHOT_EXE_STATE       4'b0110
`define HOLDING_STATE           4'b0111

module system_controller
#(
  parameter NUM_OF_DRIVERS = 10
)
(
  input   wire        clock,
  input   wire        reset_n,
  input   wire [31:0] cmd_data,
  input   wire        latch_data,
  input   wire        control_trigger,
  output reg [NUM_OF_DRIVERS-1:0]   mem_write_n,
  output reg          write_config_n,
  output wire [9:0]   mem_address,          
  output wire [15:0]  data_out,          
  output reg          timer_enable,
  input wire          update_cycle_complete
);

  wire                latch_cmd;
  wire                mem_config_select;
  reg                 update_cmd;
  wire [3:0]          sequencer_select;
  wire [1:0]          cmd_section;
  wire [2:0]          data_mask;

  reg [31:0]  cmd;
  wire running;
  wire [3:0] control_state;
  reg  [3:0] run_state;


  impulse u11(
    .clock    (clock),
    .reset_n  (reset_n),
    .trigger  (latch_data),
    .advance  (latch_cmd)
  );

  always@(posedge clock)
  begin
    case({reset_n,latch_cmd})
      2'b11   : cmd <= cmd_data;
      2'b10   : cmd <= cmd;
      default : cmd <= 'b0;
    endcase
  end

  always@(posedge clock)
  begin
      update_cmd <= latch_cmd;
  end


  assign sequencer_select     = cmd[29:26];
  assign cmd_section          = cmd[31:30];

  assign data_out             = cmd[15:0];
  assign mem_address          = cmd[25:16]; // 10 bits for address

  always@(posedge clock)
  begin
    case(cmd_section)
      2'b00   : write_config_n <= 1'b1;
      2'b01   : write_config_n <= 1'b1;
      2'b10   : write_config_n <= ~update_cmd;
      2'b11   : write_config_n <= 1'b1;
    endcase
  end

  genvar I;
  generate
    for(I=0;I<NUM_OF_DRIVERS;I=I+1)
    begin : gen0
      always@(posedge clock)
      begin
        case(cmd_section)
          2'b00   : mem_write_n[I] <= (sequencer_select == I) ? ~update_cmd : 1'b1; 
          2'b01   : mem_write_n[I] <= 1'b1;
          2'b10   : mem_write_n[I] <= 1'b1;
          2'b11   : mem_write_n[I] <= 1'b1;
        endcase
      end
    end
  endgenerate




  assign running = reset_n & (&cmd_section);

  assign control_state = cmd[29:26];

  always@(posedge clock)
  begin
    if(running)
    begin
      case(run_state)
        `IDLE_STATE             : run_state <= control_state[3] ? `ACTIVE_STATE :`IDLE_STATE; 
        `ACTIVE_STATE           : run_state <= control_state[2] ? `TRIGGERED_WAIT_STATE : `TRIGGRED_NO_WAIT_STATE;
        `TRIGGERED_WAIT_STATE   : run_state <= control_trigger ? control_state[1] ? `CONTINUOUS_EXE_STATE : `ONESHOT_EXE_STATE : `TRIGGERED_WAIT_STATE;
        `TRIGGRED_NO_WAIT_STATE : run_state <= control_state[1] ? `CONTINUOUS_EXE_STATE : `ONESHOT_EXE_STATE;
        `CONTINUOUS_EXE_STATE   : run_state <= `CONTINUOUS_EXE_STATE;
        `ONESHOT_EXE_STATE      : run_state <= update_cycle_complete ? `HOLDING_STATE : `ONESHOT_EXE_STATE;
        `HOLDING_STATE          : run_state <= control_state[0] & control_trigger ? `ONESHOT_EXE_STATE : `HOLDING_STATE;
        default                 : run_state <= `IDLE_STATE;
      endcase
    end
    else
    begin
      run_state <= `IDLE_STATE;
    end
  end

  always@(posedge clock)
  begin
    case(run_state)
      `CONTINUOUS_EXE_STATE   : timer_enable <= 1'b1;
      `ONESHOT_EXE_STATE      : timer_enable <= 1'b1;
      default                 : timer_enable <= 1'b0;
    endcase
  end



endmodule
