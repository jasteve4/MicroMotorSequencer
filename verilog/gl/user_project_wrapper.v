module user_project_wrapper (user_clock2,
    vccd1,
    vccd2,
    vdda1,
    vdda2,
    vssa1,
    vssa2,
    vssd1,
    vssd2,
    wb_clk_i,
    wb_rst_i,
    wbs_ack_o,
    wbs_cyc_i,
    wbs_stb_i,
    wbs_we_i,
    analog_io,
    io_in,
    io_oeb,
    io_out,
    la_data_in,
    la_data_out,
    la_oenb,
    user_irq,
    wbs_adr_i,
    wbs_dat_i,
    wbs_dat_o,
    wbs_sel_i);
 input user_clock2;
 input vccd1;
 input vccd2;
 input vdda1;
 input vdda2;
 input vssa1;
 input vssa2;
 input vssd1;
 input vssd2;
 input wb_clk_i;
 input wb_rst_i;
 output wbs_ack_o;
 input wbs_cyc_i;
 input wbs_stb_i;
 input wbs_we_i;
 inout [28:0] analog_io;
 input [37:0] io_in;
 output [37:0] io_oeb;
 output [37:0] io_out;
 input [127:0] la_data_in;
 output [127:0] la_data_out;
 input [127:0] la_oenb;
 output [2:0] user_irq;
 input [31:0] wbs_adr_i;
 input [31:0] wbs_dat_i;
 output [31:0] wbs_dat_o;
 input [3:0] wbs_sel_i;

 wire io_update_cycle_complete_oeb;
 wire io_sclk_oeb;
 wire io_ss_n_oeb;
 wire io_mosi_oeb;
 wire io_miso_oeb;
 wire io_latch_data_oeb;
 wire io_control_trigger_oeb;
 wire io_reset_n_oeb;
 wire io_update_cycle_complete_out;
 wire io_miso_out;
 wire \clock_out[0] ;
 wire \clock_out[1] ;
 wire \clock_out[2] ;
 wire \clock_out[3] ;
 wire \clock_out[4] ;
 wire \clock_out[5] ;
 wire \clock_out[6] ;
 wire \clock_out[7] ;
 wire \clock_out[8] ;
 wire \clock_out[9] ;
 wire \col_select_left[0] ;
 wire \col_select_left[1] ;
 wire \col_select_left[2] ;
 wire \col_select_left[3] ;
 wire \col_select_left[4] ;
 wire \col_select_left[5] ;
 wire \col_select_right[0] ;
 wire \col_select_right[1] ;
 wire \col_select_right[2] ;
 wire \col_select_right[3] ;
 wire \col_select_right[4] ;
 wire \col_select_right[5] ;
 wire \data_out_left[0] ;
 wire \data_out_left[10] ;
 wire \data_out_left[11] ;
 wire \data_out_left[12] ;
 wire \data_out_left[13] ;
 wire \data_out_left[14] ;
 wire \data_out_left[15] ;
 wire \data_out_left[1] ;
 wire \data_out_left[2] ;
 wire \data_out_left[3] ;
 wire \data_out_left[4] ;
 wire \data_out_left[5] ;
 wire \data_out_left[6] ;
 wire \data_out_left[7] ;
 wire \data_out_left[8] ;
 wire \data_out_left[9] ;
 wire \data_out_right[0] ;
 wire \data_out_right[10] ;
 wire \data_out_right[11] ;
 wire \data_out_right[12] ;
 wire \data_out_right[13] ;
 wire \data_out_right[14] ;
 wire \data_out_right[15] ;
 wire \data_out_right[1] ;
 wire \data_out_right[2] ;
 wire \data_out_right[3] ;
 wire \data_out_right[4] ;
 wire \data_out_right[5] ;
 wire \data_out_right[6] ;
 wire \data_out_right[7] ;
 wire \data_out_right[8] ;
 wire \data_out_right[9] ;
 wire \inverter_select[0] ;
 wire \inverter_select[1] ;
 wire \inverter_select[2] ;
 wire \inverter_select[3] ;
 wire \inverter_select[4] ;
 wire \inverter_select[5] ;
 wire \inverter_select[6] ;
 wire \inverter_select[7] ;
 wire \inverter_select[8] ;
 wire \inverter_select[9] ;
 wire \mem_address_left[0] ;
 wire \mem_address_left[1] ;
 wire \mem_address_left[2] ;
 wire \mem_address_left[3] ;
 wire \mem_address_left[4] ;
 wire \mem_address_left[5] ;
 wire \mem_address_left[6] ;
 wire \mem_address_left[7] ;
 wire \mem_address_left[8] ;
 wire \mem_address_left[9] ;
 wire \mem_address_right[0] ;
 wire \mem_address_right[1] ;
 wire \mem_address_right[2] ;
 wire \mem_address_right[3] ;
 wire \mem_address_right[4] ;
 wire \mem_address_right[5] ;
 wire \mem_address_right[6] ;
 wire \mem_address_right[7] ;
 wire \mem_address_right[8] ;
 wire \mem_address_right[9] ;
 wire \mem_write_n[0] ;
 wire \mem_write_n[1] ;
 wire \mem_write_n[2] ;
 wire \mem_write_n[3] ;
 wire \mem_write_n[4] ;
 wire \mem_write_n[5] ;
 wire \mem_write_n[6] ;
 wire \mem_write_n[7] ;
 wire \mem_write_n[8] ;
 wire \mem_write_n[9] ;
 wire output_active_left;
 wire output_active_right;
 wire \row_col_select[0] ;
 wire \row_col_select[1] ;
 wire \row_col_select[2] ;
 wire \row_col_select[3] ;
 wire \row_col_select[4] ;
 wire \row_col_select[5] ;
 wire \row_col_select[6] ;
 wire \row_col_select[7] ;
 wire \row_col_select[8] ;
 wire \row_col_select[9] ;
 wire \row_select_left[0] ;
 wire \row_select_left[1] ;
 wire \row_select_left[2] ;
 wire \row_select_left[3] ;
 wire \row_select_left[4] ;
 wire \row_select_left[5] ;
 wire \row_select_right[0] ;
 wire \row_select_right[1] ;
 wire \row_select_right[2] ;
 wire \row_select_right[3] ;
 wire \row_select_right[4] ;
 wire \row_select_right[5] ;
 wire \spi_data[0] ;
 wire \spi_data[10] ;
 wire \spi_data[11] ;
 wire \spi_data[12] ;
 wire \spi_data[13] ;
 wire \spi_data[14] ;
 wire \spi_data[15] ;
 wire \spi_data[16] ;
 wire \spi_data[17] ;
 wire \spi_data[18] ;
 wire \spi_data[19] ;
 wire \spi_data[1] ;
 wire \spi_data[20] ;
 wire \spi_data[21] ;
 wire \spi_data[22] ;
 wire \spi_data[23] ;
 wire \spi_data[24] ;
 wire \spi_data[25] ;
 wire \spi_data[26] ;
 wire \spi_data[27] ;
 wire \spi_data[28] ;
 wire \spi_data[29] ;
 wire \spi_data[2] ;
 wire \spi_data[30] ;
 wire \spi_data[31] ;
 wire \spi_data[3] ;
 wire \spi_data[4] ;
 wire \spi_data[5] ;
 wire \spi_data[6] ;
 wire \spi_data[7] ;
 wire \spi_data[8] ;
 wire \spi_data[9] ;
 wire spi_data_clock;

 controller_core controller_core_mod (.clock(user_clock2),
    .io_control_trigger_in(io_in[36]),
    .io_control_trigger_oeb(io_control_trigger_oeb),
    .io_latch_data_in(io_in[35]),
    .io_latch_data_oeb(io_latch_data_oeb),
    .io_reset_n_in(io_in[37]),
    .io_reset_n_oeb(io_reset_n_oeb),
    .io_update_cycle_complete_oeb(io_update_cycle_complete_oeb),
    .io_update_cycle_complete_out(io_update_cycle_complete_out),
    .output_active_left(output_active_left),
    .output_active_right(output_active_right),
    .spi_data_clock(spi_data_clock),
    .vccd1(vccd1),
    .vssd1(vssd1),
    .clock_out({\clock_out[9] ,
    \clock_out[8] ,
    \clock_out[7] ,
    \clock_out[6] ,
    \clock_out[5] ,
    \clock_out[4] ,
    \clock_out[3] ,
    \clock_out[2] ,
    \clock_out[1] ,
    \clock_out[0] }),
    .col_select_left({\col_select_left[5] ,
    \col_select_left[4] ,
    \col_select_left[3] ,
    \col_select_left[2] ,
    \col_select_left[1] ,
    \col_select_left[0] }),
    .col_select_right({\col_select_right[5] ,
    \col_select_right[4] ,
    \col_select_right[3] ,
    \col_select_right[2] ,
    \col_select_right[1] ,
    \col_select_right[0] }),
    .data_out_left({\data_out_left[15] ,
    \data_out_left[14] ,
    \data_out_left[13] ,
    \data_out_left[12] ,
    \data_out_left[11] ,
    \data_out_left[10] ,
    \data_out_left[9] ,
    \data_out_left[8] ,
    \data_out_left[7] ,
    \data_out_left[6] ,
    \data_out_left[5] ,
    \data_out_left[4] ,
    \data_out_left[3] ,
    \data_out_left[2] ,
    \data_out_left[1] ,
    \data_out_left[0] }),
    .data_out_right({\data_out_right[15] ,
    \data_out_right[14] ,
    \data_out_right[13] ,
    \data_out_right[12] ,
    \data_out_right[11] ,
    \data_out_right[10] ,
    \data_out_right[9] ,
    \data_out_right[8] ,
    \data_out_right[7] ,
    \data_out_right[6] ,
    \data_out_right[5] ,
    \data_out_right[4] ,
    \data_out_right[3] ,
    \data_out_right[2] ,
    \data_out_right[1] ,
    \data_out_right[0] }),
    .inverter_select({\inverter_select[9] ,
    \inverter_select[8] ,
    \inverter_select[7] ,
    \inverter_select[6] ,
    \inverter_select[5] ,
    \inverter_select[4] ,
    \inverter_select[3] ,
    \inverter_select[2] ,
    \inverter_select[1] ,
    \inverter_select[0] }),
    .io_driver_io_oeb({io_oeb[9],
    io_oeb[11],
    io_oeb[13],
    io_oeb[15],
    io_oeb[17],
    io_oeb[21],
    io_oeb[23],
    io_oeb[25],
    io_oeb[27],
    io_oeb[29]}),
    .la_data_in({la_data_in[17],
    la_data_in[16],
    la_data_in[15],
    la_data_in[14],
    la_data_in[13],
    la_data_in[12],
    la_data_in[11],
    la_data_in[10],
    la_data_in[9],
    la_data_in[8],
    la_data_in[7],
    la_data_in[6],
    la_data_in[5],
    la_data_in[4],
    la_data_in[3],
    la_data_in[2],
    la_data_in[1],
    la_data_in[0]}),
    .la_oenb({la_oenb[17],
    la_oenb[16],
    la_oenb[15],
    la_oenb[14],
    la_oenb[13],
    la_oenb[12],
    la_oenb[11],
    la_oenb[10],
    la_oenb[9],
    la_oenb[8],
    la_oenb[7],
    la_oenb[6],
    la_oenb[5],
    la_oenb[4],
    la_oenb[3],
    la_oenb[2],
    la_oenb[1],
    la_oenb[0]}),
    .mem_address_left({\mem_address_left[9] ,
    \mem_address_left[8] ,
    \mem_address_left[7] ,
    \mem_address_left[6] ,
    \mem_address_left[5] ,
    \mem_address_left[4] ,
    \mem_address_left[3] ,
    \mem_address_left[2] ,
    \mem_address_left[1] ,
    \mem_address_left[0] }),
    .mem_address_right({\mem_address_right[9] ,
    \mem_address_right[8] ,
    \mem_address_right[7] ,
    \mem_address_right[6] ,
    \mem_address_right[5] ,
    \mem_address_right[4] ,
    \mem_address_right[3] ,
    \mem_address_right[2] ,
    \mem_address_right[1] ,
    \mem_address_right[0] }),
    .mem_write_n({\mem_write_n[9] ,
    \mem_write_n[8] ,
    \mem_write_n[7] ,
    \mem_write_n[6] ,
    \mem_write_n[5] ,
    \mem_write_n[4] ,
    \mem_write_n[3] ,
    \mem_write_n[2] ,
    \mem_write_n[1] ,
    \mem_write_n[0] }),
    .row_col_select({\row_col_select[9] ,
    \row_col_select[8] ,
    \row_col_select[7] ,
    \row_col_select[6] ,
    \row_col_select[5] ,
    \row_col_select[4] ,
    \row_col_select[3] ,
    \row_col_select[2] ,
    \row_col_select[1] ,
    \row_col_select[0] }),
    .row_select_left({\row_select_left[5] ,
    \row_select_left[4] ,
    \row_select_left[3] ,
    \row_select_left[2] ,
    \row_select_left[1] ,
    \row_select_left[0] }),
    .row_select_right({\row_select_right[5] ,
    \row_select_right[4] ,
    \row_select_right[3] ,
    \row_select_right[2] ,
    \row_select_right[1] ,
    \row_select_right[0] }),
    .spi_data({\spi_data[31] ,
    \spi_data[30] ,
    \spi_data[29] ,
    \spi_data[28] ,
    \spi_data[27] ,
    \spi_data[26] ,
    \spi_data[25] ,
    \spi_data[24] ,
    \spi_data[23] ,
    \spi_data[22] ,
    \spi_data[21] ,
    \spi_data[20] ,
    \spi_data[19] ,
    \spi_data[18] ,
    \spi_data[17] ,
    \spi_data[16] ,
    \spi_data[15] ,
    \spi_data[14] ,
    \spi_data[13] ,
    \spi_data[12] ,
    \spi_data[11] ,
    \spi_data[10] ,
    \spi_data[9] ,
    \spi_data[8] ,
    \spi_data[7] ,
    \spi_data[6] ,
    \spi_data[5] ,
    \spi_data[4] ,
    \spi_data[3] ,
    \spi_data[2] ,
    \spi_data[1] ,
    \spi_data[0] }));
 driver_core driver_core_0 (.clock(\clock_out[0] ),
    .clock_a(\clock_out[0] ),
    .inverter_select_a(\inverter_select[0] ),
    .mem_write_n_a(\mem_write_n[0] ),
    .output_active_a(output_active_left),
    .row_col_select_a(\row_col_select[0] ),
    .vccd1(vccd1),
    .vssd1(vssd1),
    .col_select_a({\col_select_left[5] ,
    \col_select_left[4] ,
    \col_select_left[3] ,
    \col_select_left[2] ,
    \col_select_left[1] ,
    \col_select_left[0] }),
    .data_in_a({\data_out_left[15] ,
    \data_out_left[14] ,
    \data_out_left[13] ,
    \data_out_left[12] ,
    \data_out_left[11] ,
    \data_out_left[10] ,
    \data_out_left[9] ,
    \data_out_left[8] ,
    \data_out_left[7] ,
    \data_out_left[6] ,
    \data_out_left[5] ,
    \data_out_left[4] ,
    \data_out_left[3] ,
    \data_out_left[2] ,
    \data_out_left[1] ,
    \data_out_left[0] }),
    .driver_io({io_out[28],
    io_out[29]}),
    .mem_address_a({\mem_address_left[9] ,
    \mem_address_left[8] ,
    \mem_address_left[7] ,
    \mem_address_left[6] ,
    \mem_address_left[5] ,
    \mem_address_left[4] ,
    \mem_address_left[3] ,
    \mem_address_left[2] ,
    \mem_address_left[1] ,
    \mem_address_left[0] }),
    .row_select_a({\row_select_left[5] ,
    \row_select_left[4] ,
    \row_select_left[3] ,
    \row_select_left[2] ,
    \row_select_left[1] ,
    \row_select_left[0] }));
 driver_core driver_core_1 (.clock(\clock_out[1] ),
    .clock_a(\clock_out[1] ),
    .inverter_select_a(\inverter_select[1] ),
    .mem_write_n_a(\mem_write_n[1] ),
    .output_active_a(output_active_left),
    .row_col_select_a(\row_col_select[1] ),
    .vccd1(vccd1),
    .vssd1(vssd1),
    .col_select_a({\col_select_left[5] ,
    \col_select_left[4] ,
    \col_select_left[3] ,
    \col_select_left[2] ,
    \col_select_left[1] ,
    \col_select_left[0] }),
    .data_in_a({\data_out_left[15] ,
    \data_out_left[14] ,
    \data_out_left[13] ,
    \data_out_left[12] ,
    \data_out_left[11] ,
    \data_out_left[10] ,
    \data_out_left[9] ,
    \data_out_left[8] ,
    \data_out_left[7] ,
    \data_out_left[6] ,
    \data_out_left[5] ,
    \data_out_left[4] ,
    \data_out_left[3] ,
    \data_out_left[2] ,
    \data_out_left[1] ,
    \data_out_left[0] }),
    .driver_io({io_out[26],
    io_out[27]}),
    .mem_address_a({\mem_address_left[9] ,
    \mem_address_left[8] ,
    \mem_address_left[7] ,
    \mem_address_left[6] ,
    \mem_address_left[5] ,
    \mem_address_left[4] ,
    \mem_address_left[3] ,
    \mem_address_left[2] ,
    \mem_address_left[1] ,
    \mem_address_left[0] }),
    .row_select_a({\row_select_left[5] ,
    \row_select_left[4] ,
    \row_select_left[3] ,
    \row_select_left[2] ,
    \row_select_left[1] ,
    \row_select_left[0] }));
 driver_core driver_core_2 (.clock(\clock_out[2] ),
    .clock_a(\clock_out[2] ),
    .inverter_select_a(\inverter_select[2] ),
    .mem_write_n_a(\mem_write_n[2] ),
    .output_active_a(output_active_left),
    .row_col_select_a(\row_col_select[2] ),
    .vccd1(vccd1),
    .vssd1(vssd1),
    .col_select_a({\col_select_left[5] ,
    \col_select_left[4] ,
    \col_select_left[3] ,
    \col_select_left[2] ,
    \col_select_left[1] ,
    \col_select_left[0] }),
    .data_in_a({\data_out_left[15] ,
    \data_out_left[14] ,
    \data_out_left[13] ,
    \data_out_left[12] ,
    \data_out_left[11] ,
    \data_out_left[10] ,
    \data_out_left[9] ,
    \data_out_left[8] ,
    \data_out_left[7] ,
    \data_out_left[6] ,
    \data_out_left[5] ,
    \data_out_left[4] ,
    \data_out_left[3] ,
    \data_out_left[2] ,
    \data_out_left[1] ,
    \data_out_left[0] }),
    .driver_io({io_out[24],
    io_out[25]}),
    .mem_address_a({\mem_address_left[9] ,
    \mem_address_left[8] ,
    \mem_address_left[7] ,
    \mem_address_left[6] ,
    \mem_address_left[5] ,
    \mem_address_left[4] ,
    \mem_address_left[3] ,
    \mem_address_left[2] ,
    \mem_address_left[1] ,
    \mem_address_left[0] }),
    .row_select_a({\row_select_left[5] ,
    \row_select_left[4] ,
    \row_select_left[3] ,
    \row_select_left[2] ,
    \row_select_left[1] ,
    \row_select_left[0] }));
 driver_core driver_core_3 (.clock(\clock_out[3] ),
    .clock_a(\clock_out[3] ),
    .inverter_select_a(\inverter_select[3] ),
    .mem_write_n_a(\mem_write_n[3] ),
    .output_active_a(output_active_left),
    .row_col_select_a(\row_col_select[3] ),
    .vccd1(vccd1),
    .vssd1(vssd1),
    .col_select_a({\col_select_left[5] ,
    \col_select_left[4] ,
    \col_select_left[3] ,
    \col_select_left[2] ,
    \col_select_left[1] ,
    \col_select_left[0] }),
    .data_in_a({\data_out_left[15] ,
    \data_out_left[14] ,
    \data_out_left[13] ,
    \data_out_left[12] ,
    \data_out_left[11] ,
    \data_out_left[10] ,
    \data_out_left[9] ,
    \data_out_left[8] ,
    \data_out_left[7] ,
    \data_out_left[6] ,
    \data_out_left[5] ,
    \data_out_left[4] ,
    \data_out_left[3] ,
    \data_out_left[2] ,
    \data_out_left[1] ,
    \data_out_left[0] }),
    .driver_io({io_out[22],
    io_out[23]}),
    .mem_address_a({\mem_address_left[9] ,
    \mem_address_left[8] ,
    \mem_address_left[7] ,
    \mem_address_left[6] ,
    \mem_address_left[5] ,
    \mem_address_left[4] ,
    \mem_address_left[3] ,
    \mem_address_left[2] ,
    \mem_address_left[1] ,
    \mem_address_left[0] }),
    .row_select_a({\row_select_left[5] ,
    \row_select_left[4] ,
    \row_select_left[3] ,
    \row_select_left[2] ,
    \row_select_left[1] ,
    \row_select_left[0] }));
 driver_core driver_core_4 (.clock(\clock_out[4] ),
    .clock_a(\clock_out[4] ),
    .inverter_select_a(\inverter_select[4] ),
    .mem_write_n_a(\mem_write_n[4] ),
    .output_active_a(output_active_left),
    .row_col_select_a(\row_col_select[4] ),
    .vccd1(vccd1),
    .vssd1(vssd1),
    .col_select_a({\col_select_left[5] ,
    \col_select_left[4] ,
    \col_select_left[3] ,
    \col_select_left[2] ,
    \col_select_left[1] ,
    \col_select_left[0] }),
    .data_in_a({\data_out_left[15] ,
    \data_out_left[14] ,
    \data_out_left[13] ,
    \data_out_left[12] ,
    \data_out_left[11] ,
    \data_out_left[10] ,
    \data_out_left[9] ,
    \data_out_left[8] ,
    \data_out_left[7] ,
    \data_out_left[6] ,
    \data_out_left[5] ,
    \data_out_left[4] ,
    \data_out_left[3] ,
    \data_out_left[2] ,
    \data_out_left[1] ,
    \data_out_left[0] }),
    .driver_io({io_out[20],
    io_out[21]}),
    .mem_address_a({\mem_address_left[9] ,
    \mem_address_left[8] ,
    \mem_address_left[7] ,
    \mem_address_left[6] ,
    \mem_address_left[5] ,
    \mem_address_left[4] ,
    \mem_address_left[3] ,
    \mem_address_left[2] ,
    \mem_address_left[1] ,
    \mem_address_left[0] }),
    .row_select_a({\row_select_left[5] ,
    \row_select_left[4] ,
    \row_select_left[3] ,
    \row_select_left[2] ,
    \row_select_left[1] ,
    \row_select_left[0] }));
 driver_core driver_core_5 (.clock(\clock_out[5] ),
    .clock_a(\clock_out[5] ),
    .inverter_select_a(\inverter_select[5] ),
    .mem_write_n_a(\mem_write_n[5] ),
    .output_active_a(output_active_right),
    .row_col_select_a(\row_col_select[5] ),
    .vccd1(vccd1),
    .vssd1(vssd1),
    .col_select_a({\col_select_right[5] ,
    \col_select_right[4] ,
    \col_select_right[3] ,
    \col_select_right[2] ,
    \col_select_right[1] ,
    \col_select_right[0] }),
    .data_in_a({\data_out_right[15] ,
    \data_out_right[14] ,
    \data_out_right[13] ,
    \data_out_right[12] ,
    \data_out_right[11] ,
    \data_out_right[10] ,
    \data_out_right[9] ,
    \data_out_right[8] ,
    \data_out_right[7] ,
    \data_out_right[6] ,
    \data_out_right[5] ,
    \data_out_right[4] ,
    \data_out_right[3] ,
    \data_out_right[2] ,
    \data_out_right[1] ,
    \data_out_right[0] }),
    .driver_io({io_out[16],
    io_out[17]}),
    .mem_address_a({\mem_address_right[9] ,
    \mem_address_right[8] ,
    \mem_address_right[7] ,
    \mem_address_right[6] ,
    \mem_address_right[5] ,
    \mem_address_right[4] ,
    \mem_address_right[3] ,
    \mem_address_right[2] ,
    \mem_address_right[1] ,
    \mem_address_right[0] }),
    .row_select_a({\row_select_right[5] ,
    \row_select_right[4] ,
    \row_select_right[3] ,
    \row_select_right[2] ,
    \row_select_right[1] ,
    \row_select_right[0] }));
 driver_core driver_core_6 (.clock(\clock_out[6] ),
    .clock_a(\clock_out[6] ),
    .inverter_select_a(\inverter_select[6] ),
    .mem_write_n_a(\mem_write_n[6] ),
    .output_active_a(output_active_right),
    .row_col_select_a(\row_col_select[6] ),
    .vccd1(vccd1),
    .vssd1(vssd1),
    .col_select_a({\col_select_right[5] ,
    \col_select_right[4] ,
    \col_select_right[3] ,
    \col_select_right[2] ,
    \col_select_right[1] ,
    \col_select_right[0] }),
    .data_in_a({\data_out_right[15] ,
    \data_out_right[14] ,
    \data_out_right[13] ,
    \data_out_right[12] ,
    \data_out_right[11] ,
    \data_out_right[10] ,
    \data_out_right[9] ,
    \data_out_right[8] ,
    \data_out_right[7] ,
    \data_out_right[6] ,
    \data_out_right[5] ,
    \data_out_right[4] ,
    \data_out_right[3] ,
    \data_out_right[2] ,
    \data_out_right[1] ,
    \data_out_right[0] }),
    .driver_io({io_out[14],
    io_out[15]}),
    .mem_address_a({\mem_address_right[9] ,
    \mem_address_right[8] ,
    \mem_address_right[7] ,
    \mem_address_right[6] ,
    \mem_address_right[5] ,
    \mem_address_right[4] ,
    \mem_address_right[3] ,
    \mem_address_right[2] ,
    \mem_address_right[1] ,
    \mem_address_right[0] }),
    .row_select_a({\row_select_right[5] ,
    \row_select_right[4] ,
    \row_select_right[3] ,
    \row_select_right[2] ,
    \row_select_right[1] ,
    \row_select_right[0] }));
 driver_core driver_core_7 (.clock(\clock_out[7] ),
    .clock_a(\clock_out[7] ),
    .inverter_select_a(\inverter_select[7] ),
    .mem_write_n_a(\mem_write_n[7] ),
    .output_active_a(output_active_right),
    .row_col_select_a(\row_col_select[7] ),
    .vccd1(vccd1),
    .vssd1(vssd1),
    .col_select_a({\col_select_right[5] ,
    \col_select_right[4] ,
    \col_select_right[3] ,
    \col_select_right[2] ,
    \col_select_right[1] ,
    \col_select_right[0] }),
    .data_in_a({\data_out_right[15] ,
    \data_out_right[14] ,
    \data_out_right[13] ,
    \data_out_right[12] ,
    \data_out_right[11] ,
    \data_out_right[10] ,
    \data_out_right[9] ,
    \data_out_right[8] ,
    \data_out_right[7] ,
    \data_out_right[6] ,
    \data_out_right[5] ,
    \data_out_right[4] ,
    \data_out_right[3] ,
    \data_out_right[2] ,
    \data_out_right[1] ,
    \data_out_right[0] }),
    .driver_io({io_out[12],
    io_out[13]}),
    .mem_address_a({\mem_address_right[9] ,
    \mem_address_right[8] ,
    \mem_address_right[7] ,
    \mem_address_right[6] ,
    \mem_address_right[5] ,
    \mem_address_right[4] ,
    \mem_address_right[3] ,
    \mem_address_right[2] ,
    \mem_address_right[1] ,
    \mem_address_right[0] }),
    .row_select_a({\row_select_right[5] ,
    \row_select_right[4] ,
    \row_select_right[3] ,
    \row_select_right[2] ,
    \row_select_right[1] ,
    \row_select_right[0] }));
 driver_core driver_core_8 (.clock(\clock_out[8] ),
    .clock_a(\clock_out[8] ),
    .inverter_select_a(\inverter_select[8] ),
    .mem_write_n_a(\mem_write_n[8] ),
    .output_active_a(output_active_right),
    .row_col_select_a(\row_col_select[8] ),
    .vccd1(vccd1),
    .vssd1(vssd1),
    .col_select_a({\col_select_right[5] ,
    \col_select_right[4] ,
    \col_select_right[3] ,
    \col_select_right[2] ,
    \col_select_right[1] ,
    \col_select_right[0] }),
    .data_in_a({\data_out_right[15] ,
    \data_out_right[14] ,
    \data_out_right[13] ,
    \data_out_right[12] ,
    \data_out_right[11] ,
    \data_out_right[10] ,
    \data_out_right[9] ,
    \data_out_right[8] ,
    \data_out_right[7] ,
    \data_out_right[6] ,
    \data_out_right[5] ,
    \data_out_right[4] ,
    \data_out_right[3] ,
    \data_out_right[2] ,
    \data_out_right[1] ,
    \data_out_right[0] }),
    .driver_io({io_out[10],
    io_out[11]}),
    .mem_address_a({\mem_address_right[9] ,
    \mem_address_right[8] ,
    \mem_address_right[7] ,
    \mem_address_right[6] ,
    \mem_address_right[5] ,
    \mem_address_right[4] ,
    \mem_address_right[3] ,
    \mem_address_right[2] ,
    \mem_address_right[1] ,
    \mem_address_right[0] }),
    .row_select_a({\row_select_right[5] ,
    \row_select_right[4] ,
    \row_select_right[3] ,
    \row_select_right[2] ,
    \row_select_right[1] ,
    \row_select_right[0] }));
 driver_core driver_core_9 (.clock(\clock_out[9] ),
    .clock_a(\clock_out[9] ),
    .inverter_select_a(\inverter_select[9] ),
    .mem_write_n_a(\mem_write_n[9] ),
    .output_active_a(output_active_right),
    .row_col_select_a(\row_col_select[9] ),
    .vccd1(vccd1),
    .vssd1(vssd1),
    .col_select_a({\col_select_right[5] ,
    \col_select_right[4] ,
    \col_select_right[3] ,
    \col_select_right[2] ,
    \col_select_right[1] ,
    \col_select_right[0] }),
    .data_in_a({\data_out_right[15] ,
    \data_out_right[14] ,
    \data_out_right[13] ,
    \data_out_right[12] ,
    \data_out_right[11] ,
    \data_out_right[10] ,
    \data_out_right[9] ,
    \data_out_right[8] ,
    \data_out_right[7] ,
    \data_out_right[6] ,
    \data_out_right[5] ,
    \data_out_right[4] ,
    \data_out_right[3] ,
    \data_out_right[2] ,
    \data_out_right[1] ,
    \data_out_right[0] }),
    .driver_io({io_out[8],
    io_out[9]}),
    .mem_address_a({\mem_address_right[9] ,
    \mem_address_right[8] ,
    \mem_address_right[7] ,
    \mem_address_right[6] ,
    \mem_address_right[5] ,
    \mem_address_right[4] ,
    \mem_address_right[3] ,
    \mem_address_right[2] ,
    \mem_address_right[1] ,
    \mem_address_right[0] }),
    .row_select_a({\row_select_right[5] ,
    \row_select_right[4] ,
    \row_select_right[3] ,
    \row_select_right[2] ,
    \row_select_right[1] ,
    \row_select_right[0] }));
 spi_controller spi_controller_mod (.clock(user_clock2),
    .clock_out(spi_data_clock),
    .miso(io_miso_out),
    .miso_oeb(io_miso_oeb),
    .mosi(io_in[33]),
    .mosi_oeb(io_mosi_oeb),
    .sclk(io_in[31]),
    .sclk_oeb(io_sclk_oeb),
    .ss_n(io_in[32]),
    .ss_n_oeb(io_ss_n_oeb),
    .vccd1(vccd1),
    .vssd1(vssd1),
    .data_out({\spi_data[31] ,
    \spi_data[30] ,
    \spi_data[29] ,
    \spi_data[28] ,
    \spi_data[27] ,
    \spi_data[26] ,
    \spi_data[25] ,
    \spi_data[24] ,
    \spi_data[23] ,
    \spi_data[22] ,
    \spi_data[21] ,
    \spi_data[20] ,
    \spi_data[19] ,
    \spi_data[18] ,
    \spi_data[17] ,
    \spi_data[16] ,
    \spi_data[15] ,
    \spi_data[14] ,
    \spi_data[13] ,
    \spi_data[12] ,
    \spi_data[11] ,
    \spi_data[10] ,
    \spi_data[9] ,
    \spi_data[8] ,
    \spi_data[7] ,
    \spi_data[6] ,
    \spi_data[5] ,
    \spi_data[4] ,
    \spi_data[3] ,
    \spi_data[2] ,
    \spi_data[1] ,
    \spi_data[0] }),
    .la_data_in({la_oenb[35],
    la_oenb[34],
    la_oenb[33],
    la_oenb[32]}),
    .la_oenb({la_data_in[35],
    la_data_in[34],
    la_data_in[33],
    la_data_in[32]}));
 assign io_oeb[10] = io_oeb[11];
 assign io_oeb[12] = io_oeb[13];
 assign io_oeb[14] = io_oeb[15];
 assign io_oeb[16] = io_oeb[17];
 assign io_oeb[20] = io_oeb[21];
 assign io_oeb[22] = io_oeb[23];
 assign io_oeb[24] = io_oeb[25];
 assign io_oeb[26] = io_oeb[27];
 assign io_oeb[28] = io_oeb[29];
 assign io_oeb[30] = io_update_cycle_complete_oeb;
 assign io_oeb[31] = io_sclk_oeb;
 assign io_oeb[32] = io_ss_n_oeb;
 assign io_oeb[33] = io_mosi_oeb;
 assign io_oeb[34] = io_miso_oeb;
 assign io_oeb[35] = io_latch_data_oeb;
 assign io_oeb[36] = io_control_trigger_oeb;
 assign io_oeb[37] = io_reset_n_oeb;
 assign io_oeb[8] = io_oeb[9];
 assign io_out[30] = io_update_cycle_complete_out;
 assign io_out[34] = io_miso_out;
endmodule
