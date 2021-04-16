/*
    Models for the different registers in the circuit
    PC register and the different Pipeline registers
*/

module register_32_bit (clk, rst, reg_d, reg_q);
    input clk, rst;
    input [31:0] reg_d;
    output reg [31:0] reg_q;

  always @(posedge clk or posedge rst) begin
    if(rst == 1)
      reg_q <= 0;
    else
      reg_q <= reg_d;
  end
endmodule

module register_5_bit (clk, rst, reg_d, reg_q);
    input clk, rst;
    input [4:0] reg_d;
    output reg [4:0] reg_q;

  always @(posedge clk or posedge rst) begin
    if(rst == 1)
      reg_q <= 0;
    else
      reg_q <= reg_d;
  end
endmodule

module register_1_bit (clk, rst, reg_d, reg_q);
    input clk, rst;
    input reg_d;
    output reg reg_q;

  always @(posedge clk or posedge rst) begin
    if(rst == 1)
      reg_q <= 0;
    else
      reg_q <= reg_d;
  end
endmodule

module register_2_bit (clk, rst, reg_d, reg_q);
    input clk, rst;
    input [1:0] reg_d;
    output reg [1:0] reg_q;

  always @(posedge clk or posedge rst) begin
    if(rst == 1)
      reg_q <= 0;
    else
      reg_q <= reg_d;
  end
endmodule

module register_32_bit_write (clk, rst, wrt, reg_d, reg_q);
    input clk, rst, wrt;
    input [31:0] reg_d;
    output reg [31:0] reg_q;

  always @(posedge clk or posedge rst) begin
    if(rst == 1)
      reg_q <= 0;
    else if (!wrt)      // written only if wrt = 0
      reg_q <= reg_d;
  end
endmodule

module register_32_bit_write_flush (clk, rst, wrt, flush, reg_d, reg_q);
    input clk, rst, wrt, flush;
    input [31:0] reg_d;
    output reg [31:0] reg_q;

  always @(posedge clk or posedge rst) begin
    if((rst == 1) || (flush == 1))
      reg_q <= 0;
    else if (!wrt)      // written only if wrt = 0
      reg_q <= reg_d;
  end
endmodule

module register_1_bit_flush (clk, rst, flush, reg_d, reg_q);
    input clk, rst, flush;
    input reg_d;
    output reg reg_q;

  always @(posedge clk or posedge rst) begin
    if((rst == 1) || (flush == 1))
      reg_q <= 0;
    else
      reg_q <= reg_d;
  end
endmodule

module register_2_bit_flush (clk, rst, flush, reg_d, reg_q);
    input clk, rst, flush;
    input [1:0] reg_d;
    output reg [1:0] reg_q;

  always @(posedge clk or posedge rst) begin
    if((rst == 1) || (flush == 1))
      reg_q <= 0;
    else
      reg_q <= reg_d;
  end
endmodule