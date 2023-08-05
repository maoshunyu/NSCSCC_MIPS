`define IN_RANGE(v, l, u) v[31:28] >= (l) && v[31:28] <= (u)

module MMU (
    input             rst,
    input      [31:0] PC_in,
    input      [31:0] MEM_in,
    output reg [31:0] PC_out,
    output reg [31:0] MEM_out,
    output reg        is_peri
);

    always @(*) begin
        if (rst) begin
            PC_out <= 0;
        end
        else begin
            PC_out <= PC_in;
        end
    end

    always @(*) begin
        if (rst) begin
            MEM_out <= 0;
            is_peri <= 0;
        end
        else begin
            if (MEM_in[31:28] >= 4'h4) begin
                MEM_out <= {MEM_in[31:28] - 4'h4, MEM_in[27:0]};
                is_peri <= 1;
            end
            else begin
                MEM_out <= MEM_in;
                is_peri <= 0;
            end
        end
    end

endmodule  // MMU
