`timescale 1ns/1ps

`include "railway_defines.vh"
`include "railway_pkg.vh"


module fifo_request_buffer
(
    input clk,
    input reset,

    // Write side from Train Request Manager
    input [31:0] request_packet_in,
    input request_valid,

    // Read side to Intelligent Scheduler
    input read_enable,

    output reg [31:0] packet_out,

    output fifo_empty
);


//--------------------------------------------------
// FIFO Memory
//--------------------------------------------------

reg [31:0] fifo_mem [0:15];


//--------------------------------------------------
// FIFO Pointers
//--------------------------------------------------

reg [3:0] write_pointer;
reg [3:0] read_pointer;


//--------------------------------------------------
// FIFO Counter
//--------------------------------------------------

reg [4:0] count;


//--------------------------------------------------
// FIFO Status
//--------------------------------------------------

wire fifo_full;
assign fifo_full  = (count == 5'd16);
assign fifo_empty = (count == 5'd0);


//--------------------------------------------------
// FIFO Read / Write Operation
//--------------------------------------------------

always @(posedge clk)
begin

    if(reset)
    begin

        write_pointer <= 4'd0;
        read_pointer  <= 4'd0;
        count         <= 5'd0;
        packet_out    <= 32'd0;

    end

    else
    begin


        //--------------------------------------------------
        // Write Operation
        //--------------------------------------------------

        if(request_valid && !fifo_full && !read_enable)
        begin

            fifo_mem[write_pointer] <= request_packet_in;

            write_pointer <= write_pointer + 1'b1;

            count <= count + 1'b1;

        end


        //--------------------------------------------------
        // Read Operation
        //--------------------------------------------------

        else if(read_enable && !fifo_empty && !request_valid)
        begin

            packet_out <= fifo_mem[read_pointer];

            read_pointer <= read_pointer + 1'b1;

            count <= count - 1'b1;

        end


        //--------------------------------------------------
        // Simultaneous Read and Write
        //--------------------------------------------------

        else if(request_valid && read_enable &&
                !fifo_full && !fifo_empty)
        begin

            fifo_mem[write_pointer] <= request_packet_in;

            write_pointer <= write_pointer + 1'b1;


            packet_out <= fifo_mem[read_pointer];

            read_pointer <= read_pointer + 1'b1;


            count <= count;

        end


    end

end


endmodule
