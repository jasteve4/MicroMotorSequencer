module HBrigeDriver(
  output wire p_out,
  output wire n_out,
  input wire en_n,
  input wire in
);

 assign n_out = en_n ? 1'b0 : in ? 1'b0 : 1'b1; 
 assign p_out = en_n ? 1'b1 : in ? 1'b0 : 1'b1; 

endmodule
