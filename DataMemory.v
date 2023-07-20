module DataMemory (
    input            reset,
    input            clk,
    input            MemRead,
    input            MemWrite,
    input  [32 -1:0] Address,
    input  [32 -1:0] Write_data,
    output [32 -1:0] Read_data
);

    // RAM size is 256 words, each word is 32 bits, valid address is 8 bits
    parameter RAM_SIZE = 256;
    parameter RAM_SIZE_BIT = 8;

    // RAM_data is an array of 256 32-bit registers
    reg [31:0] RAM_data[RAM_SIZE - 1:0];

    // read data from RAM_data as Read_data
    assign Read_data = MemRead ? RAM_data[Address[RAM_SIZE_BIT+1:2]] : 32'h00000000;

    // write Write_data to RAM_data at clock posedge
    integer i;
    always @(posedge reset or posedge clk)
        if (reset) for (i = 0; i < RAM_SIZE; i = i + 1) RAM_data[i] <= 32'h00000000;
        else if (MemWrite) RAM_data[Address[RAM_SIZE_BIT+1:2]] <= Write_data;
endmodule
