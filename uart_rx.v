`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.10.2022 15:31:34
// Design Name: 
// Module Name: uart_rx
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


module uart_tx
#(
    parameter DBIT = 8, // data bit
            SB_TICK = 16 
)
(
    input wire clk, reset,
    input wire tx_start, s_tick,
    input wire [7:0] din,           // data in
    output reg tx_done_tick,
    output wire tx
);
// Local parameters
localparam
    ST_IDLE = 2'b00,
    ST_START = 2'b01,
    ST_DATA = 2'b10,
    ST_STOP = 2'b11;

// Local variables
reg [1:0] state_reg, state_next;//estado
reg [3:0] s_reg, s_next;        //contador de ticks
reg [2:0] n_reg, n_next;        //contador de bits
reg [7:0] b_reg, b_next;        //buffer de bits
reg tx_reg, tx_next;            //salida


//body
//FSMD state 

always @ (posedge clk or posedge reset)
begin
    if (reset)
    begin
        state_reg <= ST_IDLE;
        s_reg <= 4'b0000;
        n_reg <= 3'b000;
        b_reg <= 8'b00000000;
        tx_reg <= 1'b1; //~start
    end
    else
    begin
        state_reg <= state_next;
        s_reg <= s_next;
        n_reg <= n_next;
        b_reg <= b_next;
        tx_reg <= tx_next;
    end
end

//logic next state
always @ (*)
begin
    state_next = state_reg;
    tx_done_tick = 1'b0;
    s_next = s_reg;
    n_next = n_reg;
    b_next = b_reg;
    tx_next = tx_reg;
    case(state_reg)
        ST_IDLE:
        begin
            tx_next = 1'b1; //~start
            if (tx_start)
            begin
                state_next = ST_START;
                s_next = 4'b0000; //reset count tiks
                b_next = din;  //buffer data
                tx_next = 1'b0; //bit start
            end
        end
        ST_START:
        begin
            tx_next = 1'b0; 
            if(s_tick)
            begin
                if (s_reg == 15) 
                begin
                    state_next = ST_DATA;
                    s_next = 4'b0000; //reset count tiks
                    n_next = 3'b000; //reset count bits
                end
                else
                begin
                    s_next = s_reg + 1;
                end
            end
        end
        ST_DATA:
        begin
            tx_next = b_reg[0];
            if (s_tick)
            begin
                if (s_reg == 15)
                begin
                    s_next = 0; //reset count tiks
                    b_next = b_reg >> 1; //shift buffer
                    if (n_reg == (DBIT-1)) //termine de enviar los bits ?
                    begin
                        state_next = ST_STOP;
                    end
                    else
                    begin
                        n_next = n_reg + 1;
                        
                    end
                end
                else
                begin
                    s_next = s_reg + 1; //incremento el contador de ticks
                end
            end
        end
        ST_STOP:
        begin
            tx_next = 1'b1; //bit de stop es un 1
            if (s_tick)
            begin
                if (s_reg == (SB_TICK -1 ))
                begin
                    state_next = ST_IDLE;
                    tx_done_tick = 1'b1; //flag indico que termine de enviar
                end
                else
                begin
                    s_next = s_reg + 1;
                end
            end
        end
    endcase
end
assign tx = tx_reg;
endmodule
