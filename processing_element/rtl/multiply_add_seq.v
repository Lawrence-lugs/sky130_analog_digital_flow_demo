module multiply_add_seq
(
    input clk, nrst,
    input [7:0] a,
    input [7:0] b,
    input [7:0] constant,
    output reg [15:0] o,
    input start,                    // New signal to start multiplication
    output reg done                 // New signal to indicate completion
);

// State encoding
localparam IDLE = 2'b00;
localparam MULTIPLY = 2'b01;
localparam ADD = 2'b10;

// Registers for storing inputs and intermediate results
reg [7:0] a_q, b_q, d_q;
reg [15:0] product;
reg [7:0] multiplier;
reg [15:0] multiplicand;
reg [5:0] bit_counter;
reg [1:0] state;

always @(posedge clk or negedge nrst) begin
    if (!nrst) begin
        a_q <= 0;
        b_q <= 0;
        d_q <= 0;
        product <= 0;
        multiplier <= 0;
        multiplicand <= 0;
        bit_counter <= 0;
        state <= IDLE;
        done <= 0;
        o <= 0;
    end else begin
        case (state)
            IDLE: begin
                done <= 0;
		if (start) begin
                    // Load operands
                    a_q <= a;
                    b_q <= b;
                    d_q <= constant;
                    // Initialize multiplication
                    product <= 0;
                    multiplier <= b;
                    multiplicand <= {{8{1'b0}}, a};
                    bit_counter <= 8;
                    state <= MULTIPLY;
                end
            end

            MULTIPLY: begin
                if (bit_counter > 0) begin
                    // Check current bit of multiplier
                    if (multiplier[0]) begin
                        product <= product + multiplicand;
                    end
                    // Shift for next iteration
                    multiplier <= multiplier >> 1;
                    multiplicand <= multiplicand << 1;
                    bit_counter <= bit_counter - 1;
                end else begin
                    state <= ADD;
                end
            end

            ADD: begin
                // Final addition with d_q
                o <= product + d_q;
                state <= IDLE;
                done <= 1;
            end

            default: state <= IDLE;
        endcase
    end
end

endmodule
