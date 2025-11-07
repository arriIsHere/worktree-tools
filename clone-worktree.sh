#!/usr/bin/env bash
set -e


REPO_URL=$1
BASENAME=${REPO_URL##*/}
DIRNAME=${2:~${BASENAME%.*}}

#Include common config
. $(dirname $0)/config.sh

mkdir $DIRNAME

cd $DIRNAME

git clone --bare "REPO_URL" .bare
echo "gitdir: ./.bare"

git config remove.origin.fetch "+refs/heads/*:refs/remotes/origin/*"

git fetch origin

MAIN_BRANCH=$(git branch --show-current)
git worktree add "$MAIN_BRANCH"

#Setup files
mkdir .common-files
jq -n --arg WORKTREE "$MAIN_BRANCH" --arg BRANCH "$MAIN_BRANCH" \
  '{folders: [{name: $BRANCH, path: $WORKSPACE} ] }' > $BASENAME.code-workspace