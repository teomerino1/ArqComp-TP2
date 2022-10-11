module MEM_WB
#(
    parameter SIZE_DATA = 8
)
(
    input wire i_clk,
    input wire i_reset,
    input wire i_enable,
    input wire[(SIZE_DATA-1):0] i_rd,
    input wire[(SIZE_DATA-1):0] i_rd_value,
    input wire[(SIZE_DATA-1):0] i_alu_result,
    input wire[(SIZE_DATA-1):0] i_alu_result_value,
    output wire[(SIZE_DATA-1):0] o_rd,
    output wire[(SIZE_DATA-1):0] o_rd_value,
    output wire[(SIZE_DATA-1):0] o_alu_result,
    output wire[(SIZE_DATA-1):0] o_alu_result_value
);
    //Variables locales
    reg[(SIZE_DATA-1):0] rd_reg;
    reg[(SIZE_DATA-1):0] rd_value_reg;
    reg[(SIZE_DATA-1):0] alu_result_reg;
    reg[(SIZE_DATA-1):0] alu_result_value_reg;
    //Asignaciones
    always @(posedge i_clk)
    begin
        if (i_reset)
        begin
            rd_reg <= 0;
            rd_value_reg <= 0;
            alu_result_reg <= 0;
            alu_result_value_reg <= 0;
        end
        else if (i_enable)
        begin
            rd_reg <= i_rd;
            rd_value_reg <= i_rd_value;
            alu_result_reg <= i_alu_result;
            alu_result_value_reg <= i_alu_result_value;
        end
    end
    //Salidas
    assign o_rd = rd_reg;
    assign o_rd_value = rd_value_reg;
    assign o_alu_result = alu_result_reg;
    assign o_alu_result_value = alu_result_value_reg;
endmodule