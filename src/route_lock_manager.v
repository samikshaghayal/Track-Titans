`timescale 1ns/1ps
`include "railway_defines.vh"
`include "railway_pkg.vh"

module route_lock_manager
(
    input clk,
    input reset,

    // Input from Point Switch Controller
    input route_ready,
    input release_required,

    // Output to Train Movement Controller
    output reg route_locked
);

always @(posedge clk)
begin

    if(reset)
    begin
        route_locked <= 1'b0;
    end

    else
    begin

    if(release_required)
        route_locked <= 1'b0;
    else if(route_ready)
         route_locked <= 1'b1;

    end

end

endmodule
