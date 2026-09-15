`timescale 1ns/1ps
`include "railway_defines.vh"
`include "railway_pkg.vh"

module train_movement_controller
(
    input clk,
    input reset,

    // Input from Route Lock Manager
    input route_locked,

    // Output to Monitoring Module
    output reg train_departed,

    // Train Control
    output reg move_train
);

always @(posedge clk)
begin

    if(reset)
    begin
        move_train    <= 1'b0;
        train_departed <= 1'b0;
    end

    else
    begin

        if(route_locked)
        begin
            move_train     <= 1'b1;
            train_departed <= 1'b1;
        end

        else
        begin
            move_train     <= 1'b0;
            train_departed <= 1'b0;
        end

    end

end

endmodule
