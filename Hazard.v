module Hazard (
    input               ID_Branch,
    input               ID_Zero,
    input  wire [1 : 0] ID_PCSrc,
    input  wire [ 31:0] ID_Instruction,
    input               EX_RegWrite,
    input               EX_MemRead,
    input  wire [4 : 0] EX_Write_register,
    input               MEM_MemRead,
    input  wire [4 : 0] MEM_Write_register,
    output reg          Stall,
    output reg          IF_Flush
);
    always @(*) begin
        IF_Flush <= (ID_Branch && ID_Zero && ~Stall || ID_PCSrc != 2'b00) ? 1 : 0;
    end

    always @(*) begin
        if(EX_MemRead && (EX_Write_register == ID_Instruction[25:21] || EX_Write_register == ID_Instruction[20:16]))
            Stall <= 1;
        else if((ID_Branch == 1 || ID_PCSrc[1] == 1) && (EX_Write_register == ID_Instruction[25:21] || EX_Write_register == ID_Instruction[20:16]) && EX_RegWrite)
            Stall <= 1;
        else if((ID_Branch == 1 || ID_PCSrc[1] == 1) && (MEM_MemRead && (MEM_Write_register == ID_Instruction[25:21] || MEM_Write_register == ID_Instruction[20:16])))
            Stall <= 1;
        else Stall <= 0;
    end
endmodule
