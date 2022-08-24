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
 * dot_driver
 *
 *
 *-------------------------------------------------------------
 */
module dot_driver(
  input   wire  clock,
  //input   wire  reset_n,
  input   wire  dot_enable,
  input   wire  output_enable,
  input   wire  dot_state,
  input   wire  dot_invert,
  output  reg   data,
  output  reg   enable
);
 
  always@(posedge clock)
  begin
    /*case({reset_n,dot_enable})
      2'b11   : data <= dot_invert ? ~dot_state : dot_state;
      default : data <= 1'b0;
    endcase*/
    //case(dot_enable)
      data <= dot_invert ? ~dot_state : dot_state;
      //1'b0 : data <= 1'b0;
    //endcase
  end

  always@(posedge clock)
  begin
    /*case({reset_n,dot_enable,output_enable})
      3'b111   : enable <= dot_enable;
      default : enable <= 1'b0;
    endcase*/
    case({dot_enable,output_enable})
      2'b11   : enable <= dot_enable;
      default : enable <= 1'b0;
    endcase
  end


endmodule
