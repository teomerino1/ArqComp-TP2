`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/21/2022 09:55:48 AM
// Design Name: 
// Module Name: UART
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


module UART

#(

parameter  DATA_SIZE = 8  , // esto es A y B de la ALU
parameter  TRAMA_SIZE = 8,  //esto es el tamaño del buff que recibo desde RX
parameter LEN_BIT_COUNTER_RX=3,
parameter  OPCODE_SIZE = 6, //es menor a SIZE_TRAMA !!
parameter  COUNTER_LEN_INTERF = 5,
parameter  TOTAL_SIZE = ( DATA_SIZE *2 + TRAMA_SIZE),//tamaño total
parameter FR_COCK_HZ=4000,
parameter BAUDRATE=100,
parameter LEN_COUNTER_TIKS=8

)
(
input wire i_clock, i_reset,
input wire i_tx,
output wire o_tx,o_flag_tx_done
);
    
       
wire [7:0] a,b,resul_alu;
wire [5:0] op;    
wire [7:0] buff_data;  //Buffer de TRAMA recibidos
wire done_int,i_tick;
wire flag_rx_done;      //flag de recepcion terminada


UART_tiks #(FR_COCK_HZ,BAUDRATE,LEN_COUNTER_TIKS) tick_generator (.i_clk(i_clock),.i_reset(i_reset),.o_tick(i_tick));
UART_rx #(TRAMA_SIZE,LEN_BIT_COUNTER_RX)myRx (i_clock, i_reset,i_tx, i_tick,buff_data,flag_rx_done);
INTERFAZ #(DATA_SIZE,TRAMA_SIZE,OPCODE_SIZE,COUNTER_LEN_INTERF,TOTAL_SIZE) my_int (i_clock, i_reset,buff_data,flag_rx_done,a,b,op,done_int);
ALU #(DATA_SIZE) my_alu (a,b,op,resul_alu);
UART_tx #(TRAMA_SIZE,LEN_BIT_COUNTER_RX)myTx (i_clock, i_reset,done_int,i_tick,resul_alu,o_tx,o_flag_tx_done);
endmodule

