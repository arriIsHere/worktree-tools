#!/usr/bin/env bash
set -e

WORKTREE=$1
BRANCH=$(cd $WORKTREE; git branch --show-current)

# the "common git dir" will be .bare with using the clone script
ROOT_DIR=$(realpath $(git rev-parse --git-common-dir)../)
cd $ROOT_DIR

COMMON_FILES_DIR=$(git config worktree-tools.common-files)
WORKSPACE_FILE=$(git config worktree-tools.workspace-file)

# Delete the directory
rm -rf $WORKTREE

git worktree prune
git branch -D $BRANCH

# Update the workspace file
jq --arg WORKTREE "$WORKTREE" 'del(.folders[] | select(.path == $WORKTREE)) | {folders: .[]}' $WORKSPACE_FILE > $WORKSPACE_FILE.tmp
mv $WORKSPACE_FILE.tmp $WORKSPACE_FILE