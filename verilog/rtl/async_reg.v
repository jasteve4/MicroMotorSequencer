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
 * async_reg
 *
 *
 *-------------------------------------------------------------
 */


module async_reg(
  input wire clock_async,
  input wire clock_sync,
  input wire data_async,
  output reg data_sync
);

  reg A,B;
  always@(posedge clock_async)
  begin
    A <= data_async;
  end

  always@(posedge clock_sync)
  begin
    B <= A;
    data_sync <= A;
  end

endmodule
