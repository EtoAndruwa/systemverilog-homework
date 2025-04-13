//----------------------------------------------------------------------------
// Example
//----------------------------------------------------------------------------

module detect_4_bit_sequence_using_fsm
(
  input  clk,
  input  rst,
  input  a,
  output detected
);

  // Detection of the "1010" sequence

  // States (F — First, S — Second)
  enum logic[2:0]
  {
     IDLE = 3'b000,
     F1   = 3'b001,
     F0   = 3'b010,
     S1   = 3'b011,
     S0   = 3'b100
  }
  state, new_state;

  // State transition logic
  always_comb
  begin
    new_state = state;

    // This lint warning is bogus because we assign the default value above
    // verilator lint_off CASEINCOMPLETE

    case (state)
      IDLE: if (  a) new_state = F1;
      F1:   if (~ a) new_state = F0;
      F0:   if (  a) new_state = S1;
            else     new_state = IDLE;
      S1:   if (~ a) new_state = S0;
            else     new_state = F1;
      S0:   if (  a) new_state = S1;
            else     new_state = IDLE;
    endcase

    // verilator lint_on CASEINCOMPLETE

  end

  // Output logic (depends only on the current state)
  assign detected = (state == S0);

  // State update
  always_ff @ (posedge clk)
    if (rst)
      state <= IDLE;
    else
      state <= new_state;

endmodule

//----------------------------------------------------------------------------
// Task
//----------------------------------------------------------------------------

module detect_6_bit_sequence_using_fsm
(
  input  clk,
  input  rst,
  input  a,
  output detected
);

  // Task:
  // Implement a module that detects the "110011" input sequence
  //
  // Hint: See Lecture 3 for details
  // Define states for each step of the sequence "110011"

  enum logic[2:0]
  {
     IDLE = 3'b000, // found 0 right bit.
     S1   = 3'b001, // found 1 right bits.
     S2   = 3'b010, // found 2 right bits.
     S3   = 3'b011, // found 3 right bits.
     S4   = 3'b100, // found 4 right bits.
     S5   = 3'b101, // found 5 right bits.
     S6   = 3'b110  // found all bits.
  } state, new_state;

  always_comb begin
    new_state = state;

    case (state)
    IDLE:   if (a)  new_state = S1; // 1xxxxx.
            else    new_state = IDLE;
      S1:   if (a)  new_state = S2; // 11xxxx.
            else    new_state = IDLE;
      S2:   if (~a) new_state = S3; // 110xxx.
            else    new_state = S2;
      S3:   if (~a) new_state = S4; // 1100xx.
            else    new_state = S1;
      S4:   if (a)  new_state = S5; // 11001x.
            else    new_state = IDLE;
      S5:   if (a)  new_state = S6; // 110011.
            else    new_state = IDLE;
      S6:   if (a)  new_state = S2;
            else if (~a) new_state = S3;
    endcase
  end

  assign detected = state == S6;

  always_ff @ (posedge clk) begin
    if (rst) begin
      state <= IDLE;
    end else begin
      state <= new_state;
    end
  end

endmodule
