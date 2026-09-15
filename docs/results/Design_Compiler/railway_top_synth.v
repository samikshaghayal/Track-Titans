/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Ultra(TM) in wire load mode
// Version   : T-2022.03-SP5
// Date      : Mon Sep  7 06:59:00 2026
/////////////////////////////////////////////////////////////


module railway_top ( clk, reset, train_request, train_id, entry_track, 
        direction, train_type, emergency_flag, timestamp, track_busy, 
        signal_fault, signal_red, signal_yellow, signal_green, switch_left, 
        switch_right, train_move );
  input [5:0] train_id;
  input [2:0] entry_track;
  input [1:0] train_type;
  input [7:0] timestamp;
  input clk, reset, train_request, direction, emergency_flag, track_busy,
         signal_fault;
  output signal_red, signal_yellow, signal_green, switch_left, switch_right,
         train_move;
  wire   switch_right, route_valid, route_locked, \safe_route[0] , safe_valid,
         route_safe, conflict_detected, deadlock_detected, error_flag,
         safety_error, \conflict_route[0] , \blocked_route[0] , request_valid,
         fifo_read_enable, selected_valid, \platform_number[0] ,
         \safe_platform[0] , system_running, \U1/N106 , \U1/N105 , \U3/N48 ,
         \U4/N83 , \U5/N22 , \U5/N21 , \U6/N4 , \U7/N32 , \U9/N3 , \U10/n3 ,
         \U10/n2 , \U12/N13 , \U12/N12 , n301, n302, n303, n308, n330, n331,
         n332, n333, n334, n335, n336, n343, n346, n349, n350, n353, n360,
         n361, n362, n363, n364, n365, n366, n367, n368, n369, n370, n371,
         n372, n373, n374, n375, n376, n377, n378, n379, n380, n381, n382,
         n383, n384, n385, n386, n387, n388, n389, n390, n391, n392, n393,
         n394, n395, n396, n397, n398, n399, n400, n401, n402, n403, n404,
         n405, n406, n407, n408, n409, n410, n411, n412, n413, n414, n415,
         n416, n417, n418, n419, n420, n421, n422, n423, n424, n425, n426,
         n427, n428, n429, n430, n431, n432, n433, n434, n435, n436, n437,
         n438, n439, n440, n441, n442, n443, n444, n445, n446, n447, n448,
         n449, n450, n451, n452, n453, n454, n455, n456, n457, n458, n459,
         n460, n461, n462, n463, n464, n465, n466, n467, n468, n469, n470,
         n471, n472, n473, n474, n475, n476, n477, n478, n479, n480, n481,
         n482, n483, n484, n485, n486, n487, n488, n489, n490, n491, n492,
         n493, n494, n495, n496, n497, n498, n499, n500, n501, n502, n503,
         n504, n505, n506, n507, n508, n509, n510, n511, n512, n513, n514,
         n515, n516, n517, n518, n519, n520, n521, n522, n523, n524, n525,
         n526, n527, n528, n529, n530, n531, n532, n533, n534, n535;
  wire   [7:0] train_count;
  wire   [2:0] \U1/current_state ;
  wire   [4:0] \U_FIFO/count ;
  wire   [2:0] \U4/current_state ;
  assign signal_yellow = switch_right;

  SAEDRVT05_FDP_X1_FA \U10/system_running_reg  ( .D(n370), .CLK(clk), .Q(
        system_running) );
  SAEDRVT05_FDP_X1_FA \U12/deadlock_detected_reg  ( .D(\U12/N12 ), .CLK(clk), 
        .Q(deadlock_detected) );
  SAEDRVT05_FDP_X1_FA \U8/route_locked_reg  ( .D(n369), .CLK(clk), .Q(
        route_locked) );
  SAEDRVT05_FDP_X1_FA \U5/safe_valid_reg  ( .D(\U5/N21 ), .CLK(clk), .Q(
        safe_valid) );
  SAEDRVT05_FDP_X1_FA \U11/conflict_detected_reg  ( .D(n368), .CLK(clk), .Q(
        conflict_detected) );
  SAEDRVT05_FDP_X1_FA \U9/move_train_reg  ( .D(\U9/N3 ), .CLK(clk), .Q(
        train_move) );
  SAEDRVT05_FDP_X1_FA \U10/train_count_reg[0]  ( .D(n367), .CLK(clk), .Q(
        \U10/n3 ), .QN(n380) );
  SAEDRVT05_FDP_X1_FA \U10/train_count_reg[1]  ( .D(n366), .CLK(clk), .Q(
        \U10/n2 ), .QN(n381) );
  SAEDRVT05_FDP_X1_FA \U10/train_count_reg[2]  ( .D(n365), .CLK(clk), .Q(n384), 
        .QN(n530) );
  SAEDRVT05_FDP_X1_FA \U10/train_count_reg[3]  ( .D(n364), .CLK(clk), .Q(
        train_count[3]), .QN(n379) );
  SAEDRVT05_FDP_X1_FA \U10/train_count_reg[4]  ( .D(n363), .CLK(clk), .Q(
        train_count[4]), .QN(n531) );
  SAEDRVT05_FDP_X1_FA \U10/train_count_reg[5]  ( .D(n362), .CLK(clk), .Q(
        train_count[5]), .QN(n383) );
  SAEDRVT05_FDP_X1_FA \U10/train_count_reg[6]  ( .D(n361), .CLK(clk), .Q(
        train_count[6]), .QN(n526) );
  SAEDRVT05_FDP_X1_FA \U10/train_count_reg[7]  ( .D(n360), .CLK(clk), .Q(
        train_count[7]), .QN(n533) );
  SAEDRVT05_FDP_X1_FA \U1/current_state_reg[2]  ( .D(n303), .CLK(clk), .Q(
        \U1/current_state [2]) );
  SAEDRVT05_FDP_X1_FA \U1/current_state_reg[1]  ( .D(n302), .CLK(clk), .Q(
        \U1/current_state [1]) );
  SAEDRVT05_FDP_X1_FA \U1/current_state_reg[0]  ( .D(n301), .CLK(clk), .Q(
        \U1/current_state [0]), .QN(n535) );
  SAEDRVT05_FDP_X1_FA \U1/error_flag_reg  ( .D(\U1/N106 ), .CLK(clk), .Q(
        error_flag) );
  SAEDRVT05_FDP_X1_FA \U1/request_valid_reg  ( .D(\U1/N105 ), .CLK(clk), .Q(
        request_valid) );
  SAEDRVT05_FDP_X1_FA \U_FIFO/count_reg[4]  ( .D(n330), .CLK(clk), .Q(
        \U_FIFO/count [4]), .QN(n382) );
  SAEDRVT05_FDP_X1_FA \U3/selected_valid_reg  ( .D(\U3/N48 ), .CLK(clk), .Q(
        selected_valid) );
  SAEDRVT05_FDP_X1_FA \U4/current_state_reg[0]  ( .D(n335), .CLK(clk), .Q(
        \U4/current_state [0]), .QN(n527) );
  SAEDRVT05_FDP_X1_FA \U4/current_state_reg[1]  ( .D(n336), .CLK(clk), .Q(
        \U4/current_state [1]), .QN(n534) );
  SAEDRVT05_FDP_X1_FA \U4/route_valid_reg  ( .D(\U4/N83 ), .CLK(clk), .Q(
        route_valid) );
  SAEDRVT05_FDP_X1_FA \U5/safety_error_reg  ( .D(\U5/N22 ), .CLK(clk), .Q(
        safety_error) );
  SAEDRVT05_FDP_X1_FA \U11/route_safe_reg  ( .D(n353), .CLK(clk), .Q(
        route_safe) );
  SAEDRVT05_FDP_X1_FA \U3/fifo_read_enable_reg  ( .D(n308), .CLK(clk), .Q(
        fifo_read_enable) );
  SAEDRVT05_FDP_X1_FA \U_FIFO/count_reg[2]  ( .D(n332), .CLK(clk), .Q(
        \U_FIFO/count [2]), .QN(n529) );
  SAEDRVT05_FDP_X1_FA \U_FIFO/count_reg[3]  ( .D(n331), .CLK(clk), .Q(
        \U_FIFO/count [3]), .QN(n528) );
  SAEDRVT05_FDP_X1_FA \U4/platform_number_reg[0]  ( .D(n349), .CLK(clk), .Q(
        \platform_number[0] ), .QN(n532) );
  SAEDRVT05_FDP_X1_FA \U12/blocked_route_reg[0]  ( .D(\U12/N13 ), .CLK(clk), 
        .Q(\blocked_route[0] ) );
  SAEDRVT05_FDP_X1_FA \U5/safe_platform_reg[0]  ( .D(n346), .CLK(clk), .Q(
        \safe_platform[0] ) );
  SAEDRVT05_FDP_X1_FA \U5/safe_route_reg[0]  ( .D(n343), .CLK(clk), .Q(
        \safe_route[0] ), .QN(n376) );
  SAEDRVT05_FDP_X1_FA \U11/conflict_route_reg[0]  ( .D(n350), .CLK(clk), .Q(
        \conflict_route[0] ) );
  SAEDRVT05_FDP_X1_FA \U6/signal_red_reg  ( .D(n371), .CLK(clk), .Q(signal_red) );
  SAEDRVT05_FDP_X1_FA \U6/signal_green_reg  ( .D(\U6/N4 ), .CLK(clk), .Q(
        signal_green) );
  SAEDRVT05_FDP_X1_FA \U7/switch_left_reg  ( .D(\U7/N32 ), .CLK(clk), .Q(
        switch_left) );
  SAEDRVT05_FDP_X1_FA \U_FIFO/count_reg[1]  ( .D(n333), .CLK(clk), .Q(
        \U_FIFO/count [1]), .QN(n378) );
  SAEDRVT05_FDP_X1_FA \U_FIFO/count_reg[0]  ( .D(n334), .CLK(clk), .Q(
        \U_FIFO/count [0]), .QN(n377) );
  SAEDRVT05_ND3_X1_FA U356 ( .A(\U_FIFO/count [1]), .B(\U_FIFO/count [0]), .C(
        n373), .OUT(n372) );
  SAEDRVT05_NR3_X1_FA U357 ( .A1(reset), .A2(fifo_read_enable), .A3(n479), 
        .OUT(n373) );
  SAEDRVT05_NR2_X1_FA U358 ( .A1(n491), .A2(n492), .OUT(n374) );
  SAEDRVT05_NR3_X1_FA U359 ( .A1(n375), .A2(n480), .A3(reset), .OUT(n487) );
  SAEDRVT05_NR3_X1_FA U360 ( .A1(n517), .A2(request_valid), .A3(n477), .OUT(
        n375) );
  SAEDRVT05_ND2_X1_FA U361 ( .A1(n385), .A2(n386), .OUT(n499) );
  SAEDRVT05_ND2_X1_FA U362 ( .A1(\U_FIFO/count [3]), .A2(n497), .OUT(n385) );
  SAEDRVT05_ND2_X1_FA U363 ( .A1(n498), .A2(n528), .OUT(n386) );
  SAEDRVT05_ND2_X1_FA U364 ( .A1(n387), .A2(n388), .OUT(n334) );
  SAEDRVT05_ND2_X1_FA U365 ( .A1(\U_FIFO/count [0]), .A2(n487), .OUT(n387) );
  SAEDRVT05_ND2_X1_FA U366 ( .A1(n486), .A2(n377), .OUT(n388) );
  SAEDRVT05_ND2_X1_FA U367 ( .A1(n389), .A2(n390), .OUT(n333) );
  SAEDRVT05_ND2_X1_FA U368 ( .A1(\U_FIFO/count [1]), .A2(n492), .OUT(n389) );
  SAEDRVT05_ND2_X1_FA U369 ( .A1(n490), .A2(n378), .OUT(n390) );
  SAEDRVT05_ND2_X1_FA U370 ( .A1(n391), .A2(n392), .OUT(n454) );
  SAEDRVT05_ND2_X1_FA U371 ( .A1(train_count[3]), .A2(n452), .OUT(n391) );
  SAEDRVT05_ND2_X1_FA U372 ( .A1(n453), .A2(n379), .OUT(n392) );
  SAEDRVT05_NR2_X1_FA U373 ( .A1(n446), .A2(n456), .OUT(n452) );
  SAEDRVT05_ND2_X1_FA U374 ( .A1(n393), .A2(n394), .OUT(n458) );
  SAEDRVT05_ND2_X1_FA U375 ( .A1(\U10/n2 ), .A2(n463), .OUT(n393) );
  SAEDRVT05_ND2_X1_FA U376 ( .A1(n457), .A2(n381), .OUT(n394) );
  SAEDRVT05_NR2_X1_FA U377 ( .A1(n456), .A2(n455), .OUT(n463) );
  SAEDRVT05_ND2_X1_FA U378 ( .A1(n395), .A2(n396), .OUT(n461) );
  SAEDRVT05_ND2_X1_FA U379 ( .A1(train_count[6]), .A2(n471), .OUT(n395) );
  SAEDRVT05_ND2_X1_FA U380 ( .A1(n468), .A2(n526), .OUT(n396) );
  SAEDRVT05_ND2_X1_FA U381 ( .A1(n397), .A2(n398), .OUT(n367) );
  SAEDRVT05_ND2_X1_FA U382 ( .A1(\U10/n3 ), .A2(n456), .OUT(n397) );
  SAEDRVT05_ND2_X1_FA U383 ( .A1(n469), .A2(n380), .OUT(n398) );
  SAEDRVT05_NR2_X1_FA U384 ( .A1(reset), .A2(n456), .OUT(n469) );
  SAEDRVT05_NR2_X1_FA U385 ( .A1(reset), .A2(train_move), .OUT(n456) );
  SAEDRVT05_ND2_X1_FA U386 ( .A1(n399), .A2(n400), .OUT(n363) );
  SAEDRVT05_ND2_X1_FA U387 ( .A1(n531), .A2(n449), .OUT(n399) );
  SAEDRVT05_ND2_X1_FA U388 ( .A1(n450), .A2(train_count[4]), .OUT(n400) );
  SAEDRVT05_NR2_X1_FA U389 ( .A1(n465), .A2(n448), .OUT(n449) );
  SAEDRVT05_ND2_X1_FA U390 ( .A1(n401), .A2(n402), .OUT(n330) );
  SAEDRVT05_ND2_X1_FA U391 ( .A1(\U_FIFO/count [4]), .A2(n501), .OUT(n401) );
  SAEDRVT05_ND2_X1_FA U392 ( .A1(n502), .A2(n382), .OUT(n402) );
  SAEDRVT05_NR2_X1_FA U393 ( .A1(n528), .A2(n496), .OUT(n502) );
  SAEDRVT05_ND2_X1_FA U394 ( .A1(n403), .A2(n404), .OUT(n485) );
  SAEDRVT05_ND2_X1_FA U395 ( .A1(\U_FIFO/count [3]), .A2(n500), .OUT(n403) );
  SAEDRVT05_ND2_X1_FA U396 ( .A1(n496), .A2(n528), .OUT(n404) );
  SAEDRVT05_ND2_X1_FA U397 ( .A1(n405), .A2(n406), .OUT(n489) );
  SAEDRVT05_ND2_X1_FA U398 ( .A1(\U_FIFO/count [0]), .A2(n497), .OUT(n405) );
  SAEDRVT05_ND2_X1_FA U399 ( .A1(n498), .A2(n377), .OUT(n406) );
  SAEDRVT05_ND2_X1_FA U400 ( .A1(n407), .A2(n408), .OUT(n495) );
  SAEDRVT05_ND2_X1_FA U401 ( .A1(\U_FIFO/count [2]), .A2(n374), .OUT(n407) );
  SAEDRVT05_ND2_X1_FA U402 ( .A1(n372), .A2(n529), .OUT(n408) );
  SAEDRVT05_ND2_X1_FA U403 ( .A1(n409), .A2(n410), .OUT(n491) );
  SAEDRVT05_ND2_X1_FA U404 ( .A1(\U_FIFO/count [1]), .A2(n375), .OUT(n409) );
  SAEDRVT05_ND2_X1_FA U405 ( .A1(n373), .A2(n378), .OUT(n410) );
  SAEDRVT05_ND2_X1_FA U406 ( .A1(n411), .A2(n412), .OUT(n490) );
  SAEDRVT05_ND2_X1_FA U407 ( .A1(\U_FIFO/count [0]), .A2(n373), .OUT(n411) );
  SAEDRVT05_ND2_X1_FA U408 ( .A1(n375), .A2(n377), .OUT(n412) );
  SAEDRVT05_ND2_X1_FA U409 ( .A1(n413), .A2(n414), .OUT(n429) );
  SAEDRVT05_ND2_X1_FA U410 ( .A1(\safe_route[0] ), .A2(\platform_number[0] ), 
        .OUT(n413) );
  SAEDRVT05_ND2_X1_FA U411 ( .A1(n532), .A2(n376), .OUT(n414) );
  SAEDRVT05_ND2_X1_FA U412 ( .A1(n415), .A2(n416), .OUT(n362) );
  SAEDRVT05_ND2_X1_FA U413 ( .A1(train_count[5]), .A2(n444), .OUT(n415) );
  SAEDRVT05_ND2_X1_FA U414 ( .A1(n445), .A2(n383), .OUT(n416) );
  SAEDRVT05_ND2_X1_FA U415 ( .A1(n417), .A2(n418), .OUT(n365) );
  SAEDRVT05_ND2_X1_FA U416 ( .A1(n530), .A2(n466), .OUT(n417) );
  SAEDRVT05_ND2_X1_FA U417 ( .A1(n467), .A2(n384), .OUT(n418) );
  SAEDRVT05_ND2_X1_FA U418 ( .A1(n419), .A2(n420), .OUT(n360) );
  SAEDRVT05_ND2_X1_FA U419 ( .A1(train_count[7]), .A2(n472), .OUT(n419) );
  SAEDRVT05_ND2_X1_FA U420 ( .A1(n473), .A2(n533), .OUT(n420) );
  SAEDRVT05_INV_X1_FA U421 ( .IN(n375), .OUT(n497) );
  SAEDRVT05_INV_X1_FA U422 ( .IN(reset), .OUT(n370) );
  SAEDRVT05_TIE0_FA U423 ( .X(switch_right) );
  SAEDRVT05_NR2_X1_FA U424 ( .A1(conflict_detected), .A2(safety_error), .OUT(
        n503) );
  SAEDRVT05_ND2_X1_FA U425 ( .A1(safe_valid), .A2(route_safe), .OUT(n421) );
  SAEDRVT05_NR3_X1_FA U426 ( .A1(error_flag), .A2(deadlock_detected), .A3(n421), .OUT(n423) );
  SAEDRVT05_ND2_X1_FA U427 ( .A1(\platform_number[0] ), .A2(\blocked_route[0] ), .OUT(n422) );
  SAEDRVT05_ND3_X1_FA U428 ( .A(n503), .B(n423), .C(n422), .OUT(n424) );
  SAEDRVT05_NR3_X1_FA U429 ( .A1(reset), .A2(\conflict_route[0] ), .A3(n424), 
        .OUT(\U6/N4 ) );
  SAEDRVT05_INV_X1_FA U430 ( .IN(\U6/N4 ), .OUT(n371) );
  SAEDRVT05_ND2_X1_FA U431 ( .A1(n370), .A2(fifo_read_enable), .OUT(n477) );
  SAEDRVT05_INV_X1_FA U432 ( .IN(n477), .OUT(\U3/N48 ) );
  SAEDRVT05_NR2_X1_FA U433 ( .A1(\U1/current_state [1]), .A2(
        \U1/current_state [0]), .OUT(n522) );
  SAEDRVT05_INV_X1_FA U434 ( .IN(n522), .OUT(n425) );
  SAEDRVT05_ND2_X1_FA U435 ( .A1(\U1/current_state [2]), .A2(n370), .OUT(n506)
         );
  SAEDRVT05_NR2_X1_FA U436 ( .A1(n425), .A2(n506), .OUT(\U1/N105 ) );
  SAEDRVT05_ND3_X1_FA U437 ( .A(\U4/current_state [1]), .B(n370), .C(n527), 
        .OUT(n427) );
  SAEDRVT05_ND2_X1_FA U438 ( .A1(\platform_number[0] ), .A2(n370), .OUT(n426)
         );
  SAEDRVT05_ND2_X1_FA U439 ( .A1(n427), .A2(n426), .OUT(n349) );
  SAEDRVT05_ND3_X1_FA U440 ( .A(n370), .B(\U4/current_state [0]), .C(n534), 
        .OUT(n428) );
  SAEDRVT05_ND2_X1_FA U441 ( .A1(n428), .A2(n427), .OUT(n336) );
  SAEDRVT05_NR3_X1_FA U442 ( .A1(route_locked), .A2(track_busy), .A3(
        signal_fault), .OUT(n433) );
  SAEDRVT05_ND2_X1_FA U443 ( .A1(route_valid), .A2(n370), .OUT(n440) );
  SAEDRVT05_NR2_X1_FA U444 ( .A1(n433), .A2(n440), .OUT(\U5/N22 ) );
  SAEDRVT05_INV_X1_FA U445 ( .IN(n440), .OUT(n512) );
  SAEDRVT05_ND2_X1_FA U446 ( .A1(route_locked), .A2(n429), .OUT(n439) );
  SAEDRVT05_INV_X1_FA U447 ( .IN(track_busy), .OUT(n430) );
  SAEDRVT05_ND3_X1_FA U448 ( .A(n512), .B(n439), .C(n430), .OUT(n432) );
  SAEDRVT05_NR2_X1_FA U449 ( .A1(reset), .A2(route_valid), .OUT(n511) );
  SAEDRVT05_ND2_X1_FA U450 ( .A1(route_safe), .A2(n511), .OUT(n431) );
  SAEDRVT05_ND2_X1_FA U451 ( .A1(n432), .A2(n431), .OUT(n353) );
  SAEDRVT05_AN2_X1_FA U452 ( .A1(n512), .A2(n433), .OUT(\U5/N21 ) );
  SAEDRVT05_ND2_X1_FA U453 ( .A1(\platform_number[0] ), .A2(\U5/N21 ), .OUT(
        n438) );
  SAEDRVT05_AN2_X1_FA U454 ( .A1(route_valid), .A2(n433), .OUT(n434) );
  SAEDRVT05_NR2_X1_FA U455 ( .A1(reset), .A2(n434), .OUT(n436) );
  SAEDRVT05_ND2_X1_FA U456 ( .A1(n436), .A2(\safe_platform[0] ), .OUT(n435) );
  SAEDRVT05_ND2_X1_FA U457 ( .A1(n438), .A2(n435), .OUT(n346) );
  SAEDRVT05_ND2_X1_FA U458 ( .A1(\safe_route[0] ), .A2(n436), .OUT(n437) );
  SAEDRVT05_ND2_X1_FA U459 ( .A1(n438), .A2(n437), .OUT(n343) );
  SAEDRVT05_NR2_X1_FA U460 ( .A1(n440), .A2(n439), .OUT(\U12/N12 ) );
  SAEDRVT05_INV_X1_FA U461 ( .IN(\U12/N12 ), .OUT(n510) );
  SAEDRVT05_NR2_X1_FA U462 ( .A1(n532), .A2(n510), .OUT(\U12/N13 ) );
  SAEDRVT05_INV_X1_FA U463 ( .IN(n469), .OUT(n465) );
  SAEDRVT05_ND2_X1_FA U464 ( .A1(\U10/n3 ), .A2(\U10/n2 ), .OUT(n464) );
  SAEDRVT05_NR2_X1_FA U465 ( .A1(n464), .A2(n530), .OUT(n451) );
  SAEDRVT05_ND2_X1_FA U466 ( .A1(train_count[3]), .A2(n451), .OUT(n448) );
  SAEDRVT05_NR2_X1_FA U467 ( .A1(n531), .A2(n448), .OUT(n459) );
  SAEDRVT05_INV_X1_FA U468 ( .IN(n459), .OUT(n441) );
  SAEDRVT05_NR2_X1_FA U469 ( .A1(n465), .A2(n441), .OUT(n445) );
  SAEDRVT05_INV_X1_FA U470 ( .IN(n456), .OUT(n443) );
  SAEDRVT05_ND2_X1_FA U471 ( .A1(n370), .A2(n441), .OUT(n442) );
  SAEDRVT05_ND2_X1_FA U472 ( .A1(n443), .A2(n442), .OUT(n444) );
  SAEDRVT05_NR2_X1_FA U473 ( .A1(reset), .A2(n451), .OUT(n446) );
  SAEDRVT05_OR2_X1_FA U474 ( .A1(n465), .A2(train_count[3]), .OUT(n447) );
  SAEDRVT05_ND2_X1_FA U475 ( .A1(n452), .A2(n447), .OUT(n450) );
  SAEDRVT05_ND2_X1_FA U476 ( .A1(n469), .A2(n451), .OUT(n453) );
  SAEDRVT05_INV_X1_FA U477 ( .IN(n454), .OUT(n364) );
  SAEDRVT05_ND2_X1_FA U478 ( .A1(n469), .A2(\U10/n3 ), .OUT(n457) );
  SAEDRVT05_NR2_X1_FA U479 ( .A1(\U10/n3 ), .A2(n465), .OUT(n455) );
  SAEDRVT05_INV_X1_FA U480 ( .IN(n458), .OUT(n366) );
  SAEDRVT05_ND3_X1_FA U481 ( .A(n469), .B(train_count[5]), .C(n459), .OUT(n468) );
  SAEDRVT05_ND3_X1_FA U482 ( .A(train_count[5]), .B(n459), .C(train_move), 
        .OUT(n460) );
  SAEDRVT05_ND2_X1_FA U483 ( .A1(n460), .A2(n370), .OUT(n471) );
  SAEDRVT05_INV_X1_FA U484 ( .IN(n461), .OUT(n361) );
  SAEDRVT05_OR2_X1_FA U485 ( .A1(n465), .A2(\U10/n2 ), .OUT(n462) );
  SAEDRVT05_ND2_X1_FA U486 ( .A1(n463), .A2(n462), .OUT(n467) );
  SAEDRVT05_NR2_X1_FA U487 ( .A1(n465), .A2(n464), .OUT(n466) );
  SAEDRVT05_NR2_X1_FA U488 ( .A1(n526), .A2(n468), .OUT(n473) );
  SAEDRVT05_ND2_X1_FA U489 ( .A1(n469), .A2(n526), .OUT(n470) );
  SAEDRVT05_ND2_X1_FA U490 ( .A1(n471), .A2(n470), .OUT(n472) );
  SAEDRVT05_NR3_X1_FA U491 ( .A1(\U_FIFO/count [2]), .A2(\U_FIFO/count [1]), 
        .A3(\U_FIFO/count [0]), .OUT(n493) );
  SAEDRVT05_ND2_X1_FA U492 ( .A1(n493), .A2(n528), .OUT(n476) );
  SAEDRVT05_INV_X1_FA U493 ( .IN(n476), .OUT(n483) );
  SAEDRVT05_ND2_X1_FA U494 ( .A1(n483), .A2(\U_FIFO/count [4]), .OUT(n474) );
  SAEDRVT05_ND2_X1_FA U495 ( .A1(request_valid), .A2(n474), .OUT(n479) );
  SAEDRVT05_ND2_X1_FA U496 ( .A1(\U_FIFO/count [1]), .A2(\U_FIFO/count [0]), 
        .OUT(n475) );
  SAEDRVT05_NR2_X1_FA U497 ( .A1(n529), .A2(n475), .OUT(n478) );
  SAEDRVT05_ND2_X1_FA U498 ( .A1(n373), .A2(n478), .OUT(n496) );
  SAEDRVT05_NR2_X1_FA U499 ( .A1(\U_FIFO/count [4]), .A2(n476), .OUT(n517) );
  SAEDRVT05_NR2_X1_FA U500 ( .A1(n497), .A2(n493), .OUT(n482) );
  SAEDRVT05_INV_X1_FA U501 ( .IN(n373), .OUT(n498) );
  SAEDRVT05_NR2_X1_FA U502 ( .A1(n478), .A2(n498), .OUT(n481) );
  SAEDRVT05_NR2_X1_FA U503 ( .A1(fifo_read_enable), .A2(n479), .OUT(n480) );
  SAEDRVT05_NR3_X1_FA U504 ( .A1(n482), .A2(n481), .A3(n487), .OUT(n500) );
  SAEDRVT05_ND2_X1_FA U505 ( .A1(n375), .A2(n483), .OUT(n484) );
  SAEDRVT05_ND2_X1_FA U506 ( .A1(n484), .A2(n485), .OUT(n331) );
  SAEDRVT05_ND2_X1_FA U507 ( .A1(n498), .A2(n497), .OUT(n486) );
  SAEDRVT05_INV_X1_FA U508 ( .IN(n487), .OUT(n488) );
  SAEDRVT05_ND2_X1_FA U509 ( .A1(n488), .A2(n489), .OUT(n492) );
  SAEDRVT05_ND2_X1_FA U510 ( .A1(n375), .A2(n493), .OUT(n494) );
  SAEDRVT05_ND2_X1_FA U511 ( .A1(n494), .A2(n495), .OUT(n332) );
  SAEDRVT05_ND2_X1_FA U512 ( .A1(n500), .A2(n499), .OUT(n501) );
  SAEDRVT05_INV_X1_FA U513 ( .IN(n503), .OUT(n505) );
  SAEDRVT05_ND3_X1_FA U514 ( .A(route_locked), .B(system_running), .C(n370), 
        .OUT(n504) );
  SAEDRVT05_NR3_X1_FA U515 ( .A1(deadlock_detected), .A2(n505), .A3(n504), 
        .OUT(\U9/N3 ) );
  SAEDRVT05_AN2_X1_FA U516 ( .A1(\safe_platform[0] ), .A2(\U6/N4 ), .OUT(
        \U7/N32 ) );
  SAEDRVT05_NR3_X1_FA U517 ( .A1(\U1/current_state [1]), .A2(n535), .A3(n506), 
        .OUT(\U1/N106 ) );
  SAEDRVT05_NR3_X1_FA U518 ( .A1(reset), .A2(n527), .A3(n534), .OUT(\U4/N83 )
         );
  SAEDRVT05_NR2_X1_FA U519 ( .A1(route_locked), .A2(signal_green), .OUT(n507)
         );
  SAEDRVT05_NR3_X1_FA U520 ( .A1(n507), .A2(reset), .A3(deadlock_detected), 
        .OUT(n369) );
  SAEDRVT05_ND2_X1_FA U521 ( .A1(conflict_detected), .A2(n511), .OUT(n509) );
  SAEDRVT05_ND2_X1_FA U522 ( .A1(n512), .A2(track_busy), .OUT(n508) );
  SAEDRVT05_ND3_X1_FA U523 ( .A(n510), .B(n509), .C(n508), .OUT(n368) );
  SAEDRVT05_INV_X1_FA U524 ( .IN(\U12/N13 ), .OUT(n515) );
  SAEDRVT05_ND2_X1_FA U525 ( .A1(\conflict_route[0] ), .A2(n511), .OUT(n514)
         );
  SAEDRVT05_ND3_X1_FA U526 ( .A(\platform_number[0] ), .B(n512), .C(track_busy), .OUT(n513) );
  SAEDRVT05_ND3_X1_FA U527 ( .A(n515), .B(n514), .C(n513), .OUT(n350) );
  SAEDRVT05_NR2_X1_FA U528 ( .A1(\U4/current_state [1]), .A2(selected_valid), 
        .OUT(n516) );
  SAEDRVT05_NR3_X1_FA U529 ( .A1(n516), .A2(reset), .A3(\U4/current_state [0]), 
        .OUT(n335) );
  SAEDRVT05_NR3_X1_FA U530 ( .A1(n517), .A2(reset), .A3(fifo_read_enable), 
        .OUT(n308) );
  SAEDRVT05_OR3_X1_FA U531 ( .A1(train_count[5]), .A2(train_count[3]), .A3(
        train_count[4]), .OUT(n518) );
  SAEDRVT05_NR3_X1_FA U532 ( .A1(\U1/current_state [0]), .A2(train_id[5]), 
        .A3(n518), .OUT(n519) );
  SAEDRVT05_ND3_X1_FA U533 ( .A(n533), .B(n519), .C(n526), .OUT(n520) );
  SAEDRVT05_ND2_X1_FA U534 ( .A1(\U1/current_state [1]), .A2(n520), .OUT(n521)
         );
  SAEDRVT05_NR3_X1_FA U535 ( .A1(reset), .A2(\U1/current_state [2]), .A3(n521), 
        .OUT(n303) );
  SAEDRVT05_INV_X1_FA U536 ( .IN(n521), .OUT(n523) );
  SAEDRVT05_OR2_X1_FA U537 ( .A1(reset), .A2(\U1/current_state [2]), .OUT(n524) );
  SAEDRVT05_NR3_X1_FA U538 ( .A1(n523), .A2(n522), .A3(n524), .OUT(n302) );
  SAEDRVT05_NR2_X1_FA U539 ( .A1(\U1/current_state [1]), .A2(train_request), 
        .OUT(n525) );
  SAEDRVT05_NR3_X1_FA U540 ( .A1(n525), .A2(\U1/current_state [0]), .A3(n524), 
        .OUT(n301) );
endmodule

