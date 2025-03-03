#!/bin/bash

# Default values
NAMESPACE="default"
LABEL=""

# Parse arguments
while getopts "n:l:" opt; do
  case $opt in
    n) NAMESPACE=$OPTARG ;;
    l) LABEL=$OPTARG ;;
    *) echo "Usage: $0 [-n namespace] [-l label]"; exit 1 ;;
  esac
done

# Fetch pod names based on namespace and optional label selector
if [ -n "$LABEL" ]; then
  PODS=$(kubectl get pods -n "$NAMESPACE" -l "$LABEL" --no-headers -o custom-columns=":metadata.name")
else
  PODS=$(kubectl get pods -n "$NAMESPACE" --no-headers -o custom-columns=":metadata.name")
fi

# Define a tmux session name
SESSION_NAME="kubemax-$NAMESPACE"

# Start a new tmux session in detached mode
tmux new-session -d -s "$SESSION_NAME"

# Get the first pod name from the list
FIRST_POD=$(echo "$PODS" | awk 'NR==1')

# Execute into the first pod in the main tmux window
if [ -n "$FIRST_POD" ]; then
  tmux send-keys -t "$SESSION_NAME" "kubectl exec -it -n $NAMESPACE $FIRST_POD -- sh" C-m
  tmux send-keys -t "$SESSION_NAME" "clear" C-m
fi

# Track the first pod to avoid duplicate execution
FIRST_POD_PROCESSED=false

# Loop through all pods and create a tmux pane for each
for POD in $PODS; do
  if [ "$FIRST_POD_PROCESSED" = false ]; then
    FIRST_POD_PROCESSED=true
  else
    tmux split-window -h -t "$SESSION_NAME"
    tmux send-keys -t "$SESSION_NAME" "kubectl exec -it -n $NAMESPACE $POD -- sh" C-m
    tmux send-keys -t "$SESSION_NAME" "clear" C-m
    tmux select-layout tiled
  fi
done

# Enable input synchronization across all panes
tmux set synchronize-panes on

# Attach to the tmux session
tmux attach-session -t "$SESSION_NAME"
