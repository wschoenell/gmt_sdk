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


# Quick test on the Framework scripts - only if not a Release Candidate
if [[ $RC = "" ]]; then
    fwk_version=$VERSION
    echo "Testing alarm_server version"
    v=$(alarm_server --version)
    [[ $v == $fwk_version ]] || exit 1
    echo "Testing alarm_client version"
    v=$(alarm_client --version)
    [[ $v == $fwk_version ]] || exit 1
    echo "Testing conf_server version"
    v=$(conf_server --version)
    [[ $v == $fwk_version ]] || exit 1
    echo "Testing conf_client version"
    v=$(conf_client --version)
    [[ $v == $fwk_version ]] || exit 1
    echo "Testing data_client version"
    v=$(data_client --version)
    [[ $v == $fwk_version ]] || exit 1
    echo "Testing data_server version"
    v=$(data_server --version)
    [[ $v == $fwk_version ]] || exit 1
    echo "Testing log_server version"
    v=$(log_server --version)
    [[ $v == $fwk_version ]] || exit 1
    echo "Testing log_client version"
    v=$(log_client --version)
    [[ $v == $fwk_version ]] || exit 1
    echo "Testing sup_server version"
    v=$(sup_server --version)
    [[ $v == $fwk_version ]] || exit 1
    echo "Testing sup_client version"
    v=$(sup_client --version)
    [[ $v == $fwk_version ]] || exit 1
    echo "Testing tele_server version"
    v=$(tele_server --version)
    [[ $v == $fwk_version ]] || exit 1
    echo "Testing tele_client version"
    v=$(tele_client --version)
    [[ $v == $fwk_version ]] || exit 1

    echo "Testing gds version"
    [[ $(gds --version) == $fwk_version ]] || exit 1
    echo "Testing grs version"
    [[ $(grs --version) == $fwk_version ]] || exit 1
    echo "Testing gsq version"
    [[ $(gsq --version) == $fwk_version ]] || exit 1
    echo "Testing gtr version"
    [[ $(gtr --version) == $fwk_version ]] || exit 1
fi

# test gds
gds init tt123_dcs
gds env

# Python release test
# Python release install
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O $HOME/miniconda.sh
eval "$($HOME/miniconda/bin/conda shell.bash hook)"
conda create -y -n gmt conda-build msgpack-python=0.6.1 #numpy
conda activate gmt
conda develop "$GMT_GLOBAL/lib/py/"
pip install cson

# Run Python tests
cd $HOME

git clone https://$PAT:x-oauth-basic@github.com/GMTO/ocs_core_fwk
# Checkout pull requests
cd ocs_core_fwk
for id in $(echo $ocs_core_fwk_pull_requests | sed 's/,/\n/g')
do
    echo -e "$CL Checking pull request #$id $NC"
    git pull --no-edit origin pull/$id/head
done
cd ..

# add nanocat path to the PATH env var
export PATH=$PATH:$GMT_GLOBAL/ext/bin/
cd ocs_core_fwk/test/py/test/
for i in *.py
do
  echo "Running test: $i"
  python $i
  sleep 0.2
done

echo "Finished GMT SDK tests."