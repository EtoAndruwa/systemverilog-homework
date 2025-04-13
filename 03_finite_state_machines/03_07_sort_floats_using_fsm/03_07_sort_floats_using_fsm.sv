//----------------------------------------------------------------------------
// Task
//----------------------------------------------------------------------------

module sort_floats_using_fsm (
    input                          clk,
    input                          rst,

    input                          valid_in,
    input        [0:2][FLEN - 1:0] unsorted,

    output logic                   valid_out,
    output logic [0:2][FLEN - 1:0] sorted,
    output logic                   err,
    output                         busy,

    // f_less_or_equal interface
    output logic      [FLEN - 1:0] f_le_a,
    output logic      [FLEN - 1:0] f_le_b,
    input                          f_le_res,
    input                          f_le_err
);

    // Task:
    // Implement a module that accepts three Floating-Point numbers and outputs them in the increasing order using FSM.
    //
    // Requirements:
    // The solution must have latency equal to the three clock cycles.
    // The solution should use the inputs and outputs to the single "f_less_or_equal" module.
    // The solution should NOT create instances of any modules.
    //
    // Notes:
    // res0 must be less or equal to the res1
    // res1 must be less or equal to the res1
    //
    // The FLEN parameter is defined in the "import/preprocessed/cvw/config-shared.vh" file
    // and usually equal to the bit width of the double-precision floating-point number, FP64, 64 bits.

    enum logic [2:0] {
        S_IDLE      = 3'b000,
        S_LOAD      = 3'b001,
        S_COMPARE_1 = 3'b010,
        S_COMPARE_2 = 3'b011,
        S_COMPARE_3 = 3'b100,
        S_DONE      = 3'b101
    } state, new_state;

    logic err1, err2, err3;

    always_comb begin
        new_state = state;

        case (state)
            S_IDLE:     if (valid_in) new_state = S_LOAD;
            S_LOAD:                   new_state = S_COMPARE_1;
            S_COMPARE_1:              new_state = S_COMPARE_2;
            S_COMPARE_2:              new_state = S_COMPARE_3;
            S_COMPARE_3:              new_state = S_DONE;
            S_DONE:                   new_state = S_IDLE;
        endcase
    end

    always_ff @(posedge clk) begin
        if (rst) begin
            valid_out <= 1'b0;
            err1      <= 1'b0;
            err2      <= 1'b0;
            err3      <= 1'b0;
        end else begin
            case (state)
                S_LOAD: begin
                    sorted <= unsorted;
                end

                S_COMPARE_1: begin
                    f_le_a <= sorted[0];
                    f_le_b <= sorted[1];

                    if (!f_le_res) begin
                        sorted[0] <= sorted[1];
                        sorted[1] <= sorted[0];
                    end

                    if (f_le_err) err1 <= 1'b1;
                    else err3 <= 1'b0;
                end

                S_COMPARE_2: begin
                    f_le_a <= sorted[1];
                    f_le_b <= sorted[2];

                    if (!f_le_res) begin
                        sorted[1] <= sorted[2];
                        sorted[2] <= sorted[1];
                    end
                    if (f_le_err) err2 <= 1'b1;
                    else err3 <= 1'b0;
                end

                S_COMPARE_3: begin
                    f_le_a <= sorted[0];
                    f_le_b <= sorted[1];

                    if (!f_le_res) begin
                        sorted[0] <= sorted[1];
                        sorted[1] <= sorted[0];
                    end
                    if (f_le_err) err3 <= 1'b1;
                    else err3 <= 1'b0;
                end

                S_DONE: begin
                    valid_out <= 1'b1;
                end
            endcase
        end
    end

    assign err = err1 | err2 | err3;
    assign busy = state != S_IDLE && state != S_DONE;

    always_ff @(posedge clk) begin
        if (rst)
            state <= S_IDLE;
        else
            state <= new_state;
    end

endmodule
