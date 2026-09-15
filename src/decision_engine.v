`timescale 1ns/1ps
`include "railway_defines.vh"
`include "railway_pkg.vh"

module decision_engine
(
    input               clk,
    input               reset,

    //--------------------------------------------------
    // Input from Intelligent Scheduler
    //--------------------------------------------------

    input      [31:0]   selected_packet,
    input               selected_valid,

    //--------------------------------------------------
    // Output to Safety Integrity Checker
    //--------------------------------------------------

    output reg [4:0]    platform_number,
    output reg [4:0]    route_number,
    output reg          route_valid
);


//--------------------------------------------------
// Internal Registers
//--------------------------------------------------

reg [2:0] entry_track;
//reg       direction;
reg       emergency_flag;


//--------------------------------------------------
// FSM State Encoding
//--------------------------------------------------

localparam IDLE        = 3'd0;
localparam DECODE      = 3'd1;
localparam ALLOCATE    = 3'd2;
localparam SEND_ROUTE  = 3'd3;

reg [2:0] current_state;
reg [2:0] next_state;


//--------------------------------------------------
// State Register
//--------------------------------------------------

always @(posedge clk)
begin
    if(reset)
        current_state <= IDLE;
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

        IDLE:
        begin
            if(selected_valid)
                next_state = DECODE;
        end

        DECODE:
        begin
            next_state = ALLOCATE;
        end

        ALLOCATE:
        begin
            next_state = SEND_ROUTE;
        end

        SEND_ROUTE:
        begin
            next_state = IDLE;
        end

        default:
        begin
            next_state = IDLE;
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

        entry_track     <= 3'd0;
  //      direction       <= 1'b0;
        emergency_flag  <= 1'b0;

        platform_number <= 5'd0;
        route_number    <= 5'd0;
        route_valid     <= 1'b0;

    end

    else
    begin

        route_valid <= 1'b0;

        case(current_state)

        //--------------------------------------------------
        // Decode Incoming Packet
        //--------------------------------------------------

        DECODE:
        begin

            entry_track    <= selected_packet[25:23];
    //        direction      <= selected_packet[22];
            emergency_flag <= selected_packet[19];

        end


        //--------------------------------------------------
        // Platform and Route Allocation
        //--------------------------------------------------

        ALLOCATE:
        begin

            //--------------------------------------------------
            // Emergency Train gets highest priority
            //--------------------------------------------------

            if(emergency_flag)
            begin

                platform_number <= 5'd1;
                route_number    <= 5'd1;

            end

            else
            begin

                case(entry_track)

                    3'd0:
                    begin
                        platform_number <= 5'd1;
                        route_number    <= 5'd1;
                    end

                    3'd1:
                    begin
                        platform_number <= 5'd2;
                        route_number    <= 5'd2;
                    end

                    3'd2:
                    begin
                        platform_number <= 5'd3;
                        route_number    <= 5'd3;
                    end

                    3'd3:
                    begin
                        platform_number <= 5'd4;
                        route_number    <= 5'd4;
                    end

                    3'd4:
                    begin
                        platform_number <= 5'd5;
                        route_number    <= 5'd5;
                    end

                    default:
                    begin
                        platform_number <= 5'd0;
                        route_number    <= 5'd0;
                    end

                endcase

            end

        end


        //--------------------------------------------------
        // Send Valid Route
        //--------------------------------------------------

        SEND_ROUTE:
        begin

            route_valid <= 1'b1;

        end

        default:
        begin

            route_valid <= 1'b0;

        end

        endcase

    end

end

endmodule
