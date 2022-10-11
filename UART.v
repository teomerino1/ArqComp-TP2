`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.10.2022 15:31:34
// Design Name: 
// Module Name: uart
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module uart
#(
    parameter SIZE_DATA = 8
)
(
    input wire i_clk,
    input wire i_reset,
    input wire i_rx,
    output wire o_tx,
    output wire o_tx_value
);
    //Variables locales
    reg[(SIZE_DATA-1):0] tx_reg;
    reg[(SIZE_DATA-1):0] tx_value_reg;
    //Asignaciones
    always @(posedge i_clk)
    begin
        if (i_reset)
        begin
            tx_reg <= 0;
            tx_value_reg <= 0;
        end
        else if (i_enable)
        begin
            tx_reg <= i_rx;
            tx_value_reg <= i_rx;
        end
    end
    //Salidas
    assign o_tx = tx_reg;
    assign o_tx_value = tx_value_reg;
);
endmodule
