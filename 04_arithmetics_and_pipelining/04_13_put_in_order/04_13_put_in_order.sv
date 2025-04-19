module put_in_order
# (
    parameter width    = 16,
              n_inputs = 4
)
(
    input                       clk,
    input                       rst,

    input  [ n_inputs - 1 : 0 ] up_vlds,
    input  [ n_inputs - 1 : 0 ]
           [ width    - 1 : 0 ] up_data,

    output                      down_vld,
    output [ width   - 1 : 0 ]  down_data
);

    // Task:
    //
    // Implement a module that accepts many outputs of the computational blocks
    // and outputs them one by one in order. Input signals "up_vlds" and "up_data"
    // are coming from an array of non-pipelined computational blocks.
    // These external computational blocks have a variable latency.
    //
    // The order of incoming "up_vlds" is not determent, and the task is to
    // output "down_vld" and corresponding data in a round-robin manner,
    // one after another, in order.
    //
    // Comment:
    // The idea of the block is kinda similar to the "parallel_to_serial" block
    // from Homework 2, but here block should also preserve the output order.

    logic [$clog2(n_inputs)-1:0] current_channel;
    logic [$clog2(n_inputs)-1:0] next_channel;
    logic [n_inputs-1:0] pending;
    logic [width-1:0] data_reg;
    logic valid_reg;
    logic found;
    logic [$clog2(n_inputs)-1:0] check_channel;

    always_comb begin
        next_channel = current_channel;
        found = 0;

        for (int i = 1; i < n_inputs; i++) begin
            check_channel = (current_channel + i) % n_inputs;

            if (pending[check_channel] && !found) begin
                next_channel = check_channel;
                found = 1;
            end
        end
    end

    logic [n_inputs-1:0] pending_next;
    always_comb begin
        pending_next = up_vlds | pending;
        if (down_vld) begin
            pending_next[current_channel] = 0;
        end
    end

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            current_channel <= 0;
            pending   <= 0;
            data_reg  <= 0;
            valid_reg <= 0;
        end else begin
            pending <= pending_next;

            if (!valid_reg || down_vld) begin
                if (|pending) begin
                    current_channel <= next_channel;
                    valid_reg       <= 1;
                    data_reg        <= up_data[next_channel];
                end else begin
                    valid_reg <= 0;
                end
            end
        end
    end

    assign down_vld = valid_reg;
    assign down_data = valid_reg ? data_reg : '0;

endmodule
