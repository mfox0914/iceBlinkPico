`include "color_fade.sv"
`include "pwm.sv"

module top (
    input logic clk,
    output logic RGB_R,  // Active-Low Red
    output logic RGB_G,  // Active-Low Green
    output logic RGB_B   // Active-Low Blue
);

    logic [7:0] red, green, blue;
    logic pwm_r, pwm_g, pwm_b;

    // Instantiate color fading module
    color_fade u_color_fade (
        .clk(clk),
        .red(red),
        .green(green),
        .blue(blue)
    );

    // Instantiate PWM modules with scaling
    pwm #(.PWM_INTERVAL(256)) pwm_red (
        .clk(clk),
        .duty_cycle(red),  // Now takes 8-bit input
        .pwm_out(pwm_r)
    );

    pwm #(.PWM_INTERVAL(256)) pwm_green (
        .clk(clk),
        .duty_cycle(green),
        .pwm_out(pwm_g)
    );

    pwm #(.PWM_INTERVAL(256)) pwm_blue (
        .clk(clk),
        .duty_cycle(blue),
        .pwm_out(pwm_b)
    );

    // Assign RGB outputs (Active Low)
    assign RGB_R = ~pwm_r;
    assign RGB_G = ~pwm_g;
    assign RGB_B = ~pwm_b;

endmodule
