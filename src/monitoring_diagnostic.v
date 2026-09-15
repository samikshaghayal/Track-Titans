`timescale 1ns/1ps
`include "railway_defines.vh"
`include "railway_pkg.vh"

module monitoring_diagnostic
(
    input clk,
    input reset,

    input train_departed,

    output reg system_running,
    output reg [7:0] train_count
);


//--------------------------------------------------
// Monitoring Logic
//--------------------------------------------------

always @(posedge clk)
begin

    if(reset)
    begin
        system_running <= 1'b0;
        train_count    <= 8'd0;
    end

    else
    begin

        system_running <= 1'b1;

        if(train_departed)
        begin
            train_count <= train_count + 1'b1;
        end

    end

end


endmodule
