module IODriver(
  output wire out,
  input wire en_n,
  input wire in
);

 assign out = en_n ? 1'bz : in; 

endmodule
