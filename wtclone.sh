#!/usr/bin/env bash
set -e

REPO_URL=$1
REPO_BASE=${REPO_URL##*/}
BASENAME=${REPO_BASE%.*}
DIRNAME=${2:-$BASENAME}

# TODO: add flags to set these values
COMMON_FILES_DIR=.common_files
WORKSPACE_FILE=$BASENAME.code-workspace

mkdir $DIRNAME

cd $DIRNAME

git clone --bare $REPO_URL .bare
echo "gitdir: ./.bare" > .git

git config remove.origin.fetch "+refs/heads/*:refs/remotes/origin/*"

git fetch origin

MAIN_BRANCH=$(git branch --show-current)
git worktree add "$MAIN_BRANCH"

# configure values as set
git config worktree-tools.common-files "$(realpath $COMMON_FILES_DIR)"
git config worktree-tools.workspace-file "$(realpath $WORKSPACE_FILE)"

# Setup files
mkdir $COMMON_FILES_DIR

cat > setup.sh << EOF
#!/usr/bin/env bash
set -e

# This script gets run each time you checkout a new worktree right after the common files all get 
# Linked. It is passed two arguments shown below

# Branch this worktree is checking out
BRANCH=\$1

# the path to the worktree, relative to the directory calling this script
WORKTREE=\$2

EOF

chmod +x setup.sh

jq -n --arg WORKTREE "$MAIN_BRANCH" --arg BRANCH "$MAIN_BRANCH" \
  '{folders: [{name: $BRANCH, path: $WORKTREE} ] }' > $WORKSPACE_FILE