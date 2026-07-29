#!/usr/bin/env bash

# Exit on error
set -e

# ==============================================================================
# DEFAULT CONFIGURATION
# Modify NUM_CLIENTS to change how many client instances to open (default: 2).
# Alternatively, pass variables from the command line: make run CLIENTS=4
# ==============================================================================
MODE=${1:-all}         # all | server | clients
PORT=${2:-8080}
NUM_CLIENTS=${3:-2}
SERVER_HOST="127.0.0.1"

# Project root directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

cd "$ROOT_DIR"

OS="$(uname -s)"

run_in_terminal() {
    local title="$1"
    local cmd="$2"

    if [ "$OS" = "Darwin" ]; then
        # macOS: Prefer iTerm2 if installed/running, fallback to Terminal.app
        if osascript -e 'id of application "iTerm"' &>/dev/null; then
            osascript -e "
                tell application \"iTerm\"
                    create window with default profile command \"bash -c \\\"cd '$ROOT_DIR' && printf '\\\e]1;$title\\\a' && $cmd; exec bash\\\"\"
                end tell
            " >/dev/null
        else
            osascript -e "tell application \"Terminal\" to do script \"cd '$ROOT_DIR' && printf '\\\e]1;$title\\\a' && $cmd\"" >/dev/null
        fi
    elif [ "$OS" = "Linux" ]; then
        # Linux: try common terminal emulators
        if command -v gnome-terminal &>/dev/null; then
            gnome-terminal --title="$title" -- bash -c "cd '$ROOT_DIR' && $cmd; exec bash"
        elif command -v konsole &>/dev/null; then
            konsole --title "$title" -e bash -c "cd '$ROOT_DIR' && $cmd; exec bash"
        elif command -v xfce4-terminal &>/dev/null; then
            xfce4-terminal --title="$title" -e "bash -c 'cd \"$ROOT_DIR\" && $cmd; exec bash'"
        elif command -v xterm &>/dev/null; then
            xterm -T "$title" -e "cd '$ROOT_DIR' && $cmd; exec bash" &
        elif command -v tmux &>/dev/null && tmux info &>/dev/null; then
            tmux new-window -n "$title" "cd '$ROOT_DIR' && $cmd"
        else
            echo "⚠️ No supported Linux GUI terminal emulator found. Running in background..."
            eval "$cmd" &
        fi
    else
        echo "❌ Unsupported OS: $OS"
        exit 1
    fi
}

if [ "$MODE" = "all" ] || [ "$MODE" = "server" ]; then
    echo "🚀 Starting CrazyConquest Server on port $PORT..."
    run_in_terminal "CrazyConquest Server" "./bin/server $PORT"
    sleep 1
fi

if [ "$MODE" = "all" ] || [ "$MODE" = "clients" ]; then
    echo "🚀 Starting $NUM_CLIENTS Client(s) connecting to $SERVER_HOST:$PORT..."
    for (( i=1; i<=NUM_CLIENTS; i++ )); do
        run_in_terminal "CrazyConquest Client $i" "./bin/client $SERVER_HOST $PORT"
        sleep 0.3
    done
fi

echo "✅ Launch complete (Mode: $MODE)!"
