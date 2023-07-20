module Forward (
    input      [ 31:0] ID_Instruction,
    input      [1 : 0] ID_PCSrc,
    input              ID_Branch,
    input              MEM_RegWrite,
    input      [  4:0] MEM_Write_register,
    output reg         ID_Forward_A,
    output reg         ID_Forward_B,

    input      [31:0] EX_Instruction,
    input             WB_RegWrite,
    input      [ 4:0] WB_Write_register,
    output reg [ 1:0] EX_Forward_A,
    output reg [ 1:0] EX_Forward_B
);
    always @(*) begin
        if(MEM_RegWrite && MEM_Write_register==ID_Instruction[25:21] && MEM_Write_register!=0 && (ID_PCSrc||ID_Branch))
            ID_Forward_A <= 1;
        else ID_Forward_A <= 0;
        if(MEM_RegWrite && MEM_Write_register==ID_Instruction[20:16] && MEM_Write_register!=0 && (ID_PCSrc||ID_Branch))
            ID_Forward_B <= 1;
        else ID_Forward_B <= 0;
    end
    always @(*) begin
        if (MEM_RegWrite && MEM_Write_register != 0 && MEM_Write_register == EX_Instruction[25:21])
            EX_Forward_A <= 2'b10;
        else if (WB_RegWrite&&WB_Write_register!=0&&WB_Write_register==EX_Instruction[25:21]&&(MEM_Write_register!=EX_Instruction[25:21]||~MEM_RegWrite))
            EX_Forward_A <= 2'b01;
        else EX_Forward_A <= 2'b00;

        if (MEM_RegWrite && MEM_Write_register != 0 && MEM_Write_register == EX_Instruction[20:16])
            EX_Forward_B <= 2'b10;
        else if (WB_RegWrite&&WB_Write_register!=0&&WB_Write_register==EX_Instruction[20:16]&&(MEM_Write_register!=EX_Instruction[20:16]||~MEM_RegWrite))
            EX_Forward_B <= 2'b01;
        else EX_Forward_B <= 2'b00;

    end
endmodule
