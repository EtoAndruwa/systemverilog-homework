//----------------------------------------------------------------------------
// Example
//----------------------------------------------------------------------------

module one_bit_wide_shift_register_with_reset
# (
    parameter depth = 8
)
(
    input  clk,
    input  rst,
    input  in_data,
    output out_data
);
    logic [depth - 1:0] data;

    always_ff @ (posedge clk)
        if (rst)
            data <= '0;
        else
            data <= { data [depth - 2:0], in_data };

    assign out_data = data [depth - 1];

endmodule

//----------------------------------------------------------------------------

module shift_register
# (
    parameter width = 8, depth = 8
)
(
    input                clk,
    input  [width - 1:0] in_data,
    output [width - 1:0] out_data
);
    logic [width - 1:0] data [0:depth - 1];

    always_ff @ (posedge clk)
    begin
        data [0] <= in_data;

        for (int i = 1; i < depth; i ++)
            data [i] <= data [i - 1];
    end

    assign out_data = data [depth - 1];

endmodule

//----------------------------------------------------------------------------
// Task
//----------------------------------------------------------------------------

module shift_register_with_valid
# (
    parameter width = 8, depth = 8
)
(
    input                clk,
    input                rst,

    input                in_vld,
    input  [width - 1:0] in_data,

    output               out_vld,
    output [width - 1:0] out_data
);

    // Task:
    //
    // Implement a variant of a shift register module
    // that moves a transfer of data only if this transfer is valid.
    //
    // For the discussion of shift registers
    // see the article by Yuri Panchul published in
    // FPGA-Systems Magazine :: FSM :: Issue ALFA (state_0)
    // You can download this issue from https://fpga-systems.ru/fsm#state_0

    logic [width - 1:0] data [0:depth - 1];
    logic               vlds [0:depth - 1];

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            for (int i = 0; i < depth; i++) begin
                data[i] <= '0;
                vlds[i] <= 1'b0;
            end
        end else begin
            if (in_vld) begin
                for (int i = depth - 1; i > 0; i--) begin
                    data[i] <= data[i - 1];
                end
                data[0] <= in_data;

                for (int i = depth - 1; i > 0; i--) begin
                    vlds[i] <= vlds[i - 1];
                end

                vlds[0] <= in_vld;
            end else begin
                vlds[0] <= 1'b0;
            end
        end
    end

    assign out_data = data[depth - 1];
    assign out_vld  = vlds[depth - 1];

endmodule
