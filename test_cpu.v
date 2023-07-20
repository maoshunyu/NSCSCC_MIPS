`timescale 1ns / 1ps
module test_cpu ();
    reg reset;
    reg clk;

    wire MemRead;
    wire [31:0] MemAddress;
    CPU cpu1 (
        .reset(reset),
        .clk  (clk),
        .MemRead(MemRead),
        .MemAddress(MemAddress)
    );


    initial begin
        reset = 1;
        clk   = 1;
        #10 reset = 0;
    end

    always #5 clk = ~clk;

endmodule
