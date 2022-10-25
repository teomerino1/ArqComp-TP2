`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.10.2022 16:54:21
// Design Name: 
// Module Name: INTERFAZ
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


module INTERFAZ
#(
    parameter  DATA_SIZE = 8 , // esto es A y B de la ALU
    parameter  TRAMA_SIZE = 8,  //esto es el tamaño del buff que recibo desde RX
    parameter  OPCODE_SIZE = 6, //es menor a SIZE_TRAMA !!
    parameter  COUNTER_LEN = 5,
    parameter  TOTAL_SIZE = ( DATA_SIZE *2 + TRAMA_SIZE) //tamaño total
    
  )
(
    input  wire i_clk,
    input  wire i_reset, 
    input  wire [(TRAMA_SIZE-1):0] i_trama_rx ,
    input  wire i_flag_rx_done,
    //input wire [(DATA_SIZE-1):0] i_alu_result,
    output wire [(DATA_SIZE-1):0] o_a,
    output wire [(DATA_SIZE-1):0] o_b,
    output wire [(OPCODE_SIZE-1):0] o_opcode, 
    output wire o_done
     
    );
    
parameter pointerA_LSB = 0;
parameter pointerA_MSB = TRAMA_SIZE-1;
 
parameter pointerB_LSB = pointerA_MSB+1 ;
parameter pointerB_MSB = pointerB_LSB+DATA_SIZE-1 ;

parameter pointerOP_LSB = pointerB_MSB+1;
parameter pointerOP_MSB = pointerOP_LSB+OPCODE_SIZE-1;


//variables locales 
reg [DATA_SIZE-1:0] a,b;
reg [OPCODE_SIZE:0] op;
reg [DATA_SIZE:0] data_transmitir;
reg [COUNTER_LEN-1:0] counter_bit;
reg [TOTAL_SIZE-1:0] buff_all;
reg done;
always @(posedge i_clk)
begin 
	if(i_reset)
	begin
		counter_bit <= 0;
		done = 0;
	end
	else
		begin
		if(i_flag_rx_done)
		begin
			buff_all<={i_trama_rx,buff_all[TOTAL_SIZE-1:TRAMA_SIZE]  }; //Empuje
			counter_bit <= counter_bit + TRAMA_SIZE ;
			done = 0;
		end
		if(counter_bit >= TOTAL_SIZE )
			begin
			counter_bit <= 0;
			a<= buff_all[pointerA_MSB:pointerA_LSB];
			b<= buff_all[pointerB_MSB:pointerB_LSB];
			op<= buff_all[pointerOP_MSB:pointerOP_LSB];
			//data_transmitir <=  i_alu_result; //YA TENGO EL DATO YA QUE LA ALU ES COMBINACIONAL
			done <= 1;
			end
		end
end

assign o_done = done;
assign o_a = a;
assign o_b = b;
assign o_opcode = op;
//assign o_data_tx = data_transmitir;

endmodule
