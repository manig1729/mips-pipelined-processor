/*
	5 bit 2:1 MUX
    32 bit 2:1 MUX
    32 bit 3:1 MUX (for forwarding)
*/

module MUX_5bit (a, b, Sel, mux_out);

    input [4:0] a, b;
    input Sel;
    output [4:0] mux_out;

	assign mux_out = Sel?b:a;

endmodule

module MUX_32bit (a, b, Sel, mux_out);

    input [31:0] a, b;
    input Sel;
    output [31:0] mux_out;

	assign mux_out = Sel?b:a;

endmodule

module MUX_3_1 (a, b, c, Sel, mux_out);

    input [31:0] a, b, c;
    input [1:0] Sel;
    output reg [31:0] mux_out;

    always @(*) begin

        case(Sel)
            2'b00 : mux_out = a;
            2'b01 : mux_out = b;
            2'b10 : mux_out = c;
        endcase

    end
endmodule