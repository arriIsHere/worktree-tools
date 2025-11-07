#!/usr/bin/env bash
set -e

WORKTREE=$1
BRANCH=$(cd $WORKTREE; git branch --show-current)

#Include common config
. $(dirname $0)/config.sh

# Delete the directory
rm -rf $WORKTREE

git worktree prune
git branch -D $BRANCH

# Update the workspace file
jq --arg WORKTREE "$WORKTREE" 'del(.folders[] | select(.path == $WORKTREE)) | {folders: .[]}' > root.code-workspace.tmp
mv root.code-workspace.tmp root.code-workspace