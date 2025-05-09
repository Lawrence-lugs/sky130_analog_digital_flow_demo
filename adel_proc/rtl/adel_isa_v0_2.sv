module adel (           // Architecture
    input clk, nrst,    // Design that's
    input [15:0] inst,  // Easy to
    output reg [7:0] pc // Learn
);
reg signed [3:0][7:0] rf;
wire [1:0] opc, dst, src1, src2 = inst[1:0];
wire w, rs;
wire [7:0] imm, bpc = pc + imm;
wire [1:0] gl = {rf[src1] > 0, rf[src1] < 0};
assign {w, opc, rs, dst, src1, imm} = inst; 
always @(posedge clk or negedge nrst) begin
    if (!nrst) begin pc <= 0; rf <= 0; end else begin
    case ({!w,opc})
        0: rf[dst] <= rf[src1] + (rs ? rf[src2] : imm);
        1: rf[dst] <= rf[src1] - (rs ? rf[src2] : imm);
        2: rf[dst] <= rf[src1] & (rs ? rf[src2] : imm);
        3: rf[dst] <= rf[src1] | (rs ? rf[src2] : imm);
        default:;
    endcase
    pc <= !w & ( &opc & ^gl | opc == gl ) ? bpc : pc+1;
end end
endmodule