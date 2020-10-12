echo "Running swarm-gen-watch-directories..."
swarm-gen-watch-directories &
export PID="$!"
echo "...swarm-gen-watch-directories is now running: ${PID}"
