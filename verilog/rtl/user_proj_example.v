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
 * user_proj_example
 *
 *
 *-------------------------------------------------------------
 */
`ifndef MPRJ_IO_PADS
  `define MPRJ_IO_PADS 38
`endif


//module micro_motor_sequencer
module user_proj_example
(
`ifdef USE_POWER_PINS
    inout vccd1,	// User area 1 1.8V supply
    inout vssd1,	// User area 1 digital ground
`endif

    // Logic Analyzer Signals
    input  wire [127:0] la_data_in,
    output wire [127:0] la_data_out,
    input  wire [127:0] la_oenb,

    // IOs
    input  wire [`MPRJ_IO_PADS-1:0] io_in,
    output wire [`MPRJ_IO_PADS-1:0] io_out,
    output wire [`MPRJ_IO_PADS-1:0] io_oeb,


    // Independent clock (on independent integer divider)
    input wire   user_clock2,

    // User maskable interrupt signals
    output wire [2:0] irq

);
    localparam NUM_OF_DRIVERS = 8;

    wire [37:0]             user_data_out;
    wire [37:0]             user_data_oeb;
    reg [`MPRJ_IO_PADS-1:0] io_in_reg;

    wire                    clock;
    wire                    reset_n;
    wire                    latch_data;
    wire                    control_trigger;
    wire                    ss_n;
    wire                    sclk;
    wire                    mosi;

    wire [NUM_OF_DRIVERS*2-1:0]             driver_io;
    wire                    update_cycle_complete;
    wire                    miso;


    //Q
    assign irq = 3'b000;	// Unused

    // Assuming LA probes [65:64] are for controlling the count clk & reset  
    assign clock = (~la_oenb[64]) ? la_data_in[64]: user_clock2;

    genvar i;
    generate
    for(i=0;i<38;i=i+1'b1)
    begin : io_port_assignment
        assign io_out[i]       = (~la_oenb[i])    ? la_data_in[i]    : user_data_out[i];
	assign io_oeb[i]       = (~la_oenb[i+38]) ? la_data_in[i+38] : user_data_oeb[i];
	assign la_data_out[i]  = (~la_oenb[i])    ? 1'b0             : io_in_reg[i];
	//assign la_data_out[i] = (~la_oenb[i]) ? 1'b0 : io_in[i];
	always@(posedge clock)
	begin
		io_in_reg[i] = io_in[i];
	end
    end

    endgenerate
    // 15 16 18 19 21 23
    //  0 14 17 20 22  0
    // 12  0 13 24  0 25
    //  0  0  0  0 26 27
    //  0  0  0  0 28 29
    //  0  0  0  0 30 31
    //  0  0  0  0  0 32
    //  0  0  0 33 34 35
    //  0  0  0  0 36 37
    //  0  0  0  0  0  0
    //  28 decated pins

    assign user_data_out = {
	1'b0,			// 37 enable_n
	1'b0,			// 36 control_trigger
	1'b0,			// 35 latch_data
	miso,			// 34 miso
	1'b0,			// 33 mosi
	1'b0,			// 32 ss_n
        1'b0,			// 31 sclk 
 	driver_io[0],		// 30
 	driver_io[1],		// 29
 	driver_io[2],		// 28
 	driver_io[3],		// 27
 	driver_io[4],		// 26
 	driver_io[5],		// 25
 	driver_io[6],		// 24
 	driver_io[7],		// 23
 	driver_io[8],		// 22
 	driver_io[9],		// 21
 	driver_io[10],		// 20
 	driver_io[11],		// 19
 	driver_io[12],		// 18
 	driver_io[13],		// 17
 	driver_io[14],		// 16
 	driver_io[15],		// 15
	1'b0,			// 14	user_control_enable_6
	1'b0,			// 13	user_control_enable_5
	1'b0,			// 12	user_control_enable_4
	1'b0,			// 11   user_control_enable_3
	update_cycle_complete,	// 10	flash2_io  / user_control_enable_2
	1'b0,			// 9	flash2_io  / user_control_enable_1
	1'b0,			// 8	flash2_csb / user_control_enable_0
	1'b0,			// 7	irq
	1'b0,			// 6	ser_tx
	1'b0,			// 5	ser_rx
	1'b0,			// 4	SCK
	1'b0,			// 3	CSB
	1'b0,			// 2	SDI
	1'b0,			// 1	SDO  / CPU_TO_IO
	1'b0			// 0   	JTAG / IO_TO_CPU
	};

    assign user_data_oeb = {
	1'b1,			// 37 	reset_n     	: input
	1'b1,			// 36 	control_trigger : input  
	1'b1,			// 35 	latch_data 	: input
	1'b0,			// 34 	miso 	   	: output
	1'b1,			// 33 	mosi 	   	: input
	1'b1,			// 32 	ss_n 	   	: input
	1'b1,			// 31 	sclk	   	: input
	1'b0,			// 30	hbrige_0 	: output
	1'b0,			// 29	hbrige_0 	: output
	1'b0,			// 28	hbrige_0 	: output
	1'b0,			// 27	hbrige_0 	: output
	1'b0,			// 26	hbrige_0 	: output
	1'b0,			// 25	hbrige_0 	: output
	1'b0,			// 24	hbrige_0 	: output
	1'b0,			// 23	hbrige_0 	: output
	1'b0,			// 22	hbrige_0 	: output
	1'b0,			// 21	hbrige_0 	: output
	1'b0,			// 20	hbrige_0 	: output
	1'b0,			// 19	hbrige_0 	: output
	1'b0,			// 18	hbrige_0 	: output
	1'b0,			// 17	hbrige_0 	: output
	1'b0,			// 16	triger_out_n 	: output
	1'b0,			// 15   n/a 		: input				
	1'b1,			// 14	user_control_enable_6
	1'b1,			// 13	user_control_enable_5
	1'b1,			// 12	user_control_enable_4
	1'b1,			// 11   user_control_enable_3
	1'b0,			// 10	flash2_io  / user_control_enable_2
	1'b1,			// 9	flash2_io  / user_control_enable_1
	1'b1,			// 8	flash2_csb / user_control_enable_0
	1'b1,			// 7	irq
	1'b1,			// 6	ser_tx
	1'b1,			// 5	ser_rx
	1'b1,			// 4	SCK
	1'b1,			// 3	CSB
	1'b1,			// 2	SDI
	1'b1,			// 1	SDO  / IO_TO_CPU : input
	1'b1			// 0   	JTAG / CPU_TO_IO : output
	};

	
	assign reset_n         = (~la_oenb[64]) ? la_data_in[64] : io_in_reg[37]; 
	assign control_trigger = (~la_oenb[65]) ? la_data_in[65] : io_in_reg[36]; 	  
	assign latch_data      = (~la_oenb[66]) ? la_data_in[66] : io_in_reg[35];	
	//					                   io_in_reg[34];	
	//assign mosi 	       = (~la_oenb[67]) ? la_data_in[67] : io_in_reg[33];	
	assign mosi 	       = (~la_oenb[67]) ? la_data_in[67] : io_in_reg[33];	
	assign ss_n 	       = (~la_oenb[68]) ? la_data_in[68] : io_in_reg[32];  
	assign sclk 	       = (~la_oenb[69]) ? la_data_in[69] : io_in_reg[31];	

  sequencer_chip 
  #(
    .NUM_OF_DRIVERS (NUM_OF_DRIVERS)
  )
  user_design
  (
`ifdef USE_POWER_PINS
     //.vccd1                 (vccd1                 ),	// User area 1 1.8V supply
     //.vssd1                 (vssd1                 ),	// User area 1 digital ground
`endif
    .clock                  (clock                 ),
    .reset_n                (reset_n               ),
    .latch_data             (latch_data            ),
    .control_trigger        (control_trigger       ),
    .driver_io              (driver_io             ),
    .update_cycle_complete  (update_cycle_complete ),
    .sclk                   (sclk                  ),
    .mosi                   (mosi                  ),
    .ss_n                   (ss_n                  ),
    .miso                   (miso                  )
  );

endmodule

`default_nettype wire

