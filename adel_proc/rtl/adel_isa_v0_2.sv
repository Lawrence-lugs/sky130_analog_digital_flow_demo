module adel (
    input clk, nrst,
    input [15:0] inst,
    output reg [7:0] pc
);
reg signed [3:0][7:0] rf;
wire [1:0] opc, dst, src1, src2;
wire w, rs;
wire [7:0] imm;
wire [7:0] bpc = pc + imm;
wire [1:0] gl = {rf[src1] > 0, rf[src1] < 0};
assign {w, opc, rs, dst, src1, imm} = inst;
assign src2 = inst[1:0]; 
always @(posedge clk or negedge nrst) begin
    if (!nrst) begin pc <= 0; rf <= 0; end else begin
    case ({w,opc})
        3'b100: rf[dst] <= rf[src1] + (rs ? rf[src2] : imm);
        3'b101: rf[dst] <= rf[src1] - (rs ? rf[src2] : imm);
        3'b110: rf[dst] <= rf[src1] & (rs ? rf[src2] : imm);
        3'b111: rf[dst] <= rf[src1] | (rs ? rf[src2] : imm);
    endcase
    pc <= !w & ( &opc & ^gl | opc == gl ) ? bpc : pc+1;
end end
endmodule

