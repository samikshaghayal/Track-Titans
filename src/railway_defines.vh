`ifndef RAILWAY_DEFINES_VH
`define RAILWAY_DEFINES_VH

//--------------------------------------------------
// Station Configuration
//--------------------------------------------------

`define NUM_TRACKS         8
`define NUM_PLATFORMS      5
`define NUM_SIGNALS        16
`define NUM_ROUTES         24
`define FIFO_DEPTH         16

//--------------------------------------------------
// Train Types
//--------------------------------------------------

`define PASSENGER          2'b00
`define EXPRESS            2'b01
`define FREIGHT            2'b10
`define EMERGENCY          2'b11

//--------------------------------------------------
// Train Directions
//--------------------------------------------------

`define UP_DIRECTION       1'b0
`define DOWN_DIRECTION     1'b1

//--------------------------------------------------
// FSM States
//--------------------------------------------------

`define IDLE              3'd0
`define RECEIVE_REQUEST   3'd1
`define VALIDATE_REQUEST  3'd2
`define GENERATE_PACKET   3'd3
`define SEND_TO_FIFO      3'd4
`define ERROR_STATE       3'd5

`endif
