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
 * spi_controller
 *
 *
 *-------------------------------------------------------------
 */
module spi_controller(
`ifdef USE_POWER_PINS
    inout wire vssd1,	// User area 2 analog ground
    inout wire vccd1,	// User area 1 1.8V supply
`endif
  input wire clock,
  output wire [31:0] data_out,
  output wire clock_out,
  output wire miso,
  output reg  miso_oeb,
  input wire  mosi,
  output reg  mosi_oeb,
  input wire  ss_n,
  output reg  ss_n_oeb,
  input wire  sclk,
  output reg  sclk_oeb,
  output reg  [3:0] la_oenb,
  input  wire [3:0] la_data_in
);

  reg [2:0] sclk_reg;
  reg [2:0] ss_n_reg;
  reg [2:0] mosi_reg;
  reg [31:0] spi_data;

  wire sclk_rising_edge;
  wire ss_n_enable;
  wire mosi_data;


  always@(posedge clock)
  begin
    miso_oeb      = (~la_oenb[0]) ? la_data_in[0]   : 1'b1;       
    mosi_oeb      = (~la_oenb[1]) ? la_data_in[1]   : 1'b0;       
    ss_n_oeb      = (~la_oenb[2]) ? la_data_in[2]   : 1'b0;       
    sclk_oeb      = (~la_oenb[3]) ? la_data_in[3]   : 1'b0;       
  end

  assign clock_out = clock;

  always@(posedge clock)
  sclk_reg <= {sclk_reg[1:0],sclk};

  always@(posedge clock)
  ss_n_reg <= {ss_n_reg[1:0],ss_n};

  always@(posedge clock)
  mosi_reg <= {mosi_reg[1:0],mosi};

  assign sclk_rising_edge = (sclk_reg[2:1] == 2'b01);
  assign ss_n_enable = (ss_n_reg[2:1] == 3'b11);
  assign mosi_data = (mosi_reg[2:1] == 3'b11);

  /*always@(posedge clock)
  begin
    case({enable_sn,ss_n_enable,data_valid_n})
      3'b000: spi_data <= sclk_rising_edge ? {spi_data[30:0],mosi_data} : spi_data;
      3'b001: spi_data <= sclk_rising_edge ? {spi_data[30:0],mosi_data} : spi_data;
      3'b001: spi_data <= sclk_rising_edge ? {spi_data[30:0],mosi_data} : spi_data;
      3'b010: spi_data <= data_in;
      3'b011: spi_data <= spi_data;
      default: spi_data <= 32'hDEADBEEF;
    endcase
  end*/
  always@(posedge clock)
  begin
    case(ss_n_enable)
      1'b0: spi_data <= sclk_rising_edge ? {spi_data[30:0],mosi_data} : spi_data;
      1'b1: spi_data <= spi_data;
    endcase
  end


  assign data_out = spi_data;
  assign miso = spi_data[31];


endmodule
