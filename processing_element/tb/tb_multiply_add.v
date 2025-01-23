`timescale 1ns/1ps

module multiply_add_tb;

// Parameters
localparam CLK_PERIOD = 10;
localparam NUM_TESTS = 20;

// Signals
reg clk;
reg nrst;
reg [7:0] a;
reg [7:0] b;
reg [7:0] c;
wire [15:0] o;

// Instance of module under test
multiply_add dut (
    .clk(clk),
    .nrst(nrst),
    .a(a),
    .b(b),
    .constant(c),
    .o(o)
);

// Clock generation
initial begin
    clk = 0;
    forever #(CLK_PERIOD/2) clk = ~clk;
end

integer ans,a0,b0,c0;
integer right;

// Test stimulus
initial begin
    // Initialize waveform dumping
    $dumpfile("multiply_add_tb.vcd");
    $dumpvars(0, multiply_add_tb);
    
    // $sdf_annotate("../mapped/multiply_add_mapped.sdf",dut);

    // Initial values
    nrst = 1;
    a = 0;
    b = 0;
    c = 0;
    right = 0;
    
    // Reset sequence
    #(CLK_PERIOD*2);
    nrst = 0;
    #(CLK_PERIOD*2);
    nrst = 1;
    #(CLK_PERIOD*2);

    repeat(NUM_TESTS) begin
        a0 = $random;
        b0 = $random;
        c0 = $random;
        a = a0[7:0];
        b = b0[7:0];
        c = c0[7:0];
        $display("Random values - a=%d, b=%d, c=%d", a, b, c);
        #(CLK_PERIOD);
	ans = a * b + c;
	if (o == ans) begin
	    $display("Output: %d, Expected: %d, CORRECT", o,ans);
	    right = right + 1;
        end else begin
            $display("Output: %d, Expected: %d, WRONG", o,ans);
	end
    end

    $display("Got %d / %d correct",right,NUM_TESTS);
    
    // End simulation
    #(CLK_PERIOD*5);
    $display("Simulation completed successfully");
    $finish;
end

endmodule
