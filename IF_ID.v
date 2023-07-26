module IF_ID (
    input             clk,
    input             reset,
    input      [31:0] IF_PC_plus_4,
    input      [31:0] IF_PC,
    input      [31:0] IF_Instruction,
    input             IF_Flush,
    input             IF_Branch_likely,
    input             IF_BTB_Hit,
    input             Stall,
    output reg [31:0] ID_PC_plus_4,
    output reg [31:0] ID_PC,
    output reg [31:0] ID_Instruction,
    output reg        ID_Branch_likely,
    output reg        ID_BTB_Hit
);

    always @(posedge clk or posedge reset) begin
        if (reset || IF_Flush) begin
            ID_PC_plus_4 <= 32'h4;
            ID_PC <= 0;
            ID_Instruction <= 32'h0;
            ID_Branch_likely <= 0;
            ID_BTB_Hit <= 0;
        end
        else if (Stall) begin
            ID_PC_plus_4 <= ID_PC_plus_4;
            ID_PC <= ID_PC;
            ID_Instruction <= ID_Instruction;
            ID_Branch_likely <= ID_Branch_likely;
            ID_BTB_Hit <= ID_BTB_Hit;
        end
        else begin
            ID_PC <= IF_PC;
            ID_PC_plus_4 <= IF_PC_plus_4;
            ID_Instruction <= IF_Instruction;
            ID_Branch_likely <= IF_Branch_likely;
            ID_BTB_Hit <= IF_BTB_Hit;
        end
    end


endmodule
