//----------------------------------------------------------------------------
// Task
//----------------------------------------------------------------------------

module serial_adder_with_vld
(
  input  clk,
  input  rst,
  input  vld,
  input  a,
  input  b,
  input  last,
  output sum
);

    logic carry;
    logic carry_d;

    assign carry_d = (a & b) | (carry & (a ^ b));
    assign sum = vld ? (a ^ b ^ carry) : sum;

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            carry <= 1'b0;
        end else if (vld) begin
            if (last) begin
                carry <= 1'b0;
            end else begin
                carry <= carry_d;
            end
        end
    end


  // Task:
  // Implement a module that performs serial addition of two numbers
  // (one pair of bits is summed per clock cycle).
  //
  // It should have input signals a and b, and output signal sum.
  // Additionally, the module have two control signals, vld and last.
  //
  // The vld signal indicates when the input values are valid.
  // The last signal indicates when the last digits of the input numbers has been received.
  //
  // When vld is high, the module should add the values of a and b and produce the sum.
  // When last is high, the module should output the sum and reset its internal state, but
  // only if vld is also high, otherwise last should be ignored.
  //
  // When rst is high, the module should reset its internal state.


endmodule
