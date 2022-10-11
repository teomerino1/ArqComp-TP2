/*
    Latches are level-sensitive (not edge-sensitive) circuits, so in an always block, they use level-sensitive sensitivity lists.
    However, they are still sequential elements, so should use non-blocking assignments.
    A D-latch acts like a wire (or non-inverting buffer) when enabled, and preserves the current value when disabled.
*/
module Latch 
#(
    parameter SIZE_DATA = 8         //bits number of data
)
(   input wire[SIZE_DATA] i_dData,  // 1-bit input pin for data  
    input wire i_enable,            // 1-bit input pin for enabling the latch  
    input wire i_reset,             // 1-bit input pin for active-high i_reset   //! hay que usar low?
    output wire[SIZE_DATA] o_qData  // 1-bit output pin for data output  
);     


    //Variables locales
    reg[SIZE_DATA] data_reg; // 1-bit register for data

    //logica de latcheado
    always @(i_clk)
    begin
        if (i_reset) data_reg <= 0;
        else if (i_enable) data_reg <= i_dData; //activado actua como un "wire" 
        else data_reg <= data_reg; //desactivado prevalece el valor (no hace nada)
    end

    //cableado de salidas
    assign o_qData = data_reg;
endmodule  