#!/usr/bin/env bash
tmux -S "${HOME}/tmux.sock" new-session -d "${HOME}/mc-server.sh"
