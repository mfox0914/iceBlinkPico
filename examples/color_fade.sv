// Fade
// Smoothly cycles through HSV color wheel using PWM

module color_fade #(
    parameter CLK_FREQ = 12_000_000,  // 12 MHz clock
    parameter TOTAL_STEPS = 360,      // Total hue transition steps
    parameter COLOR_INTERVAL = CLK_FREQ / TOTAL_STEPS  // Cycles per hue step
)(
    input logic clk,
    output logic [7:0] red, green, blue
);

    localparam int STEP_SIZE = 60;   // Number of steps per color transition

    logic [$clog2(COLOR_INTERVAL)-1:0] cycle_counter = 0;  // Counts clock cycles
    logic [8:0] step_counter = 0;    // Hue step counter (0-359)
    logic [2:0] hue_region;          // Stores which hue transition we're in

    // RGB values
    logic [7:0] red_value   = 8'd255;
    logic [7:0] green_value = 8'd0;
    logic [7:0] blue_value  = 8'd0;

    // Step counter logic (advances hue every `COLOR_INTERVAL` cycles)
    always_ff @(posedge clk) begin
        if (cycle_counter >= COLOR_INTERVAL - 1) begin
            cycle_counter <= 0;
            if (step_counter >= TOTAL_STEPS - 1)
                step_counter <= 0;
            else
                step_counter <= step_counter + 1;
        end 
        else begin
            cycle_counter <= cycle_counter + 1;
        end
    end

    // Assign hue region using division
    always_comb begin
        hue_region = step_counter / STEP_SIZE;
    end

    // Compute step within the current region using division
    logic [8:0] step_in_region;
    always_comb begin
        step_in_region = step_counter - (hue_region * STEP_SIZE);
    end

    // Assign RGB values based on hue region (smooth color transitions)
    always_comb begin
        case (hue_region)
            3'd0:  {red_value, green_value, blue_value} = {8'd255, step_in_region * 4'd4, 8'd0};  // Red → Yellow
            3'd1:  {red_value, green_value, blue_value} = {8'd255 - step_in_region * 4'd4, 8'd255, 8'd0};  // Yellow → Green
            3'd2:  {red_value, green_value, blue_value} = {8'd0, 8'd255, step_in_region * 4'd4};  // Green → Cyan
            3'd3:  {red_value, green_value, blue_value} = {8'd0, 8'd255 - step_in_region * 4'd4, 8'd255};  // Cyan → Blue
            3'd4:  {red_value, green_value, blue_value} = {step_in_region * 4'd4, 8'd0, 8'd255};  // Blue → Magenta
            3'd5:  {red_value, green_value, blue_value} = {8'd255, 8'd0, 8'd255 - step_in_region * 4'd4};  // Magenta → Red
            default: {red_value, green_value, blue_value} = {8'd255, 8'd0, 8'd0};  // Default to red
        endcase
    end

    // Assign outputs
    assign red   = red_value;
    assign green = green_value;
    assign blue  = blue_value;

endmodule