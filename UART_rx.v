module UART_rx
#(
    parameter SIZE_TRAMA_BIT= 8    //Size Data bits (TRAMA)
)
(
    input wire i_clk,               //Clock
    input wire i_reset,             //Reset
    input wire i_rx,                //Serial data recibida
    input wire i_tick,              //Tick
    output wire [7:0] o_buff_data,  //Buffer de datos recibidos
    output wire o_flag_rx_done      //flag de recepcion terminada
);

localparam TICK16 = 16;             //Ticks de muestreo

//ESTADOS FSMD (REPRESENTACION: One-Cold)
localparam [3:0]
    ST_IDLE     =   4'b1110,        //Estado de espera
    ST_START    =   4'b1101,        //Estado de recepcion de start bit 
    ST_DATA     =   4'b1011,        //Estado de recepcion de data bits
    ST_STOP     =   4'b0111;        //Estado de recepcion de stop bit


//VARIABLES LOCALES
reg flag_rx_done,flag_rx_done_next;               //flag de recepcion terminada
reg[3:0] state_reg, state_next;                 //Estado
reg[3:0] tiks_count,tiks_count_next;            //contador de ticks
reg[2:0] bits_count,bits_count_next;            //contador de bits
reg[7:0] buff_data,buff_data_next;              //buffer de bits


//LOGICA DE FSMD ESTADO
always @(posedge i_clk) 
begin
    if(i_reset) //reset sincronico
        begin
            /*
            En reset se inicializan las 
            variables en el estado de espera
            */
            state_reg   <=  ST_IDLE;
            tiks_count  <=  4'b0;
            bits_count  <=  3'b0;
            buff_data   <=  8'b0;
            flag_rx_done <=  1'b0;
        end
    else
        begin 
            /*
            En el resto de ciclos se actualizan
            */
            state_reg    <=  state_next; 
            tiks_count   <=  tiks_count_next;
            bits_count   <=  bits_count_next;
            buff_data    <=  buff_data_next;
            flag_rx_done <=  flag_rx_done_next;
        end
end

//LOGICA DEL SIGUIENTE ESTADO
always @(*)
    begin

        //else unificado para cada *case*
        state_next          =   state_reg; 
        tiks_count_next     =   tiks_count;
        bits_count_next     =   bits_count; 

        case(state_reg)
            ST_IDLE:
                if(~i_rx)   //bit de start == 0
                    begin
                        state_next      =   ST_START;   //cambio de estado
                        tiks_count_next =   4'b0;       //reset counter
                    end 
            ST_START: //sincronizacion a la mitad del bit (==7 tiks)
                if(i_tick)
                    if(tiks_count == (TICK16-1)) //ticks === 7?
                        begin
                            state_next      =   ST_DATA;
                            tiks_count_next =   4'b0;
                            bits_count_next =   8'b0;
                        end 
                    else 
                        tiks_count_next = tiks_count + 4'b1;
            ST_DATA:
                if(i_tick)
                    if(tiks_count   ==  (TICK16-1)) //ticks === 15? (is prox bit)
                        begin 
                            tiks_count_next = 4'b0;
                            //!obtengo un dato
                            if(bits_count == (SIZE_TRAMA_BIT-1)) //ultimo bit?
                                state_next = ST_STOP; //cambio de estado
                            else
                                bits_count_next = bits_count + 4'b1;
                        end
                    else 
                        tiks_count_next = tiks_count + 4'b1; 
            ST_STOP:
                if(i_tick)
                    if(tiks_count == (TICK16-1)) //ticks === 15? (is prox bit)
                        begin  
                            state_next= ST_IDLE;
                        end 
                    else 
                        tiks_count_next=tiks_count + 4'b1;
            default: //!Error (deberiamos crear un estado de error?)
                state_next = ST_IDLE;
        endcase
    end

//LOGICA DE SALIDA (MEALY)
always @(*)
    begin
        case(state_reg)
            ST_IDLE:
                begin
                    buff_data_next   = 8'b0; 
                    flag_rx_done_next = 1'b0;
                end
            ST_START:
                begin
                    buff_data_next   = 8'b0;
                    flag_rx_done_next = 1'b0;
                end
            ST_DATA:
                begin
                    flag_rx_done_next = 1'b0;
                    if(tiks_count   == (TICK16-1)) //ticks === 15? (is prox bit)
                        buff_data_next = {i_rx,buff_data[7:1]}; //auto shift
                    else 
                        buff_data_next = buff_data;
                end
            ST_STOP:
                begin
                    buff_data_next   = buff_data;
                    if(tiks_count == (TICK16-1))
                        flag_rx_done_next = i_rx; //only if stop bit == 1
                    else
                        flag_rx_done_next = 1'b0;
                end
            default:
                begin
                    buff_data_next   = 8'b0; //!should be code error? 
                    flag_rx_done_next = 1'b0;
                end
        
        endcase
                

    end


//cabeado de SALIDAS 
assign o_buff_data      =   buff_data;
assign o_flag_rx_done   =   flag_rx_done;

endmodule
