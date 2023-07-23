module BP (
    input             clk,
    input             reset,
    input  wire [5:0] OpCode,
    input  wire       Update,
    input             Branch_Actual,
    output wire       Is_Branch,
    output reg        Branch_likely
);
    reg [1:0] Branch_State;  //0 --> Not Taken ; 1  --> Taken
    assign Is_Branch=(OpCode==6'h01)||(OpCode==6'h04)||(OpCode==6'h05)||(OpCode==6'h06)||(OpCode==6'h07);

    always @(*) begin
        if (Is_Branch) begin
            Branch_likely<=Branch_State[1];
        end
        else Branch_likely <= 0;
    end
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            Branch_State <= 2'b01;
        end
        else begin
            if (Update) begin
                case (Branch_State)
                    2'b00: begin
                        if (Branch_Actual) Branch_State <= 2'b01;
                        else Branch_State <= 2'b00;
                    end
                    2'b01: begin
                        if (Branch_Actual) Branch_State <= 2'b10;
                        else Branch_State <= 2'b00;
                    end
                    2'b11: begin
                        if (Branch_Actual) Branch_State <= 2'b11;
                        else Branch_State <= 2'b10;
                    end
                    2'b10: begin
                        if (Branch_Actual) Branch_State <= 2'b11;
                        else Branch_State <= 2'b01;
                    end
                    default: Branch_State <= Branch_State;
                endcase
            end
        end
    end
endmodule
