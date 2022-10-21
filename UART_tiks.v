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
	
	
always @(posedge i_clk)
	begin
    if(contador > MODULO)
        begin
            tik_reg         = 1;
            contador    = {LEN_COUNTER{1'b0}};
        end
    else
         begin
             tik_reg        = 0;
             contador   = contador + 1'b1;
         end	
	end
	//es por flanco de bajada para que no ocurra interferencias en los bloques (ocurrian inconsistencias de duplicado)

assign o_tick = tik_reg;



endmodule
