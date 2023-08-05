module ID_EX (
    input               clk,
    input               reset,
    input               ID_Flush,
    input               ID_MemRead,
    input               ID_MemWrite,
    input               ID_RegWrite,
    input               ID_ALUSrc1,
    input               ID_ALUSrc2,
    input  wire [  1:0] ID_MemtoReg,
    input  wire [  3:0] ID_ALUOp,
    input  wire [ 31:0] ID_PC_plus_4,
    input  wire [ 31:0] ID_Instruction,
    input  wire [ 31:0] ID_Databus1,
    input  wire [ 31:0] ID_Databus2,
    input  wire [ 31:0] ID_Lu_out,
    input  wire [4 : 0] ID_Write_register,
    output reg          EX_MemRead,
    output reg          EX_MemWrite,
    output reg          EX_RegWrite,
    output reg          EX_ALUSrc1,
    output reg          EX_ALUSrc2,
    output reg  [  1:0] EX_MemtoReg,
    output reg  [  3:0] EX_ALUOp,
    output reg  [ 31:0] EX_PC_plus_4,
    output reg  [ 31:0] EX_Instruction,
    output reg  [ 31:0] EX_Databus1,
    output reg  [ 31:0] EX_Databus2,
    output reg  [ 31:0] EX_Lu_out,
    output reg  [4 : 0] EX_Write_register
);
    always @(posedge clk or posedge reset) begin
        if (reset || ID_Flush) begin
            EX_MemRead <= 0;
            EX_MemWrite <= 0;
            EX_RegWrite <= 0;
            EX_ALUSrc1 <= 0;
            EX_ALUSrc2 <= 0;
            EX_MemtoReg <= 0;
            EX_ALUOp <= 0;
            EX_PC_plus_4 <= 32'h4;
            EX_Instruction <= 0;
            EX_Databus1 <= 0;
            EX_Databus2 <= 0;
            EX_Lu_out <= 0;
            EX_Write_register <= 0;
        end
        else begin
            EX_MemRead <= ID_MemRead;
            EX_MemWrite <= ID_MemWrite;
            EX_RegWrite <= ID_RegWrite;
            EX_ALUSrc1 <= ID_ALUSrc1;
            EX_ALUSrc2 <= ID_ALUSrc2;
            EX_MemtoReg <= ID_MemtoReg;
            EX_ALUOp <= ID_ALUOp;
            EX_PC_plus_4 <= ID_PC_plus_4;
            EX_Instruction <= ID_Instruction;
            EX_Databus1 <= ID_Databus1;
            EX_Databus2 <= ID_Databus2;
            EX_Lu_out <= ID_Lu_out;
            EX_Write_register <= ID_Write_register;
        end
    end

endmodule
