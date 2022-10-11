module UART_tx
#(
    parameter SIZE_TRAMA_BIT = 8 // len TRAMA of bit
)
(
    input wire i_clk,               //Clock
    input wire i_reset,             //Reset
    input wire i_tx_start,          //Start bit
    input wire i_tick,              //Tick
    input wire [7:0] i_buff_data,   //Buffer de datos recibidos
    output wire o_tx,               //Serial data transmitida
    output wire o_flag_tx_done      //"flag" de transmisión terminada
);

localparam TICKS_PER_BIT = 15;             //Ticks de muestreo - 1

//ESTADOS FSMD (REPRESENTACION: One-Cold)
localparam [3:0]
    ST_IDLE     =   4'b1110,        //Estado de espera
    ST_START    =   4'b1101,        //Estado de transmision de start bit 
    ST_DATA     =   4'b1011,        //Estado de transmision de data bits
    ST_STOP     =   4'b0111;        //Estado de transmision de stop bit


//VARIABLES LOCALES
reg      tx_reg,        tx_next;          //dato a transmitir
reg      flag_tx_done,  reg_tx_done_next; //"flag" de transmisión terminada
reg[3:0] state_reg,     state_next;       //Estado
reg[3:0] tiks_count,    tiks_count_next;  //contador de ticks
reg[2:0] bits_count,    bits_count_next;  //contador de bits
reg[7:0] buff_data,     buff_data_next;   //buffer de bits por transmitir


//LOGICA DE FSMD ESTADO
always @ (posedge i_clk)
begin
    if (i_reset) //reset sincronico
    begin
        state_reg     <= ST_IDLE;
        tiks_count    <= 4'b0;
        bits_count    <= 3'b0;
        buff_data     <= 8'b0;
        tx_reg        <= 1'b1; //~start
    end
    else
    begin
        state_reg       <= state_next;
        tiks_count      <= tiks_count_next;
        bits_count      <= bits_count_next;
        buff_data       <= buff_data_next;
        flag_tx_done    <= reg_tx_done_next;
        tx_reg          <= tx_next;
    end
end

//LOGICA DEL SIGUIENTE ESTADO
always @(*)
begin

    //else unificado para cada *case*
    state_next      = state_reg; 
    tiks_count_next = tiks_count;
    bits_count_next = bits_count;
    buff_data_next  = buff_data;
    //! tx_next = 0;

    case(state_reg)
        ST_IDLE:
            begin
                //! tx_next = 1'b1; //~start
                if (i_tx_start)
                begin
                    state_next          = ST_START;
                    tiks_count_next     = 4'b0;         //reset count tiks
                    buff_data_next      = i_buff_data;  //almacena el dato a transmitir
                    //! tx_next  = 1'b0;         //start bit
                end
            end
        ST_START:
        begin
            //! tx_next = 1'b0; 
            if(i_tick)
            begin
                if (tiks_count == TICKS_PER_BIT) 
                    begin
                        state_next      = ST_DATA;
                        tiks_count_next = 4'b0; //reset count tiks
                        bits_count_next = 3'b0; //reset count bits
                    end
                else
                    tiks_count_next = tiks_count + 4'b1;
            end
        end
        ST_DATA:
        begin
            //! tx_next = buff_data[0];
            if (i_tick)
            begin
                if (tiks_count == TICKS_PER_BIT)
                    begin
                        tiks_count_next = 4'b0;                 //reset count tiks
                        buff_data_next  = buff_data >> 1;       //shift buffer 
                        if (bits_count == (SIZE_TRAMA_BIT-1))   //termine de enviar los bits ?
                                state_next = ST_STOP;
                        else
                            bits_count_next = bits_count + 4'b1;
                    end
                else 
                    tiks_count_next = tiks_count + 4'b1; //incremento el contador de ticks
            end
        end
        ST_STOP:
        begin
            //! tx_next = 1'b1; //bit de stop es un 1
            if (i_tick)
            begin
                if (tiks_count == TICKS_PER_BIT)
                begin
                    state_next = ST_IDLE;
                    //! o_flag_tx_done = 1'b1; //flag indico que termine de enviar
                end
                else 
                    tiks_count_next = tiks_count + 4'b1; 
            end
        end
        default: 
            state_next = ST_IDLE; 
    endcase
end

//LOGICA DE SALIDA (Mealy)
always @(*)
    begin
        case(state_reg)
            ST_IDLE:
                begin
                    tx_next   = ~i_tx_start; //bit de start es un 0
                    flag_tx_done_next = 1'b0;
                end
            ST_START:
                begin
                    tx_next   = 1'b0; //bit de start es un 0
                    flag_tx_done_next = 1'b0;
                end
            ST_DATA:
                begin
                    tx_next = buff_data[0]; //proximo bit por transmitir
                    flag_tx_done_next = 1'b0;
                end
            ST_STOP:
                begin
                   tx_next = 1'b1; //bit de stop es un 1
                    if (tiks_count == TICKS_PER_BIT)
                        reg_rx_done_next = 1'b1; //flag indico que termine de enviar
                    else
                        reg_rx_done_next = 1'b0;
                end
            default:
                begin
                    tx_next = 1'b1; //error (nunca queremos un 0 aca o podriamos comenzar una transmision erronea)
                    flag_tx_done_next = flag_tx_done;
                end
        
        endcase
                

//Cableado de salida
assign o_tx = tx_reg;
assign o_flag_tx_done = flag_tx_done;

endmodule
