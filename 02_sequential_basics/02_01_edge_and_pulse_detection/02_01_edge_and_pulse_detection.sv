//----------------------------------------------------------------------------
// Example
//----------------------------------------------------------------------------

module posedge_detector (input clk, rst, a, output detected);

  logic a_r;

  // Note:
  // The a_r flip-flop input value d propogates to the output q
  // only on the next clock cycle.

  always_ff @ (posedge clk)
    if (rst)
      a_r <= '0;
    else
      a_r <= a;

  assign detected = ~ a_r & a;

endmodule

//----------------------------------------------------------------------------
// Task
//----------------------------------------------------------------------------

module one_cycle_pulse_detector (input clk, rst, a, output detected);

    logic a_prev;
    logic a_prev2;

    // Create flip-flop
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            a_prev <= 1'b0;
            a_prev2 <= 1'b0;
        end else begin
            a_prev <= a;
            a_prev2 <= a_prev;
        end
    end

    assign detected =  a_prev & ~a_prev2 & ~a ;

  // Task:
  // Create an one cycle pulse (010) detector.
  //
  // Note:
  // See the testbench for the output format ($display task).


endmodule
