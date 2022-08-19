
`define IDLE_STATE              4'b0001 
`define ACTIVE_STATE            4'b0010
`define TRIGGERED_WAIT_STATE    4'b0011
`define TRIGGRED_NO_WAIT_STATE  4'b0100
`define CONTINUOUS_EXE_STATE    4'b0101
`define ONESHOT_EXE_STATE       4'b0110
`define HOLDING_STATE           4'b0111

module system_controller
#(
  parameter NUM_OF_DRIVERS = 16
)
(
  input   wire        clock,
  input   wire        reset_n,
  input   wire [31:0] cmd_data,
  input   wire        latch_data,
  input   wire        control_trigger,

  output reg [NUM_OF_DRIVERS-1:0]   mem_dot_write_n,
  output reg [NUM_OF_DRIVERS-1:0]   mem_sel_write_n,
  output reg [NUM_OF_DRIVERS-1:0]   mem_write_n,
  output reg          write_config_n,
  output reg [2:0]    mask_select,
 
  output wire [15:0]  mem_data,             
  output wire [6:0]   mem_address,          
  output wire [15:0]  mem_dot_data,         
                       
  output wire [15:0]  config_data,          
  output wire [5:0]   config_address,       
                       
  output wire [7:0]   mem_sel_data,         
  output wire [6:0]   mem_sel_col_address,  
  //output wire [6:0]   mem_sel_row_address,

  output reg          timer_enable,
  input wire          update_cycle_complete
);

  wire                latch_cmd;
  wire                mem_config_select;
  reg                 update_cmd;
  wire [3:0]          sequencer_select;
  wire [1:0]          cmd_section;
  wire [2:0]          data_mask;

  reg [31:0]  cmd;
  wire running;
  wire [3:0] control_state;
  reg  [3:0] run_state;


  impulse u11(
    .clock    (clock),
    .reset_n  (reset_n),
    .trigger  (latch_data),
    .advance  (latch_cmd)
  );

  always@(posedge clock)
  begin
    case({reset_n,latch_cmd})
      2'b11   : cmd <= cmd_data;
      2'b10   : cmd <= cmd;
      default : cmd <= 'b0;
    endcase
  end

  always@(posedge clock)
  begin
    /*case(reset_n)
      1'b1    : update_cmd <= latch_cmd;
      default : update_cmd <= 'b0;
    endcase*/
      update_cmd <= latch_cmd;
  end


  assign sequencer_select     = cmd[29:26];
  assign cmd_section          = cmd[31:30];
  assign data_mask            = cmd[25:23]; // 3 bits for mask

  assign mem_data             = cmd[15:0];  // 16 bits for mem data
  assign mem_address          = cmd[22:16]; // 7 bits for address

  assign mem_dot_data         = cmd[15:0];  // 16 bits for dot data

  assign config_data          = cmd[15:0];  // 16 bits for config data
  assign config_address       = cmd[21:16]; // 6 bits for address

  assign mem_sel_data         = cmd[7:0];   // 8 bits for sequence data
  assign mem_sel_col_address  = cmd[14:8];  // 7 bits for col address
  //assign mem_sel_row_address  = cmd[21:15]; // 7 bits for row address
  assign mem_config_select    = cmd[22];

  always@(posedge clock)
  begin
    /*case({reset_n,cmd_section})
      3'b100   : write_config_n <= 1'b1;
      3'b101   : write_config_n <= 1'b1;
      3'b110   : write_config_n <= (update_cmd & ~mem_config_select) ? 1'b0 : 1'b1;
      3'b111   : write_config_n <= 1'b1;
      default  : write_config_n <= 1'b1; 
    endcase*/
    case(cmd_section)
      2'b00   : write_config_n <= 1'b1;
      2'b01   : write_config_n <= 1'b1;
      2'b10   : write_config_n <= (update_cmd & ~mem_config_select) ? 1'b0 : 1'b1;
      2'b11   : write_config_n <= 1'b1;
    endcase
  end

  always@(posedge clock)
  begin
    /*case({reset_n,cmd_section})
      3'b100   : mask_select <= data_mask; 
      3'b101   : mask_select <= data_mask;
      3'b110   : mask_select <= 'b0;
      3'b111   : mask_select <= 'b0;
      default  : mask_select <= 'b0; 
    endcase*/
    case(cmd_section)
      2'b00   : mask_select <= data_mask; 
      2'b01   : mask_select <= data_mask;
      2'b10   : mask_select <= 'b0;
      2'b11   : mask_select <= 'b0;
    endcase
  end

  genvar I;
  generate
    for(I=0;I<NUM_OF_DRIVERS;I=I+1)
    begin
      always@(posedge clock)
      begin
        /*case({reset_n,cmd_section})
          3'b100   : mem_write_n[I] <= (I==sequencer_select) ? update_cmd ? 1'b0 : 1'b1 : 1'b1; 
          3'b101   : mem_write_n[I] <= 1'b1;
          3'b110   : mem_write_n[I] <= 1'b1;
          3'b111   : mem_write_n[I] <= 1'b1;
          default  : mem_write_n[I] <= 1'b1; 
        endcase*/
        case(cmd_section)
          2'b00   : mem_write_n[I] <= (I==sequencer_select) ? update_cmd ? 1'b0 : 1'b1 : 1'b1; 
          2'b01   : mem_write_n[I] <= 1'b1;
          2'b10   : mem_write_n[I] <= 1'b1;
          2'b11   : mem_write_n[I] <= 1'b1;
        endcase
      end
      always@(posedge clock)
      begin
        /*case({reset_n,cmd_section})
          3'b100   : mem_dot_write_n[I] <=  1'b1;
          3'b101   : mem_dot_write_n[I] <= (I==sequencer_select) ? update_cmd ? 1'b0 : 1'b1 : 1'b1;
          3'b110   : mem_dot_write_n[I] <= 1'b1;
          3'b111   : mem_dot_write_n[I] <= 1'b1;
          default  : mem_dot_write_n[I] <= 1'b1; 
        endcase*/
        case(cmd_section)
          2'b00   : mem_dot_write_n[I] <=  1'b1;
          2'b01   : mem_dot_write_n[I] <= (I==sequencer_select) ? update_cmd ? 1'b0 : 1'b1 : 1'b1;
          2'b10   : mem_dot_write_n[I] <= 1'b1;
          2'b11   : mem_dot_write_n[I] <= 1'b1;
        endcase
      end
      always@(posedge clock)
      begin
        /*case({reset_n,cmd_section})
          3'b100   : mem_sel_write_n[I] <= 1'b1;
          3'b101   : mem_sel_write_n[I] <= 1'b1;
          3'b110   : mem_sel_write_n[I] <= (I==sequencer_select) ? (update_cmd & mem_config_select) ? 1'b0 : 1'b1 : 1'b1;
          3'b111   : mem_sel_write_n[I] <= 1'b1;
          default  : mem_sel_write_n[I] <= 1'b1; 
        endcase*/
        case(cmd_section)
          2'b00   : mem_sel_write_n[I] <= 1'b1;
          2'b01   : mem_sel_write_n[I] <= 1'b1;
          2'b10   : mem_sel_write_n[I] <= (I==sequencer_select) ? (update_cmd & mem_config_select) ? 1'b0 : 1'b1 : 1'b1;
          2'b11   : mem_sel_write_n[I] <= 1'b1;
        endcase
      end
    end
  endgenerate




  assign running = reset_n & (&cmd_section);

  assign control_state = cmd[29:26];

  always@(posedge clock)
  begin
    if(running)
    begin
      case(run_state)
        `IDLE_STATE             : run_state <= control_state[3] ? `ACTIVE_STATE :`IDLE_STATE; 
        `ACTIVE_STATE           : run_state <= control_state[2] ? `TRIGGERED_WAIT_STATE : `TRIGGRED_NO_WAIT_STATE;
        `TRIGGERED_WAIT_STATE   : run_state <= control_trigger ? control_state[1] ? `CONTINUOUS_EXE_STATE : `ONESHOT_EXE_STATE : `TRIGGERED_WAIT_STATE;
        `TRIGGRED_NO_WAIT_STATE : run_state <= control_state[1] ? `CONTINUOUS_EXE_STATE : `ONESHOT_EXE_STATE;
        `CONTINUOUS_EXE_STATE   : run_state <= `CONTINUOUS_EXE_STATE;
        `ONESHOT_EXE_STATE      : run_state <= update_cycle_complete ? `HOLDING_STATE : `ONESHOT_EXE_STATE;
        `HOLDING_STATE          : run_state <= `HOLDING_STATE;
        default                 : run_state <= `IDLE_STATE;
      endcase
    end
    else
    begin
      run_state <= `IDLE_STATE;
    end
  end

  always@(posedge clock)
  begin
    case(run_state)
      `CONTINUOUS_EXE_STATE   : timer_enable <= 1'b1;
      `ONESHOT_EXE_STATE      : timer_enable <= 1'b1;
      default                 : timer_enable <= 1'b0;
    endcase
  end



endmodule
