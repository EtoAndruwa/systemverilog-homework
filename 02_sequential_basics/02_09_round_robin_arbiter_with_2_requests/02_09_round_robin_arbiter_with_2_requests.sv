//----------------------------------------------------------------------------
// Task
//----------------------------------------------------------------------------

module round_robin_arbiter_with_2_requests
(
    input        clk,
    input        rst,
    input  [1:0] requests,
    output [1:0] grants
);
    // Task:
    // Implement a "arbiter" module that accepts up to two requests
    // and grants one of them to operate in a round-robin manner.
    //
    // The module should maintain an internal register
    // to keep track of which requester is next in line for a grant.
    //
    // Note:
    // Check the waveform diagram in the README for better understanding.
    //
    // Example:
    // requests -> 01 00 10 11 11 00 11 00 11 11
    // grants   -> 01 00 10 01 10 00 01 00 10 01

    assign grants = grants_saved;

    logic [1:0] mask;
    logic [1:0] grants_saved;

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            mask <= 2'b00;
            grants_saved <= 2'b00;
        end else begin
            if ($isunknown(mask)) begin
                mask <= 2'b00;
            end

            if (requests == 2'b00) begin
                grants_saved <= 2'b00;
            end else begin
                if (mask == 2'b00) begin
                    if (requests == 2'b11) begin
                        grants_saved <= 2'b01;
                        mask <= 2'b10;
                    end else begin
                        grants_saved <= requests;
                        mask <= ~requests;
                    end
                end else begin
                    grants_saved <= requests & mask;
                    mask <= ~mask;
                end
            end
        end
    end


endmodule
