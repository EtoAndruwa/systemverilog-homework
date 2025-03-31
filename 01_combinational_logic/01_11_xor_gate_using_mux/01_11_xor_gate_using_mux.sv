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
endmodule

module and_gate_using_mux
(
    input  a,
    input  b,
    output o
);

  // Store the result of mux1.
  logic mux1_res;

  mux mux1 (
    .d0(0),
    .d1(b),
    .sel(a),
    .y(mux1_res)
  );

  mux mux2 (
    .d0(0),
    .d1(1),
    .sel(mux1_res),
    .y(o)
  );
endmodule

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
endmodule

module xor_gate_using_mux
(
    input  a,
    input  b,
    output o
);

  logic [2:0] gate_results;

  or_gate_using_mux OR (
    .a(a),
    .b(b),
    .o(gate_results[0])
  );

  and_gate_using_mux AND (
    .a(a),
    .b(b),
    .o(gate_results[1])
  );

  not_gate_using_mux NAND (
    .i(gate_results[1]),
    .o(gate_results[2])
  );

  and_gate_using_mux XOR (
    .a(gate_results[2]),
    .b(gate_results[0]),
    .o(o)
  );

  // Solution:
  // (a OR b) AND (a NAND b)

  // Task:
  // Implement xor gate using instance(s) of mux,
  // constants 0 and 1, and wire connections


endmodule
