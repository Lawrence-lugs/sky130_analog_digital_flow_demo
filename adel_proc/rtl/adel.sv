module adel (
    input clk, nrst,
    input [15:0] inst,
    output reg [15:0] pc
);
reg signed [3:0][15:0] rf;
wire [1:0] opc, dest, src1, src2;
wire w, rs;
wire [7:0] imm;
wire [15:0] b_op2 = rs ? rf[src2] : 16'(imm);
wire [15:0] br_pc = pc + 16'(signed'(imm));
assign {w, opc, rs, dest, src1, imm} = inst;
assign src2 = inst[1:0]; 
always @(posedge clk or negedge nrst) begin
    if (!nrst) begin pc <= 0; rf <= 0; end else
    if (w) begin
        case (opc)
            2'b00: rf[dest] <= rf[src1] + b_op2;
            2'b01: rf[dest] <= rf[src1] - b_op2;
            2'b10: rf[dest] <= rf[src1] & b_op2;
            2'b11: rf[dest] <= rf[src1] | b_op2;
        endcase
        pc <= pc + 1;
    end else
        case (opc)
            2'b00: pc <= (rf[src1] == 0) ? br_pc : pc + 1;
            2'b11: pc <= (rf[src1] != 0) ? br_pc : pc + 1;
            2'b01: pc <= (rf[src1] < 0) ? br_pc : pc + 1;
            2'b10: pc <= (rf[src1] > 0) ? br_pc : pc + 1;
        endcase
end
endmodule

