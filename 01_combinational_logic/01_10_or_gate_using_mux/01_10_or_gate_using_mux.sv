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

`define true 1
`define false 0

module or_gate_using_mux
(
    input  a,
    input  b,
    output o
);

  // Store the result of mux1.
  logic mux1_res;

  mux mux1 (
    .d0(b),
    .d1(1),
    .sel(a),
    .y(mux1_res)
  );

  mux mux2 (
    .d0(0),
    .d1(1),
    .sel(mux1_res),
    .y(o)
  );

  // Solution in ternary: a ? 1 : b ? 1 : 0;

  // Task:

  // Implement or gate using instance(s) of mux,
  // constants 0 and 1, and wire connections


endmodule
