module IF_ID (
    input             clk,
    input             reset,
    input      [31:0] IF_PC_plus_4,
    input      [31:0] IF_Instruction,
    input             IF_Flush,
    input             Stall,
    output reg [31:0] ID_PC_plus_4,
    output reg [31:0] ID_Instruction
);

    always @(posedge clk or posedge reset) begin
        if (reset || IF_Flush) begin
            ID_PC_plus_4   <= 32'h4;
            ID_Instruction <= 32'h0;
        end
        else if (Stall) begin
            ID_PC_plus_4   <= ID_PC_plus_4;
            ID_Instruction <= ID_Instruction;
        end
        else begin
            ID_PC_plus_4   <= IF_PC_plus_4;
            ID_Instruction <= IF_Instruction;
        end
    end


endmodule
