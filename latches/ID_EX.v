
module ID_EX
#(
    parameter   SIZE_DATA = 8      // bits number of data
)
(
    input wire i_clk,
    input wire i_reset,
    input wire i_enable,
    input wire[(SIZE_DATA-1):0] i_rd,
    input wire[(SIZE_DATA-1):0] i_rs,
    input wire[(SIZE_DATA-1):0] i_rt,
    input wire[(SIZE_DATA-1):0] i_rd_value,
    input wire[(SIZE_DATA-1):0] i_rs_value,
    input wire[(SIZE_DATA-1):0] i_rt_value,
    input wire[(SIZE_DATA-1):0] i_alu_result,
    input wire[(SIZE_DATA-1):0] i_alu_result_value,
    output wire[(SIZE_DATA-1):0] o_rd,
    output wire[(SIZE_DATA-1):0] o_rs,
    output wire[(SIZE_DATA-1):0] o_rt,
    output wire[(SIZE_DATA-1):0] o_rd_value,
    output wire[(SIZE_DATA-1):0] o_rs_value,
    output wire[(SIZE_DATA-1):0] o_rt_value,
    output wire[(SIZE_DATA-1):0] o_alu_result,
    output wire[(SIZE_DATA-1):0] o_alu_result_value
);
    //Variables locales
    reg[(SIZE_DATA-1):0] rd_reg;
    reg[(SIZE_DATA-1):0] rs_reg;
    reg[(SIZE_DATA-1):0] rt_reg;
    reg[(SIZE_DATA-1):0] rd_value_reg;
    reg[(SIZE_DATA-1):0] rs_value_reg;
    reg[(SIZE_DATA-1):0] rt_value_reg;
    reg[(SIZE_DATA-1):0] alu_result_reg;
    reg[(SIZE_DATA-1):0] alu_result_value_reg;
    //Asignaciones
    always @(posedge i_clk)
    begin
        if (i_reset)
        begin
            rd_reg <= 0;
            rs_reg <= 0;
            rt_reg <= 0;
            rd_value_reg <= 0;
            rs_value_reg <= 0;
            rt_value_reg <= 0;
            alu_result_reg <= 0;
            alu_result_value_reg <= 0;
        end
        else if (i_enable)
        begin
            rd_reg <= i_rd;
            rs_reg <= i_rs;
            rt_reg <= i_rt
            rd_value_reg <= i_rd_value;
            rs_value_reg <= i_rs_value;
            rt_value_reg <= i_rt_value;
            alu_result_reg <= i_alu_result;
            alu_result_value_reg <= i_alu_result_value;
        end
    end
    //Salidas
    assign o_rd = rd_reg;
    assign o_rs = rs_reg;
    assign o_rt = rt_reg;
    assign o_rd_value = rd_value_reg;
    assign o_rs_value = rs_value_reg;
    assign o_rt_value = rt_value_reg;
    assign o_alu_result = alu_result_reg;
    assign o_alu_result_value = alu_result_value_reg;


endmodule
