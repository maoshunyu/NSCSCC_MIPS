module CPU (
    input                reset,
    input                clk,
    input  wire [31 : 0] IF_Instruction,
    output reg  [31 : 0] IF_PC,
    output reg           MemWrite,
    input  wire [  31:0] MemReadData,
    output reg  [  31:0] MemAddress,
    output reg  [  31:0] MemWriteData
);

    wire          Stall;

    wire [31 : 0] IF_PC_next;
    wire [31 : 0] IF_PC_plus_4;
    wire          IF_Flush;
    wire [31 : 0] IF_Jump_target;
    wire [31 : 0] IF_Branch_target;

    wire          ID_Flush;
    wire [31 : 0] ID_Instruction;
    wire [31 : 0] ID_PC_plus_4;
    wire          ID_Forward_A;
    wire          ID_Forward_B;
    wire [ 1 : 0] ID_RegDst;
    wire [ 1 : 0] ID_PCSrc;
    wire          ID_Branch;
    wire          ID_MemRead;
    wire          ID_MemWrite;
    wire [ 1 : 0] ID_MemtoReg;
    wire          ID_ALUSrc1;
    wire          ID_ALUSrc2;
    wire [ 3 : 0] ID_ALUOp;
    wire          ID_ExtOp;
    wire          ID_LuOp;
    wire          ID_RegWrite;
    wire [ 4 : 0] ID_Write_register;
    wire [31 : 0] ID_Databus1;
    wire [31 : 0] ID_Databus2;
    wire          ID_Zero;
    wire [31 : 0] ID_Ext_out;
    wire [31 : 0] ID_Lu_out;
    wire [31 : 0] ID_comp_a;
    wire [31 : 0] ID_comp_b;
    wire [   2:0] ID_Branch_Type;


    wire          EX_MemRead;
    wire          EX_MemWrite;
    wire          EX_RegWrite;
    wire          EX_ALUSrc1;
    wire          EX_ALUSrc2;
    wire [ 1 : 0] EX_MemtoReg;
    wire [ 3 : 0] EX_ALUOp;
    wire [31 : 0] EX_PC_plus_4;
    wire [31 : 0] EX_Instruction;
    wire [31 : 0] EX_Databus1;
    wire [31 : 0] EX_Databus2;
    wire [31 : 0] EX_Lu_out;
    wire [ 4 : 0] EX_Write_register;
    wire [31 : 0] EX_Data_in1;
    wire [31 : 0] EX_Data_in2;
    wire [31 : 0] EX_ALU_in1;
    wire [31 : 0] EX_ALU_in2;
    wire [31 : 0] EX_ALU_out;
    wire          EX_Zero;
    wire [ 1 : 0] EX_Forward_A;
    wire [ 1 : 0] EX_Forward_B;


    wire          MEM_MemRead;
    wire          MEM_MemWrite;
    wire          MEM_RegWrite;
    wire [ 1 : 0] MEM_MemtoReg;
    wire [31 : 0] MEM_Data_in2;
    wire [31 : 0] MEM_PC_plus_4;
    wire [ 4 : 0] MEM_Write_register;
    wire [31 : 0] MEM_ALU_out;
    wire [31 : 0] MEM_Read_Data;

    wire          WB_RegWrite;
    wire [ 1 : 0] WB_MemtoReg;
    wire [ 4 : 0] WB_Write_register;
    wire [31 : 0] WB_Read_Data;
    wire [31 : 0] WB_ALU_out;
    wire [31 : 0] WB_PC_plus_4;
    wire [31 : 0] WB_Databus3;



    // IF stage
    always @(posedge reset or posedge clk) begin
        if (reset) IF_PC <= 32'h00000000;
        else if (Stall) IF_PC <= IF_PC;
        else IF_PC <= IF_PC_next;
    end

    assign IF_PC_plus_4 = IF_PC + 32'd4;


    // // Instruction Memory
    // InstructionMemory instruction_memory1 (
    //     .Address    (IF_PC),
    //     .Instruction(IF_Instruction)
    // );




    IF_ID if_id1 (
        .clk           (clk),
        .reset         (reset),
        .IF_PC_plus_4  (IF_PC_plus_4),
        .IF_Instruction(IF_Instruction),
        .IF_Flush      (IF_Flush),
        .Stall         (Stall),
        .ID_PC_plus_4  (ID_PC_plus_4),
        .ID_Instruction(ID_Instruction)
    );


    Control control1 (
        .OpCode     (ID_Instruction[31:26]),
        .Funct      (ID_Instruction[5 : 0]),
        .PCSrc      (ID_PCSrc),
        .Branch     (ID_Branch),
        .RegWrite   (ID_RegWrite),
        .RegDst     (ID_RegDst),
        .MemRead    (ID_MemRead),
        .MemWrite   (ID_MemWrite),
        .MemtoReg   (ID_MemtoReg),
        .ALUSrc1    (ID_ALUSrc1),
        .ALUSrc2    (ID_ALUSrc2),
        .ExtOp      (ID_ExtOp),
        .LuOp       (ID_LuOp),
        .ALUOp      (ID_ALUOp),
        .Branch_Type(ID_Branch_Type)
    );

    // Register File


    assign ID_Write_register = (ID_RegDst == 2'b00)? ID_Instruction[20:16]: (ID_RegDst == 2'b01)? ID_Instruction[15:11]: 5'b11111; //20:16  ->  rt    ;15:11  ->  rd

    RegisterFile register_file1 (
        .reset         (reset),
        .clk           (clk),
        .RegWrite      (WB_RegWrite),
        .Read_register1(ID_Instruction[25:21]),
        .Read_register2(ID_Instruction[20:16]),
        .Write_register(WB_Write_register),
        .Write_data    (WB_Databus3),
        .Read_data1    (ID_Databus1),
        .Read_data2    (ID_Databus2)
    );



    // Extend

    assign ID_Ext_out = {ID_ExtOp ? {16{ID_Instruction[15]}} : 16'h0000, ID_Instruction[15:0]};

    assign ID_Lu_out = ID_LuOp ? {ID_Instruction[15:0], 16'h0000} : ID_Ext_out;

    assign ID_comp_a = (ID_Forward_A == 1) ? MEM_ALU_out : ID_Databus1;
    assign ID_comp_b = (ID_Forward_B == 1) ? MEM_ALU_out : ID_Databus2;
    assign ID_Zero =(ID_Branch_Type==3'b000)?(ID_comp_a == ID_comp_b):
                    (ID_Branch_Type==3'b001)?(ID_comp_a != ID_comp_b):
                    (ID_Branch_Type==3'b010)?(ID_comp_a <= 0):
                    (ID_Branch_Type==3'b011)?(ID_comp_a > 0):
                    (ID_Branch_Type==3'b100)?((ID_Instruction[20:16]==0)?(ID_comp_a < 0):(ID_comp_a >= 0)):0;

    // PC jump and branch

    assign IF_Jump_target = {ID_PC_plus_4[31:28], ID_Instruction[25:0], 2'b00};


    assign IF_Branch_target = (ID_Branch & ID_Zero) ? ID_PC_plus_4 + {ID_Lu_out[29:0], 2'b00} : IF_PC_plus_4;

    assign IF_PC_next = (ID_PCSrc == 2'b00) ? IF_Branch_target : (ID_PCSrc == 2'b01) ? IF_Jump_target : ID_Databus1;


    ID_EX id_ex1 (
        clk,
        reset,
        ID_Flush,
        ID_MemRead,
        ID_MemWrite,
        ID_RegWrite,
        ID_ALUSrc1,
        ID_ALUSrc2,
        ID_MemtoReg,
        ID_ALUOp,
        ID_PC_plus_4,
        ID_Instruction,
        ID_Databus1,
        ID_Databus2,
        ID_Lu_out,
        ID_Write_register,
        EX_MemRead,
        EX_MemWrite,
        EX_RegWrite,
        EX_ALUSrc1,
        EX_ALUSrc2,
        EX_MemtoReg,
        EX_ALUOp,
        EX_PC_plus_4,
        EX_Instruction,
        EX_Databus1,
        EX_Databus2,
        EX_Lu_out,
        EX_Write_register
    );


    // ALU Control
    wire [5 -1:0] EX_ALUCtl;
    wire          EX_Sign;

    ALUControl alu_control1 (
        .ALUOp (EX_ALUOp),
        .Funct (EX_Instruction[5:0]),
        .ALUCtl(EX_ALUCtl),
        .Sign  (EX_Sign)
    );

    // ALU

    assign EX_Data_in1=(EX_Forward_A==2'b01)?WB_Databus3:(EX_Forward_A==2'b10)?MEM_ALU_out:EX_Databus1;
    assign EX_Data_in2=(EX_Forward_B==2'b01)?WB_Databus3:(EX_Forward_B==2'b10)?MEM_ALU_out:EX_Databus2;

    assign EX_ALU_in1 = EX_ALUSrc1 ? {27'h00000, EX_Instruction[10:6]} : EX_Data_in1;
    assign EX_ALU_in2 = EX_ALUSrc2 ? EX_Lu_out : EX_Data_in2;

    ALU alu1 (
        .in1   (EX_ALU_in1),
        .in2   (EX_ALU_in2),
        .ALUCtl(EX_ALUCtl),
        .Sign  (EX_Sign),
        .out   (EX_ALU_out),
        .zero  (EX_Zero)
    );
    EX_MEM ex_mem1 (
        clk,
        reset,
        EX_MemRead,
        EX_MemWrite,
        EX_RegWrite,
        EX_MemtoReg,
        EX_Data_in2,
        EX_PC_plus_4,
        EX_Write_register,
        EX_ALU_out,
        MEM_MemRead,
        MEM_MemWrite,
        MEM_RegWrite,
        MEM_MemtoReg,
        MEM_Data_in2,
        MEM_PC_plus_4,
        MEM_Write_register,
        MEM_ALU_out
    );


    // DataMemory data_memory1 (
    //     .reset     (reset),
    //     .clk       (clk),
    //     .Address   (MEM_ALU_out),
    //     .Write_data(MEM_Data_in2),
    //     .Read_data (MEM_Read_Data),
    //     .MemRead   (MEM_MemRead),
    //     .MemWrite  (MEM_MemWrite)
    // );
    always @(*) begin
        MemWrite <= MEM_MemWrite;
        MemAddress <= MEM_ALU_out;
        MemWriteData <= MEM_Data_in2;
    end
    assign MEM_Read_Data = MemReadData;
    MEM_WB mem_wb1 (
        clk,
        reset,
        MEM_RegWrite,
        MEM_MemtoReg,
        MEM_Write_register,
        MEM_Read_Data,
        MEM_ALU_out,
        MEM_PC_plus_4,
        WB_RegWrite,
        WB_MemtoReg,
        WB_Write_register,
        WB_Read_Data,
        WB_ALU_out,
        WB_PC_plus_4
    );

    // write back
    assign WB_Databus3 = (WB_MemtoReg == 2'b00)? WB_ALU_out: ((WB_MemtoReg == 2'b01)? WB_Read_Data: WB_PC_plus_4);





    Forward forward1 (
        .ID_Instruction    (ID_Instruction),
        .ID_PCSrc          (ID_PCSrc),
        .ID_Branch         (ID_Branch),
        .MEM_RegWrite      (MEM_RegWrite),
        .MEM_Write_register(MEM_Write_register),
        .ID_Forward_A      (ID_Forward_A),
        .ID_Forward_B      (ID_Forward_B),
        .EX_Instruction    (EX_Instruction),
        .WB_RegWrite       (WB_RegWrite),
        .WB_Write_register (WB_Write_register),
        .EX_Forward_A      (EX_Forward_A),
        .EX_Forward_B      (EX_Forward_B)
    );

    Hazard hazard1 (
        ID_Branch,
        ID_Zero,
        ID_PCSrc,
        ID_Instruction,
        EX_RegWrite,
        EX_MemRead,
        EX_Write_register,
        MEM_MemRead,
        MEM_Write_register,
        Stall,
        IF_Flush,
        ID_Flush
    );
endmodule
