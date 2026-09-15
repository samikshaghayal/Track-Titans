`timescale 1ns/1ps
`include "railway_defines.vh"
`include "railway_pkg.vh"

module intelligent_scheduler
(
    input               clk,
    input               reset,

    //--------------------------------------------------
    // Input from FIFO
    //--------------------------------------------------
    input      [31:0]   fifo_packet,
    input               fifo_empty,

    //--------------------------------------------------
    // Control to FIFO
    //--------------------------------------------------
    output reg          fifo_read_enable,

    //--------------------------------------------------
    // Output to Decision Engine
    //--------------------------------------------------
    output reg [31:0]   selected_packet,
    output reg          selected_valid
);


//--------------------------------------------------
// Scheduler State Machine
//--------------------------------------------------

localparam IDLE = 2'd0;
localparam READ = 2'd1;

reg [1:0] scheduler_state;
reg [1:0] next_state;


//--------------------------------------------------
// Next State Logic (Combinational)
//--------------------------------------------------

always @(*)
begin

    next_state = scheduler_state;

    case(scheduler_state)

        IDLE:
        begin
            if(!fifo_empty)
                next_state = READ;
        end

        READ:
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
// State Register (Sequential)
//--------------------------------------------------

always @(posedge clk)
begin

    if(reset)
        scheduler_state <= IDLE;
    else
        scheduler_state <= next_state;

end


//--------------------------------------------------
// Output Logic (Sequential)
//--------------------------------------------------

always @(posedge clk)
begin

    if(reset)
    begin
        fifo_read_enable <= 1'b0;
        selected_packet  <= 32'd0;
        selected_valid   <= 1'b0;
    end
    else
    begin

        fifo_read_enable <= 1'b0;
        selected_valid   <= 1'b0;

        case(scheduler_state)

            IDLE:
            begin
                if(!fifo_empty)
                    fifo_read_enable <= 1'b1;
            end

            READ:
            begin
                selected_packet <= fifo_packet;
                selected_valid  <= 1'b1;
            end

            default:
            begin
                fifo_read_enable <= 1'b0;
                selected_valid   <= 1'b0;
            end

        endcase

    end

end

endmodule
