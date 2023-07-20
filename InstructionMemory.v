module InstructionMemory (
    input      [32 -1:0] Address,
    output reg [32 -1:0] Instruction
);

    always @(*)
        case (Address[9:2])
            // -------- Paste Binary Instruction Below (Inst-q1.txt, Inst-q2.txt, Inst-q3.txt)

            8'd0:  Instruction <= 32'h20042f5b;
            8'd1:  Instruction <= 32'h2405cfc7;
            8'd2:  Instruction <= 32'h00053400;
            8'd3:  Instruction <= 32'h00063c03;
            8'd4:  Instruction <= 32'hac040000;
            8'd5:  Instruction <= 32'h10e50001;
            8'd6:  Instruction <= 32'h3c0456ce;
            8'd7:  Instruction <= 32'h00c44020;
            8'd8:  Instruction <= 32'h00084a03;
            8'd9:  Instruction <= 32'h200ad0a5;
            8'd10: Instruction <= 32'h008a102a;
            8'd11: Instruction <= 32'h008a182b;
            8'd12: Instruction <= 32'h8c0b0000;
            8'd13: Instruction <= 32'h0810000d;

            // -------- Paste Binary Instruction Above

            default: Instruction <= 32'h00000000;
        endcase

endmodule
