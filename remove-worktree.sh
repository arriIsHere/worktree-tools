#!/usr/bin/env bash
set -e

WORKTREE=$1
BRANCH=$(cd $WORKTREE; git branch --show-current)
SHARED_CONFIG_DIR=.commonfiles

# Delete the directory
rm -rf $WORKTREE

git worktree prune
git branch -D $BRANCH