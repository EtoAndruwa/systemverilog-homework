//----------------------------------------------------------------------------
// Task
//----------------------------------------------------------------------------

module formula_1_pipe_aware_fsm
(
    input               clk,
    input               rst,

    input               arg_vld,
    input        [31:0] a,
    input        [31:0] b,
    input        [31:0] c,

    output logic        res_vld,
    output logic [31:0] res,

    // isqrt interface

    output logic        isqrt_x_vld,
    output logic [31:0] isqrt_x,

    input               isqrt_y_vld,
    input        [15:0] isqrt_y
);

    // Task:
    //
    // Implement a module formula_1_pipe_aware_fsm
    // with a Finite State Machine (FSM)
    // that drives the inputs and consumes the outputs
    // of a single pipelined module isqrt.
    //
    // The formula_1_pipe_aware_fsm module is supposed to be instantiated
    // inside the module formula_1_pipe_aware_fsm_top,
    // together with a single instance of isqrt.
    //
    // The resulting structure has to compute the formula
    // defined in the file formula_1_fn.svh.
    //
    // The formula_1_pipe_aware_fsm module
    // should NOT create any instances of isqrt module,
    // it should only use the input and output ports connecting
    // to the instance of isqrt at higher level of the instance hierarchy.
    //
    // All the datapath computations except the square root calculation,
    // should be implemented inside formula_1_pipe_aware_fsm module.
    // So this module is not a state machine only, it is a combination
    // of an FSM with a datapath for additions and the intermediate data
    // registers.
    //
    // Note that the module formula_1_pipe_aware_fsm is NOT pipelined itself.
    // It should be able to accept new arguments a, b and c
    // arriving at every N+3 clock cycles.
    //
    // In order to achieve this latency the FSM is supposed to use the fact
    // that isqrt is a pipelined module.
    //
    // For more details, see the discussion of this problem
    // in the article by Yuri Panchul published in
    // FPGA-Systems Magazine :: FSM :: Issue ALFA (state_0)
    // You can download this issue from https://fpga-systems.ru/fsm#state_0

    typedef enum logic [1:0] {
        IDLE,
        CALC_A,
        CALC_B,
        CALC_C
    } state_t;

    state_t state, next_state;

    logic [15:0] sqrt_a, sqrt_b, sqrt_c;
    logic sqrt_a_vld, sqrt_b_vld, sqrt_c_vld;

    logic [31:0] sum_ab, sum_abc;
    logic sum_ab_vld, sum_abc_vld;

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end

    always_comb begin
        next_state = state;
        isqrt_x_vld = 1'b0;
        isqrt_x = '0;

        case (state)
            IDLE: begin
                if (arg_vld) begin
                    next_state = CALC_A;
                    isqrt_x_vld = 1'b1;
                    isqrt_x = a;
                end
            end

            CALC_A: begin
                isqrt_x_vld = 1'b1;
                isqrt_x = b;
                next_state = CALC_B;
            end

            CALC_B: begin
                isqrt_x_vld = 1'b1;
                isqrt_x = c;
                next_state = CALC_C;
            end

            CALC_C: begin
                if (arg_vld) begin
                    isqrt_x_vld = 1'b1;
                    isqrt_x = a;
                    next_state = CALC_A;
                end else begin
                    next_state = IDLE;
                end
            end
        endcase
    end

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            sqrt_a <= '0;
            sqrt_b <= '0;
            sqrt_c <= '0;
            sqrt_a_vld <= 1'b0;
            sqrt_b_vld <= 1'b0;
            sqrt_c_vld <= 1'b0;
        end else begin
            if (isqrt_y_vld) begin
                case (state)
                    CALC_A: begin
                        sqrt_a <= isqrt_y;
                        sqrt_a_vld <= 1'b1;
                    end
                    CALC_B: begin
                        sqrt_b <= isqrt_y;
                        sqrt_b_vld <= 1'b1;
                    end
                    CALC_C: begin
                        sqrt_c <= isqrt_y;
                        sqrt_c_vld <= 1'b1;
                    end
                    default: begin
                        sqrt_a_vld <= 1'b0;
                        sqrt_b_vld <= 1'b0;
                        sqrt_c_vld <= 1'b0;
                    end
                endcase
            end
        end
    end

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            sum_ab <= '0;
            sum_abc <= '0;
            sum_ab_vld <= 1'b0;
            sum_abc_vld <= 1'b0;
            res <= '0;
            res_vld <= 1'b0;
        end else begin
            if (sqrt_a_vld && sqrt_b_vld) begin
                sum_ab <= sqrt_a + sqrt_b;
                sum_ab_vld <= 1'b1;
            end else begin
                sum_ab_vld <= 1'b0;
            end

            if (sum_ab_vld && sqrt_c_vld) begin
                sum_abc <= sum_ab + sqrt_c;
                sum_abc_vld <= 1'b1;
            end else begin
                sum_abc_vld <= 1'b0;
            end

            res <= sum_abc;
            res_vld <= sum_abc_vld;
        end
    end

endmodule
