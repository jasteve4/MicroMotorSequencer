
module driver_core
#(

  parameter MEM_LENGTH           =48,
  parameter MEM_ADDRESS_LENGTH   =6
)
(
  input wire                           clock,
  input wire                           clock_a,
  input wire  [2:0]                    mask_select_a,
  input wire  [MEM_ADDRESS_LENGTH-1:0] mem_address_a,
  input wire                           mem_write_n_a,
  input wire                           mem_dot_write_n_a,
  input wire  [MEM_ADDRESS_LENGTH-1:0] row_select_a,
  input wire  [MEM_ADDRESS_LENGTH-1:0] col_select_a,
  input wire  [MEM_ADDRESS_LENGTH-1:0] mem_sel_col_address_a,
  input wire  [15:0]                   data_in_a,
  input wire                           mem_sel_write_n_a,
  input wire                           row_col_select_a, 
  input wire                           output_active_a,
  input wire                           inverter_select_a,
  output wire [1:0]                    driver_io
);

  wire  [2:0]                    mask_select;
  wire  [MEM_ADDRESS_LENGTH-1:0] mem_address;
  wire                           mem_write_n;
  wire                           mem_dot_write_n;
  wire  [MEM_ADDRESS_LENGTH-1:0] row_select;
  wire  [MEM_ADDRESS_LENGTH-1:0] col_select;
  wire  [MEM_ADDRESS_LENGTH-1:0] mem_sel_col_address;
  wire  [15:0]                   data_in;
  wire                           mem_sel_write_n;
  wire                           row_col_select; 
  wire                           output_active;
  wire                           inverter_select;
  reg	[3:0]                    output_active_hold;

  wire firing_data;
  wire firing_bit;
  wire data;
  wire enable;

  always@(posedge clock)
  begin
    output_active_hold = {output_active_hold[2:0],output_active};
  end

   async_reg  mask_select_trans[2:0](
    .clock_async        (clock_a),
    .clock_sync         (clock),
    .data_async         (mask_select_a),
    .data_sync          (mask_select)
  );

  async_reg  mem_address_trans[MEM_ADDRESS_LENGTH-1:0](
    .clock_async        (clock_a),
    .clock_sync         (clock),
    .data_async         (mem_address_a),
    .data_sync          (mem_address)
  );

  async_reg  mem_write_n_trans(
    .clock_async        (clock_a),
    .clock_sync         (clock),
    .data_async         (mem_write_n_a),
    .data_sync          (mem_write_n)
  );

  async_reg  mem_dot_write_n_trans(
    .clock_async        (clock_a),
    .clock_sync         (clock),
    .data_async         (mem_dot_write_n_a),
    .data_sync          (mem_dot_write_n)
  );

  async_reg  row_select_trans[MEM_ADDRESS_LENGTH-1:0](
    .clock_async        (clock_a),
    .clock_sync         (clock),
    .data_async         (row_select_a),
    .data_sync          (row_select)
  );

  async_reg  col_select_trans[MEM_ADDRESS_LENGTH-1:0](
    .clock_async        (clock_a),
    .clock_sync         (clock),
    .data_async         (col_select_a),
    .data_sync          (col_select)
  );

  async_reg  mem_sel_col_address_trans[MEM_ADDRESS_LENGTH-1:0](
    .clock_async        (clock_a),
    .clock_sync         (clock),
    .data_async         (mem_sel_col_address_a),
    .data_sync          (mem_sel_col_address)
  );

  async_reg  data_in_trans[15:0](
    .clock_async        (clock_a),
    .clock_sync         (clock),
    .data_async         (data_in_a),
    .data_sync          (data_in)
  );

  async_reg  mem_sel_write_n_trans(
    .clock_async        (clock_a),
    .clock_sync         (clock),
    .data_async         (mem_sel_write_n_a),
    .data_sync          (mem_sel_write_n)
  );

  async_reg  row_col_select_trans(
    .clock_async        (clock_a),
    .clock_sync         (clock),
    .data_async         (row_col_select_a),
    .data_sync          (row_col_select)
  );
  
  async_reg  output_active_trans(
    .clock_async        (clock_a),
    .clock_sync         (clock),
    .data_async         (output_active_a),
    .data_sync          (output_active)
  );

  async_reg  inverter_select_trans(
    .clock_async        (clock_a),
    .clock_sync         (clock),
    .data_async         (inverter_select_a),
    .data_sync          (inverter_select)
  );



  dot_sequencer 
  #(
    .MEM_LENGTH           (MEM_LENGTH           ),
    .MEM_ADDRESS_LENGTH   (MEM_ADDRESS_LENGTH   )
  )
  u2
  (
    .clock                (clock                                        ),
    .mask_select          (mask_select                                  ),
    .mem_address          (mem_address                                  ),
    .mem_write_n          (mem_write_n                                  ),
    .mem_dot_write_n      (mem_dot_write_n                              ),
    .row_select           (row_select                                   ),
    .col_select           (col_select                                   ),
    .mem_sel_col_address  (mem_sel_col_address                          ),
    .data_in              (data_in                                      ),
    .mem_sel_write_n      (mem_sel_write_n                              ),
    .row_col_select       (row_col_select                               ),
    .firing_data          (firing_data                                  ),
    .firing_bit           (firing_bit                                   )
  );                      

  dot_driver u3(          
    .clock                (clock                ),
    .dot_enable           (firing_bit           ),
    .output_enable        (&output_active_hold  ),
    .dot_state            (firing_data          ),
    .dot_invert           (inverter_select      ),
    .data                 (data                 ),
    .enable               (enable               )
  );                      

  HBrigeDriver u4(
    .p_out                (driver_io[1]),
    .n_out                (driver_io[0]),
    .en_n                 (~enable),
    .in                   (data)
  );




endmodule
