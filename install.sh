
REPO_URL="git@github.com:arriIsHere/worktree-tools.git"
DEST_DIR=~/.wttools
LATEST_DIR=$DEST_DIR/latest
RUN_DIR=$DEST_DIR/bin

# Set up worktree dir
mkdir $DEST_DIR
cd $DEST_DIR

git clone --bare $REPO_URL .bare
echo "gitdir: ./.bare" > $DEST_DIR/.git

git config remove.origin.fetch "+refs/heads/*:refs/remotes/origin/*"
git fetch origin --tags

LATEST_RELEASE=$(git tag | sort -V | tail -1)
git worktree add latest $LATEST_RELEASE

mkdir $RUN_DIR

# copy all scripts
cp $LATEST_DIR/*.sh $RUN_DIR/

# exclude install, we do not want it added
rm $RUN_DIR/install.sh

# Make all scripts executable and aliases
for SCRIPT in $RUN_DIR/*.sh; do
	chmod +x $SCRIPT

	SCRIPT_NAME=$(basename $SCRIPT .sh)
	git config --global alias."$SCRIPT_NAME" "!$SCRIPT"
done