`timescale 1ns / 1ps

module MAIN
	#( 
       parameter DATA_SIZE    = 8,
       parameter TRAMA_SIZE   = 8,
	   parameter OPCODE_SIZE  = 6
    )
	(
        input wire i_clock,
        input wire i_reset,
        input wire i_rx,
        output wire o_tx,
        output wire o_tx_done_tick
     );

wire [DATA_SIZE -1:0] dataALU;
wire [DATA_SIZE -1:0] dataA ;
wire [DATA_SIZE -1:0] dataB;
wire [OPCODE_SIZE -1:0] dataOpcode;
wire [TRAMA_SIZE -1:0] trama;
wire rx_done_tick_wire;
wire tx_start_wire;

UART UART_instance(.i_clk(i_clock),
		   .i_reset(i_reset),
		   .i_rx(i_rx),
		   .i_tx(dataALU), 
		   .i_tx_start(tx_start_wire),
		   .o_rx(trama),
		   .o_rx_done_tick(rx_done_tick_wire),
		   .o_tx(o_tx),
		   .o_tx_done_tick(o_tx_done_tick));

INTERFAZ interfaz (.i_clk(i_clock),
                             .i_reset(i_reset),
                             .i_flag_rx_done(rx_done_tick_wire),
                             .i_trama_rx(trama),
                             .o_a(dataA ),
                             .o_b(dataB),
                             .o_opcode(dataOpcode),
                             .o_done(tx_start_wire));

ALU alu_instance(.i_a_alu(dataA ),
                 .i_b_alu(dataB),
                 .i_opcode_alu(dataOpcode),
                 .o_res_alu(dataALU));

endmodule