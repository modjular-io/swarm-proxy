echo "Running swarm gen..."
swarm-gen &
export PID="$!"
echo "...swarm-gen is now running: ${PID}"
