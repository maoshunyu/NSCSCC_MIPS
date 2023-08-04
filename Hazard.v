module Hazard (
    input               ID_Branch,
    input               ID_Zero,
    input  wire [1 : 0] ID_PCSrc,
    input  wire [ 31:0] ID_Instruction,
    input               ID_Update,
    input               EX_RegWrite,
    input               EX_MemRead,
    input  wire [4 : 0] EX_Write_register,
    input               MEM_MemRead,
    input  wire [4 : 0] MEM_Write_register,
    output reg          Stall,
    output reg          IF_Flush,
    output reg          ID_Flush
);
    always @(*) begin
        IF_Flush <= (ID_PCSrc != 2'b00 && ~Stall) || (ID_Update && ~Stall) ? 1 : 0;
    end

    always @(*) begin
        if(EX_MemRead && (EX_Write_register == ID_Instruction[25:21] || EX_Write_register == ID_Instruction[20:16]) && EX_Write_register!=0)begin//load-use
            Stall <= 1;
            ID_Flush <= 1;
        end
        else if((ID_Branch == 1 || ID_PCSrc[1] == 1) && (EX_Write_register == ID_Instruction[25:21] || EX_Write_register == ID_Instruction[20:16]) && EX_RegWrite && EX_Write_register!=0)begin//write-beq
            Stall <= 1;
            ID_Flush <= 1;
        end
        else if((ID_Branch == 1 || ID_PCSrc[1] == 1) && (MEM_MemRead && (MEM_Write_register == ID_Instruction[25:21] || MEM_Write_register == ID_Instruction[20:16])) && MEM_Write_register!=0)begin
            Stall <= 1;
            ID_Flush <= 1;
        end
        else begin
            Stall <= 0;
            ID_Flush <= 0;
        end
    end
endmodule
