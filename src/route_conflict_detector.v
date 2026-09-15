`timescale 1ns/1ps
`include "railway_defines.vh"
`include "railway_pkg.vh"
module route_conflict_detector(input clk,input reset,input route_request,input [4:0] requested_route,input [4:0] active_route,input route_locked,input track_busy,output reg conflict_detected,output reg [4:0] conflict_route,output reg route_safe);
always @(posedge clk) begin
if(reset) begin conflict_detected<=1'b0; conflict_route<=5'd0; route_safe<=1'b0; end
else if(route_request) begin
if(route_locked && (requested_route==active_route)) begin conflict_detected<=1'b1; conflict_route<=requested_route; route_safe<=1'b0; end
else if(track_busy) begin conflict_detected<=1'b1; conflict_route<=requested_route; route_safe<=1'b0; end
else begin conflict_detected<=1'b0; conflict_route<=5'd0; route_safe<=1'b1; end
end
end
endmodule
