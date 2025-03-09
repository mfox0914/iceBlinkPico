`timescale 1ns/1ps
`include "top.sv"

module top_tb;

    logic clk = 0;
    logic RGB_R;
    logic RGB_G;
    logic RGB_B;

    // Instantiate the top module instead of color_fade
    top uut (
        .clk(clk),
        .RGB_R(RGB_R),
        .RGB_G(RGB_G),
        .RGB_B(RGB_B)
    );

    // Generate clock signal
    always begin
        #41.6667 clk = ~clk; // Approximate 24 MHz clock
    end

    initial begin
        clk = 0;
        $dumpfile("top.vcd");
        $dumpvars(0, top_tb);
        #1000000000; // Run long enough to observe PWM transitions
        $finish;
    end

endmodule


