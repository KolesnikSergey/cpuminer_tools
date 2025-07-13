#!/bin/bash

SESSION="miners"

# Define commands for each miner
MINER="taskset -c 2 cpuminer256d"
MINER1="$MINER --cpu-affinit 0x1 --cpu-priority 5 -q -t 1 -b 127.0.0.1:4048" # full power core0
MINER2="$MINER --cpu-affinit 0x8 --cpu-priority 5 -q -t 1 -b 127.0.0.1:4051" # full power core3 cross to core0
MINER3="$MINER --max-temp=74 --cpu-affinit 0x2 --cpu-priority 1 -q -t 1 -b 127.0.0.1:4049" # reserved with temp regulation core1 cross to core2
#

# Kill existing :session
tmux kill-session -t "$SESSION" 2>/dev/null

# Start tmux session and first miner
taskset -c 2 tmux new-session -d -s "$SESSION" -n "miner0x1-4048" # on free core2
taskset -c 2 tmux send-keys -t "$SESSION:0" "$MINER1" C-m

# Second miner
taskset -c 2 tmux new-window -t "$SESSION" -n "miner0x8-4051"
taskset -c 2 tmux send-keys -t "$SESSION:1" "$MINER2" C-m

# Third miner
taskset -c 2 tmux new-window -t "$SESSION" -n "miner0x2-4049"
taskset -c 2 tmux send-keys -t "$SESSION:2" "$MINER3" C-m

# Attach to session
# taskset -c 2 tmux attach-session -t "$SESSION"
