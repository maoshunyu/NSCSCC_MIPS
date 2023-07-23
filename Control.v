module Control (
    input      [6 -1:0] OpCode,
    input      [6 -1:0] Funct,
    output reg [2 -1:0] PCSrc,
    output reg          Branch,
    output reg          RegWrite,
    output reg [2 -1:0] RegDst,
    output reg          MemRead,
    output reg          MemWrite,
    output reg [2 -1:0] MemtoReg,
    output reg          ALUSrc1,
    output reg          ALUSrc2,
    output reg          ExtOp,
    output reg          LuOp,
    output     [4 -1:0] ALUOp,
    output     [   2:0] Branch_Type
);
    assign Branch_Type = (OpCode == 6'h04) ? 3'b000 :  //beq
        (OpCode == 6'h05) ? 3'b001 :  //bne
        (OpCode == 6'h06) ? 3'b010 :  //blez
        (OpCode == 6'h07) ? 3'b011 :  //bgtz
        (OpCode == 6'h01) ? 3'b100 : 3'b000;  //bgez/bltz
    always @(*) begin
        case (OpCode)
            6'h00: begin
                if (Funct == 6'h08) begin  //jr
                    PCSrc <= 2'b11;
                    RegWrite <= 1'b0;
                end
                else if (Funct == 6'h09) begin  //jalr
                    PCSrc <= 2'b11;
                    RegWrite <= 1'b1;
                end
                else begin
                    PCSrc <= 2'b00;
                    RegWrite <= 1'b1;
                end
                Branch   <= 1'b0;  //jr Branch=X;
                RegDst   <= 2'b01;  // jr RegDst=x;
                MemRead  <= 1'b0;  //MemRead=x;
                MemWrite <= 1'b0;
                if (Funct == 6'h09) begin
                    MemtoReg <= 2'b11;
                end
                else MemtoReg <= 2'b00;  // jr MemtoReg=x;
                if (Funct == 6'h00 || Funct == 6'h02 || Funct == 6'h03) begin  // sll/srl/sra
                    ALUSrc1 <= 1'b1;
                end
                else begin
                    ALUSrc1 <= 1'b0;
                end
                ALUSrc2 <= 1'b0;  //jr ALUSrc2=x;
                ExtOp <= 1'b0;  //ExtOp=x;
                LuOp <= 1'b0;  //LuOp=x;
            end
            6'h02: begin  // j 
                PCSrc <= 2'b01;
                Branch <= 1'b0;  //Branch=x;
                RegWrite <= 1'b0;
                RegDst <= 2'b00;  //RegDst=x;
                MemRead <= 1'b0;  //MemRead=x;
                MemWrite <= 1'b0;
                MemtoReg <= 2'b00;  //MemtoReg=x;
                ALUSrc1 <= 1'b0;  //ALUSrc1=x;
                ALUSrc2 <= 1'b0;  //ALUSrc2=x;
                ExtOp <= 1'b0;  //ExtOp=x;
                LuOp <= 1'b0;  //LuOp=x
            end
            6'h03: begin  // jal
                PCSrc <= 2'b01;
                Branch <= 1'b0;  //Branch=x;
                RegWrite <= 1'b1;
                RegDst <= 2'b11;
                MemRead <= 1'b0;  //MemRead=x;
                MemWrite <= 1'b0;
                MemtoReg <= 2'b11;
                ALUSrc1 <= 1'b0;  //ALUSrc1=x;
                ALUSrc2 <= 1'b0;  //ALUSrc2=x;
                ExtOp <= 1'b0;  //ExtOp=x;
                LuOp <= 1'b0;  //LuOp=x
            end
            6'h04: begin  // beq
                PCSrc <= 2'b00;
                Branch <= 1'b1;
                RegWrite <= 1'b0;
                RegDst <= 2'b00;  //RegDst=x;
                MemRead <= 1'b0;  //MemRead=x;
                MemWrite <= 1'b0;
                MemtoReg <= 2'b00;  //MemtoReg=x;
                ALUSrc1 <= 1'b0;
                ALUSrc2 <= 1'b0;
                ExtOp <= 1'b1;
                LuOp <= 1'b0;  //LuOp=x
            end
            6'h05: begin  // bne
                PCSrc <= 2'b00;
                Branch <= 1'b1;
                RegWrite <= 1'b0;
                RegDst <= 2'b00;  //RegDst=x;
                MemRead <= 1'b0;  //MemRead=x;
                MemWrite <= 1'b0;
                MemtoReg <= 2'b00;  //MemtoReg=x;
                ALUSrc1 <= 1'b0;
                ALUSrc2 <= 1'b0;
                ExtOp <= 1'b1;
                LuOp <= 1'b0;  //LuOp=x
            end
            6'h08: begin  //addi
                PCSrc <= 2'b00;
                Branch <= 1'b0;
                RegWrite <= 1'b1;
                RegDst <= 2'b00;
                MemRead <= 1'b0;  //MemRead=x;
                MemWrite <= 1'b0;
                MemtoReg <= 2'b00;
                ALUSrc1 <= 1'b0;
                ALUSrc2 <= 1'b1;
                ExtOp <= 1'b1;
                LuOp <= 1'b0;
            end
            6'h09: begin  //addiu
                PCSrc <= 2'b00;
                Branch <= 1'b0;
                RegWrite <= 1'b1;
                RegDst <= 2'b00;
                MemRead <= 1'b0;  //MemRead=x;
                MemWrite <= 1'b0;
                MemtoReg <= 2'b00;
                ALUSrc1 <= 1'b0;
                ALUSrc2 <= 1'b1;
                ExtOp <= 1'b1;
                LuOp <= 1'b0;
            end
            6'h0a: begin  //slti
                PCSrc <= 2'b00;
                Branch <= 1'b0;
                RegWrite <= 1'b1;
                RegDst <= 2'b00;
                MemRead <= 1'b0;  //MemRead=x;
                MemWrite <= 1'b0;
                MemtoReg <= 2'b00;
                ALUSrc1 <= 1'b0;
                ALUSrc2 <= 1'b1;
                ExtOp <= 1'b1;
                LuOp <= 1'b0;
            end
            6'h0b: begin  //sltiu
                PCSrc <= 2'b00;
                Branch <= 1'b0;
                RegWrite <= 1'b1;
                RegDst <= 2'b00;
                MemRead <= 1'b0;  //MemRead=x;
                MemWrite <= 1'b0;
                MemtoReg <= 2'b00;
                ALUSrc1 <= 1'b0;
                ALUSrc2 <= 1'b1;
                ExtOp <= 1'b0;
                LuOp <= 1'b0;
            end
            6'h0c: begin  //andi
                PCSrc <= 2'b00;
                Branch <= 1'b0;
                RegWrite <= 1'b1;
                RegDst <= 2'b00;
                MemRead <= 1'b0;  //MemRead=x;
                MemWrite <= 1'b0;
                MemtoReg <= 2'b00;
                ALUSrc1 <= 1'b0;
                ALUSrc2 <= 1'b1;
                ExtOp <= 1'b0;
                LuOp <= 1'b0;
            end
            6'h0d: begin  //ori
                PCSrc <= 2'b00;
                Branch <= 1'b0;
                RegWrite <= 1'b1;
                RegDst <= 2'b00;
                MemRead <= 1'b0;  //MemRead=x;
                MemWrite <= 1'b0;
                MemtoReg <= 2'b00;
                ALUSrc1 <= 1'b0;
                ALUSrc2 <= 1'b1;
                ExtOp <= 1'b0;
                LuOp <= 1'b0;
            end
            6'h0e: begin  //xori
                PCSrc <= 2'b00;
                Branch <= 1'b0;
                RegWrite <= 1'b1;
                RegDst <= 2'b00;
                MemRead <= 1'b0;  //MemRead=x;
                MemWrite <= 1'b0;
                MemtoReg <= 2'b00;
                ALUSrc1 <= 1'b0;
                ALUSrc2 <= 1'b1;
                ExtOp <= 1'b0;
                LuOp <= 1'b0;
            end
            6'h0f: begin  //lui
                PCSrc <= 2'b00;
                Branch <= 1'b0;
                RegWrite <= 1'b1;
                RegDst <= 2'b00;
                MemRead <= 1'b0;  //MemRead=x;
                MemWrite <= 1'b0;
                MemtoReg <= 2'b00;
                ALUSrc1 <= 1'b0;
                ALUSrc2 <= 1'b1;
                ExtOp <= 1'b0;  //ExtOp=x;
                LuOp <= 1'b1;
            end
            6'h23: begin  //lw
                PCSrc <= 2'b00;
                Branch <= 1'b0;
                RegWrite <= 1'b1;
                RegDst <= 2'b00;
                MemRead <= 1'b1;
                MemWrite <= 1'b0;
                MemtoReg <= 2'b01;
                ALUSrc1 <= 1'b0;
                ALUSrc2 <= 1'b1;
                ExtOp <= 1'b1;
                LuOp <= 1'b0;
            end
            6'h2b: begin  //sw
                PCSrc <= 2'b00;
                Branch <= 1'b0;
                RegWrite <= 1'b0;
                RegDst <= 2'b00;  //RegDst=x;
                MemRead <= 1'b0;  //MemRead=x;
                MemWrite <= 1'b1;
                MemtoReg <= 2'b00;  //MemtoReg=x;
                ALUSrc1 <= 1'b0;
                ALUSrc2 <= 1'b1;
                ExtOp <= 1'b1;
                LuOp <= 1'b0;
            end
            default: begin
                PCSrc <= 2'b00;
                Branch <= 1'b0;
                RegWrite <= 1'b0;
                RegDst <= 2'b00;
                MemRead <= 1'b0;
                MemWrite <= 1'b0;
                MemtoReg <= 2'b00;
                ALUSrc1 <= 1'b0;
                ALUSrc2 <= 1'b0;
                ExtOp <= 1'b0;
                LuOp <= 1'b0;
            end

        endcase
    end


    // Your code above (for question 1)

    // set ALUOp
    assign ALUOp[2:0] = 
		(OpCode == 6'h00)? 3'b010: 
		(OpCode == 6'h04)? 3'b001: 
		(OpCode == 6'h0c)? 3'b100: //and
        (OpCode == 6'h0d) ? 3'b011 :  //or
        (OpCode == 6'h0e) ? 3'b110 :  //xor 
        (OpCode == 6'h0a || OpCode == 6'h0b) ? 3'b101 : 3'b000;

    assign ALUOp[3] = OpCode[0];

    // Add your code above (for question 2)

endmodule
