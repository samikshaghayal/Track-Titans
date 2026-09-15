`timescale 1ns/1ps

`include "railway_defines.vh"
`include "railway_pkg.vh"

module deadlock_prevention
(
    input clk,
    input reset,

    input route_request,
    input route_locked,

    input [4:0] requested_route,
    input [4:0] active_route,

    input waiting_condition,

    output reg deadlock_detected,
    output reg [4:0] blocked_route,
    output reg release_required
);

always @(posedge clk)
begin

    if (reset)
    begin
        deadlock_detected <= 1'b0;
        blocked_route     <= 5'd0;
        release_required  <= 1'b0;
    end

    else
    begin

        deadlock_detected <= 1'b0;
        blocked_route     <= 5'd0;
        release_required  <= 1'b0;

        if (route_request &&
            route_locked &&
            (requested_route == active_route) &&
            waiting_condition)
        begin

            deadlock_detected <= 1'b1;
            blocked_route     <= requested_route;
            release_required  <= 1'b1;

        end

    end

end

endmodule
