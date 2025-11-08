#!/usr/bin/env bash
set -e

BRANCH=$1
WORKTREE=${2:~BRANCH}

git worktree add $WORKTREE -b $BRANCH

jq --arg WORKTREE "$WORKTREE" --arg BRANCH "$BRANCH" \
  '{folders: [ .folders[], {name: $BRANCH, path: $WORKSPACE } ] }' .code-workspace > .code-workspace.tmp

cp -lfR 
cp -lf

#Setup scripts