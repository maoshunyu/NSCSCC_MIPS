module top (
    input             clk,
    input             reset,
    output reg  [7:0] leds,
    output reg  [3:0] ans,
    output wire       txd,
    input  wire       rxd,
    output reg  [4:0] con
);
    wire [31:0] IF_Instruction;
    wire [31:0] IF_PC;
    wire [31:0] MemReadData;
    wire [31:0] MemWriteData;
    wire [31:0] MemAddress;
    wire [31:0] phy_Instr_Addr;
    wire [31:0] phy_Data_Addr;
    wire        MemWrite;
    wire        MemRead;
    wire        is_peri;
    wire [31:0] Dram_ReadData;
    reg  [31:0] Peri_ReadData;

    wire        nclk = ~clk;
    CPU u_CPU (
        .reset         (reset),
        .clk           (clk),
        .IF_Instruction(IF_Instruction),
        .IF_PC         (IF_PC),
        .MemWrite      (MemWrite),
        .MemReadData   (MemReadData),
        .MemAddress    (MemAddress),
        .MemWriteData  (MemWriteData)
    );
    I_RAM iram (
        .clk(clk),                   // input wire clka
        .we (1'b0),                  // input wire [0 : 0] wea
        .a  (phy_Instr_Addr[10:2]),  // input wire [10 : 0] addra
        .d  (32'b0),                 // input wire [31 : 0] dina
        .spo(IF_Instruction)         // output wire [31 : 0] douta
    );
    D_RAM dram (
        .clka (nclk),                   // input wire clka
        .wea  (MemWrite & (~is_peri)),  // input wire [0 : 0] wea
        .addra(phy_Data_Addr[12:2]),    // input wire [10 : 0] addra
        .dina (MemWriteData),           // input wire [31 : 0] dina
        .douta(Dram_ReadData)           // output wire [31 : 0] douta
    );
    assign MemReadData = is_peri ? Peri_ReadData : Dram_ReadData;
    MMU u_MMU (
        .rst    (rst),
        .PC_in  (IF_PC),
        .MEM_in (MemAddress),
        .PC_out (phy_Instr_Addr),
        .MEM_out(phy_Data_Addr),
        .is_peri(is_peri)
    );

    wire       rx_ready;
    reg        rx_avai;
    wire       tx_busy;
    reg        tx_start;
    reg        tx_done;
    wire       o_Tx_Done;  //Only High for 1 Cycle

    reg  [7:0] uart_txd;
    wire [7:0] uart_rxd;


    always @(posedge clk or posedge reset) begin
        if (reset) begin
            leds <= 0;
            ans <= 0;
            Peri_ReadData <= 0;
            tx_start <= 0;
        end
        else begin
            if (is_peri) begin
                case (phy_Data_Addr[7:0])
                    8'h10: begin
                        if (MemWrite) begin
                            leds <= MemWriteData[7:0];
                            ans  <= MemWriteData[11:8];
                        end
                    end
                    8'h18: begin  //txd
                        if (MemWrite && !tx_busy) begin
                            tx_start <= 1;
                            uart_txd <= MemWriteData[7:0];
                        end
                    end
                    8'h1c: begin  //rxd
                        if (MemRead) Peri_ReadData <= uart_rxd;
                    end
                    8'h20: begin  //con
                        if (MemRead) Peri_ReadData <= {tx_busy, rx_avai, tx_done, 2'b0};
                    end
                endcase
            end
        end
    end
    always @(posedge clk or posedge reset) begin
        if (reset) rx_avai <= 0;
        else if (rx_ready) rx_avai <= 1;
        else if (is_peri && phy_Data_Addr[7:0] == 8'h20 && MemRead && rx_avai) rx_avai <= 0;
    end
    always @(posedge clk or posedge reset) begin
        if (reset) tx_done <= 0;
        else if (o_Tx_Done) tx_done <= 1;
        else if (is_peri && phy_Data_Addr[7:0] == 8'h20 && MemRead && tx_done) tx_done <= 0;
    end
    uart_tx u_uart_tx (
        .i_Clock    (clk),
        .i_Tx_DV    (tx_start),
        .i_Tx_Byte  (uart_txd),
        .o_Tx_Active(tx_busy),
        .o_Tx_Serial(txd),
        .o_Tx_Done  (o_Tx_Done)
    );
    uart_rx u_uart_rx (
        .i_Clock    (clk),
        .i_Rx_Serial(rxd),
        .o_Rx_DV    (rx_ready),
        .o_Rx_Byte  (uart_rxd)
    );

endmodule
