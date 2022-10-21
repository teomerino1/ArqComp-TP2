module UART_rx
#(
    parameter SIZE_TRAMA_BIT= 8,    //Size Data bits (TRAMA) (NO CAMBIAR )
    parameter SIZE_BIT_COUNTER = 3  //tamaño del contadoe de bits
)
(
    input wire i_clk,               //Clock
    input wire i_reset,             //Reset
    input wire i_rx,                //Serial data recibida
    input wire i_tick,              //Tick
    output wire [(SIZE_TRAMA_BIT-1):0] o_buff_data,  //Buffer de datos recibidos
    output wire o_flag_rx_done      //flag de recepcion terminada
);

localparam TICK16 = 16;             //Ticks de muestreo
localparam TICK7 = 7;             //Ticks de sinc


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
reg[(SIZE_BIT_COUNTER-1):0] bits_count,bits_count_next;            //contador de bits
reg[(SIZE_TRAMA_BIT-1):0] buff_data,buff_data_next;              //buffer de bits


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
            tiks_count  <=  0;
            bits_count  <=  0;
            buff_data   <=  0;
            flag_rx_done <= 0;
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
            begin
                buff_data_next   = 0; 
                flag_rx_done_next = 0;
                if(~i_rx)   //bit de start == 0
                    begin
                        state_next      =   ST_START;   //cambio de estado
                        tiks_count_next =   0;       //reset counter
                    end 
              end
            ST_START: //sincronizacion a la mitad del bit (==7 tiks)
                if(i_tick)
                begin 
                    buff_data_next   = 0;
                    flag_rx_done_next = 0; 
                    if(tiks_count == (TICK7-1)) //ticks === 7?
                        begin
                            state_next      =   (!i_rx)? ST_DATA : ST_IDLE ; //chequa que bit start = 0
                            tiks_count_next =   0;
                            bits_count_next =   0;
                        end 
                    else 
                        tiks_count_next = tiks_count + 1;
                 end
            ST_DATA: 
                if(i_tick)
                 begin
                   
                    if(tiks_count   ==  (TICK16-1)) //ticks === 15? (is prox bit)
                        begin 
                            buff_data_next = {i_rx,buff_data[(SIZE_TRAMA_BIT-1):1]}; //auto shift
                            tiks_count_next = 0;
                            //!obtengo un dato
                            if(bits_count == (SIZE_TRAMA_BIT-1)) //ultimo bit?
                                state_next = ST_STOP; //cambio de estado
                            else
                                bits_count_next = bits_count +1;
                        end
                    else
                        begin 
                            buff_data_next = buff_data;
                            tiks_count_next = tiks_count + 1; 
                        end
                  end 
            ST_STOP: 
                if(i_tick)
                begin
                    if(tiks_count == (TICK16-1)) //ticks === 15? (is prox bit)
                        begin
                            flag_rx_done_next = i_rx; //only if stop bit == 1
                            state_next= ST_IDLE;
                        end 
                    else
                        tiks_count_next=tiks_count +1;
                    
                end
            default: //!Error (deberiamos crear un estado de error?)
                begin
                state_next = ST_IDLE;
                buff_data_next   = 0; //!should be code error? 
                flag_rx_done_next = 0;
                end
        endcase
    end



//cabeado de SALIDAS 
assign o_buff_data      =   buff_data;
assign o_flag_rx_done   =   flag_rx_done;

endmodule
