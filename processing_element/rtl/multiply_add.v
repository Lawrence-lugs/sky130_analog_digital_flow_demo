module multiply_add (
    input clk, nrst,
    input [7:0] a,
    input [7:0] b,
    input [7:0] constant,
    output reg [15:0] o
);


always @ (posedge clk or negedge nrst) begin
    if(!nrst) begin
    	o <= 0;
    end else begin
        o <= a * b + {{8{1'b0}},constant};
    end
end

endmodule
