#!/usr/bin/env bash
set -e

BRANCH=$1
WORKTREE=${2:-$BRANCH}

# the "common git dir" will be .bare with using the clone script
ROOT_DIR=$(realpath $(git rev-parse --git-common-dir)/../)
cd $ROOT_DIR

COMMON_FILES_DIR=$(git config worktree-tools.common-files)
WORKSPACE_FILE=$(git config worktree-tools.workspace-file)

git worktree add $WORKTREE -b $BRANCH

jq --arg WORKTREE "$WORKTREE" --arg BRANCH "$BRANCH" \
  '{folders: [ .folders[], {name: $BRANCH, path: $WORKTREE } ] }' $WORKSPACE_FILE > $WORKSPACE_FILE.tmp
mv $WORKSPACE_FILE.tmp $WORKSPACE_FILE

if [ -n "$(ls -A $COMMON_FILES_DIR)" ]; then
  cp -lfR $COMMON_FILES_DIR/* $WORKTREE/
  cp -lf $COMMON_FILES_DIR/.* $WORKTREE/
fi

./setup.sh $BRANCH $WORKTREE