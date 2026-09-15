`timescale 1ns/1ps

//==============================================================
// TESTBENCH : railway_top_tb
// PROJECT   : Smart Railway Interlocking System
//
// Purpose:
//   This testbench verifies the railway_top module by applying
//   different train requests and safety conditions.
//
// Tests included:
//   1. Normal Train Request
//   2. Second Train Request
//   3. Entry Track 0
//   4. Entry Track 3
//   5. Entry Track 4
//   6. Emergency Train
//   7. Invalid Train ID
//   8. Track Busy Condition
//   9. Signal Fault Condition
//  10. Multiple Train Requests
//  11. Deadlock Prevention
//
// Waveform:
//   railway.fsdb
//==============================================================

module railway_top_tb;

//--------------------------------------------------------------
// 1. INPUT SIGNAL DECLARATIONS
//--------------------------------------------------------------

// Clock and reset
reg clk;
reg reset;

// Train request information
reg train_request;
reg [5:0] train_id;
reg [2:0] entry_track;
reg direction;
reg [1:0] train_type;
reg emergency_flag;
reg [7:0] timestamp;

// Safety-related inputs
reg track_busy;
reg signal_fault;


//--------------------------------------------------------------
// 2. OUTPUT SIGNAL DECLARATIONS
//--------------------------------------------------------------

// Signal outputs
wire signal_red;
wire signal_yellow;
wire signal_green;

// Point/switch outputs
wire switch_left;
wire switch_right;

// Train movement output
wire train_move;


//--------------------------------------------------------------
// 3. DUT - DEVICE UNDER TEST
//--------------------------------------------------------------
//
// railway_top is the complete railway interlocking system.
// The testbench supplies train requests and safety inputs,
// and observes the resulting signals, switches and movement.
//
//--------------------------------------------------------------

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


//--------------------------------------------------------------
// 4. CLOCK GENERATION
//--------------------------------------------------------------
//
// Clock period = 10 ns
// Clock toggles every 5 ns.
//
//--------------------------------------------------------------

always #5 clk = ~clk;


//--------------------------------------------------------------
// 5. FSDB WAVEFORM DUMP
//--------------------------------------------------------------
//
// Creates railway.fsdb for viewing internal signals in Verdi.
//
//--------------------------------------------------------------

initial
begin
    $fsdbDumpfile("railway.fsdb");
    $fsdbDumpvars(0, railway_top_tb);
end


//--------------------------------------------------------------
// 6. MAIN TEST SEQUENCE
//--------------------------------------------------------------

initial
begin

    //----------------------------------------------------------
    // INITIAL VALUES
    //----------------------------------------------------------
    //
    // All inputs are initialized before starting the tests.
    //

    clk = 1'b0;
    reset = 1'b1;

    train_request = 1'b0;

    train_id = 6'd0;
    entry_track = 3'd0;
    direction = 1'b0;
    train_type = 2'b00;
    emergency_flag = 1'b0;
    timestamp = 8'd0;

    track_busy = 1'b0;
    signal_fault = 1'b0;


    //----------------------------------------------------------
    // RESET
    //----------------------------------------------------------
    //
    // Keep reset active initially so all internal registers
    // of the railway system are initialized.
    //

    #20;
    reset = 1'b0;


    //----------------------------------------------------------
    // TEST 1: NORMAL TRAIN REQUEST
    //----------------------------------------------------------
    //
    // A normal train enters through track 1.
    // Expected:
    //   Request is accepted.
    //   Route is selected.
    //   Safety checks are performed.
    //   Train can eventually move.
    //

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


    //----------------------------------------------------------
    // TEST 2: SECOND TRAIN REQUEST
    //----------------------------------------------------------
    //
    // A second train is requested from entry track 2.
    // This checks the request FIFO/scheduler operation.
    //

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


    //----------------------------------------------------------
    // TEST 3: ENTRY TRACK 0
    //----------------------------------------------------------
    //
    // Tests route generation for entry track 0.
    //

    #40;

    train_id = 6'd3;
    entry_track = 3'd0;
    direction = 1'b0;
    train_type = 2'b00;
    emergency_flag = 1'b0;
    timestamp = 8'd60;

    train_request = 1'b1;

    #10;

    train_request = 1'b0;


    //----------------------------------------------------------
    // TEST 4: ENTRY TRACK 3
    //----------------------------------------------------------
    //
    // Tests another entry route with opposite direction.
    //

    #60;

    train_id = 6'd4;
    entry_track = 3'd3;
    direction = 1'b1;
    train_type = 2'b01;
    emergency_flag = 1'b0;
    timestamp = 8'd80;

    train_request = 1'b1;

    #10;

    train_request = 1'b0;


    //----------------------------------------------------------
    // TEST 5: ENTRY TRACK 4
    //----------------------------------------------------------
    //
    // Tests route selection for entry track 4.
    //

    #60;

    train_id = 6'd5;
    entry_track = 3'd4;
    direction = 1'b0;
    train_type = 2'b10;
    emergency_flag = 1'b0;
    timestamp = 8'd100;

    train_request = 1'b1;

    #10;

    train_request = 1'b0;


    //----------------------------------------------------------
    // TEST 6: EMERGENCY TRAIN
    //----------------------------------------------------------
    //
    // emergency_flag = 1
    //
    // This checks how the system handles a high-priority
    // emergency train request.
    //

    #60;

    train_id = 6'd6;
    entry_track = 3'd2;
    direction = 1'b0;
    train_type = 2'b11;
    emergency_flag = 1'b1;
    timestamp = 8'd120;

    train_request = 1'b1;

    #10;

    train_request = 1'b0;

    #40;

    emergency_flag = 1'b0;


    //----------------------------------------------------------
    // TEST 7: INVALID TRAIN ID
    //----------------------------------------------------------
    //
    // train_id = 40
    //
    // This checks the error handling of the train request
    // manager for an invalid train ID.
    //

    #60;

    train_id = 6'd40;
    entry_track = 3'd1;
    direction = 1'b0;
    train_type = 2'b00;
    emergency_flag = 1'b0;
    timestamp = 8'd140;

    train_request = 1'b1;

    #10;

    train_request = 1'b0;

    #40;


    //----------------------------------------------------------
    // TEST 8: TRACK BUSY
    //----------------------------------------------------------
    //
    // track_busy = 1
    //
    // This checks whether the safety logic prevents a route
    // from being considered safe when the track is occupied.
    //

    #60;

    track_busy = 1'b1;

    train_id = 6'd7;
    entry_track = 3'd2;
    direction = 1'b1;
    train_type = 2'b01;
    emergency_flag = 1'b0;
    timestamp = 8'd160;

    train_request = 1'b1;

    #10;

    train_request = 1'b0;

    #50;

    track_busy = 1'b0;


    //----------------------------------------------------------
    // TEST 9: SIGNAL FAULT
    //----------------------------------------------------------
    //
    // signal_fault = 1
    //
    // This verifies that the railway system does not allow
    // unsafe train movement when a signal fault exists.
    //

    #60;

    signal_fault = 1'b1;

    train_id = 6'd8;
    entry_track = 3'd3;
    direction = 1'b0;
    train_type = 2'b10;
    emergency_flag = 1'b0;
    timestamp = 8'd180;

    train_request = 1'b1;

    #10;

    train_request = 1'b0;

    #50;

    signal_fault = 1'b0;


    //----------------------------------------------------------
    // TEST 10: MULTIPLE TRAIN REQUESTS
    //----------------------------------------------------------
    //
    // Two requests are generated close together.
    // This checks the FIFO and intelligent scheduler.
    //

    #60;


    //----------------------------------------------------------
    // Request 1
    //----------------------------------------------------------

    train_id = 6'd9;
    entry_track = 3'd1;
    direction = 1'b0;
    train_type = 2'b01;
    emergency_flag = 1'b0;
    timestamp = 8'd200;

    train_request = 1'b1;

    #10;

    train_request = 1'b0;


    //----------------------------------------------------------
    // Request 2
    //----------------------------------------------------------

    #10;

    train_id = 6'd10;
    entry_track = 3'd4;
    direction = 1'b1;
    train_type = 2'b10;
    emergency_flag = 1'b0;
    timestamp = 8'd210;

    train_request = 1'b1;

    #10;

    train_request = 1'b0;

    #50;


        //----------------------------------------------------------
    // TEST 11: DEADLOCK PREVENTION
    //----------------------------------------------------------

    $display("");
    $display("==============================================");
    $display("TEST 11: DEADLOCK PREVENTION");
    $display("==============================================");

    //----------------------------------------------------------
    // Allow previous transactions to complete
    //----------------------------------------------------------

    #100;

    //----------------------------------------------------------
    // Create an intentional deadlock condition
    //
    // Required condition:
    //
    //   route_valid   = 1
    //   route_locked  = 1
    //   route_number  = safe_route
    //
    //----------------------------------------------------------

    $display("");
    $display("Creating intentional deadlock condition...");

    force DUT.route_valid   = 1'b1;
    force DUT.route_locked  = 1'b1;
    force DUT.route_number  = 5'd1;
    force DUT.safe_route    = 5'd1;

    #10;

    //----------------------------------------------------------
    // Display internal condition
    //----------------------------------------------------------

    $display("");
    $display("TEST 11 INTERNAL STATUS");
    $display("----------------------------------------------");
    $display("Route Valid        : %b", DUT.route_valid);
    $display("Route Number       : %0d", DUT.route_number);
    $display("Safe Route         : %0d", DUT.safe_route);
    $display("Route Locked       : %b", DUT.route_locked);
    $display("Waiting Condition  : %b", DUT.waiting_condition);
    $display("Deadlock Detected  : %b", DUT.deadlock_detected);
    $display("Release Required   : %b", DUT.release_required);
    $display("Blocked Route      : %0d", DUT.blocked_route);
    $display("----------------------------------------------");

    #10;

    //----------------------------------------------------------
    // Final deadlock prevention result
    //----------------------------------------------------------

    $display("");
    $display("----------------------------------------------");
    $display("DEADLOCK PREVENTION RESULT");
    $display("----------------------------------------------");

    $display("Deadlock Detected : %b", DUT.deadlock_detected);
    $display("Waiting Condition : %b", DUT.waiting_condition);
    $display("Route Locked      : %b", DUT.route_locked);
    $display("Release Required  : %b", DUT.release_required);
    $display("Blocked Route     : %0d", DUT.blocked_route);

    $display("----------------------------------------------");

    //----------------------------------------------------------
    // Release forced signals
    //----------------------------------------------------------

    release DUT.route_valid;
    release DUT.route_locked;
    release DUT.route_number;
    release DUT.safe_route;

    #10;

    //----------------------------------------------------------
    // Give some additional simulation time
    //----------------------------------------------------------

    #50;


    //----------------------------------------------------------
    // END SIMULATION
    //----------------------------------------------------------

    $display("");
    $display("==============================================");
    $display("ALL TESTS COMPLETED");
    $display("==============================================");

    #100;

    $finish;

end


//--------------------------------------------------------------
// 7. REAL-TIME INTERNAL SIGNAL MONITOR
//--------------------------------------------------------------
//
// This monitor prints important internal signals whenever any
// monitored signal changes.
//
// Signal meanings:
//
// RV  = Route Valid
// SV  = Safe Valid
// RS  = Route Safe
// CR  = Conflict Route
// RR  = Route Ready
// RL  = Route Locked
// WAIT = Waiting Condition
// DL  = Deadlock Detected
// REL = Release Required
// Move = Train Movement
//
// These signals are accessed hierarchically through DUT.
//
//--------------------------------------------------------------

initial
begin

    $display("");
    $display("==============================================================");
    $display("RAILWAY INTERLOCKING SYSTEM SIMULATION");
    $display("==============================================================");

    $display(
        "Time\tReq\tRV\tSV\tRS\tCR\tRR\tRL\tWAIT\tDL\tREL\tMove"
    );

    $monitor(
        "%0t\t%b\t%b\t%b\t%b\t%0d\t%b\t%b\t%b\t%b\t%b\t%b",

        $time,

        train_request,

        DUT.route_valid,

        DUT.safe_valid,

        DUT.route_safe,

        DUT.conflict_route,

        DUT.route_ready,

        DUT.route_locked,

        DUT.waiting_condition,

        DUT.deadlock_detected,

        DUT.release_required,

        train_move
    );

end

endmodule
