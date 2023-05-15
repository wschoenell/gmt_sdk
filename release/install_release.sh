#!/usr/bin/env bash
set -xe

# Unpack release
VERSION=$1
RC=$2
if [[ $RC == "" ]] ; then
  SDK_TAR_FILE="gmt-sdk-$VERSION.tar.gz"
else
  SDK_TAR_FILE="gmt-sdk-$VERSION.$RC.tar.gz"
fi

# git configuration to checkout pull requests
git config --global user.email "you@example.com"
git config --global user.name "Your Name"
git config --global pull.rebase false


# Uncompress SDK
source /root/.bashrc
cd $GMT_GLOBAL
tar zxvf /github/workspace/$SDK_TAR_FILE

# update env
source /root/.bashrc
gmt_env

# Install dependencies
cd "$GMT_GLOBAL"
npm install
cp "$GMT_GLOBAL/package.json" "$GMT_LOCAL"
cd "$GMT_LOCAL"
npm install


# test gds info
gds info

# gds init
gds init

## Ensure that the bundles.coffee and ocs_local_bundle.coffee files exist, copying them from $GMT_GLOBAL if need be.
mkdir -p "$GMT_LOCAL/etc/bundles"
sed 's/global/local/g;s/sdk/local/g' "$GMT_GLOBAL/etc/bundles/bundles.coffee" > "$GMT_LOCAL/etc/bundles/bundles.coffee"
cp "$GMT_GLOBAL/etc/bundles/ocs_local_bundle.coffee" "$GMT_LOCAL/etc/bundles/"
