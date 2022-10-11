
module interface
	#(  parameter NB_INPUTS = 8,
        parameter NB_OUTPUTS = 8,
        parameter NB_OP = 6,
        parameter NB_COUNT = 2)
	(   input wire                  i_clock,
        input wire                  i_reset,
        input wire                  i_valid, //rx_done
        input wire  signed [NB_INPUTS-1:0]  i_data,
        output wire signed [NB_OUTPUTS-1:0] o_data_a,
        output wire signed [NB_OUTPUTS-1:0] o_data_b,
        output wire [NB_OP-1:0]      o_operation,
        output wire o_transmit
);

reg [NB_OUTPUTS-1:0]    data_a;
reg [NB_OUTPUTS-1:0]    data_b;
reg [NB_OP-1:0]         operation;
reg [NB_COUNT-1:0]      counter;

always@(posedge i_clock)begin
    if(i_reset)begin
        data_a      <= {NB_OUTPUTS{1'b0}};
        data_b      <= {NB_OUTPUTS{1'b0}};
        operation   <= {NB_OP{1'b0}};
        counter     <= {NB_COUNT{1'b0}};
    end
    else begin
        if(i_valid) begin 
            if(counter == 0)begin
                data_a <= i_data;
            end
            if(counter == 1)begin
                data_b <= i_data;
            end
            if(counter == 2)begin
                operation <= i_data[NB_OP-1:0];
            end

            counter <= counter + 1;
        end

        if(counter == 3)
            counter <= 0;
    end
end

assign o_data_a     = data_a;
assign o_data_b     = data_b;
assign o_operation  = operation;
assign o_transmit = (counter == 3)? 1'b1 : 1'b0;

endmodule