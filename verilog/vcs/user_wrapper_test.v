

`ifndef MPRJ_IO_PADS
`define MPRJ_IO_PADS 38
`endif

module test_firing_sequence_10_drivers();


  localparam NUM_OF_DRIVERS =10;
  localparam NUM_OF_ROWS =5;
  localparam NUM_OF_COLS =5;
  localparam NUM_OF_UPDATE_CYCLES = NUM_OF_ROWS*NUM_OF_COLS;  

  localparam MEM_LENGTH           =48;
  localparam MEM_ADDRESS_LENGTH   =6;
  localparam MEM_BOUND            =3;
  localparam NUM_OF_DOTS_PER_MEM    = 3;
  localparam ACTIVE_MEM_LOWER_BOUND = 0;
  localparam ACTIVE_MEM_UPPER_BOUND = ACTIVE_MEM_LOWER_BOUND + NUM_OF_DOTS_PER_MEM * MEM_LENGTH - 1 ;
  localparam SELECT_MEM_LOWER_BOUND = ACTIVE_MEM_UPPER_BOUND + 1 ;
  localparam SELECT_MEM_UPPER_BOUND = SELECT_MEM_LOWER_BOUND + MEM_LENGTH -1 ;
  localparam DOT_MEM_LOWER_BOUND    = SELECT_MEM_UPPER_BOUND + 1 ; 
  localparam DOT_MEM_UPPER_BOUND    = DOT_MEM_LOWER_BOUND + NUM_OF_DOTS_PER_MEM - 1 ;
  localparam SYS_MEM_BOUND          = DOT_MEM_UPPER_BOUND;
  localparam SYS_MEM_ADDRESS_LENGTH = 2*MEM_ADDRESS_LENGTH;

  // testbench only here
  integer i;
  integer j;
  reg  [31:0]    ccr0;
  reg  [31:0]    ccr1;
  reg  [31:0]    row_limit;
  reg  [31:0]    col_limit;
  wire          output_state [0:NUM_OF_ROWS-1][NUM_OF_COLS-1:0];
  wire [NUM_OF_DRIVERS-1:0]   driver_cell_output;
  reg dot_2d_array [0:NUM_OF_ROWS-1][NUM_OF_COLS-1:0];
  wire VDD1V8;
  wire VDD3V3;
  wire VSS;
  reg test;


  // Chip IO
  reg           clock;
  reg           spi_clock;
  reg           reset_n;
  reg           latch_data;
  reg           control_trigger;
  wire           sclk;
  reg           mosi;
  reg           ss_n;
  wire [NUM_OF_DRIVERS*2-1:0]   driver_io;
  wire          update_cycle_complete;
  wire          miso;

  wire wb_clk_i;
  wire wb_rst_i;
  wire wbs_stb_i;
  wire wbs_cyc_i;
  wire wbs_we_i;
  wire [3:0] wbs_sel_i;
  wire [31:0] wbs_dat_i;
  wire [31:0] wbs_adr_i;
  wire wbs_ack_o;
  wire [31:0] wbs_dat_o;

  // Logic Analyzer Signals
  wire [127:0] la_data_in;
  wire [127:0] la_data_out;
  wire [127:0] la_oenb;

  // IOs
  wire [`MPRJ_IO_PADS-1:0] io_in;
  wire [`MPRJ_IO_PADS-1:0] io_out;
  wire [`MPRJ_IO_PADS-1:0] io_oeb;

  // Analog (direct connection to GPIO pad---use with caution)
  // Note that analog I/O is not available on the 7 lowest-numbered
  // GPIO pads; and so the analog_io indexing is offset from the
  // GPIO indexing by 7 (also upper 2 GPIOs do not have analog_io).
  wire [`MPRJ_IO_PADS-10:0] analog_io;

  // Independent clock (on independent integer divider)
  wire   user_clock2;

  // User maskable integererrupt signals
  wire [2:0] user_irq;

  reg power1, power2;

  always #50 clock    <= (clock === 1'b0);
  always #500 spi_clock <= ~spi_clock;
  assign sclk = ~ss_n & spi_clock;

  assign VDD3V3 = power1;
  assign VDD1V8 = power2;
  assign VSS = 1'b0;


  initial begin
    repeat(10000)
      repeat(1000)
        @(posedge clock);
    $finish();
  end


  `ifdef ENABLE_SDF
  initial begin
    $sdf_annotate("../../sdf/user_project_wrapper.sdf",dut);
    $sdf_annotate("../../sdf/controller_core.sdf",dut.controller_core_mod);
    $sdf_annotate("../../sdf/spi_controller.sdf",dut.spi_controller_mod);
    $sdf_annotate("../../sdf/driver_core.sdf",dut.driver_core_0);
    $sdf_annotate("../../sdf/driver_core.sdf",dut.driver_core_1);
    $sdf_annotate("../../sdf/driver_core.sdf",dut.driver_core_2);
    $sdf_annotate("../../sdf/driver_core.sdf",dut.driver_core_3);
    $sdf_annotate("../../sdf/driver_core.sdf",dut.driver_core_4);
    $sdf_annotate("../../sdf/driver_core.sdf",dut.driver_core_5);
    $sdf_annotate("../../sdf/driver_core.sdf",dut.driver_core_6);
    $sdf_annotate("../../sdf/driver_core.sdf",dut.driver_core_7);
    $sdf_annotate("../../sdf/driver_core.sdf",dut.driver_core_8);
    $sdf_annotate("../../sdf/driver_core.sdf",dut.driver_core_9);
  end
    `define SDF_DELAY #4
  `else
    `define SDF_DELAY #0
  `endif

user_project_wrapper dut (
  `ifdef USE_POWER_PINS
    .vccd1 (VDD1V8),
    .vccd2 (VDD1V8),
    .vdda1  (VDD3V3),
    .vdda2  (VDD3V3),
    .vssa1  (VSS),
    .vssa2  (VSS),
    .vssd1  (VSS),
    .vssd2  (VSS),
  `endif
    // Wishbone Slave ports (WB MI A)
    .wb_clk_i          (wb_clk_i     ),                                                                     
    .wb_rst_i          (wb_rst_i     ),                                                                     
    .wbs_stb_i         (wbs_stb_i    ),                                                                      
    .wbs_cyc_i         (wbs_cyc_i    ),                                                                      
    .wbs_we_i          (wbs_we_i     ),                                                                     
    .wbs_sel_i         (wbs_sel_i    ),                                                                      
    .wbs_dat_i         (wbs_dat_i    ),                                                                      
    .wbs_adr_i         (wbs_adr_i    ),                                                                      
    .wbs_ack_o         (wbs_ack_o    ),                                                                      
    .wbs_dat_o         (wbs_dat_o    ),                                                                      
    .la_data_in        (la_data_in   ),                                                                       
    .la_data_out       (la_data_out  ),                                                                        
    .la_oenb           (la_oenb      ),                                                                    
    .io_in             (io_in        ),                                                                  
    .io_out            (io_out       ),                                                                   
    .io_oeb            (io_oeb       ),                                                                   
    .analog_io         (analog_io    ),                                                                      
    .user_clock2       (clock        ),                                                                        
    .user_irq          (user_irq     )
);

  assign `SDF_DELAY la_oenb                    = ~{128'b0};
  assign `SDF_DELAY io_in[37]                  = reset_n;
  assign `SDF_DELAY io_in[36]                  = control_trigger;
  assign `SDF_DELAY io_in[35]                  = latch_data;
  assign miso                       = io_out[34];
  assign `SDF_DELAY io_in[33]                  = mosi;
  assign `SDF_DELAY io_in[32]                  = ss_n ;
  assign `SDF_DELAY io_in[31]                  = sclk;
  assign update_cycle_complete      = io_out[30] ;
  assign driver_io[0]               = io_out[29];
  assign driver_io[1]               = io_out[28];
  assign driver_io[2]               = io_out[27];
  assign driver_io[3]               = io_out[26];
  assign driver_io[4]               = io_out[25];
  assign driver_io[5]               = io_out[24];
  assign driver_io[6]               = io_out[23];
  assign driver_io[7]               = io_out[22];
  assign driver_io[8]               = io_out[21];
  assign driver_io[9]               = io_out[20];
//  assign io_out[19]                 = 0;
//  assign io_out[18]                 = 0;
  assign driver_io[10]               = io_out[17];
  assign driver_io[11]               = io_out[16];
  assign driver_io[12]               = io_out[15];
  assign driver_io[13]               = io_out[14];
  assign driver_io[14]               = io_out[13];
  assign driver_io[15]               = io_out[12];
  assign driver_io[16]               = io_out[11];
  assign driver_io[17]               = io_out[10];
  assign driver_io[18]               = io_out[9] ;
  assign driver_io[19]               = io_out[8] ;
//  assign io_out[7]                 = 0;
//  assign io_out[6]                 = 0;
//  assign io_out[5]                 = 0;
//  assign io_out[4]                 = 0;
//  assign io_out[3]                 = 0;
//  assign io_out[2]                 = 0;
//  assign io_out[1]                 = 0;
//  assign io_out[0]                 = 0;


  genvar I,J;
  generate
    for(I=0;I<NUM_OF_DRIVERS;I=I+1)
    begin : block1
      HBCell u5(
        .p_in                 (driver_io[I*2+1]),
        .n_in                 (driver_io[I*2]),
        .line                 (driver_cell_output[I])
      );
    end                       
    for(I=0;I<NUM_OF_ROWS;I=I+1)
    begin: block2
      for(J=0;J<NUM_OF_COLS;J=J+1)
      begin: block3
        cell_converter u7(
          .in                 ({driver_cell_output[I],driver_cell_output[J+NUM_OF_ROWS]}),
          .state              (output_state[I][J])
        );
      end
    end
  endgenerate                 

  task wait_n_clocks;
    input [31:0] n;
    integer ii;
    begin
      for(ii=0;ii<n;ii=ii+1)
      begin
        @(posedge clock);
      end
    end
  endtask


  task initialize_io;
    begin
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
    end
  endtask

  task reset_chip;
    begin
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

  task write_mem_data_cmd;
    input [3:0]  driver_select;
    input [9:0]  address;
    input [15:0] data;
    reg [31:0] cmd; 
    begin
      cmd[15:0] = data;
      cmd[25:16] = address;
      cmd[29:26] = driver_select;
      cmd[31:30] = 2'b00;
      wait_n_clocks(10);
      wait_n_clocks(10);
      spi_write(cmd);
      wait_n_clocks(10);
    end
  endtask


  task clear_mem;
    input [3:0] device_select;
    integer ii;
    begin
      for(ii=0;ii<SYS_MEM_BOUND+1;ii=ii+1) begin
        write_mem_data_cmd(device_select,ii,16'b0);
      end
    end
  endtask


  task write_to_select_mem;
    input [3:0]  driver_select;
    input [31:0] idx;
    input [31:0] data;
    begin
      write_mem_data_cmd(driver_select,idx+SELECT_MEM_LOWER_BOUND,data); 
    end
  endtask

  task write_to_active_mem;
    input [3:0]  driver_select;
    input [31:0] idx;
    input [31:0] data;
    begin
      write_mem_data_cmd(driver_select,idx+ACTIVE_MEM_LOWER_BOUND,data); 
    end
  endtask

  task write_to_dot_data_mem;
    input [3:0]  driver_select;
    input [31:0] idx;
    input [31:0] data;
    begin
      write_mem_data_cmd(driver_select,idx+DOT_MEM_LOWER_BOUND,data); 
    end
  endtask

  task oneshot_exe;
    begin
      @(posedge clock);
      spi_write({2'b11,4'b1101,26'b0});
      wait_n_clocks(100);
      control_trigger = 1'b1;
      wait_n_clocks(100);
      control_trigger = 1'b0;
      @(posedge update_cycle_complete);
      wait_n_clocks(10);
    end
  endtask

  task refresh_display;
  begin
      control_trigger = 1'b1;
      wait_n_clocks(100);
      control_trigger = 1'b0;
      @(posedge update_cycle_complete);
  end
  endtask

  task update_select;
    input [31:0] driver_select;
    integer ii;
    begin
      for(ii=0;ii<48;ii=ii+1)
      begin
        write_to_select_mem(driver_select,ii,ii);
      end
    end
  endtask

  task update_active_mem_row;
    input [3:0]   driver_select;
    input [6:0]   address;
    input [47:0] data;
    integer ii;
    reg [15:0] d;
    begin
      for(ii=0;ii<3;ii=ii+1)
      begin
        @(posedge clock);
        d = data>>(16*ii);
        @(posedge clock);
        write_to_active_mem(driver_select,address*3,d);
        @(posedge clock);
      end
    end
  endtask


  task update_active_mem_col;
    input [3:0]   driver_select;
    input [9:0]   address;
    input [47:0] data;
    integer ii;
    reg d; 
    reg [15:0] insert_data;
    reg [2:0] mask_offset ;
    reg [9:0] address_offset;
    reg [9:0] row_address;
    begin
      for(ii=0;ii<48;ii=ii+1)
      begin
        insert_data = data[ii];
        @(posedge clock);
        if(address < 16) begin
          address_offset = 0;
          insert_data = insert_data << address;
        end else if(address < 32) begin
          address_offset = 1;
          insert_data = insert_data << (address - 16);
        end else begin
          address_offset = 2;
          insert_data = insert_data << (address - 32);
        end
        row_address = address_offset+3*ii;
        @(posedge clock);
        write_to_active_mem(driver_select,row_address,insert_data);
        @(posedge clock);
      end
    end
  endtask

  task update_dot_data;
    input [3:0]   driver_select;
    input [47:0] data;
    integer ii;
    reg [15:0] d;
    begin
      for(ii=0;ii<3;ii=ii+1)
      begin
        @(posedge clock);
        d = data>>(16*ii);
        @(posedge clock);
        write_to_dot_data_mem(driver_select,ii,d);
        @(posedge clock);
      end
    end
  endtask

  task write_config_cmd;
    input [9:0]  address;
    input [15:0] data;
    reg [31:0] cmd; 
    begin
      cmd[15:0] = data;
      cmd[25:16] = address;
      cmd[29:26] = 4'b0;
      cmd[31:30] = 2'b10;
      wait_n_clocks(10);
      wait_n_clocks(10);
      spi_write(cmd);
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
    input [31:0] _row_col_select;
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
      write_config_cmd(9,_row_col_select);
    end
  endtask


  task set_config_5x5;
    integer ii, jj;
    reg [31:0] device;
    begin
      config_backend(ccr0,ccr1,NUM_OF_UPDATE_CYCLES,NUM_OF_ROWS-1,NUM_OF_COLS-1,16'b0000_0011_1110_0000,16'b0000_0000_0001_1111);
      for(ii=0;ii<NUM_OF_ROWS;ii=ii+1)
      begin
        device = ii;
        update_active_mem_row(device,device,~(48'b0));
        update_select(device);
      end
      for(ii=0;ii<NUM_OF_COLS;ii=ii+1)
      begin
        device = ii;
        update_active_mem_col(device+NUM_OF_ROWS,device,~(48'b0));
        update_select(device+NUM_OF_ROWS);
      end
    end
  endtask

  task write_5x5_data;
    reg data [0:NUM_OF_ROWS-1][NUM_OF_COLS-1:0];
    integer ii,jj;
    reg [47:0] row;
    reg [47:0] col;
    begin
      data=dot_2d_array;
      row=0;
      col=0;
      for(jj=0;jj<NUM_OF_ROWS;jj=jj+1)
      begin
        for(ii=0;ii<NUM_OF_COLS;ii=ii+1)
        begin
          row[ii] = data[jj][ii];
          @(posedge clock);
        end
        update_dot_data(jj,row);
      end
      for(jj=0;jj<NUM_OF_COLS;jj=jj+1)
      begin
        for(ii=0;ii<NUM_OF_ROWS;ii=ii+1)
        begin
          col[ii] = data[ii][jj];
          @(posedge clock);
        end
        update_dot_data(jj+NUM_OF_ROWS,col);
      end
    end
  endtask


  task test_output_5x5;
    reg [NUM_OF_ROWS*NUM_OF_COLS-1:0] dot_array;
    integer ii,jj;
    begin
      dot_array = $random();
      dot_array = dot_array ^ $random();
      set_config_5x5();
      for(ii=0;ii<NUM_OF_ROWS;ii=ii+1)
      begin
        for(jj=0;jj<NUM_OF_COLS;jj=jj+1)
        begin
          dot_2d_array[ii][jj] = dot_array[ii*NUM_OF_COLS+jj];
          @(posedge clock);
        end
      end
      write_5x5_data();
      oneshot_exe();
    end
  endtask


  task test_bit;
  input [31:0] pos;
  integer ii;
  reg [31:0] temp;
  begin
    temp = 32'b0000_0001 << pos;
    for(ii=0;ii<4;ii=ii+1)
    begin
    spi_write(32'h0000_0000);
    spi_write(temp);
    spi_write(32'h0000_0000);
    temp = temp << 1;
    end
  end
  endtask

  reg[31:0] temp;
  initial
  begin
    test=0;
    initialize_io();
    wait_n_clocks(1);
    test=~test;
    @(posedge power2)
    test=~test;
    wait_n_clocks(10);
    reset_chip();
    //wait_n_clocks(200);
    //clear_mem(0);
    wait_n_clocks(200);
    test_output_5x5();
    wait_n_clocks(500);
    $finish();
    
  end

  initial begin		// Power-up sequence
    power1 <= 1'b0;
    power2 <= 1'b0;
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    power1 <= 1'b1;
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    power2 <= 1'b1;
  end

endmodule

module HBCell(
input wire p_in,
input wire n_in,
output wire line
);

wire common;
wire temp1;
wire temp2;

nmos n1Mos (common,1'b0,n_in);
pmos p1Mos (common,1'b1,p_in);

assign line = common;

endmodule

module cell_converter(
input wire [1:0] in,
output reg state
);

always@(*)
begin
state = state;
if((in[0] == 1) & (in[1] == 0))
begin
state = 1'b0;
end
if((in[1] == 1) & (in[0] == 0))
begin
state = 1'b1;
end
end

initial
begin
state = 1'bz;
end

endmodule
