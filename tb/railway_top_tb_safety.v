`timescale 1ns/1ps

module railway_top_tb;

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

wire signal_red;
wire signal_yellow;
wire signal_green;

wire switch_left;
wire switch_right;

wire train_move;

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

always #5 clk = ~clk;

initial
begin
    $fsdbDumpfile("railway_safety.fsdb");
    $fsdbDumpvars(0, railway_top_tb);
end


//--------------------------------------------------
// Task: generate train request
//--------------------------------------------------

task send_request;
    input [5:0] id;
    input [2:0] track;
    input dir;
    input [1:0] train_type_in;
    input emergency;
    input [7:0] time_stamp;

    begin

        @(negedge clk);

        train_id       = id;
        entry_track    = track;
        direction      = dir;
        train_type     = train_type_in;
        emergency_flag = emergency;
        timestamp      = time_stamp;

        train_request = 1'b1;

        @(negedge clk);

        train_request = 1'b0;

    end
endtask


//--------------------------------------------------
// Task: check train movement
//--------------------------------------------------

task check_move;
    input expected;
    input [200:0] test_name;

    begin
        if (expected === 1'b1)
        begin
            @(posedge train_move);

            if (train_move === 1'b1)
                $display("PASS: %s | train_move=%b",
                         test_name, train_move);
            else
                $display("FAIL: %s | expected=%b actual=%b",
                         test_name, expected, train_move);
        end
        else
        begin
            #100;

            if (train_move === 1'b0)
                $display("PASS: %s | train_move=%b",
                         test_name, train_move);
            else
                $display("FAIL: %s | expected=%b actual=%b",
                         test_name, expected, train_move);
        end
    end
endtask

//--------------------------------------------------
// Main Test Sequence
//--------------------------------------------------

initial
begin

    clk = 0;
    reset = 1;

    train_request = 0;

    train_id = 0;
    entry_track = 0;
    direction = 0;
    train_type = 0;
    emergency_flag = 0;
    timestamp = 0;

    track_busy = 0;
    signal_fault = 0;


    //--------------------------------------------------
    // RESET
    //--------------------------------------------------

    $display("");
    $display("==============================================");
    $display(" RAILWAY INTERLOCKING SAFETY VERIFICATION");
    $display("==============================================");

    #20;

    reset = 0;

    #20;


    //--------------------------------------------------
    // TEST 1: NORMAL SAFE ROUTE
    //--------------------------------------------------

    $display("");
    $display("TEST 1: NORMAL SAFE ROUTE");

    track_busy = 0;
    signal_fault = 0;

    send_request(
        6'd1,
        3'd1,
        1'b0,
        2'b01,
        1'b0,
        8'd20
    );

    check_move(
        1'b1,
        "NORMAL ROUTE"
    );


    //--------------------------------------------------
    // TEST 2: TRACK BUSY
    //--------------------------------------------------

    $display("");
    $display("TEST 2: TRACK BUSY");

    reset = 1;
    #20;
    reset = 0;

    track_busy = 1;
    signal_fault = 0;

    send_request(
        6'd2,
        3'd1,
        1'b0,
        2'b01,
        1'b0,
        8'd30
    );

    check_move(
        1'b0,
        "TRACK BUSY - TRAIN MUST NOT MOVE"
    );


    //--------------------------------------------------
    // TEST 3: SIGNAL FAULT
    //--------------------------------------------------

    $display("");
    $display("TEST 3: SIGNAL FAULT");

    reset = 1;
    #20;
    reset = 0;

    track_busy = 0;
    signal_fault = 1;

    send_request(
        6'd3,
        3'd1,
        1'b0,
        2'b01,
        1'b0,
        8'd40
    );

    check_move(
        1'b0,
        "SIGNAL FAULT - TRAIN MUST NOT MOVE"
    );


    //--------------------------------------------------
// TEST 4: ROUTE CONFLICT
//--------------------------------------------------

$display("");
$display("TEST 4: ROUTE CONFLICT");

reset = 1;
#20;
reset = 0;

track_busy = 1;
signal_fault = 0;

send_request(
    6'd4,
    3'd1,
    1'b0,
    2'b01,
    1'b0,
    8'd50
);

#150;

$display("Route locked = %b",
         DUT.route_locked);

$display("Conflict detected = %b",
         DUT.conflict_detected);

$display("Conflict route = %0d",
         DUT.conflict_route);

$display("Train move = %b",
         train_move);

if (DUT.conflict_detected === 1'b1 &&
    train_move === 1'b0)
    $display("PASS: ROUTE CONFLICT - TRAIN MUST NOT MOVE");
else
    $display("FAIL: ROUTE CONFLICT");

    //--------------------------------------------------
    // TEST 5: DEADLOCK CONDITION
    //--------------------------------------------------

    $display("");
    $display("TEST 5: DEADLOCK CONDITION");

    reset = 1;
    #20;
    reset = 0;

    track_busy = 0;
    signal_fault = 0;

    send_request(
        6'd5,
        3'd1,
        1'b0,
        2'b01,
        1'b0,
        8'd60
    );

    #50;

    $display("Deadlock detected = %b",
             DUT.deadlock_detected);

    $display("Release required = %b",
             DUT.release_required);

    $display("Train move = %b",
             train_move);


    //--------------------------------------------------
    // TEST 6: ROUTE RELEASE
    //--------------------------------------------------

    $display("");
    $display("TEST 6: ROUTE RELEASE");

    $display("Before release:");
    $display("Route locked = %b",
             DUT.route_locked);

    $display("Release required = %b",
             DUT.release_required);

    #20;

    $display("After release:");
    $display("Route locked = %b",
             DUT.route_locked);

    $display("Release required = %b",
             DUT.release_required);


    //--------------------------------------------------
    // TEST 7: MULTIPLE TRAIN REQUESTS
    //--------------------------------------------------

    $display("");
    $display("TEST 7: MULTIPLE TRAIN REQUESTS");

    reset = 1;
    #20;
    reset = 0;

    track_busy = 0;
    signal_fault = 0;

    send_request(
        6'd10,
        3'd1,
        1'b0,
        2'b01,
        1'b0,
        8'd100
    );

    send_request(
        6'd11,
        3'd2,
        1'b1,
        2'b10,
        1'b0,
        8'd101
    );

    send_request(
        6'd12,
        3'd3,
        1'b0,
        2'b00,
        1'b0,
        8'd102
    );

    #100;

    $display("FIFO empty  = %b",
             DUT.fifo_empty);

    $display("FIFO full   = %b",
             DUT.fifo_full);

    $display("Train count = %0d",
             DUT.train_count);


    //--------------------------------------------------
    // TEST 8: POINT / SWITCH SELECTION
    //--------------------------------------------------

    $display("");
    $display("TEST 8: POINT / SWITCH SELECTION");

    reset = 1;
    #20;
    reset = 0;

    track_busy = 0;
    signal_fault = 0;

    send_request(
        6'd20,
        3'd1,
        1'b0,
        2'b01,
        1'b0,
        8'd120
    );

    #50;

    $display("Platform = %0d",
             DUT.safe_platform);

    $display("Route    = %0d",
             DUT.safe_route);

    $display("Switch LEFT  = %b",
             switch_left);

    $display("Switch RIGHT = %b",
             switch_right);


    //--------------------------------------------------
    // END
    //--------------------------------------------------

    $display("");
    $display("==============================================");
    $display(" SAFETY VERIFICATION COMPLETE");
    $display("==============================================");

    #50;

    $finish;

end

//--------------------------------------------------
// Continuous Debug Monitor
//--------------------------------------------------

initial
begin

    $monitor(
        "TIME=%0t REQ=%b BUSY=%b FAULT=%b | RV=%b SV=%b RS=%b CR=%0d RR=%b LOCK=%b DEADLOCK=%b RELEASE=%b MOVE=%b LEFT=%b RIGHT=%b",
        $time,
        train_request,
        track_busy,
        signal_fault,
        DUT.route_valid,
        DUT.safe_valid,
        DUT.route_safe,
        DUT.conflict_route,
        DUT.route_ready,
        DUT.route_locked,
        DUT.deadlock_detected,
        DUT.release_required,
        train_move,
        switch_left,
        switch_right
    );

end

endmodule
