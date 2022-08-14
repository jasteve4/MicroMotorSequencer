


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
