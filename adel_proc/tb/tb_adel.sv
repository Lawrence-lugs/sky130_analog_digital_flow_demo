module tb_adel (
);

parameter CLK_PERIOD = 10;

reg clk, nrst;
reg [15:0] inst [64];
reg [7:0] pc;

always #(CLK_PERIOD/2) clk = ~clk;

// Instantiate the design under test
adel dut (
    .clk(clk),
    .nrst(nrst),
    .inst(inst[pc[5:0]]),
    .pc(pc)
);

int instmem;

initial begin

    instmem = $fopen("../tb/instructions.txt", "r");
    for (int i = 0; i < 64; i++) begin
        $fscanf(instmem, "%h ", inst[i]);
        $display("inst[%0d] = %h", i, inst[i]);
    end
    
    clk = 0;
    nrst = 0;
    #(CLK_PERIOD);
    nrst = 1;

    // Print entire register file
    $display("Register File:");
    for (int t = 0; t < 100; t++) begin
        #(CLK_PERIOD);
        $display("pc = %h", dut.pc);
        $display("inst = %h", inst[pc[5:0]]);
        for (int i = 0; i < 4; i++) begin
            $display("rf[%0d] = %h", i, dut.rf[i]);
        end
        // $display("pc = %h", dut.pc);
        $display("======");
    end

    $finish();

end
    
endmodule