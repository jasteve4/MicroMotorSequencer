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
 wire \mask_select_left[0] ;
 wire \mask_select_left[1] ;
 wire \mask_select_left[2] ;
 wire \mask_select_right[0] ;
 wire \mask_select_right[1] ;
 wire \mask_select_right[2] ;
 wire \mem_address_left[0] ;
 wire \mem_address_left[1] ;
 wire \mem_address_left[2] ;
 wire \mem_address_left[3] ;
 wire \mem_address_left[4] ;
 wire \mem_address_left[5] ;
 wire \mem_address_left[6] ;
 wire \mem_address_right[0] ;
 wire \mem_address_right[1] ;
 wire \mem_address_right[2] ;
 wire \mem_address_right[3] ;
 wire \mem_address_right[4] ;
 wire \mem_address_right[5] ;
 wire \mem_address_right[6] ;
 wire \mem_dot_write_n[0] ;
 wire \mem_dot_write_n[1] ;
 wire \mem_dot_write_n[2] ;
 wire \mem_dot_write_n[3] ;
 wire \mem_dot_write_n[4] ;
 wire \mem_dot_write_n[5] ;
 wire \mem_dot_write_n[6] ;
 wire \mem_dot_write_n[7] ;
 wire \mem_dot_write_n[8] ;
 wire \mem_dot_write_n[9] ;
 wire \mem_sel_col_address_left[0] ;
 wire \mem_sel_col_address_left[1] ;
 wire \mem_sel_col_address_left[2] ;
 wire \mem_sel_col_address_left[3] ;
 wire \mem_sel_col_address_left[4] ;
 wire \mem_sel_col_address_left[5] ;
 wire \mem_sel_col_address_left[6] ;
 wire \mem_sel_col_address_right[0] ;
 wire \mem_sel_col_address_right[1] ;
 wire \mem_sel_col_address_right[2] ;
 wire \mem_sel_col_address_right[3] ;
 wire \mem_sel_col_address_right[4] ;
 wire \mem_sel_col_address_right[5] ;
 wire \mem_sel_col_address_right[6] ;
 wire \mem_sel_write_n[0] ;
 wire \mem_sel_write_n[1] ;
 wire \mem_sel_write_n[2] ;
 wire \mem_sel_write_n[3] ;
 wire \mem_sel_write_n[4] ;
 wire \mem_sel_write_n[5] ;
 wire \mem_sel_write_n[6] ;
 wire \mem_sel_write_n[7] ;
 wire \mem_sel_write_n[8] ;
 wire \mem_sel_write_n[9] ;
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

 controller_unit controller_unit_mod (.io_control_trigger_in(io_in[36]),
    .io_control_trigger_oeb(io_control_trigger_oeb),
    .io_latch_data_in(io_in[35]),
    .io_latch_data_oeb(io_latch_data_oeb),
    .io_miso_oeb(io_miso_oeb),
    .io_miso_out(io_miso_out),
    .io_mosi_in(io_in[33]),
    .io_mosi_oeb(io_mosi_oeb),
    .io_reset_n_in(io_in[37]),
    .io_reset_n_oeb(io_reset_n_oeb),
    .io_sclk_in(io_in[31]),
    .io_sclk_oeb(io_sclk_oeb),
    .io_ss_n_in(io_in[32]),
    .io_ss_n_oeb(io_ss_n_oeb),
    .io_update_cycle_complete_oeb(io_update_cycle_complete_oeb),
    .io_update_cycle_complete_out(io_update_cycle_complete_out),
    .output_active_left(output_active_left),
    .output_active_right(output_active_right),
    .user_clock2(user_clock2),
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
    .la_data_in({la_data_in[127],
    la_data_in[126],
    la_data_in[125],
    la_data_in[124],
    la_data_in[123],
    la_data_in[122],
    la_data_in[121],
    la_data_in[120],
    la_data_in[119],
    la_data_in[118],
    la_data_in[117],
    la_data_in[116],
    la_data_in[115],
    la_data_in[114],
    la_data_in[113],
    la_data_in[112],
    la_data_in[111],
    la_data_in[110],
    la_data_in[109],
    la_data_in[108],
    la_data_in[107],
    la_data_in[106],
    la_data_in[105],
    la_data_in[104],
    la_data_in[103],
    la_data_in[102],
    la_data_in[101],
    la_data_in[100],
    la_data_in[99],
    la_data_in[98],
    la_data_in[97],
    la_data_in[96],
    la_data_in[95],
    la_data_in[94],
    la_data_in[93],
    la_data_in[92],
    la_data_in[91],
    la_data_in[90],
    la_data_in[89],
    la_data_in[88],
    la_data_in[87],
    la_data_in[86],
    la_data_in[85],
    la_data_in[84],
    la_data_in[83],
    la_data_in[82],
    la_data_in[81],
    la_data_in[80],
    la_data_in[79],
    la_data_in[78],
    la_data_in[77],
    la_data_in[76],
    la_data_in[75],
    la_data_in[74],
    la_data_in[73],
    la_data_in[72],
    la_data_in[71],
    la_data_in[70],
    la_data_in[69],
    la_data_in[68],
    la_data_in[67],
    la_data_in[66],
    la_data_in[65],
    la_data_in[64],
    la_data_in[63],
    la_data_in[62],
    la_data_in[61],
    la_data_in[60],
    la_data_in[59],
    la_data_in[58],
    la_data_in[57],
    la_data_in[56],
    la_data_in[55],
    la_data_in[54],
    la_data_in[53],
    la_data_in[52],
    la_data_in[51],
    la_data_in[50],
    la_data_in[49],
    la_data_in[48],
    la_data_in[47],
    la_data_in[46],
    la_data_in[45],
    la_data_in[44],
    la_data_in[43],
    la_data_in[42],
    la_data_in[41],
    la_data_in[40],
    la_data_in[39],
    la_data_in[38],
    la_data_in[37],
    la_data_in[36],
    la_data_in[35],
    la_data_in[34],
    la_data_in[33],
    la_data_in[32],
    la_data_in[31],
    la_data_in[30],
    la_data_in[29],
    la_data_in[28],
    la_data_in[27],
    la_data_in[26],
    la_data_in[25],
    la_data_in[24],
    la_data_in[23],
    la_data_in[22],
    la_data_in[21],
    la_data_in[20],
    la_data_in[19],
    la_data_in[18],
    la_data_in[17],
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
    .la_oenb({la_oenb[127],
    la_oenb[126],
    la_oenb[125],
    la_oenb[124],
    la_oenb[123],
    la_oenb[122],
    la_oenb[121],
    la_oenb[120],
    la_oenb[119],
    la_oenb[118],
    la_oenb[117],
    la_oenb[116],
    la_oenb[115],
    la_oenb[114],
    la_oenb[113],
    la_oenb[112],
    la_oenb[111],
    la_oenb[110],
    la_oenb[109],
    la_oenb[108],
    la_oenb[107],
    la_oenb[106],
    la_oenb[105],
    la_oenb[104],
    la_oenb[103],
    la_oenb[102],
    la_oenb[101],
    la_oenb[100],
    la_oenb[99],
    la_oenb[98],
    la_oenb[97],
    la_oenb[96],
    la_oenb[95],
    la_oenb[94],
    la_oenb[93],
    la_oenb[92],
    la_oenb[91],
    la_oenb[90],
    la_oenb[89],
    la_oenb[88],
    la_oenb[87],
    la_oenb[86],
    la_oenb[85],
    la_oenb[84],
    la_oenb[83],
    la_oenb[82],
    la_oenb[81],
    la_oenb[80],
    la_oenb[79],
    la_oenb[78],
    la_oenb[77],
    la_oenb[76],
    la_oenb[75],
    la_oenb[74],
    la_oenb[73],
    la_oenb[72],
    la_oenb[71],
    la_oenb[70],
    la_oenb[69],
    la_oenb[68],
    la_oenb[67],
    la_oenb[66],
    la_oenb[65],
    la_oenb[64],
    la_oenb[63],
    la_oenb[62],
    la_oenb[61],
    la_oenb[60],
    la_oenb[59],
    la_oenb[58],
    la_oenb[57],
    la_oenb[56],
    la_oenb[55],
    la_oenb[54],
    la_oenb[53],
    la_oenb[52],
    la_oenb[51],
    la_oenb[50],
    la_oenb[49],
    la_oenb[48],
    la_oenb[47],
    la_oenb[46],
    la_oenb[45],
    la_oenb[44],
    la_oenb[43],
    la_oenb[42],
    la_oenb[41],
    la_oenb[40],
    la_oenb[39],
    la_oenb[38],
    la_oenb[37],
    la_oenb[36],
    la_oenb[35],
    la_oenb[34],
    la_oenb[33],
    la_oenb[32],
    la_oenb[31],
    la_oenb[30],
    la_oenb[29],
    la_oenb[28],
    la_oenb[27],
    la_oenb[26],
    la_oenb[25],
    la_oenb[24],
    la_oenb[23],
    la_oenb[22],
    la_oenb[21],
    la_oenb[20],
    la_oenb[19],
    la_oenb[18],
    la_oenb[17],
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
    .mask_select_left({\mask_select_left[2] ,
    \mask_select_left[1] ,
    \mask_select_left[0] }),
    .mask_select_right({\mask_select_right[2] ,
    \mask_select_right[1] ,
    \mask_select_right[0] }),
    .mem_address_left({\mem_address_left[6] ,
    \mem_address_left[5] ,
    \mem_address_left[4] ,
    \mem_address_left[3] ,
    \mem_address_left[2] ,
    \mem_address_left[1] ,
    \mem_address_left[0] }),
    .mem_address_right({\mem_address_right[6] ,
    \mem_address_right[5] ,
    \mem_address_right[4] ,
    \mem_address_right[3] ,
    \mem_address_right[2] ,
    \mem_address_right[1] ,
    \mem_address_right[0] }),
    .mem_dot_write_n({\mem_dot_write_n[9] ,
    \mem_dot_write_n[8] ,
    \mem_dot_write_n[7] ,
    \mem_dot_write_n[6] ,
    \mem_dot_write_n[5] ,
    \mem_dot_write_n[4] ,
    \mem_dot_write_n[3] ,
    \mem_dot_write_n[2] ,
    \mem_dot_write_n[1] ,
    \mem_dot_write_n[0] }),
    .mem_sel_col_address_left({\mem_sel_col_address_left[6] ,
    \mem_sel_col_address_left[5] ,
    \mem_sel_col_address_left[4] ,
    \mem_sel_col_address_left[3] ,
    \mem_sel_col_address_left[2] ,
    \mem_sel_col_address_left[1] ,
    \mem_sel_col_address_left[0] }),
    .mem_sel_col_address_right({\mem_sel_col_address_right[6] ,
    \mem_sel_col_address_right[5] ,
    \mem_sel_col_address_right[4] ,
    \mem_sel_col_address_right[3] ,
    \mem_sel_col_address_right[2] ,
    \mem_sel_col_address_right[1] ,
    \mem_sel_col_address_right[0] }),
    .mem_sel_write_n({\mem_sel_write_n[9] ,
    \mem_sel_write_n[8] ,
    \mem_sel_write_n[7] ,
    \mem_sel_write_n[6] ,
    \mem_sel_write_n[5] ,
    \mem_sel_write_n[4] ,
    \mem_sel_write_n[3] ,
    \mem_sel_write_n[2] ,
    \mem_sel_write_n[1] ,
    \mem_sel_write_n[0] }),
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
    \row_select_right[0] }));
 driver_core driver_core_0 (.clock(\clock_out[0] ),
    .clock_a(\clock_out[0] ),
    .inverter_select_a(\inverter_select[0] ),
    .mem_dot_write_n_a(\mem_dot_write_n[0] ),
    .mem_sel_write_n_a(\mem_sel_write_n[0] ),
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
    .mask_select_a({\mask_select_left[2] ,
    \mask_select_left[1] ,
    \mask_select_left[0] }),
    .mem_address_a({\mem_address_left[5] ,
    \mem_address_left[4] ,
    \mem_address_left[3] ,
    \mem_address_left[2] ,
    \mem_address_left[1] ,
    \mem_address_left[0] }),
    .mem_sel_col_address_a({\mem_sel_col_address_left[5] ,
    \mem_sel_col_address_left[4] ,
    \mem_sel_col_address_left[3] ,
    \mem_sel_col_address_left[2] ,
    \mem_sel_col_address_left[1] ,
    \mem_sel_col_address_left[0] }),
    .row_select_a({\row_select_left[5] ,
    \row_select_left[4] ,
    \row_select_left[3] ,
    \row_select_left[2] ,
    \row_select_left[1] ,
    \row_select_left[0] }));
 driver_core driver_core_1 (.clock(\clock_out[1] ),
    .clock_a(\clock_out[1] ),
    .inverter_select_a(\inverter_select[1] ),
    .mem_dot_write_n_a(\mem_dot_write_n[1] ),
    .mem_sel_write_n_a(\mem_sel_write_n[1] ),
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
    .mask_select_a({\mask_select_left[2] ,
    \mask_select_left[1] ,
    \mask_select_left[0] }),
    .mem_address_a({\mem_address_left[5] ,
    \mem_address_left[4] ,
    \mem_address_left[3] ,
    \mem_address_left[2] ,
    \mem_address_left[1] ,
    \mem_address_left[0] }),
    .mem_sel_col_address_a({\mem_sel_col_address_left[5] ,
    \mem_sel_col_address_left[4] ,
    \mem_sel_col_address_left[3] ,
    \mem_sel_col_address_left[2] ,
    \mem_sel_col_address_left[1] ,
    \mem_sel_col_address_left[0] }),
    .row_select_a({\row_select_left[5] ,
    \row_select_left[4] ,
    \row_select_left[3] ,
    \row_select_left[2] ,
    \row_select_left[1] ,
    \row_select_left[0] }));
 driver_core driver_core_2 (.clock(\clock_out[2] ),
    .clock_a(\clock_out[2] ),
    .inverter_select_a(\inverter_select[2] ),
    .mem_dot_write_n_a(\mem_dot_write_n[2] ),
    .mem_sel_write_n_a(\mem_sel_write_n[2] ),
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
    .mask_select_a({\mask_select_left[2] ,
    \mask_select_left[1] ,
    \mask_select_left[0] }),
    .mem_address_a({\mem_address_left[5] ,
    \mem_address_left[4] ,
    \mem_address_left[3] ,
    \mem_address_left[2] ,
    \mem_address_left[1] ,
    \mem_address_left[0] }),
    .mem_sel_col_address_a({\mem_sel_col_address_left[5] ,
    \mem_sel_col_address_left[4] ,
    \mem_sel_col_address_left[3] ,
    \mem_sel_col_address_left[2] ,
    \mem_sel_col_address_left[1] ,
    \mem_sel_col_address_left[0] }),
    .row_select_a({\row_select_left[5] ,
    \row_select_left[4] ,
    \row_select_left[3] ,
    \row_select_left[2] ,
    \row_select_left[1] ,
    \row_select_left[0] }));
 driver_core driver_core_3 (.clock(\clock_out[3] ),
    .clock_a(\clock_out[3] ),
    .inverter_select_a(\inverter_select[3] ),
    .mem_dot_write_n_a(\mem_dot_write_n[3] ),
    .mem_sel_write_n_a(\mem_sel_write_n[3] ),
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
    .mask_select_a({\mask_select_left[2] ,
    \mask_select_left[1] ,
    \mask_select_left[0] }),
    .mem_address_a({\mem_address_left[5] ,
    \mem_address_left[4] ,
    \mem_address_left[3] ,
    \mem_address_left[2] ,
    \mem_address_left[1] ,
    \mem_address_left[0] }),
    .mem_sel_col_address_a({\mem_sel_col_address_left[5] ,
    \mem_sel_col_address_left[4] ,
    \mem_sel_col_address_left[3] ,
    \mem_sel_col_address_left[2] ,
    \mem_sel_col_address_left[1] ,
    \mem_sel_col_address_left[0] }),
    .row_select_a({\row_select_left[5] ,
    \row_select_left[4] ,
    \row_select_left[3] ,
    \row_select_left[2] ,
    \row_select_left[1] ,
    \row_select_left[0] }));
 driver_core driver_core_4 (.clock(\clock_out[4] ),
    .clock_a(\clock_out[4] ),
    .inverter_select_a(\inverter_select[4] ),
    .mem_dot_write_n_a(\mem_dot_write_n[4] ),
    .mem_sel_write_n_a(\mem_sel_write_n[4] ),
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
    .mask_select_a({\mask_select_left[2] ,
    \mask_select_left[1] ,
    \mask_select_left[0] }),
    .mem_address_a({\mem_address_left[5] ,
    \mem_address_left[4] ,
    \mem_address_left[3] ,
    \mem_address_left[2] ,
    \mem_address_left[1] ,
    \mem_address_left[0] }),
    .mem_sel_col_address_a({\mem_sel_col_address_left[5] ,
    \mem_sel_col_address_left[4] ,
    \mem_sel_col_address_left[3] ,
    \mem_sel_col_address_left[2] ,
    \mem_sel_col_address_left[1] ,
    \mem_sel_col_address_left[0] }),
    .row_select_a({\row_select_left[5] ,
    \row_select_left[4] ,
    \row_select_left[3] ,
    \row_select_left[2] ,
    \row_select_left[1] ,
    \row_select_left[0] }));
 driver_core driver_core_5 (.clock(\clock_out[5] ),
    .clock_a(\clock_out[5] ),
    .inverter_select_a(\inverter_select[5] ),
    .mem_dot_write_n_a(\mem_dot_write_n[5] ),
    .mem_sel_write_n_a(\mem_sel_write_n[5] ),
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
    .mask_select_a({\mask_select_right[2] ,
    \mask_select_right[1] ,
    \mask_select_right[0] }),
    .mem_address_a({\mem_address_right[5] ,
    \mem_address_right[4] ,
    \mem_address_right[3] ,
    \mem_address_right[2] ,
    \mem_address_right[1] ,
    \mem_address_right[0] }),
    .mem_sel_col_address_a({\mem_sel_col_address_right[5] ,
    \mem_sel_col_address_right[4] ,
    \mem_sel_col_address_right[3] ,
    \mem_sel_col_address_right[2] ,
    \mem_sel_col_address_right[1] ,
    \mem_sel_col_address_right[0] }),
    .row_select_a({\row_select_right[5] ,
    \row_select_right[4] ,
    \row_select_right[3] ,
    \row_select_right[2] ,
    \row_select_right[1] ,
    \row_select_right[0] }));
 driver_core driver_core_6 (.clock(\clock_out[6] ),
    .clock_a(\clock_out[6] ),
    .inverter_select_a(\inverter_select[6] ),
    .mem_dot_write_n_a(\mem_dot_write_n[6] ),
    .mem_sel_write_n_a(\mem_sel_write_n[6] ),
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
    .mask_select_a({\mask_select_right[2] ,
    \mask_select_right[1] ,
    \mask_select_right[0] }),
    .mem_address_a({\mem_address_right[5] ,
    \mem_address_right[4] ,
    \mem_address_right[3] ,
    \mem_address_right[2] ,
    \mem_address_right[1] ,
    \mem_address_right[0] }),
    .mem_sel_col_address_a({\mem_sel_col_address_right[5] ,
    \mem_sel_col_address_right[4] ,
    \mem_sel_col_address_right[3] ,
    \mem_sel_col_address_right[2] ,
    \mem_sel_col_address_right[1] ,
    \mem_sel_col_address_right[0] }),
    .row_select_a({\row_select_right[5] ,
    \row_select_right[4] ,
    \row_select_right[3] ,
    \row_select_right[2] ,
    \row_select_right[1] ,
    \row_select_right[0] }));
 driver_core driver_core_7 (.clock(\clock_out[7] ),
    .clock_a(\clock_out[7] ),
    .inverter_select_a(\inverter_select[7] ),
    .mem_dot_write_n_a(\mem_dot_write_n[7] ),
    .mem_sel_write_n_a(\mem_sel_write_n[7] ),
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
    .mask_select_a({\mask_select_right[2] ,
    \mask_select_right[1] ,
    \mask_select_right[0] }),
    .mem_address_a({\mem_address_right[5] ,
    \mem_address_right[4] ,
    \mem_address_right[3] ,
    \mem_address_right[2] ,
    \mem_address_right[1] ,
    \mem_address_right[0] }),
    .mem_sel_col_address_a({\mem_sel_col_address_right[5] ,
    \mem_sel_col_address_right[4] ,
    \mem_sel_col_address_right[3] ,
    \mem_sel_col_address_right[2] ,
    \mem_sel_col_address_right[1] ,
    \mem_sel_col_address_right[0] }),
    .row_select_a({\row_select_right[5] ,
    \row_select_right[4] ,
    \row_select_right[3] ,
    \row_select_right[2] ,
    \row_select_right[1] ,
    \row_select_right[0] }));
 driver_core driver_core_8 (.clock(\clock_out[8] ),
    .clock_a(\clock_out[8] ),
    .inverter_select_a(\inverter_select[8] ),
    .mem_dot_write_n_a(\mem_dot_write_n[8] ),
    .mem_sel_write_n_a(\mem_sel_write_n[8] ),
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
    .mask_select_a({\mask_select_right[2] ,
    \mask_select_right[1] ,
    \mask_select_right[0] }),
    .mem_address_a({\mem_address_right[5] ,
    \mem_address_right[4] ,
    \mem_address_right[3] ,
    \mem_address_right[2] ,
    \mem_address_right[1] ,
    \mem_address_right[0] }),
    .mem_sel_col_address_a({\mem_sel_col_address_right[5] ,
    \mem_sel_col_address_right[4] ,
    \mem_sel_col_address_right[3] ,
    \mem_sel_col_address_right[2] ,
    \mem_sel_col_address_right[1] ,
    \mem_sel_col_address_right[0] }),
    .row_select_a({\row_select_right[5] ,
    \row_select_right[4] ,
    \row_select_right[3] ,
    \row_select_right[2] ,
    \row_select_right[1] ,
    \row_select_right[0] }));
 driver_core driver_core_9 (.clock(\clock_out[9] ),
    .clock_a(\clock_out[9] ),
    .inverter_select_a(\inverter_select[9] ),
    .mem_dot_write_n_a(\mem_dot_write_n[9] ),
    .mem_sel_write_n_a(\mem_sel_write_n[9] ),
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
    .mask_select_a({\mask_select_right[2] ,
    \mask_select_right[1] ,
    \mask_select_right[0] }),
    .mem_address_a({\mem_address_right[5] ,
    \mem_address_right[4] ,
    \mem_address_right[3] ,
    \mem_address_right[2] ,
    \mem_address_right[1] ,
    \mem_address_right[0] }),
    .mem_sel_col_address_a({\mem_sel_col_address_right[5] ,
    \mem_sel_col_address_right[4] ,
    \mem_sel_col_address_right[3] ,
    \mem_sel_col_address_right[2] ,
    \mem_sel_col_address_right[1] ,
    \mem_sel_col_address_right[0] }),
    .row_select_a({\row_select_right[5] ,
    \row_select_right[4] ,
    \row_select_right[3] ,
    \row_select_right[2] ,
    \row_select_right[1] ,
    \row_select_right[0] }));
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
