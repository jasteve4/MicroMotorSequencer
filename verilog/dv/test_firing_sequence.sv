
module test_firing_sequence();


  // testbench only here
  int i;
  int j;
  reg  [31:0]    ccr0;
  reg  [31:0]    ccr1;
  reg  [31:0]    ordering_complete;
  reg  [31:0]    row_limit;
  reg  [31:0]    col_limit;
  wire          output_state [0:9][5:0];
  wire [15:0]   driver_cell_output;

  // Chip IO
  reg           clock;
  reg           spi_clock;
  reg           reset_n;
  reg           latch_data;
  reg           control_trigger;
  reg           sclk;
  reg           mosi;
  reg           ss_n;
  wire [31:0]   driver_io;
  wire          update_cycle_complete;
  wire          miso;


  always #12.5 clock    <= (clock === 1'b0);
  always #100 spi_clock <= ~spi_clock;
  assign sclk = ~ss_n & spi_clock;

  
  sequencer_chip top(
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

  genvar I,J;
  generate
    for(I=0;I<16;I++)
    begin
      HBCell u5(
        .p_in                 (driver_io[I*2+1]),
        .n_in                 (driver_io[I*2]),
        .line                 (driver_cell_output[I])
      );
    end                       
    for(I=0;I<10;I++)
    begin
      for(J=0;J<6;J++)
      begin
        cell_converter u7(
          .in                 ({driver_cell_output[I],driver_cell_output[J+10]}),
          .state              (output_state[I][J])
        );
      end
    end
  endgenerate                 

  task wait_n_clocks;
    input [31:0] n;
    begin
      int ii;
      for(ii=0;ii<n;ii++)
      begin
        @(posedge clock);
      end
    end
  endtask


  task initialize_io;
    begin
      ordering_complete=60;
      ccr0 = 32;
      ccr1 = 128;
      row_limit = 9;
      col_limit = 5;
      // Start of IO
      clock =     1;
      spi_clock = 1;
      reset_n = 1;
      latch_data=0;
      control_trigger=0;
      // spi IO
      mosi=0;
      ss_n=1;
      wait_n_clocks(100);
    end
  endtask

  task reset_chip;
    begin
      wait_n_clocks(50);
      reset_n = 0;
      wait_n_clocks(50);
      reset_n = 1;
      wait_n_clocks(50);
    end
  endtask

  task spi_shift;
    input [31:0] data_in;
    output [31:0] data_out;
    integer ii;
    begin
      for(ii=0;ii<32;ii=ii+1)
      begin
      @(negedge spi_clock);
      ss_n = 1'b0;
      mosi = data_in[31];
      data_in = data_in << 1;
      @(posedge spi_clock)
      data_out = {data_out[31:0],miso};
      end
      @(negedge spi_clock);
      ss_n = 1'b1;
      @(posedge clock);
      @(posedge clock);
    end
  endtask


  task spi_write;
    input [31:0] spi_data;
    reg   [31:0] pass;
    begin
      wait_n_clocks(50); 
      latch_data=0;
      wait_n_clocks(50); 
      spi_shift(spi_data,pass);
      wait_n_clocks(50); 
      latch_data=1;
      wait_n_clocks(100); 
      latch_data=0;
      wait_n_clocks(50); 
    end
  endtask


  task set_to_oneshot_exe;
    begin
      spi_write({2'b11,4'b1000,26'b0});
    end
  endtask


  task oneshot_exe;
    begin
      @(posedge clock);
      set_to_oneshot_exe();
      wait_n_clocks(10);
      @(posedge update_cycle_complete);
      wait_n_clocks(10);
    end
  endtask

  task write_sel_cmd;
    input [3:0]  driver_select;
    input [31:0] row_address;
    input [31:0] col_address;
    input [31:0] data;
    begin
      reg [31:0] cmd; 
      cmd[7:0] = data;
      cmd[14:8] = col_address;
      cmd[21:15] = row_address;
      cmd[22] = 1'b1;
      cmd[25:23] = 3'b0;
      cmd[29:26] = driver_select;
      cmd[31:30] = 2'b10;
      wait_n_clocks(10);
      spi_write(cmd);
      wait_n_clocks(10);
    end
  endtask

  task update_row_sel;
    input [31:0] driver_select;
    input [31:0] row_address;
    int ii;
    begin
      for(ii=0;ii<128;ii++)
      begin
        write_sel_cmd(driver_select,row_address,ii,ii);
      end
    end
  endtask

  task update_row_sel_limit;
    input [31:0] driver_select;
    input [31:0] row_address;
    input [31:0] limit;
    int ii;
    begin
      for(ii=0;ii<limit;ii++)
      begin
        write_sel_cmd(driver_select,row_address,ii,ii);
      end
    end
  endtask

  task update_col_sel;
    input [31:0] driver_select;
    input [31:0] col_address;
    int ii;
    begin
      for(ii=0;ii<128;ii++)
      begin
        write_sel_cmd(driver_select,ii,col_address,ii);
      end
    end
  endtask

  task update_col_sel_limit;
    input [31:0] driver_select;
    input [31:0] col_address;
    input [31:0] limit;
    int ii;
    begin
      for(ii=0;ii<limit;ii++)
      begin
        write_sel_cmd(driver_select,ii,col_address,ii);
      end
    end
  endtask

  task write_mem_data_cmd;
    input [3:0]  driver_select;
    input [6:0]  address;
    input [2:0]  update_mask;
    input [15:0] data;
    begin
      reg [31:0] cmd; 
      cmd[15:0] = data;
      cmd[22:16] = address;
      cmd[25:23] = update_mask;
      cmd[29:26] = driver_select;
      cmd[31:30] = 2'b00;
      wait_n_clocks(10);
      //latch_data=1;
      wait_n_clocks(10);
      //latch_data=0;
      spi_write(cmd);
      wait_n_clocks(10);
    end
  endtask

  task update_mem_row;
    input [3:0]   driver_select;
    input [6:0]   address;
    input [127:0] data;
    int ii;
    reg [15:0] d;
    begin
      for(ii=0;ii<8;ii=ii+1)
      begin
        @(posedge clock);
        d = data>>(16*ii);
        @(posedge clock);
        write_mem_data_cmd(driver_select,address,ii,d);
        @(posedge clock);
      end
    end
  endtask

  task update_mem_row_limit;
    input [3:0]   driver_select;
    input [6:0]   address;
    input [127:0] data;
    input [31:0]  limit;
    int ii;
    reg [15:0] d;
    begin
      for(ii=0;ii<($floor(limit/16)+1);ii=ii+1)
      begin
        @(posedge clock);
        d = data>>(16*ii);
        @(posedge clock);
        write_mem_data_cmd(driver_select,address,ii,d);
        @(posedge clock);
      end
    end
  endtask

  task update_mem_col;
    input [3:0]   driver_select;
    input [6:0]   address;
    input [127:0] data;
    int ii;
    reg d; 
    reg [15:0] insert_data;
    reg [2:0] mask_offset ;
    begin
      mask_offset= address[6:4];
      for(ii=0;ii<128;ii=ii+1)
      begin
        @(posedge clock);
        d = data>>(ii);
        insert_data = 16'b0;
        insert_data = d << address[3:0];
        @(posedge clock);
        write_mem_data_cmd(driver_select,ii,mask_offset,insert_data);
        @(posedge clock);
      end
    end
  endtask

  task update_mem_col_limit;
    input [3:0]   driver_select;
    input [6:0]   address;
    input [127:0] data;
    input [31:0] limit;
    int ii;
    reg d; 
    reg [15:0] insert_data;
    reg [2:0] mask_offset ;
    begin
      mask_offset= address[6:4];
      for(ii=0;ii<limit;ii=ii+1)
      begin
        @(posedge clock);
        d = data>>(ii);
        insert_data = 16'b0;
        insert_data = d << address[3:0];
        @(posedge clock);
        write_mem_data_cmd(driver_select,ii,mask_offset,insert_data);
        @(posedge clock);
      end
    end
  endtask

  task write_dot_data_cmd;
    input [3:0]  driver_select;
    input [2:0] update_mask;
    input [15:0] data;
    begin
      reg [31:0] cmd; 
      cmd[15:0] = data;
      cmd[22:16] = 0;
      cmd[25:23] = update_mask;
      cmd[29:26] = driver_select;
      cmd[31:30] = 2'b01;
      wait_n_clocks(10);
      //latch_data=1;
      wait_n_clocks(10);
      //latch_data=0;
      spi_write(cmd);
      wait_n_clocks(10);
    end
  endtask


  task update_dot_data;
    input [3:0]   driver_select;
    input [127:0] data;
    int ii;
    reg [15:0] d;
    begin
      for(ii=0;ii<8;ii=ii+1)
      begin
        @(posedge clock);
        d = data>>(16*ii);
        @(posedge clock);
        write_dot_data_cmd(driver_select,ii,d);
        @(posedge clock);
      end
    end
  endtask

  task update_dot_data_limit;
    input [3:0]   driver_select;
    input [127:0] data;
    input [31:0]  _col_limit;
    int ii;
    reg [15:0] d;
    begin
      for(ii=0;ii<($floor(_col_limit/16)+1);ii=ii+1)
      begin
        @(posedge clock);
        d = data>>(16*ii);
        @(posedge clock);
        write_dot_data_cmd(driver_select,ii,d);
        @(posedge clock);
      end
    end
  endtask

  task write_config_cmd;
    input [5:0]  address;
    input [15:0] data;
    begin
      reg [31:0] cmd; 
      cmd[15:0] = data;
      cmd[21:16] = address;
      cmd[22] = 1'b0;
      cmd[25:23] = 3'b0;
      cmd[29:26] = 4'b0;
      cmd[31:30] = 2'b10;
      wait_n_clocks(10);
      //latch_data=1;
      wait_n_clocks(10);
      spi_write(cmd);
      //latch_data=0;
      wait_n_clocks(10);
    end
  endtask

  task config_backend;
    input [31:0] _ccr0;
    input [31:0] _ccr1;
    input [31:0] _ordering_complete;
    input [31:0] _row_limit;
    input [31:0] _col_limit;
    input [31:0] _inverter_select;
    begin
      @(posedge clock);

      write_config_cmd(0,_ccr0[15:0]);
      write_config_cmd(1,_ccr0[31:16]);
      write_config_cmd(2,_ccr1[15:0]);
      write_config_cmd(3,_ccr1[31:16]);
      write_config_cmd(4,_ordering_complete[15:0]);
      write_config_cmd(5,_ordering_complete[31:16]);
      write_config_cmd(6,_row_limit);
      write_config_cmd(7,_col_limit);
      write_config_cmd(8,_inverter_select);
    end
  endtask


  task set_config_10x6;
    int ii, jj;
    begin
      reg [31:0] num_cols;
      reg [31:0] num_rows;
      reg [31:0] device;
      num_cols = 6;
      num_rows = 10;
      config_backend(ccr0,ccr1,ordering_complete,num_rows-1,num_cols-1,16'b1111_1100_0000_0000);
      for(ii=0;ii<num_rows;ii++)
      begin
        device = ii;
        update_dot_data_limit(device,ii+1,num_cols);
        update_mem_row_limit(device,device,~(31'b0),num_cols);
        update_row_sel_limit(device,device,num_cols);
      end
      for(ii=0;ii<num_cols;ii++)
      begin
        device = ii;
        update_dot_data_limit(device+num_rows,ii+num_rows+1,num_rows);
        update_mem_col_limit(device+num_rows,device,~(31'b0),num_rows);
        update_col_sel_limit(device+num_rows,device,num_rows);
      end
    end
  endtask

  task write_10x6_data;
    input data [0:9][5:0];
    begin
      int ii,jj;
      reg [31:0] num_cols;
      reg [31:0] num_rows;
      reg [15:0] row;
      reg [15:0] col;
      num_cols = 6;
      num_rows = 10;
      row=0;
      col=0;
      for(jj=0;jj<num_rows;jj++)
      begin
        for(ii=0;ii<num_cols;ii++)
        begin
          row[ii] = data[jj][ii];
          @(posedge clock);
        end
        update_dot_data_limit(jj,row,num_cols);
      end
      for(jj=0;jj<num_cols;jj++)
      begin
        for(ii=0;ii<num_rows;ii++)
        begin
          col[ii] = data[ii][jj];
          @(posedge clock);
        end
        update_dot_data_limit(jj+num_rows,col,num_rows);
      end
    end
  endtask


  task test_output_10x6;
    begin
      reg [59:0] dot_array;
      reg dot_2d_array [0:9][5:0];
      reg [31:0] num_cols;
      reg [31:0] num_rows;
      int ii,jj;
      num_cols = 6;
      num_rows = 10;
      dot_array = $random();
      dot_array = dot_array ^ $random();
      set_config_10x6();
      for(ii=0;ii<num_rows;ii++)
      begin
        for(jj=0;jj<num_cols;jj++)
        begin
          dot_2d_array[ii][jj] = dot_array[ii*num_cols+jj];
          @(posedge clock);
        end
      end
      write_10x6_data(dot_2d_array);
      oneshot_exe();
    end
  endtask


  initial
  begin
    initialize_io();
    wait_n_clocks(20);
    reset_chip();
    wait_n_clocks(200);
    config_backend(ccr0,ccr1,ordering_complete,row_limit,col_limit,16'b1111_1100_0000_0000);
    test_output_10x6();
    wait_n_clocks(1000);
    $finish();
    
  end

endmodule
