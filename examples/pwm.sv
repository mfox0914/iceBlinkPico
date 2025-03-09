// PWM generator to fade LED

module pwm #(
    parameter PWM_INTERVAL = 256  // 8-bit range
)(
    input logic clk,
    input logic [7:0] duty_cycle,
    output logic pwm_out
);

    logic [7:0] pwm_count = 0;

    always_ff @(posedge clk) begin
        pwm_count <= pwm_count + 1;
    end

    assign pwm_out = (pwm_count < duty_cycle) ? 1'b1 : 1'b0;

endmodule



