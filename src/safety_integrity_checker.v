`timescale 1ns/1ps
`include "railway_defines.vh"
`include "railway_pkg.vh"

module safety_integrity_checker
(
    input clk,
    input reset,

    // From Decision Engine
    input [4:0] platform_number,
    input [4:0] route_number,
    input route_valid,

    // Safety Inputs
    input track_busy,
    input route_locked,
    input signal_fault,

    // To Signal Manager
    output reg [4:0] safe_platform,
    output reg [4:0] safe_route,
    output reg safe_valid,

    output reg safety_error
);

always @(posedge clk)
begin

    if(reset)
    begin
        safe_platform <= 5'd0;
        safe_route    <= 5'd0;
        safe_valid    <= 1'b0;
        safety_error  <= 1'b0;
    end

    else
    begin

        safe_valid   <= 1'b0;
        safety_error <= 1'b0;

        if(route_valid)
        begin

            if(track_busy || route_locked || signal_fault)
            begin
                safety_error <= 1'b1;
            end

            else
            begin
                safe_platform <= platform_number;
                safe_route    <= route_number;
                safe_valid    <= 1'b1;
            end

        end

    end

end

endmodule
