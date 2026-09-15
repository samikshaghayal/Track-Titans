`timescale 1ns/1ps
`include "railway_defines.vh"
`include "railway_pkg.vh"

module signal_manager
(
    input clk,
    input reset,
    //input safe_valid,

    input  route_enable,

    output reg signal_red,
    output reg signal_yellow,
    output reg signal_green
);

always @(posedge clk)
begin
    if(reset)
    begin
        signal_red    <= 1'b1;
        signal_yellow <= 1'b0;
        signal_green  <= 1'b0;
        //route_enable  <= 1'b0;
    end
    else
    begin
        if(route_enable)
        begin
            signal_red    <= 1'b0;
            signal_yellow <= 1'b0;
            signal_green  <= 1'b1;
          //  route_enable  <= 1'b1;
        end
        else
        begin
            signal_red    <= 1'b1;
            signal_yellow <= 1'b0;
            signal_green  <= 1'b0;
            //route_enable  <= 1'b0;
        end
    end
end

endmodule
