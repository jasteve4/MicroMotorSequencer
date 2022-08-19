
module dot_driver(
  input   wire  clock,
  //input   wire  reset_n,
  input   wire  dot_enable,
  input   wire  output_enable,
  input   wire  dot_state,
  input   wire  dot_invert,
  output  reg   data,
  output  reg   enable
);
 
  always@(posedge clock)
  begin
    /*case({reset_n,dot_enable})
      2'b11   : data <= dot_invert ? ~dot_state : dot_state;
      default : data <= 1'b0;
    endcase*/
    //case(dot_enable)
      data <= dot_invert ? ~dot_state : dot_state;
      //1'b0 : data <= 1'b0;
    //endcase
  end

  always@(posedge clock)
  begin
    /*case({reset_n,dot_enable,output_enable})
      3'b111   : enable <= dot_enable;
      default : enable <= 1'b0;
    endcase*/
    case({dot_enable,output_enable})
      2'b11   : enable <= dot_enable;
      default : enable <= 1'b0;
    endcase
  end


endmodule
