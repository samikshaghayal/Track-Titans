`timescale 1ns/1ps

module railway_top_tb;

//--------------------------------------------------
// Inputs
//--------------------------------------------------

reg clk;
reg reset;

reg train_request;
reg [5:0] train_id;
reg [2:0] entry_track;
reg direction;
reg [1:0] train_type;
reg emergency_flag;
reg [7:0] timestamp;

reg track_busy;

reg signal_fault;


//--------------------------------------------------
// Outputs
//--------------------------------------------------

wire signal_red;
wire signal_yellow;
wire signal_green;

wire switch_left;
wire switch_right;

wire train_move;


//--------------------------------------------------
// DUT Instantiation
//--------------------------------------------------

railway_top DUT
(
    .clk(clk),
    .reset(reset),

    .train_request(train_request),
    .train_id(train_id),
    .entry_track(entry_track),
    .direction(direction),
    .train_type(train_type),
    .emergency_flag(emergency_flag),
    .timestamp(timestamp),

    .track_busy(track_busy),

    .signal_fault(signal_fault),

    .signal_red(signal_red),
    .signal_yellow(signal_yellow),
    .signal_green(signal_green),

    .switch_left(switch_left),
    .switch_right(switch_right),

    .train_move(train_move)
);


//--------------------------------------------------
// Clock Generation
//--------------------------------------------------

always #5 clk = ~clk;


//--------------------------------------------------
// FSDB + VCD Waveform Dump
//--------------------------------------------------

initial
begin

    $fsdbDumpfile("railway.fsdb");
    $fsdbDumpvars(0, railway_top_tb);

end



//--------------------------------------------------
// Test Sequence
//--------------------------------------------------

initial
begin

    // Initial values

    clk = 0;
    reset = 1;

    train_request = 0;

    train_id = 6'd0;
    entry_track = 3'd0;
    direction = 1'b0;
    train_type = 2'b00;
    emergency_flag = 1'b0;
    timestamp = 8'd0;


    // Safety inputs

    track_busy = 1'b0;
   
    signal_fault = 1'b0;



    //----------------------------------------------
    // Reset
    //----------------------------------------------

    #20;
    reset = 0;



    //----------------------------------------------
    // Train 1 Request
    //----------------------------------------------

    #20;

    train_id = 6'd1;
    entry_track = 3'd1;
    direction = 1'b0;
    train_type = 2'b01;
    emergency_flag = 1'b0;
    timestamp = 8'd20;

    train_request = 1'b1;


    #10;

    train_request = 1'b0;



    //----------------------------------------------
    // Train 2 Request
    //----------------------------------------------

    #60;

    train_id = 6'd2;
    entry_track = 3'd2;
    direction = 1'b1;
    train_type = 2'b10;
    emergency_flag = 1'b0;
    timestamp = 8'd50;

    train_request = 1'b1;


    #10;

    train_request = 1'b0;



    //----------------------------------------------
    // End Simulation
    //----------------------------------------------

    #100;

    $finish;

end



//--------------------------------------------------
// Monitor
//--------------------------------------------------

initial
begin

    $display("Time\tReset\tReq\tGreen\tMove");
    $monitor(
"%0t Req=%b RV=%b SV=%b RS=%b CR=%0d RR=%b REL=%b RL=%b Move=%b",
$time,
train_request,
DUT.route_valid,
DUT.safe_valid,
DUT.route_safe,
DUT.conflict_route,
DUT.route_ready,
DUT.release_required,
DUT.route_locked,
train_move
);
end


endmodule
