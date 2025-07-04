module BaudGenT(
    input wire         reset_n,           //  Active low reset.
    input wire         clock,             //  The System's main clock.
    input wire  [1:0]  baud_rate,         //  Baud Rate agreed upon by the Tx and Rx units.

    output reg         baud_clk           //  Clocking output for the other modules.
);

//  Internal declarations
reg [13 : 0] clock_ticks;
reg [13 : 0] final_value;

//  Encoding for the Baud Rates states
 parameter BAUD24  = 2'b00,
           BAUD48  = 2'b01,
           BAUD96  = 2'b10,
           BAUD192 = 2'b11;

//  BaudRate 4-1 Mux
always @(*)
begin
    case (baud_rate)
        //  clock frequency = 50MHz Clock,  prescaler = 2 (it ensures the final value under the hardware limit)          
      
/* Formula of (no. of clock ticks required for single transition of baud_clk) = Clock Frequency / (baud_rate * prescaler) */
      
        BAUD24 : final_value = 14'd10417;  //  ratio ticks for the 2400 BaudRate.
        BAUD48 : final_value = 14'd5208;   //  ratio ticks for the 4800 BaudRate.
        BAUD96 : final_value = 14'd2604;   //  ratio ticks for the 9600 BaudRate.
        BAUD192 : final_value = 14'd1302;  //  ratio ticks for the 19200 BaudRate.
        default: final_value = 14'd0;      //  The systems original Clock.
    endcase
end

//  Timer logic
always @(negedge reset_n, posedge clock)
begin
    if(!reset_n)
    begin
        clock_ticks <= 14'd0; 
        baud_clk    <= 1'b0; 
    end
    else
    begin
        if (clock_ticks == final_value)
        begin
            clock_ticks <= 14'd0; 
            baud_clk    <= ~baud_clk; 
        end 
        else
        begin
            clock_ticks <= clock_ticks + 1'd1;
            baud_clk    <= baud_clk;
        end
    end 
end

endmodule
