//----------------------------------------------------------------------------
// Task
//----------------------------------------------------------------------------

module halve_tokens
(
    input  clk,
    input  rst,
    input  a,
    output b
);

    // Task:
    // Implement a serial module that reduces amount of incoming '1' tokens by half.
    //
    // Note:
    // Check the waveform diagram in the README for better understanding.
    //
    // Example:
    // a -> 110_011_101_000_1111
    // b -> 010_001_001_000_0101

    // Internal state to track whether to pass or suppress the next '1'.
    logic suppress_next_one;
    // To save output.
    logic b_saved;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            suppress_next_one <= 1'b0;
            b_saved <= 1'b0;
        end else begin
            if (a == 1'b1) begin
                if (suppress_next_one) begin
                    b_saved <= 1'b0;
                    suppress_next_one <= 1'b0;
                end else begin
                    b_saved <= 1'b1;
                    suppress_next_one <= 1'b1;
                end
            end else begin
                b_saved <= 1'b0;
            end
        end
    end

    assign b = b_saved;

endmodule
