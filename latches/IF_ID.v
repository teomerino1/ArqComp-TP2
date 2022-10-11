module IF_ID
#(
    parameter SIZE_DATA = 8
)
(
    input wire i_clk,
    input wire i_reset,
    input wire i_enable,
    input wire[(SIZE_DATA-1):0] i_pc,
    input wire[(SIZE_DATA-1):0] i_pc_value,
    output wire[(SIZE_DATA-1):0] o_pc,
    output wire[(SIZE_DATA-1):0] o_pc_value
);
    //Variables locales
    reg[(SIZE_DATA-1):0] pc_reg;
    reg[(SIZE_DATA-1):0] pc_value_reg;
    //Asignaciones
    always @(posedge i_clk)
    begin
        if (i_reset)
        begin
            pc_reg <= 0;
            pc_value_reg <= 0;
        end
        else if (i_enable)
        begin
            pc_reg <= i_pc;
            pc_value_reg <= i_pc_value;
        end
    end
    //Salidas
    assign o_pc = pc_reg;
    assign o_pc_value = pc_value_reg;
endmodule