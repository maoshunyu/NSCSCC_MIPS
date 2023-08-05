//~ `New testbench
`timescale  1ns / 1ps
module tb_top;
// top Parameters
parameter PERIOD  = 10;

// top Inputs
reg   clk                                  = 0 ;
reg   reset                                ;
// top Outputs
initial begin
    reset=1;
    #50 reset=0;
end

initial
begin
    forever #(PERIOD/2)  clk=~clk;
end
top  u_top (
    .clk                     ( clk     ),
    .reset                   ( reset   )
);endmodule