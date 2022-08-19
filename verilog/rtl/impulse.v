module impulse(
  input clock,
  input reset_n,
  input trigger,
  output advance
);

  reg [1:0] impulse_gen;

  always@(posedge clock)
  begin
    if(reset_n)
    begin
      impulse_gen <= {impulse_gen[0],trigger};
    end
    else
    begin
      impulse_gen <= 2'b0;
    end
  end

  assign advance = impulse_gen == 2'b01;

endmodule

module impulse_no_reset(
  input clock,
  input trigger,
  output advance
);

  reg [1:0] impulse_gen;

  always@(posedge clock)
  begin
    impulse_gen <= {impulse_gen[0],trigger};
  end

  assign advance = impulse_gen == 2'b01;

endmodule
