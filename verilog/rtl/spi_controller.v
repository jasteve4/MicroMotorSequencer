
module spi_controller(
  input wire clock,
  input wire enable_sn,
  input wire sclk,
  input wire mosi,
  input wire ss_n,
  output wire miso,
  input wire data_valid_n,
  output wire [31:0] data_out,
  input wire [31:0] data_in
);

  reg [2:0] sclk_reg;
  reg [2:0] ss_n_reg;
  reg [2:0] mosi_reg;
  reg [31:0] spi_data;
  wire sclk_rising_edge;
  wire ss_n_enable;
  wire mosi_data;

  always@(posedge clock)
  sclk_reg <= {sclk_reg[1:0],sclk};

  always@(posedge clock)
  ss_n_reg <= {ss_n_reg[1:0],ss_n};

  always@(posedge clock)
  mosi_reg <= {mosi_reg[1:0],mosi};

  assign sclk_rising_edge = (sclk_reg[2:1] == 2'b01);
  assign ss_n_enable = (ss_n_reg[2:1] == 3'b11);
  assign mosi_data = (mosi_reg[2:1] == 3'b11);

  always@(posedge clock)
  begin
    case({enable_sn,ss_n_enable,data_valid_n})
      3'b000: spi_data <= sclk_rising_edge ? {spi_data[30:0],mosi_data} : spi_data;
      3'b001: spi_data <= sclk_rising_edge ? {spi_data[30:0],mosi_data} : spi_data;
      3'b001: spi_data <= sclk_rising_edge ? {spi_data[30:0],mosi_data} : spi_data;
      3'b010: spi_data <= data_in;
      3'b011: spi_data <= spi_data;
      default: spi_data <= 32'hDEADBEEF;
    endcase
  end


  assign data_out = spi_data;
  assign miso = spi_data[31];


endmodule
