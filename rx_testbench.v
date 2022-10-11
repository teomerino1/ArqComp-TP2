`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.10.2022 17:21:04
// Design Name: 
// Module Name: rx_testbench
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


module rx_testbench(

    );
    
reg i_clock, reset,i_rx, i_tick;
wire [7:0] o_buff_data;  //Buffer de datos recibidos
wire o_flag_rx_done;      //flag de recepcion terminada
localparam SIZE_TRAMA_BIT= 8 ;   //Size Data bits (TRAMA)

UART_rx #(SIZE_TRAMA_BIT)myRx (i_clock, reset,i_rx, i_tick,o_buff_data,o_flag_rx_done);


    
    initial
    begin
    i_clock=1'b0;
    #100
    i_clock=1'b1;
    i_rx=1'b1;
    i_tick = 0;
    
    reset = 1;
    #20 
    
    i_clock=1'b0;
    #20 
    i_clock=1'b1;
    
    
    
    #20
    reset = 0;
     i_clock=1'b0;
    #20 
    i_clock=1'b1;
    //todo incializad 
    
    
    #20
    //eSTADO DILE
    //start
    i_rx=1'b0;
    
     i_clock=1'b0;
    #20 
    i_clock=1'b1;
    
    #20
    //ESTADO START
    //mandamos tik
    
    i_tick = 1'b1;
    #20
    i_clock=1'b0;
    #20 
    i_clock=1'b1;
    #20
    i_tick = 0;
    //ESTADO DATA
    #20
    i_rx=1'b1;
    
    i_clock=1'b0;
    #20 
    i_clock=1'b1;
    #20
      i_tick = 1'b1;
    #20
    i_clock=1'b0;
    #20 
    i_clock=1'b1;
    #20
    i_tick = 0;
   
   //ESTADO STOP   
    i_clock=1'b0;
    #20
    i_clock=1'b1;
    #20
    i_rx=1'b1;
    #20 
      i_tick = 1;
    #20
    i_clock=1'b0;
    #20 
    i_clock=1'b1;
    #20
    i_tick = 0;
     i_clock=1'b0;
    #200 
    i_clock=1'b1;
    end
endmodule
