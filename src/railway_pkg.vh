`ifndef RAILWAY_PKG_VH
`define RAILWAY_PKG_VH


parameter NUM_PLATFORMS = 5;
parameter NUM_TRACKS    = 8;
parameter NUM_SIGNALS   = 16;
parameter NUM_SWITCHES  = 10;


typedef enum logic [1:0]
{
    TRAIN_IDLE,
    TRAIN_REQUEST,
    TRAIN_MOVING,
    TRAIN_COMPLETE
} train_state_t;


typedef enum logic [1:0]
{
    SIGNAL_RED,
    SIGNAL_YELLOW,
    SIGNAL_GREEN,
    SIGNAL_BLUE
} signal_state_t;


`endif
