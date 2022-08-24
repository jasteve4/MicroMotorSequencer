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
 * impulse
 *
 *
 *-------------------------------------------------------------
 */



module impulse(
  input clock,
  input reset_n,
  input trigger,
  output advance
);

  reg [1:0] impulse_gen;

  always@(posedge clock)
  begin
    if(reset_n)
    begin
      impulse_gen <= {impulse_gen[0],trigger};
    end
    else
    begin
      impulse_gen <= 2'b0;
    end
  end

  assign advance = impulse_gen == 2'b01;

endmodule

/*
 *-------------------------------------------------------------
 *
 * impulse_no_reset
 *
 *
 *-------------------------------------------------------------
 */
module impulse_no_reset(
  input clock,
  input trigger,
  output advance
);

  reg [1:0] impulse_gen;

  always@(posedge clock)
  begin
    impulse_gen <= {impulse_gen[0],trigger};
  end

  assign advance = impulse_gen == 2'b01;

endmodule
