#!/usr/bin/bash
set -e

VERSION=$1
RC=$2
BASE_DIR=/module
SDK_BUILD_DIR="$BASE_DIR/gmt_build"
SDK_DIST_DIR="$BASE_DIR/gmt_dist"

# git configuration to checkout pull requests
git config --global user.email "you@example.com"
git config --global user.name "Your Name"
git config --global submodule.fetchJobs $(nproc --all)  # The number of submodules fetched at the same time
git config --global pull.rebase false

if [[ $RC == "" ]] ; then
  SDK_TAR_FILE="$BASE_DIR/gmt-sdk-$VERSION.tar.gz"
else
  SDK_TAR_FILE="$BASE_DIR/gmt-sdk-$VERSION.$RC.tar.gz"
fi

# Color options for echo commands
CL='\033[1;34m' # Bold blue
NC='\033[0m' # No Color

# Clean up previous build
if [ -f $SDK_TAR_FILE ] ; then
	echo -e "$CL Removing old SDK tar file: $SDK_TAR_FILE $NC"
	rm -f $SDK_TAR_FILE
fi

if [ -d $SDK_BUILD_DIR ] ; then
	echo -e "$CL Removing old build directory: $SDK_BUILD_DIR $NC"
	rm -rf $SDK_BUILD_DIR
fi
echo -e "$CL Removing old SDK distribution directory: $SDK_DIST_DIR $NC"
rm -rf $SDK_DIST_DIR

# Create new build directory
echo -e "$CL Creating new build directory: $SDK_BUILD_DIR $NC"
mkdir $SDK_BUILD_DIR

# Set environment variables
export GMT_GLOBAL=$SDK_BUILD_DIR
export GMT_LOCAL=$SDK_BUILD_DIR

# Checkout and build ocs_dev_fwk
MODULES=$GMT_LOCAL/modules
mkdir $MODULES
cd $MODULES


echo -e "$CL Cloning: ocs_dev_fwk $NC"
git clone --recursive https://$PAT:x-oauth-basic@github.com/GMTO/ocs_dev_fwk
# Checkout pull requests
cd ocs_dev_fwk
for id in $(echo $ocs_dev_fwk_pull_requests | sed 's/,/\n/g')
do
    echo -e "$CL Checking pull request #$id $NC"
    git pull --no-edit origin pull/$id/head
done
cd ..

echo -e "$CL Initializing: ocs_dev_fwk $NC"
cd ocs_dev_fwk
source src/bin/gmt_env.sh
make init
echo -e "$CL Building: ocs_dev_fwk $NC"
make build
echo -e "$CL Installing: ocs_dev_fwk $NC"
make install

# clone all SDK modules
echo -e "$CL Cloning: ocs_sys $NC"
cd $MODULES
git clone --recursive https://$PAT:x-oauth-basic@github.com/GMTO/ocs_sys

echo -e "$CL Cloning core frameworks $NC"
cd $MODULES
git clone --recursive https://$PAT:x-oauth-basic@github.com/GMTO/ocs_core_fwk
# Checkout pull requests
cd ocs_core_fwk
for id in $(echo $ocs_core_fwk_pull_requests | sed 's/,/\n/g')
do
    echo -e "$CL Checking pull request #$id $NC"
    git pull --no-edit origin pull/$id/head
done
cd ..

git clone --recursive https://$PAT:x-oauth-basic@github.com/GMTO/ocs_ctrl_fwk
# Checkout pull requests
cd ocs_ctrl_fwk
for id in $(echo $ocs_ctrl_fwk_pull_requests | sed 's/,/\n/g')
do
    echo -e "$CL Checking pull request #$id $NC"
    git pull --no-edit origin pull/$id/head
done
cd ..

git clone --recursive https://$PAT:x-oauth-basic@github.com/GMTO/ocs_dp_fwk
# Checkout pull requests
cd ocs_dp_fwk
for id in $(echo $ocs_dp_fwk_pull_requests | sed 's/,/\n/g')
do
    echo -e "$CL Checking pull request #$id $NC"
    git pull --no-edit origin pull/$id/head
done
cd ..


git clone --recursive https://$PAT:x-oauth-basic@github.com/GMTO/ocs_io_fwk
# Checkout pull requests
cd ocs_io_fwk
for id in $(echo $ocs_io_fwk_pull_requests | sed 's/,/\n/g')
do
    echo -e "$CL Checking pull request #$id $NC"
    git pull --no-edit origin pull/$id/head
done
cd ..

git clone --recursive https://$PAT:x-oauth-basic@github.com/GMTO/ocs_pers_fwk
# Checkout pull requests
cd ocs_pers_fwk
for id in $(echo $ocs_pers_fwk_pull_requests | sed 's/,/\n/g')
do
    echo -e "$CL Checking pull request #$id $NC"
    git pull --no-edit origin pull/$id/head
done
cd ..

git clone --recursive https://$PAT:x-oauth-basic@github.com/GMTO/ocs_test_fwk
# Checkout pull requests
cd ocs_test_fwk
for id in $(echo $ocs_test_fwk_pull_requests | sed 's/,/\n/g')
do
    echo -e "$CL Checking pull request #$id $NC"
    git pull --no-edit origin pull/$id/head
done
cd ..

#git clone --recursive https://$PAT:x-oauth-basic@github.com/GMTO/ocs_ui_fwk
## Checkout pull requests
#cd ocs_ui_fwk
#for id in $(echo $ocs_ui_fwk_pull_requests | sed 's/,/\n/g')
#do
#    echo -e "$CL Checking pull request #$id $NC"
#    git pull --no-edit origin pull/$id/head
#done
#cd ..


echo -e "$CL Cloning core services $NC"
cd $MODULES
git clone --recursive https://$PAT:x-oauth-basic@github.com/GMTO/ocs_log_sys
# Checkout pull requests
cd ocs_log_sys
for id in $(echo $ocs_log_sys_pull_requests | sed 's/,/\n/g')
do
    echo -e "$CL Checking pull request #$id $NC"
    git pull --no-edit origin pull/$id/head
done
cd ..

git clone --recursive https://$PAT:x-oauth-basic@github.com/GMTO/ocs_alarm_sys
# Checkout pull requests
cd ocs_alarm_sys
for id in $(echo $ocs_alarm_sys_pull_requests | sed 's/,/\n/g')
do
    echo -e "$CL Checking pull request #$id $NC"
    git pull --no-edit origin pull/$id/head
done
cd ..

git clone --recursive https://$PAT:x-oauth-basic@github.com/GMTO/ocs_tele_sys
# Checkout pull requests
cd ocs_tele_sys
for id in $(echo $ocs_tele_sys_pull_requests | sed 's/,/\n/g')
do
    echo -e "$CL Checking pull request #$id $NC"
    git pull --no-edit origin pull/$id/head
done
cd ..

git clone --recursive https://$PAT:x-oauth-basic@github.com/GMTO/ocs_conf_sys
# Checkout pull requests
cd ocs_conf_sys
for id in $(echo $ocs_conf_sys_pull_requests | sed 's/,/\n/g')
do
    echo -e "$CL Checking pull request #$id $NC"
    git pull --no-edit origin pull/$id/head
done
cd ..

git clone --recursive https://$PAT:x-oauth-basic@github.com/GMTO/ocs_sup_sys
# Checkout pull requests
cd ocs_sup_sys
for id in $(echo $ocs_sup_sys_pull_requests | sed 's/,/\n/g')
do
    echo -e "$CL Checking pull request #$id $NC"
    git pull --no-edit origin pull/$id/head
done
cd ..

git clone --recursive https://$PAT:x-oauth-basic@github.com/GMTO/ocs_da_sys
# Checkout pull requests
cd ocs_da_sys
for id in $(echo $ocs_da_sys_pull_requests | sed 's/,/\n/g')
do
    echo -e "$CL Checking pull request #$id $NC"
    git pull --no-edit origin pull/$id/head
done
cd ..

git clone --recursive https://$PAT:x-oauth-basic@github.com/GMTO/ocs_app_sys
# Checkout pull requests
cd ocs_app_sys
for id in $(echo $ocs_app_sys_pull_requests | sed 's/,/\n/g')
do
    echo -e "$CL Checking pull request #$id $NC"
    git pull --no-edit origin pull/$id/head
done
cd ..

git clone --recursive https://$PAT:x-oauth-basic@github.com/GMTO/ocs_seq_sys
# Checkout pull requests
cd ocs_seq_sys
for id in $(echo $ocs_seq_sys_pull_requests | sed 's/,/\n/g')
do
    echo -e "$CL Checking pull request #$id $NC"
    git pull --no-edit origin pull/$id/head
done
cd ..

git clone --recursive https://$PAT:x-oauth-basic@github.com/GMTO/ocs_ui_fwk
# Checkout pull requests
cd ocs_ui_fwk
for id in $(echo $ocs_ui_fwk_pull_requests | sed 's/,/\n/g')
do
    echo -e "$CL Checking pull request #$id $NC"
    git pull --no-edit origin pull/$id/head
done
cd ..

# use build script to compile Node.js code for the SDK
echo -e "$CL Building Node version of the core frameworks and services $NC"
cd $BASE_DIR
./build_release
echo -e "$CL Node Core Fwk build DONE $NC"

# Install Python fwks
echo -e "$CL Copying Python version of the core frameworks and services $NC"
cp -fr $MODULES/ocs_core_fwk/src/py/ $BASE_DIR/lib/

## Build the UI Framework
#echo -e "$CL Building: ocs_ui_fwk $NC"
#cd $MODULES
#cd ocs_ui_fwk
#coffee build_ui_fwk.coffee
#echo -e "$CL Node UI Fwk build DONE $NC"

## Checkout and build nanomsg for C++
echo -e "$CL Cloning: ocs_boost_ext $NC"
cd $MODULES
git clone --recursive https://$PAT:x-oauth-basic@github.com/GMTO/ocs_boost_ext
# Checkout pull requests
cd ocs_boost_ext
for id in $(echo $ocs_boost_ext_pull_requests | sed 's/,/\n/g')
do
    echo -e "$CL Checking pull request #$id $NC"
    git pull --no-edit origin pull/$id/head
done
cd ..

echo -e "$CL Building: ocs_boost_ext $NC"
cd ocs_boost_ext
./gmt_install_ext.sh

## Checkout and build nanomsg for C++
echo -e "$CL Cloning: ocs_eigen_ext $NC"
cd $MODULES
git clone --recursive https://$PAT:x-oauth-basic@github.com/GMTO/ocs_eigen_ext
# Checkout pull requests
cd ocs_eigen_ext
for id in $(echo $ocs_eigen_ext_pull_requests | sed 's/,/\n/g')
do
    echo -e "$CL Checking pull request #$id $NC"
    git pull --no-edit origin pull/$id/head
done
cd ..

echo -e "$CL Building: ocs_eigen_ext $NC"
cd ocs_eigen_ext
./gmt_install_ext.sh

## Checkout and build nanomsg for C++
echo -e "$CL Cloning: ocs_nanomsg_ext $NC"
cd $MODULES
git clone --recursive https://$PAT:x-oauth-basic@github.com/GMTO/ocs_nanomsg_ext
# Checkout pull requests
cd ocs_nanomsg_ext
for id in $(echo $ocs_nanomsg_ext_pull_requests | sed 's/,/\n/g')
do
    echo -e "$CL Checking pull request #$id $NC"
    git pull --no-edit origin pull/$id/head
done
cd ..

echo -e "$CL Building: ocs_nanomsg_ext $NC"
cd ocs_nanomsg_ext
./gmt_install_ext.sh

## Checkout and build msgpack for C++
echo -e "$CL Cloning: ocs_msgpack_ext $NC"
cd $MODULES
git clone --recursive https://$PAT:x-oauth-basic@github.com/GMTO/ocs_msgpack_ext
# Checkout pull requests
cd ocs_msgpack_ext
for id in $(echo $ocs_msgpack_ext_pull_requests | sed 's/,/\n/g')
do
    echo -e "$CL Checking pull request #$id $NC"
    git pull --no-edit origin pull/$id/head
done
cd ..

echo -e "$CL Building: ocs_msgpack_ext $NC"
cd ocs_msgpack_ext
./gmt_install_ext.sh

# compile c++ modules
echo -e "$CL Compiling C++ Libs: ocs_core_fwk $NC"
cd $MODULES/ocs_core_fwk/src/cpp && make -j$(nproc --all)
cd $GMT_LOCAL/include;  g++ -I. -Wall -Wextra -pedantic -std=c++17 -Wno-variadic-macros -I$GMT_LOCAL/ext/include -Wno-class-memaccess -fPIC -c -x c++-header -O2 -o ocs_core_fwk.h.gch ocs_core_fwk.h
echo -e "$CL Compiling C++ Libs: ocs_io_fwk $NC"
cd $MODULES/ocs_io_fwk/src/cpp && make -j$(nproc --all)
echo -e "$CL Compiling C++ Libs: ocs_ctrl_fwk $NC"
cd $MODULES/ocs_ctrl_fwk/src/cpp && make -j$(nproc --all)

# compile c++ tests
echo -e "$CL Compiling C++ Tests: ocs_core_fwk $NC"
cd $MODULES/ocs_core_fwk/test/cpp && make -j$(nproc --all)
ls $GMT_LOCAL

# Python fwks
mkdir -p $GMT_GLOBAL/lib/py/
export PYTHONPATH=$PYTHONPATH:$GMT_GLOBAL/lib/py/

echo -e "$CL Cloning: nnpy Python Library $NC"
cd $MODULES
git clone --recursive https://github.com/wschoenell/nnpy.git
echo -e "$CL Building: nnpy Python Library $NC"
cd nnpy
dnf install -y python3-devel redhat-rpm-config
pip3 install cffi
pip3 install . --target $GMT_GLOBAL/lib/py/

echo -e "$CL Cloning: aionn Python Library $NC"
cd $MODULES
git clone --recursive https://github.com/wschoenell/aionn.git
echo -e "$CL Building: aionn Python Library $NC"
pip3 install --no-deps $MODULES/aionn/ --target $GMT_GLOBAL/lib/py/



echo -e "$CL Copying Python version of the core frameworks and services $NC"
cp -fr $MODULES/ocs_core_fwk/src/py/gmt/ $GMT_GLOBAL/lib/py/gmt/


# create docs directory
echo -e "$CL Creating doc/ folder $NC"
mkdir $SDK_BUILD_DIR/doc

# copy PDFs from gmt_docs repo
DOCS=$GMT_LOCAL/doc
cd $MODULES
echo -e "$CL Cloning: gmt_docs $NC"
git clone --recursive --single-branch -b gh-pages https://$PAT:x-oauth-basic@github.com/GMTO/gmt_docs
# Checkout pull requests
cd gmt_docs
for id in $(echo $gmt_docs_pull_requests | sed 's/,/\n/g')
do
    echo -e "$CL Checking pull request #$id $NC"
    git pull --no-edit origin pull/$id/head
done
cd ..

cd gmt_docs/pdf/
echo -e "$CL Copying PDF files $NC"
cp swc_core_services_user_guide.pdf $DOCS
cp swc_gds_documentation.pdf $DOCS
cp swc_grs_documentation.pdf $DOCS
cp swc_hdk_example.pdf $DOCS
cp swc_installation.pdf $DOCS
cp swc_isample_example.pdf $DOCS
cp swc_map_model_cpp.pdf $DOCS
cp swc_modeling_guidelines.pdf $DOCS
cp swc_test_guidelines.pdf $DOCS
#cp swc_ui_fwk_guidelines.pdf $DOCS

echo -e "$CL Writing in the docs the git hashes used on this release... $NC"
cd $MODULES
echo "# List of repositories and git hashes used in this release #" > $DOCS/GIT_MANIFEST.txt
for repo in *
do
  cd $repo
  echo -n "$repo: "
  git rev-parse --short HEAD
  cd ..
done >> $DOCS/GIT_MANIFEST.txt

# create distribution directory
echo -e "$CL Creating SDK distribution: $SDK_DIST_DIR $NC"
cp -r $SDK_BUILD_DIR $SDK_DIST_DIR
chown -R root:root $SDK_DIST_DIR
echo -e "$CL Cleaning up SDK distribution: $SDK_DIST_DIR $NC"
rm -rf $SDK_DIST_DIR/modules
rm -rf $SDK_DIST_DIR/node_modules
rm -rf $SDK_DIST_DIR/examples
rm -rf $SDK_DIST_DIR/modules
rm -rf $SDK_DIST_DIR/node_modules

# Create TAR file
echo -e "$CL Creating TAR file: $SDK_TAR_FILE $NC"
cd $SDK_DIST_DIR
tar -czf $SDK_TAR_FILE .

# Copy tarfile to workspace so can be created as an artifact
echo -e "$CL Copying TAR file: $SDK_TAR_FILE $NC"
mkdir -p /github/workspace/  # to work locally
cp $SDK_TAR_FILE /github/workspace/

# Done
echo -e "$CL DONE $NC"
# --------
