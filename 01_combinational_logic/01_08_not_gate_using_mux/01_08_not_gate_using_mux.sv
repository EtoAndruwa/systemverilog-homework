//----------------------------------------------------------------------------
// Example
//----------------------------------------------------------------------------

module mux
(
  input  d0, d1,
  input  sel,
  output y
);

  assign y = sel ? d1 : d0;

endmodule

//----------------------------------------------------------------------------
// Task
//----------------------------------------------------------------------------

module not_gate_using_mux
(
    input  i,
    output o
);

  mux mux1 (
    .d0(1),
    .d1(0),
    .sel(i),
    .y(o)
  );

  // Solution in ternary: i ? 1 : 0;

  // Task:
  // Implement not gate using instance(s) of mux,
  // constants 0 and 1, and wire connections


endmodule
