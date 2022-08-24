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
 * HBrigeDriver
 *
 *
 *-------------------------------------------------------------
 */
module HBrigeDriver(
  output wire p_out,
  output wire n_out,
  input wire en_n,
  input wire in
);

 assign n_out = en_n ? 1'b0 : in ? 1'b0 : 1'b1; 
 assign p_out = en_n ? 1'b1 : in ? 1'b0 : 1'b1; 

endmodule


