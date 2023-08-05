module EX_MEM (
    input clk,
    input reset,
    input wire EX_MemRead,
    input wire EX_MemWrite,
    input wire EX_RegWrite,
    input wire [1 : 0] EX_MemtoReg,
    input wire [31 : 0] EX_Data_in2,
    input wire [31 : 0] EX_PC_plus_4,
    input wire [4 : 0] EX_Write_register,
    input wire [31 : 0] EX_ALU_out,
    output reg MEM_MemRead,
    output reg MEM_MemWrite,
    output reg MEM_RegWrite,
    output reg [1 : 0] MEM_MemtoReg,
    output reg [31 : 0] MEM_Data_in2,
    output reg [31 : 0] MEM_PC_plus_4,
    output reg [4 : 0] MEM_Write_register,
    output reg [31 : 0] MEM_ALU_out
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            MEM_MemRead <= 0;
            MEM_MemWrite <= 0;
            MEM_RegWrite <= 0;
            MEM_MemtoReg <= 0;
            MEM_Data_in2 <= 0;
            MEM_PC_plus_4 <= 32'h4;
            MEM_Write_register <= 0;
            MEM_ALU_out <= 0;
        end else begin
            MEM_MemRead <= EX_MemRead;
            MEM_MemWrite <= EX_MemWrite;
            MEM_RegWrite <= EX_RegWrite;
            MEM_MemtoReg <= EX_MemtoReg;
            MEM_Data_in2 <= EX_Data_in2;
            MEM_PC_plus_4 <= EX_PC_plus_4;
            MEM_Write_register <= EX_Write_register;
            MEM_ALU_out <= EX_ALU_out;
        end
    end
endmodule
