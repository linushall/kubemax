#!/bin/bash

# Get the namespace from the first script argument
LABEL=$1

# Fetch all pod names in the given label
PODS=$(kubectl get pods -l $LABEL --all-namespaces --no-headers -o custom-columns=":metadata.name")
NAMESPACE=$(kubectl get pods --all-namespaces -l $LABEL -o jsonpath='{.items[0].metadata.namespace}')

# Define a tmux session name based on the label
SESSION_NAME="k8s-$LABEL"

# Start a new tmux session in detached mode
tmux new-session -d -s $SESSION_NAME

# Get the first pod name from the list
FIRST_POD=$(echo $PODS | awk '{print $1}')

# Execute into the first pod in the main tmux window
tmux send-keys -t $SESSION_NAME "kubectl exec -it -n $NAMESPACE $FIRST_POD -- sh" C-m

# Clear the terminal inside the first pane to improve readability
tmux send-keys -t $SESSION_NAME "clear" C-m

# Flag to track the first pod (avoiding unnecessary duplicate execution)
FIRST_POD=true

# Loop through all pods and create a tmux pane for each one
for POD in $PODS; do
    if [ "$FIRST_POD" = true ]; then
        # Skip the first pod since it's already opened
        FIRST_POD=false
    else
        # Create a new horizontally split tmux pane
        tmux split-window -h -t $SESSION_NAME

        # Execute into the pod inside the new pane
        tmux send-keys -t $SESSION_NAME "kubectl exec -it -n $NAMESPACE $POD -- sh" C-m

        # Clear the terminal inside the new pane
        tmux send-keys -t $SESSION_NAME "clear" C-m

        # Arrange panes in a tiled layout for better visibility
        tmux select-layout tiled
    fi
done

# Enable input synchronization across all panes (execute commands in all at once)
tmux set synchronize-panes on

# Attach to the tmux session so the user can interact with the pods
tmux attach-session -t $SESSION_NAME