module MEM_WB (
    input                clk,
    input                reset,
    input                MEM_RegWrite,
    input  wire [ 1 : 0] MEM_MemtoReg,
    input  wire [ 4 : 0] MEM_Write_register,
    input  wire [31 : 0] MEM_Read_Data,
    input  wire [31 : 0] MEM_ALU_out,
    input  wire [31 : 0] MEM_PC_plus_4,
    output reg           WB_RegWrite,
    output reg  [ 1 : 0] WB_MemtoReg,
    output reg  [ 4 : 0] WB_Write_register,
    output reg  [31 : 0] WB_Read_Data,
    output reg  [31 : 0] WB_ALU_out,
    output reg  [31 : 0] WB_PC_plus_4
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            WB_RegWrite <= 0;
            WB_MemtoReg <= 0;
            WB_Write_register <= 0;
            WB_Read_Data <= 0;
            WB_ALU_out <= 0;
            WB_PC_plus_4 <= 32'h4;
        end
        else begin
            WB_RegWrite <= MEM_RegWrite;
            WB_MemtoReg <= MEM_MemtoReg;
            WB_Write_register <= MEM_Write_register;
            WB_Read_Data <= MEM_Read_Data;
            WB_ALU_out <= MEM_ALU_out;
            WB_PC_plus_4 <= MEM_PC_plus_4;
        end
    end
endmodule
