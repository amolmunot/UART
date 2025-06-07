module SIPO (
    input  wire         reset_n,        // Active low reset
    input  wire         data_tx,        // Serial Data received from the transmitter
    input  wire         baud_clk,       // Sampling clock input

    output wire         active_flag,    // High when data is being received
    output wire         recieved_flag,  // High when full frame is received
    output wire [10:0]  data_parll      // 11-bit parallel frame output
);

  // FSM state encoding using parameters
  parameter IDLE   = 2'b00;
  parameter CENTER = 2'b01;
  parameter GET    = 2'b10;
  parameter FRAME  = 2'b11;

  // FSM state registers
  reg [1:0] current_state, next_state;

  // Internal registers
  reg [10:0] temp;
  reg [3:0] frame_counter;
  reg [3:0] stop_count;

  // Combinational logic for next state
  always @(*) begin
    case (current_state)
      IDLE: begin
        next_state = (data_tx == 1'b0) ? CENTER : IDLE;
      end
      CENTER: begin
        next_state = (stop_count == 4'd6) ? GET : CENTER;
      end
      GET: begin
        next_state = FRAME;
      end
      FRAME: begin
        if (frame_counter == 4'd10)
          next_state = IDLE;
        else if (stop_count == 4'd14)
          next_state = GET;
        else
          next_state = FRAME;
      end
      default: next_state = IDLE;
    endcase
  end

  // Sequential logic for state transitions and counters
  always @(posedge baud_clk or negedge reset_n) begin
    if (!reset_n) begin
      current_state  <= IDLE;
      temp           <= 11'b111_1111_1111;
      stop_count     <= 4'd0;
      frame_counter  <= 4'd0;
    end else begin
      current_state <= next_state;

      case (current_state)
        IDLE: begin
          temp          <= 11'b111_1111_1111;
          stop_count    <= 4'd0;
          frame_counter <= 4'd0;
        end

        CENTER: begin
          stop_count <= stop_count + 1;
        end

        GET: begin
          temp <= {data_tx, temp[10:1]};  // Right shift + insert new bit at MSB
        end

        FRAME: begin
          if (stop_count == 4'd14)
            stop_count <= 4'd0;
          else
            stop_count <= stop_count + 1;

          if (stop_count == 4'd14)
            frame_counter <= frame_counter + 1;
        end
      endcase
    end
  end

  // Output logic
  assign recieved_flag = (frame_counter == 4'd10);
  assign active_flag   = ~recieved_flag;
  assign data_parll    = recieved_flag ? temp : 11'b111_1111_1111;

endmodule
