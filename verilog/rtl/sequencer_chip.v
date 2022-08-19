
module sequencer_chip
#(
  parameter MEM_LENGTH = 48,
  parameter MEM_ADDRESS_LENGTH=6,
  parameter NUM_OF_DRIVERS =16
)
(
  input  wire         clock,
  input  wire         reset_n,
  input  wire         latch_data,
  input  wire         control_trigger,
  output wire [NUM_OF_DRIVERS*2-1:0]  driver_io,
  output wire         update_cycle_complete,
  // spi 
  input wire          sclk,
  input wire          mosi,
  input wire          ss_n,
  output wire         miso
);



  wire [31:0]   cmd_data;
  wire [NUM_OF_DRIVERS-1:0]   mem_dot_write_n;
  wire [NUM_OF_DRIVERS-1:0]   mem_sel_write_n;
  wire [NUM_OF_DRIVERS-1:0]   mem_write_n;
  wire          write_config_n;
  wire [2:0]    mask_select;
  wire [15:0]   mem_data;
  wire [6:0]    mem_address;
  wire [15:0]   mem_dot_data;
  wire [15:0]   config_data;
  wire [5:0]    config_address;
  wire [7:0]    mem_sel_data;
  wire [6:0]    mem_sel_col_address;
  //wire [6:0]    mem_sel_row_address;
  wire          timer_enable;

  wire  [MEM_ADDRESS_LENGTH-1:0]   row_select;
  wire  [MEM_ADDRESS_LENGTH-1:0]   col_select;
  wire          output_active;
  wire [NUM_OF_DRIVERS-1:0]   inverter_select;
  wire [NUM_OF_DRIVERS-1:0]   row_col_select;

  system_controller 
  #(
    .NUM_OF_DRIVERS             (NUM_OF_DRIVERS)
  )
  u0 (
    .clock                 (clock                 ),
    .reset_n               (reset_n               ),
    .cmd_data              (cmd_data              ),
    .latch_data            (latch_data            ),
    .control_trigger       (control_trigger       ),
    .mem_dot_write_n       (mem_dot_write_n       ),
    .mem_sel_write_n       (mem_sel_write_n       ),
    .mem_write_n           (mem_write_n           ),
    .write_config_n        (write_config_n        ),
    .mask_select           (mask_select           ),
    .mem_data              (mem_data              ),             
    .mem_address           (mem_address           ),
    .mem_dot_data          (mem_dot_data          ),         
    .config_data           (config_data           ),          
    .config_address        (config_address        ),       
    .mem_sel_data          (mem_sel_data          ),         
    .mem_sel_col_address   (mem_sel_col_address   ),   
    //.mem_sel_row_address   (mem_sel_row_address   ),
    .timer_enable          (timer_enable          ),
    .update_cycle_complete (update_cycle_complete )
  );

  backend_cycle_controller 
  #(
  .MEM_ADDRESS_LENGTH         (MEM_ADDRESS_LENGTH),
  .NUM_OF_DRIVERS             (NUM_OF_DRIVERS)
  )
  u1
  (
    .clock                    (clock                 ),
//    .reset_n                  (reset_n               ),
    .timer_enable             (timer_enable          ),
    .write_config_n           (write_config_n        ),
    .config_address           (config_address        ),
    .config_data              (config_data           ),
    .row_select               (row_select            ),
    .col_select               (col_select            ),
    .output_active            (output_active         ),
    .inverter_select          (inverter_select       ),
    .row_col_select           (row_col_select        ),
    .update_cycle_complete    (update_cycle_complete )
  );


  genvar I,J;
  generate
    for(I=0;I<NUM_OF_DRIVERS;I=I+1)
    begin
      wire firing_bit;
      wire firing_data;
      wire data;
      wire enable;
      wire p_wire;
      wire n_wire;

      dot_sequencer 
      #(
        .MEM_LENGTH           (MEM_LENGTH           ),
        .MEM_ADDRESS_LENGTH   (MEM_ADDRESS_LENGTH   )
      )
      u2
      (
        .clock                (clock                                        ),
        //.reset_n              (reset_n                                      ),
        .mask_select          (mask_select                                  ),
        .mem_address          (mem_address         [MEM_ADDRESS_LENGTH-1:0] ),
        .mem_data             (mem_data                                     ),
        .mem_write_n          (mem_write_n[I]                               ),
        .mem_dot_data         (mem_dot_data                                 ),
        .mem_dot_write_n      (mem_dot_write_n[I]                           ),
        .row_select           (row_select                                   ),
        .col_select           (col_select                                   ),
        //.mem_sel_row_address  (mem_sel_row_address [MEM_ADDRESS_LENGTH-1:0] ),
        .mem_sel_col_address  (mem_sel_col_address [MEM_ADDRESS_LENGTH-1:0] ),
        .mem_sel_data         (mem_sel_data        [MEM_ADDRESS_LENGTH-1:0] ),
        .mem_sel_write_n      (mem_sel_write_n[I]                           ),
        .row_col_select       (row_col_select[I]                            ),
        .firing_data          (firing_data                                  ),
        .firing_bit           (firing_bit                                   )
      );                      

      dot_driver u3(          
        .clock                (clock                ),
        //.reset_n              (reset_n              ),
        .dot_enable           (firing_bit           ),
        .output_enable        (output_active        ),
        .dot_state            (firing_data          ),
        .dot_invert           (inverter_select[I]   ),
        .data                 (data                 ),
        .enable               (enable               )
      );                      

      HBrigeDriver u4(
        .p_out                (p_wire),
        .n_out                (n_wire),
        .en_n                 (~enable),
        .in                   (data)
      );

      assign driver_io[I*2+1:I*2] = {p_wire,n_wire};

    end                       
  endgenerate                 
  spi_controller u5(
    .clock          (clock),
    .enable_sn      (~reset_n),
    .sclk           (sclk),
    .mosi           (mosi),
    .ss_n           (ss_n),
    .miso           (miso),
    .data_valid_n   (1'b1),
    .data_out       (cmd_data),
    .data_in        (32'b0)
  );

endmodule
