module UART_tiks
#(
    parameter   FR_COCK_HZ = 50000000,      // frecuencia del clock 50 Mhz
    parameter   BAUDRATE = 19200,     // BAUDRATE parametriazable
    parameter   LEN_COUNTER = 8             // numero de bits de la trama
)
(
    input  wire i_clk,
    input  wire i_reset, 
    output wire o_tick
    
);
    
//variables locales
localparam MODULO = FR_COCK_HZ / (BAUDRATE * 16);
reg [LEN_COUNTER-1:0]   contador = {LEN_COUNTER{1'b0}};
reg  tik_reg;

	

//generador de tiks
always @(posedge i_clk ) //!or posedge i_reset (Es mejor sincronico o asincronico?)
begin 
    if (i_reset) contador <= {LEN_COUNTER{1'b0}}; //Reset counter sincronico
    else if (tik_reg) contador <= {LEN_COUNTER{1'b0}}; //Reset counter cuando se detecta un tik 
    else contador <= contador +  1'b1; //Increment counter
end

//cableado de salidas
always @(*) tik_reg = (contador == MODULO); 
assign o_tick = tik_reg;



endmodule