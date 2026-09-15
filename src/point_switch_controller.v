`timescale 1ns/1ps
`include "railway_defines.vh"
`include "railway_pkg.vh"

module point_switch_controller
(
    input clk,
    input reset,

    // Input from Signal Manager
    input route_enable,
    input [4:0] platform_number,
    // Output to Route Lock Manager
    output reg route_ready,

    // Point Switch Outputs
    output reg switch_left,
    output reg switch_right
);


   always @(posedge clk)
begin

    if(reset)
    begin
        switch_left  <= 1'b0;
        switch_right <= 1'b0;
        route_ready  <= 1'b0;
    end

    else
    begin

        if(route_enable)
        begin


            case(platform_number)

                5'd1, 5'd3, 5'd5:
                begin
                    switch_left  <= 1'b1;
                    switch_right <= 1'b0;
                end

                5'd2, 5'd4:
		begin
                    switch_left  <= 1'b0;
                    switch_right <= 1'b1;
                end

                default:
                begin
                    switch_left  <= 1'b0;
                    switch_right <= 1'b0;
                end

            endcase
               route_ready <= 1'b1;
        end

        else
        begin
            switch_left  <= 1'b0;
            switch_right <= 1'b0;
            route_ready  <= 1'b0;
        end

    end

end
endmodule
