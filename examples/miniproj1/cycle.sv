// Mini Project 1 - LED Color Cycling

module led_controller(
    input logic clk,     // System clock (12 MHz)
    output logic RGB_R,  // Red in RGB LED (Active Low)
    output logic RGB_G,  // Green in RGB LED (Active Low)
    output logic RGB_B   // Blue in RGB LED (Active Low)
);

    // Define color states (Active LOW)
    typedef enum logic [2:0] {
        RED     = 3'b011, // Red ON, others OFF
        YELLOW  = 3'b001, // Red & Green ON
        GREEN   = 3'b101, // Green ON, others OFF
        CYAN    = 3'b100, // Green & Blue ON
        BLUE    = 3'b110, // Blue ON, others OFF
        MAGENTA = 3'b010  // Red & Blue ON
    } color_t;

    color_t current_color;
    logic [$clog2(12000000) - 1:0] count = 0; // Counter for 1s interval

    always_ff @(posedge clk) begin
        if (count == 12000000 - 1) begin // 1 second interval (12 MHz clock)
            count <= 0;
            case (current_color)
                RED:     current_color <= YELLOW;
                YELLOW:  current_color <= GREEN;
                GREEN:   current_color <= CYAN;
                CYAN:    current_color <= BLUE;
                BLUE:    current_color <= MAGENTA;
                MAGENTA: current_color <= RED;
                default: current_color <= RED;
            endcase
        end else begin
            count <= count + 1;
        end
    end

    // Assign the current color to the RGB outputs (Active Low)
    always_comb begin
        {RGB_R, RGB_G, RGB_B} = current_color;
    end

endmodule