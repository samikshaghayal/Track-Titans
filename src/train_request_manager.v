`timescale 1ns/1ps

`include "railway_defines.vh"
`include "railway_pkg.vh"

module train_request_manager
(
    input clk,
    input reset,

    input train_request,
    input [7:0] train_count,
    input [5:0] train_id,
    input [2:0] entry_track,
    input direction,
    input [1:0] train_type,
    input emergency_flag,
    input [7:0] timestamp,

    output reg [31:0] request_packet,
    output reg request_valid,
    output reg error_flag
);

//--------------------------------------------------
// State Registers
//--------------------------------------------------

reg [2:0] current_state;
reg [2:0] next_state;


//--------------------------------------------------
// State Register
//--------------------------------------------------

always @(posedge clk)
begin
    if(reset)
        current_state <= `IDLE;
    else
        current_state <= next_state;
end


//--------------------------------------------------
// Next State Logic
//--------------------------------------------------

always @(*)
begin

    next_state = current_state;

    case(current_state)

        `IDLE:
        begin
            if(train_request)
                next_state = `RECEIVE_REQUEST;
        end


        `RECEIVE_REQUEST:
        begin
            next_state = `VALIDATE_REQUEST;
        end


        `VALIDATE_REQUEST:
        begin

        if(train_count >= 8)
           next_state = `ERROR_STATE;

        else if(train_id < 6'd32)
           next_state = `GENERATE_PACKET;

        else
           next_state = `ERROR_STATE;

        end


        `GENERATE_PACKET:
        begin
            next_state = `SEND_TO_FIFO;
        end


        `SEND_TO_FIFO:
        begin
            next_state = `IDLE;
        end


        `ERROR_STATE:
        begin
            next_state = `IDLE;
        end


        default:
        begin
            next_state = `IDLE;
        end


    endcase

end



//--------------------------------------------------
// Output Logic
//--------------------------------------------------

always @(posedge clk)
begin

    if(reset)
    begin

        request_packet <= 32'd0;
        request_valid  <= 1'b0;
        error_flag     <= 1'b0;

    end

    else
    begin

        request_valid <= 1'b0;
        error_flag    <= 1'b0;


        case(current_state)


            //--------------------------------------------------
            // Generate 32-bit Train Request Packet
            //--------------------------------------------------
            //
            // Packet Format:
            //
            // [31:21] Reserved
            // [20:15] Train ID
            // [14:12] Entry Track
            // [11]    Direction
            // [10:9]  Train Type
            // [8]     Emergency Flag
            // [7:0]   Timestamp
            //
            //--------------------------------------------------

            `GENERATE_PACKET:
            begin

                request_packet <=
                {
                    11'b0,
                    train_id,
                    entry_track,
                    direction,
                    train_type,
                    emergency_flag,
                    timestamp
                };

            end



            //--------------------------------------------------
            // Send Packet to FIFO
            //--------------------------------------------------

            `SEND_TO_FIFO:
            begin

                request_valid <= 1'b1;

            end



            //--------------------------------------------------
            // Invalid Request
            //--------------------------------------------------

            `ERROR_STATE:
            begin

                request_packet <= 32'd0;
                error_flag     <= 1'b1;

            end



            default:
            begin

                request_valid <= 1'b0;
                error_flag    <= 1'b0;

            end


        endcase

    end

end


endmodule
