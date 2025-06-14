`timescale 1ns/1ps
`include "Baud_Generator"


module BaudTest;
//  Regs to drive the inputs
reg  reset_n;
reg   clock;
reg [1:0] baud_rate;
//  wires to show the outputs
wire      baud_clk;

//  Instance of the design module
BaudGenT ForTest(
    .reset_n(reset_n),
    .clock(clock),
    .baud_rate(baud_rate),
    
    .baud_clk(baud_clk)
);

// waveform of the baud_clk
initial
begin
    $dumpfile("BaudTest.vcd");
    $dumpvars;
end

//  System's Clock 50MHz
initial begin
                clock = 1'b0;
    forever #10 clock = ~clock;
end

//  Resetting the system
initial begin
        reset_n = 1'b0;
    #100  reset_n = 1'b1;
end

  // Real time monitoring of values and transition of baud_clk in terminal 
initial
  begin
    $monitor("t = %t , baud_rate = %b , baud_clk = %b" , $time , baud_rate , baud_clk);
  end 
//  Test
integer i = 0;
initial 
begin
    //  Testing for all the rates available
    for (i = 0; i < 4; i = i +1) 
    begin
        baud_rate = i;
        //  enough time for about 4 cycles for each baud rate
        #(1680000/(i+1));
    end
end

//  finish
initial begin
    #3500000 $finish;
    // Simulation for 4 ms
end

endmodule
