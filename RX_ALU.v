module RX_ALU
#(
    parameter SIZE_DATA = 8
)
(
    input wire i_clk,
    input wire i_reset,
    input wire i_enable,
    input wire[(SIZE_DATA-1):0] i_operandoA,
    input wire[(SIZE_DATA-1):0] i_operandoB,
    input wire[(SIZE_DATA-1):0] i_opcode,
    output wire[(SIZE_DATA-1):0] o_operandoA,
    output wire[(SIZE_DATA-1):0] o_operandoB,
    output wire[(SIZE_DATA-1):0] o_opcode
);
Latch (SIZE_DATA) latchA (
    .i_clk(i_clk),
    .i_reset(i_reset),
    .i_enable(i_enable),
    .i_data(i_operandoA),
    .o_data(o_operandoA)
);
  
Latch (SIZE_DATA) latchB (
    .i_clk(i_clk),
    .i_reset(i_reset),
    .i_enable(i_enable),
    .i_data(i_operandoB),
    .o_data(o_operandoB)
);

Latch (SIZE_DATA) latchOPCODE (
    .i_clk(i_clk),
    .i_reset(i_reset),
    .i_enable(i_enable),
    .i_data(i_opcode),
    .o_data(o_opcode)
);

endmodule