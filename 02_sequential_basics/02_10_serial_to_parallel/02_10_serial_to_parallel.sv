//----------------------------------------------------------------------------
// Task
//----------------------------------------------------------------------------

module serial_to_parallel
# (
    parameter width = 8
)
(
    input                      clk,
    input                      rst,

    input                      serial_valid,
    input                      serial_data,

    output logic               parallel_valid,
    output logic [width - 1:0] parallel_data
);
    // Task:
    // Implement a module that converts serial data to the parallel multibit value.
    //
    // The module should accept one-bit values with valid interface in a serial manner.
    // After accumulating 'width' bits, the module should assert the parallel_valid
    // output and set the data.
    //
    // Note:
    // Check the waveform diagram in the README for better understanding.

    // $clog2 - tells how many bits are needed to represent values up to width - 1.
    logic [$clog2(width):0] bits_count;  // Counts how many bits received so far.
    logic [width - 1:0] shift_reg;       // Store the incoming bits.

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            bits_count     <= 0;
            shift_reg      <= 0;
            parallel_valid <= 0;
            parallel_data  <= 0;
        end else begin
            parallel_valid <= 0;

            if (serial_valid) begin
                shift_reg <= {shift_reg[width - 2:0], serial_data};
                bits_count <= bits_count + 1;

                if (bits_count == width - 1) begin
                    parallel_valid <= 1;
                    parallel_data  <= {shift_reg[width - 2:0], serial_data};
                    bits_count     <= 0;
                    shift_reg      <= 0;
                end
            end
        end
    end

endmodule
