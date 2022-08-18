
module dot_sequencer
#(
  //parameter MEM_LENGTH = 128,
  //parameter MEM_ADDRESS_LENGTH=7
  parameter MEM_LENGTH = 48,
  parameter MEM_ADDRESS_LENGTH=6
)
(
  input   wire                            clock,
  input   wire                            reset_n,
  input   wire [2:0]                      mask_select,
  input   wire [MEM_ADDRESS_LENGTH-1:0]   mem_address,
  input   wire [15:0]                     mem_data,
  input   wire                            mem_write_n,
  input   wire [15:0]                     mem_dot_data,
  input   wire                            mem_dot_write_n,
  input   wire [MEM_ADDRESS_LENGTH-1:0]   row_select,
  input   wire [MEM_ADDRESS_LENGTH-1:0]   col_select,
  //input   wire [MEM_ADDRESS_LENGTH-1:0]   mem_sel_row_address,
  input   wire [MEM_ADDRESS_LENGTH-1:0]   mem_sel_col_address,
  input   wire [MEM_ADDRESS_LENGTH-1:0]   mem_sel_data,
  input   wire                            mem_sel_write_n,
  input   wire                            row_col_select,
  output  wire                            firing_data,
  output  wire                            firing_bit
);

  wire [MEM_LENGTH-1:0]                   current_row;
  reg  [MEM_LENGTH-1:0]                   mem [0:MEM_LENGTH-1];
  reg  [MEM_ADDRESS_LENGTH-1:0]           mem_sel [0:MEM_LENGTH-1];
  reg  [MEM_LENGTH-1:0]                   mem_dot;
  wire                                    current_bit;
  wire [MEM_ADDRESS_LENGTH-1:0]           current_data_idx;

  genvar I;
  genvar J;
  generate
    for(J=0;J<MEM_LENGTH;J=J+1)
    begin
      always@(posedge clock)
      begin
        case({reset_n,mem_sel_write_n})
          2'b11   : mem_sel[J] <= mem_sel[J];
          2'b10   : mem_sel[J] <= (mem_sel_col_address == J) ? mem_sel_data : mem_sel[J];
          default : mem_sel[J] <= 'b0;
        endcase
      end
    end
    for(J=0;J<$ceil(MEM_LENGTH/16);J=J+1)
    begin
      for(I=0;I<MEM_LENGTH;I=I+1)
      begin
        always@(posedge clock)
        begin
          case({reset_n,mem_write_n})
            2'b11   : mem[I][J*16+15:J*16] <= mem[I][J*16+15:J*16];
            2'b10   : mem[I][J*16+15:J*16] <= (I==mem_address) & (J==mask_select) ? mem_data : mem[I][J*16+15:J*16] ;
            default : mem[I][J*16+15:J*16] <= 'b0;
          endcase
        end
      end
    end
    for(J=0;J<$ceil(MEM_LENGTH/16);J=J+1)
    begin
      always@(posedge clock)
      begin
        case({reset_n,mem_dot_write_n})
          2'b11   : mem_dot[J*16+15:J*16] <= mem_dot[J*16+15:J*16];
          2'b10   : mem_dot[J*16+15:J*16] <= (J==mask_select) ? mem_dot_data : mem_dot[J*16+15:J*16];
          default : mem_dot[J*16+15:J*16] <= 'b0;
        endcase
      end
    end
  endgenerate

  assign current_data_idx = row_col_select ? mem_sel[col_select] : mem_sel[row_select];

  assign current_row = mem[row_select];


  assign current_bit = current_row[col_select];
  assign firing_data = mem_dot[current_data_idx];
  assign firing_bit = current_bit;

endmodule
