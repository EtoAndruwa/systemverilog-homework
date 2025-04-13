//----------------------------------------------------------------------------
// Task
//----------------------------------------------------------------------------

module double_tokens
(
    input        clk,
    input        rst,
    input        a,
    output       b,
    output logic overflow
);

    // Task:
    // Implement a serial module that doubles each incoming token '1' two times.
    // The module should handle doubling for at least 200 tokens '1' arriving in a row.
    //
    // In case module detects more than 200 sequential tokens '1', it should assert
    // an overflow error. The overflow error should be sticky. Once the error is on,
    // the only way to clear it is by using the "rst" reset signal.
    //
    // Note:
    // Check the waveform diagram in the README for better understanding.
    //
    // Example:
    // a -> 10 010 0 1100 0 110 100 00 1100 10 0
    // b -> 11 011 0 1111 0 111 111 00 1111 11 0

    logic [7:0] counter;          // Counter to track consecutive '1's.
    logic overflow_flag;          // Sticky overflow flag.
    logic [7:0] delayed;          // Number of delayed '1'.
    logic b_saved;                // Saved output b.

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            counter <= 8'd0;
            delayed <= 8'd0;
            overflow_flag <= 1'b0;
            b_saved <= 1'b0;
        end else begin
            if (a == 1'b1) begin
                if (counter < 200) begin
                    counter <= counter + 1;
                end else begin
                    overflow_flag <= 1'b1;
                end

                b_saved <= 1'b1;
                delayed <= delayed + 1;
            end else begin
                counter <= 0;

                if (delayed) begin
                    b_saved <= 1'b1;
                    delayed <= delayed - 1;
                end else begin
                    b_saved <= 1'b0;
                end
            end
        end
    end

    assign overflow = overflow_flag;
    assign b = b_saved;


endmodule
