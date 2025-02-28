#!/bin/bash

NAMESPACE=$1

PODS=$(kubectl get pods -n $NAMESPACE --no-headers -o custom-columns=":metadata.name")

SESSION_NAME="k8s-$NAMESPACE"

tmux new-session -d -s $SESSION_NAME

FIRST_POD=$(echo $PODS | awk '{print $1}')
tmux send-keys -t $SESSION_NAME "kubectl exec -it -n $NAMESPACE $FIRST_POD -- sh" C-m
tmux send-keys -t $SESSION_NAME "clear" C-m

FIRST_POD=true
for POD in $PODS; do
    if [ "$FIRST_POD" = true ]; then
        FIRST_POD=false
    else
        tmux split-window -h -t $SESSION_NAME
        tmux send-keys -t $SESSION_NAME "kubectl exec -it -n $NAMESPACE $POD -- sh" C-m
        tmux send-keys -t $SESSION_NAME "clear" C-m
        tmux select-layout tiled  # Ensure proper layout
    fi
done

tmux set synchronize-panes on
tmux attach-session -t $SESSION_NAME