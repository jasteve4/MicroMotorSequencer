


module controller_unit
#(
  parameter MEM_LENGTH = 48,
  parameter MEM_ADDRESS_LENGTH=6,
  parameter NUM_OF_DRIVERS =8
)
(
  // logic analizer inputs
  input  wire [127:0]               la_data_in,
  //output wire [127:0]               la_data_out,
  input  wire [127:0]               la_oenb,
  // clock
  input wire                        user_clock2,
  // user control of IO
  input  wire                       io_reset_n_in,
  output reg                        io_reset_n_oeb,
  input  wire                       io_latch_data_in,
  output reg                        io_latch_data_oeb,
  input  wire                       io_control_trigger_in,
  output reg                        io_control_trigger_oeb,
  output reg [NUM_OF_DRIVERS-1:0]   io_driver_io_oeb,
  output reg                        io_update_cycle_complete_out,
  output reg                        io_update_cycle_complete_oeb,
  input  wire                       io_sclk_in,
  output reg                        io_sclk_oeb,
  input  wire                       io_mosi_in,
  output reg                        io_mosi_oeb,
  input  wire                       io_ss_n_in,
  output reg                        io_ss_n_oeb,
  output reg                        io_miso_out,
  output reg                        io_miso_oeb,

  // system inputs
  output reg  [2:0]                 mask_select_right,
  output reg  [2:0]                 mask_select_left,
  output reg  [6:0]                 mem_address_right,
  output reg  [6:0]                 mem_address_left,
  output reg  [NUM_OF_DRIVERS-1:0]  mem_write_n,
  output reg  [NUM_OF_DRIVERS-1:0]  mem_dot_write_n,
  output reg  [MEM_ADDRESS_LENGTH-1:0]   row_select_right,
  output reg  [MEM_ADDRESS_LENGTH-1:0]   row_select_left,
  output reg  [MEM_ADDRESS_LENGTH-1:0]   col_select_right,
  output reg  [MEM_ADDRESS_LENGTH-1:0]   col_select_left,
  output reg  [6:0]                 mem_sel_col_address_right,
  output reg  [6:0]                 mem_sel_col_address_left,
  output reg  [15:0]                data_out_right,
  output reg  [15:0]                data_out_left,
  output reg  [NUM_OF_DRIVERS-1:0]  mem_sel_write_n,
  output reg  [NUM_OF_DRIVERS-1:0]  row_col_select,
  output reg                        output_active_right,
  output reg                        output_active_left,
  output reg  [NUM_OF_DRIVERS-1:0]  inverter_select,
  // clock fanout reduction
  output wire [NUM_OF_DRIVERS-1:0] clock_out
);

  wire  [2:0]                     internal_mask_select;
  wire  [6:0]                     internal_mem_address;
  wire  [NUM_OF_DRIVERS-1:0]      internal_mem_write_n;
  wire  [NUM_OF_DRIVERS-1:0]      internal_mem_dot_write_n;
  wire  [MEM_ADDRESS_LENGTH-1:0]  internal_row_select;
  wire  [MEM_ADDRESS_LENGTH-1:0]  internal_col_select;
  wire  [6:0]                     internal_mem_sel_col_address;
  wire  [15:0]                    internal_data_out;
  wire  [NUM_OF_DRIVERS-1:0]      internal_mem_sel_write_n;
  wire  [NUM_OF_DRIVERS-1:0]      internal_row_col_select;
  wire                            internal_output_active;
  wire  [NUM_OF_DRIVERS-1:0]      internal_inverter_select;


  reg           reset_n;
  reg           latch_data;
  reg           control_trigger;
  reg           sclk;
  reg           mosi;
  reg           ss_n;
  wire          miso;
  wire [31:0]   cmd_data;
  wire          write_config_n;
  wire [5:0]    config_address;


  wire update_cycle_complete;
  wire          timer_enable;
  wire          clock;
  reg [1:0]     latch_data_sync;
  wire          latch_data_s;
  reg [1:0]     control_trigger_sync;
  wire          control_trigger_s;
  reg [1:0]     reset_n_sync;
  wire          reset_n_s;

  always@(posedge clock)
  begin
    latch_data_sync = {latch_data_sync[0],latch_data};
    control_trigger_sync = {control_trigger_sync[0],control_trigger};
    reset_n_sync = {reset_n_sync[0],reset_n};
  end

  assign latch_data_s = &{latch_data_sync,latch_data} ? 1'b1 : 1'b0;
  assign control_trigger_s = &{control_trigger_sync,control_trigger} ? 1'b1 : 1'b0;
  assign reset_n_s = |{reset_n_sync,reset_n} ? 1'b1 : 1'b0;


  always@(posedge clock)
  begin
    mask_select_right         = internal_mask_select;          
    mask_select_left          = internal_mask_select;         
    mem_address_right         = internal_mem_address;        
    mem_address_left          = internal_mem_address;         
    mem_write_n               = internal_mem_write_n;         
    mem_dot_write_n           = internal_mem_dot_write_n;     
    row_select_right          = internal_row_select;         
    row_select_left           = internal_row_select;          
    col_select_right          = internal_col_select;         
    col_select_left           = internal_col_select;          
    mem_sel_col_address_right = internal_mem_sel_col_address;
    mem_sel_col_address_left  = internal_mem_sel_col_address; 
    data_out_right            = internal_data_out;            
    data_out_left             = internal_data_out;            
    mem_sel_write_n           = internal_mem_sel_write_n;     
    row_col_select            = internal_row_col_select;      
    output_active_right       = internal_output_active;      
    output_active_left        = internal_output_active;       
    inverter_select           = internal_inverter_select;     
  end

  // Assuming LA probes [65:64] are for controlling the count clk & reset  
  assign clock = (~la_oenb[64]) ? la_data_in[64]: user_clock2;


  always@(posedge clock)
  begin
    // inputs
    io_reset_n_oeb                = (~la_oenb[0]) ? la_data_in[0]   : 1'b1;       
    io_latch_data_oeb             = (~la_oenb[1]) ? la_data_in[1]   : 1'b1;       
    io_control_trigger_oeb        = (~la_oenb[2]) ? la_data_in[2]   : 1'b1;       
    io_update_cycle_complete_oeb  = (~la_oenb[3]) ? la_data_in[3]   : 1'b0;       
    io_sclk_oeb                   = (~la_oenb[4]) ? la_data_in[4]   : 1'b1;       
    io_mosi_oeb                   = (~la_oenb[5]) ? la_data_in[5]   : 1'b1;       
    io_ss_n_oeb                   = (~la_oenb[6]) ? la_data_in[6]   : 1'b1;       
    io_miso_oeb                   = (~la_oenb[7]) ? la_data_in[7]   : 1'b0;       

    reset_n                       = (~la_oenb[32]) ? la_data_in[32] : io_reset_n_in;          
    latch_data                    = (~la_oenb[33]) ? la_data_in[33] : io_latch_data_in;       
    control_trigger               = (~la_oenb[34]) ? la_data_in[34] : io_control_trigger_in;  
    io_update_cycle_complete_out  = (~la_oenb[35]) ? la_data_in[35] : update_cycle_complete;      
    sclk                          = (~la_oenb[36]) ? la_data_in[36] : io_sclk_in;             
    mosi                          = (~la_oenb[37]) ? la_data_in[37] : io_mosi_in;             
    ss_n                          = (~la_oenb[38]) ? la_data_in[38] : io_ss_n_in;             
    io_miso_out                   = (~la_oenb[39]) ? la_data_in[39] : miso;      
  end

  // Driver ouptuts
  genvar I;
  generate
  for(I=0;I<NUM_OF_DRIVERS;I=I+1'b1)
  begin
    always@(posedge clock)
    begin
      io_driver_io_oeb[I]            = (~la_oenb[8+I]) ? la_data_in[8+I] : 1'b0;
    end
    assign clock_out[I] = clock;
  end
  endgenerate






  system_controller 
  #(
    .NUM_OF_DRIVERS             (NUM_OF_DRIVERS)
  )
  u0 (
    .clock                 (clock                        ),
    .reset_n               (reset_n_s                      ),
    .cmd_data              (cmd_data                     ),
    .latch_data            (latch_data_s                   ),
    .control_trigger       (control_trigger_s              ),
    .mem_dot_write_n       (internal_mem_dot_write_n              ),
    .mem_sel_write_n       (internal_mem_sel_write_n              ),
    .mem_write_n           (internal_mem_write_n                  ),
    .write_config_n        (write_config_n               ),
    .mask_select           (internal_mask_select         ),
    .mem_address           (internal_mem_address         ),
    .config_address        (config_address               ),       
    .mem_sel_col_address   (internal_mem_sel_col_address ),   
    .data_out              (internal_data_out            ),
    .timer_enable          (timer_enable                 ),
    .update_cycle_complete (update_cycle_complete        )
  );

  backend_cycle_controller 
  #(
  .MEM_ADDRESS_LENGTH         (MEM_ADDRESS_LENGTH),
  .NUM_OF_DRIVERS             (NUM_OF_DRIVERS)
  )
  u1
  (
    .clock                    (clock                    ),
    .timer_enable             (timer_enable             ),
    .write_config_n           (write_config_n           ),
    .config_address           (config_address           ),
    .config_data              (internal_data_out        ),
    .row_select               (internal_row_select      ),
    .col_select               (internal_col_select      ),
    .output_active            (internal_output_active   ),
    .inverter_select          (internal_inverter_select ),
    .row_col_select           (internal_row_col_select  ),
    .update_cycle_complete    (update_cycle_complete    )
  );

  spi_controller u2(
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
