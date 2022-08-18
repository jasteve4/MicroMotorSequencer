
module backend_cycle_controller
#(
  parameter MEM_ADDRESS_LENGTH=7
)
(
  input  wire                           clock,
  input  wire                           reset_n,
  input  wire                           timer_enable,
  input  wire                           write_config_n,
  input  wire [5:0]                     config_address,
  input  wire [15:0]                    config_data,
  output wire [MEM_ADDRESS_LENGTH-1:0]  row_select,
  output wire [MEM_ADDRESS_LENGTH-1:0]  col_select,
  output wire                           output_active,
  output reg  [15:0]                    inverter_select,
  output reg  [15:0]                    row_col_select,
  output wire                           update_cycle_complete
);

  reg [31:0]  ordering_timer;
  reg [31:0]  timer;

  reg [31:0]  ccr0;
  reg [31:0]  ccr1;
  reg [31:0]  ordering_complete;
  reg [MEM_ADDRESS_LENGTH:0]  row_limit;
  reg [MEM_ADDRESS_LENGTH:0]  col_limit;
  reg [MEM_ADDRESS_LENGTH:0]  row_sel;
  reg [MEM_ADDRESS_LENGTH:0]  col_sel;

  wire        ccr0_flag;
  wire        ccr1_flag;
  wire        advance;

  always@(posedge clock)
  begin
    case({reset_n,write_config_n})
      2'b10   : ccr0[15:0] <= (config_address == 6'h00) ? config_data : ccr0[15:0];
      2'b11   : ccr0[15:0] <= ccr0[15:0];
      default : ccr0[15:0] <= 'b0;
    endcase
  end

  always@(posedge clock)
  begin
    case({reset_n,write_config_n})
      2'b10   : ccr0[31:16] <= (config_address == 6'h01) ? config_data : ccr0[31:16];
      2'b11   : ccr0[31:16] <= ccr0[31:16];
      default : ccr0[31:16] <= 'b0;
    endcase
  end

  always@(posedge clock)
  begin
    case({reset_n,write_config_n})
      2'b10   : ccr1[15:0] <= (config_address == 6'h02) ? config_data : ccr1[15:0];
      2'b11   : ccr1[15:0] <= ccr1[15:0];
      default : ccr1[15:0] <= 'b0;
    endcase
  end

  always@(posedge clock)
  begin
    case({reset_n,write_config_n})
      2'b10   : ccr1[31:16] <= (config_address == 6'h03) ? config_data : ccr1[31:16];
      2'b11   : ccr1[31:16] <= ccr1[31:16];
      default : ccr1[31:16] <= 'b0;
    endcase
  end

  always@(posedge clock)
  begin
    case({reset_n,write_config_n})
      2'b10   : ordering_complete[15:0] <= (config_address == 6'h04) ? config_data : ordering_complete[15:0];
      2'b11   : ordering_complete[15:0] <= ordering_complete[15:0];
      default : ordering_complete[15:0] <= 'b0;
    endcase
  end

  always@(posedge clock)
  begin
    case({reset_n,write_config_n})
      2'b10   : ordering_complete[31:16] <= (config_address == 6'h05) ? config_data : ordering_complete[31:16];
      2'b11   : ordering_complete[31:16] <= ordering_complete[31:16];
      default : ordering_complete[31:16] <= 'b0;
    endcase
  end

  always@(posedge clock)
  begin
    case({reset_n,write_config_n})
      2'b10   : row_limit <= (config_address == 6'h06) ? config_data : row_limit;
      2'b11   : row_limit <= row_limit;
      default : row_limit <= 'b0;
    endcase
  end

  always@(posedge clock)
  begin
    case({reset_n,write_config_n})
      2'b10   : col_limit <= (config_address == 6'h07) ? config_data : col_limit;
      2'b11   : col_limit <= col_limit;
      default : col_limit <= 'b0;
    endcase
  end

  always@(posedge clock)
  begin
    case({reset_n,write_config_n})
      2'b10   : inverter_select <= (config_address == 6'h08) ? config_data : inverter_select;
      2'b11   : inverter_select <= inverter_select;
      default : inverter_select <= 'b0;
    endcase
  end

  always@(posedge clock)
  begin
    case({reset_n,write_config_n})
      2'b10   : row_col_select <= (config_address == 6'h09) ? config_data : row_col_select;
      2'b11   : row_col_select <= row_col_select;
      default : row_col_select <= 'b0;
    endcase
  end

  always@(posedge clock)
  begin
    case({reset_n,timer_enable})
      2'b11   : ordering_timer <= (ordering_timer < ordering_complete) && ccr1_flag ? ordering_timer +1'b1 : (ordering_timer == ordering_complete)? ordering_complete : ordering_timer;
      default : ordering_timer <= 'b0;
    endcase
  end

  assign update_cycle_complete = ordering_timer == ordering_complete;

  always@(posedge clock)
  begin
    case({reset_n,timer_enable})
      2'b11   : timer <= (timer <= ccr1) ? timer +1'b1 : 32'b0;
      default : timer <= ccr1;
    endcase
  end
  
  assign ccr0_flag = timer == ccr0;
  assign ccr1_flag = timer == ccr1;
  assign output_active = timer <= ccr0 && timer != 32'b0;

  impulse u1 (clock,reset_n,ccr1_flag,advance);

  always@(posedge clock)      
  begin
    case({reset_n,timer_enable,advance})
      3'b111: row_sel <= row_sel < row_limit && col_sel==col_limit ? row_sel+1'b1 : col_sel == col_limit ? 'b0 : row_sel; 
      3'b110: row_sel <= row_sel; 
      default: row_sel <= 'b0;
    endcase
  end
  always@(posedge clock)      
  begin
    case({reset_n,timer_enable,advance})
      3'b111: col_sel <= col_sel < col_limit ? col_sel+1'b1 : 'b0; 
      3'b110: col_sel <= col_sel; 
      default: col_sel <= 'b0;
    endcase
  end

  assign col_select = col_sel[MEM_ADDRESS_LENGTH-1:0];
  assign row_select = row_sel[MEM_ADDRESS_LENGTH-1:0];

endmodule
