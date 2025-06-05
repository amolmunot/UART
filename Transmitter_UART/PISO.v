module PISO (
    input wire         reset_n,        // Active low reset
    input wire         switch,         // Start transmission
    input wire         baud_clk,       // Baud rate clock
    input wire         parity_bit,     // Parity input
    input wire [7:0]   data_in,        // 8-bit parallel data

    output reg         data_tx,        // Serial output
    output reg         active_flag,    // HIGH when transmitting
    output reg         done_flag       // HIGH when done
);

// Internal registers
reg [3:0]   stop_count;
reg [10:0]  frame_r;
reg [10:0]  frame_man;
reg         next_state, curr_state;

// FSM states
localparam IDLE   = 1'b0,
           ACTIVE = 1'b1;
  

// Counter full flag
wire count_full = (stop_count == 4'd11);

  
// Frame Generation
always @(posedge baud_clk or negedge reset_n) begin
    if (!reset_n)
        frame_r <= 11'b111_1111_1111;
    else if (curr_state == IDLE && switch)
        frame_r <= {1'b1, parity_bit, data_in, 1'b0};  // {Stop, Parity, Data[7:0], Start}
end


// FSM: State Register
always @(posedge baud_clk or negedge reset_n) begin
    if (!reset_n)
        curr_state <= IDLE;
    else
        curr_state <= next_state;
end


// FSM: Next State Logic
always @(*) begin
    case (curr_state)
        IDLE:   next_state = (switch) ? ACTIVE : IDLE;
        ACTIVE: next_state = (count_full) ? IDLE : ACTIVE;
        default: next_state = IDLE;
    endcase
end

// Counter Logic
always @(posedge baud_clk or negedge reset_n) begin
    if (!reset_n || curr_state == IDLE || count_full)
        stop_count <= 4'd0;
    else
        stop_count <= stop_count + 1'b1;
end


// Frame Shift Register
always @(posedge baud_clk or negedge reset_n) begin
    if (!reset_n)
        frame_man <= 11'b111_1111_1111;
    else if (curr_state == IDLE && switch)
        frame_man <= {1'b1, parity_bit, data_in, 1'b0};  // load full frame
    else if (curr_state == ACTIVE)
        frame_man <= frame_man >> 1;  // shift frame
end


// Output Logic
always @(posedge baud_clk or negedge reset_n) begin
    if (!reset_n) begin
        data_tx     <= 1'b1;
        active_flag <= 1'b0;
        done_flag   <= 1'b0;
    end else begin
        case (curr_state)
            IDLE: begin
                data_tx     <= 1'b1;       // line idle
                active_flag <= 1'b0;
                done_flag   <= (switch) ? 1'b0 : 1'b1; // done if nothing to send
            end
            ACTIVE: begin
                data_tx     <= frame_man[0]; // send LSB
                active_flag <= 1'b1;
                done_flag   <= 1'b0;
            end
        endcase
    end
end

endmodule
