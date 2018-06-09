#!/usr/bin/env bash
tmux -S "${HOME}/tmux.sock" send-keys -t 0 "stop" Enter
