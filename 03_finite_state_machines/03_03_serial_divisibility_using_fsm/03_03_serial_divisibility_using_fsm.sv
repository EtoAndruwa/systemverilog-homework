//----------------------------------------------------------------------------
// Example
//----------------------------------------------------------------------------

module serial_divisibility_by_3_using_fsm
(
  input  clk,
  input  rst,
  input  new_bit,
  output div_by_3
);

  // States
  enum logic[1:0]
  {
     mod_0 = 2'b00,
     mod_1 = 2'b01,
     mod_2 = 2'b10
  }
  state, new_state;

  // State transition logic
  always_comb
  begin
    new_state = state;

    // This lint warning is bogus because we assign the default value above
    // verilator lint_off CASEINCOMPLETE

    case (state)
      mod_0 : if(new_bit) new_state = mod_1;
              else        new_state = mod_0;
      mod_1 : if(new_bit) new_state = mod_0;
              else        new_state = mod_2;
      mod_2 : if(new_bit) new_state = mod_2;
              else        new_state = mod_1;
    endcase

    // verilator lint_on CASEINCOMPLETE

  end

  // Output logic
  assign div_by_3 = state == mod_0;

  // State update
  always_ff @ (posedge clk)
    if (rst)
      state <= mod_0;
    else
      state <= new_state;

endmodule

//----------------------------------------------------------------------------
// Task
//----------------------------------------------------------------------------

module serial_divisibility_by_5_using_fsm
(
  input  clk,
  input  rst,
  input  new_bit,
  output div_by_5
);

  // Implement a module that performs a serial test if input number is divisible by 5.
  //
  // On each clock cycle, module receives the next 1 bit of the input number.
  // The module should set output to 1 if the currently known number is divisible by 5.
  //
  // Hint: new bit is coming to the right side of the long binary number `X`.
  // It is similar to the multiplication of the number by 2*X or by 2*X + 1.
  //
  // Hint 2: As we are interested only in the remainder, all operations are performed under the modulo 5 (% 5).
  // Check manually how the remainder changes under such modulo.

  enum logic [2:0] {
    S0 = 3'd0,  // remainder 0.
    S1 = 3'd1,  // remainder 1.
    S2 = 3'd2,  // remainder 2.
    S3 = 3'd3,  // remainder 3.
    S4 = 3'd4   // remainder 4.
  } state, new_state;

  always_comb begin
    new_state = state;

    case (state)
      S0: if (new_bit) new_state = S1;
          else         new_state = S0;
      S1: if (new_bit) new_state = S3;
          else         new_state = S2;
      S2: if (new_bit) new_state = S0;
          else         new_state = S4;
      S3: if (new_bit) new_state = S2;
          else         new_state = S1;
      S4: if (new_bit) new_state = S4;
          else         new_state = S3;
      default: new_state = S0;
    endcase
  end

  assign div_by_5 = state == S0;

  always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
      state <= S0;
    end else begin
      state <= new_state;
    end
  end

endmodule
