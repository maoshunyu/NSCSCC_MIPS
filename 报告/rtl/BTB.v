module BTB (
    input                clk,
    input                reset,
    input                Update,
    input  wire [31 : 0] PC,
    input  wire [  31:0] PC_Update,
    output reg  [  31:0] Branch_Pred_target,
    input  wire [  31:0] Branch_Update_target,
    output reg           BTB_Hit
);
    wire [ 4:0] index = PC[6:2];
    wire [ 4:0] index_update = PC_Update[6:2];

    wire [24:0] tag = PC[31:7];
    wire [24:0] tag_update = PC_Update[31:7];

    reg  [56:0] btbs                          [31:0];
    // 56--------32 - 31------0
    always @(*) begin
        Branch_Pred_target <= btbs[index][31:0];
        BTB_Hit <= tag == btbs[index][56:32];
    end
    integer i;
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            for (i = 0; i < 32; i = i + 1) btbs[i] <= 57'b0;
        end
        else begin
            if (Update) begin
                btbs[index_update] <= {tag_update, Branch_Update_target};
            end
        end
    end
endmodule
