module adel (
    input clk, nrst,
    input [15:0] inst,
    output reg [15:0] pc
);
reg signed [3:0][15:0] rf;
wire [15:0] b_op2 = inst[12] ? rf[inst[1:0]] : 16'(inst[7:0]);
wire [15:0] br_pc = pc + 16'(signed'(inst[7:0]));
always @(posedge clk or negedge nrst) begin
    if (!nrst) begin pc <= 0; rf <= 0; end else
    if (inst[15]) begin
        case (inst[14:13])
            2'b00: rf[inst[11:10]] <= rf[inst[9:8]] + b_op2;
            2'b01: rf[inst[11:10]] <= rf[inst[9:8]] - b_op2;
            2'b10: rf[inst[11:10]] <= rf[inst[9:8]] & b_op2;
            2'b11: rf[inst[11:10]] <= rf[inst[9:8]] | b_op2;
        endcase
        pc <= pc + 1;
    end else
        case (inst[14:13])
            2'b00: pc <= (rf[inst[9:8]] == 0) ? br_pc : pc + 1;
            2'b01: pc <= (rf[inst[9:8]] != 0) ? br_pc : pc + 1;
            2'b10: pc <= (rf[inst[9:8]] < 0) ? br_pc : pc + 1;
            2'b11: pc <= (rf[inst[9:8]] > 0) ? br_pc : pc + 1;
        endcase
end
endmodule

