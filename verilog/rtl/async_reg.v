module async_reg(
  input wire clock_async,
  input wire clock_sync,
  input wire data_async,
  output reg data_sync
);

  reg A,B;
  always@(posedge clock_async)
  begin
    A <= data_async;
  end

  always@(posedge clock_sync)
  begin
    B <= A;
    data_sync <= A;
  end

endmodule
