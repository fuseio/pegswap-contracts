#!/usr/bin/env bash

# Exit script as soon as a command fails
set -o errexit

# Executes cleanup function at script exit.
trap cleanup EXIT

cleanup() {
  # Kill the ganache instance that we started (if started and running)
  if [ -n "$ganache_pid" ] && ps -p $ganache_pid > /dev/null; then
    kill -9 $ganache_pid
  fi
}

ganache_port=8545

ganache_running() {
	nc -z localhost "$ganache_port" 
}

start_ganache() {
	node_modules/.bin/ganache-cli > /dev/null & ganache_pid=$!
}

if ganache_running; then
	echo "Using existing ganache instance"
else
	echo "Starting our own ganache instance"
	start_ganache
	sleep 2
fi

echo "Let's run the test suite"
node_modules/.bin/truffle test