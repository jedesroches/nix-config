#!/bin/sh

BRANCH="$1"

jj bookmark move main --to "$BRANCH"
jj git push --bookmark main
echo "waiting for remote branch deletion..."
sleep 5
echo "finished waiting"
jj git fetch

