//----------------------------------------------------------------------------
// Task
//----------------------------------------------------------------------------

module formula_2_pipe
(
    input         clk,
    input         rst,

    input         arg_vld,
    input  [31:0] a,
    input  [31:0] b,
    input  [31:0] c,

    output        res_vld,
    output [31:0] res
);

    // Task:
    //
    // Implement a pipelined module formula_2_pipe that computes the result
    // of the formula defined in the file formula_2_fn.svh.
    //
    // The requirements:
    //
    // 1. The module formula_2_pipe has to be pipelined.
    //
    // It should be able to accept a new set of arguments a, b and c
    // arriving at every clock cycle.
    //
    // It also should be able to produce a new result every clock cycle
    // with a fixed latency after accepting the arguments.
    //
    // 2. Your solution should instantiate exactly 3 instances
    // of a pipelined isqrt module, which computes the integer square root.
    //
    // 3. Your solution should save dynamic power by properly connecting
    // the valid bits.
    //
    // You can read the discussion of this problem
    // in the article by Yuri Panchul published in
    // FPGA-Systems Magazine :: FSM :: Issue ALFA (state_0)
    // You can download this issue from https://fpga-systems.ru/fsm#state_0

    logic [31:0] sqrt_c, sqrt_b_plus_sqrt_c, sqrt_a_plus_sqrt_b_plus_sqrt_c;
    logic isqrt_vld_c, isqrt_vld_b, isqrt_vld_a;

    isqrt #(.n_pipe_stages(4)) dd_isqrt_c
    (
        .clk    (clk        ),
        .rst    (rst        ),
        .x_vld  (arg_vld    ),
        .x      (c          ),
        .y_vld  (isqrt_vld_c),
        .y      (sqrt_c     )
    );

    logic [31:0] b_plus_sqrt_c;
    logic b_plus_sqrt_c_vld;

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            b_plus_sqrt_c <= 32'b0;
            b_plus_sqrt_c_vld <= 1'b0;
        end else begin
            if (isqrt_vld_c) begin
                b_plus_sqrt_c <= b + sqrt_c;
                b_plus_sqrt_c_vld <= 1'b1;
            end else begin
                b_plus_sqrt_c_vld <= 1'b0;
            end
        end
    end

    isqrt #(.n_pipe_stages(4)) dd_isqrt_b
    (
        .clk    (clk        ),
        .rst    (rst        ),
        .x_vld  (b_plus_sqrt_c_vld),
        .x      (b_plus_sqrt_c    ),
        .y_vld  (isqrt_vld_b      ),
        .y      (sqrt_b_plus_sqrt_c)
    );

    logic [31:0] a_plus_sqrt_b_plus_sqrt_c;
    logic a_plus_sqrt_b_plus_sqrt_c_vld;

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            a_plus_sqrt_b_plus_sqrt_c <= 32'b0;
            a_plus_sqrt_b_plus_sqrt_c_vld <= 1'b0;
        end else begin
            if (isqrt_vld_b) begin
                a_plus_sqrt_b_plus_sqrt_c <= a + sqrt_b_plus_sqrt_c;
                a_plus_sqrt_b_plus_sqrt_c_vld <= 1'b1;
            end else begin
                a_plus_sqrt_b_plus_sqrt_c_vld <= 1'b0;
            end
        end
    end

    isqrt #(.n_pipe_stages(4)) dd_isqrt_a
    (
        .clk    (clk        ),
        .rst    (rst        ),
        .x_vld  (a_plus_sqrt_b_plus_sqrt_c_vld),
        .x      (a_plus_sqrt_b_plus_sqrt_c    ),
        .y_vld  (isqrt_vld_a                  ),
        .y      (sqrt_a_plus_sqrt_b_plus_sqrt_c)
    );

    logic [31:0] res_stage_final;
    logic res_vld_final;

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            res_stage_final <= 32'b0;
            res_vld_final <= 1'b0;
        end else begin
            res_stage_final <= sqrt_a_plus_sqrt_b_plus_sqrt_c;
            res_vld_final <= isqrt_vld_a;
        end
    end

    assign res = res_stage_final;
    assign res_vld = res_vld_final;

endmodule
