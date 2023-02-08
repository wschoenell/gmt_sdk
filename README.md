Configuring forks
-----------------

To run actions on fork, a [Personal Access Token](https://docs.github.com/en/github/authenticating-to-github/keeping-your-account-and-data-secure/creating-a-personal-access-token) 
must be created with `repo` permissions. This token should be added as an [Encrypted secret](https://docs.github.com/en/actions/reference/encrypted-secrets)
named `PAT` in the forked repository. This secret is used to clone all the repositories needed to generating the 
release.  

Running locally (requires docker)
---------------------------------
    # Personal Access Token needed for cloning GMT private repos
    export PAT="" # put a valid Personal Access Token
    
    # Build SDK
    cd release
    docker build -t gmt_sdk .
    eval $(egrep '(_pull_requests|_pull_requests)' ../.github/workflows/release_candidates.yaml | grep -v '^#' | sed 's/^/export/;s/: /=/g;')
    docker run -e PAT -e ocs_dev_fwk_pull_requests -e ocs_core_fwk_pull_requests -e ocs_io_fwk_pull_requests -e ocs_eigen_ext_pull_requests \
     -v $PWD/github/workspace/:/github/workspace/ gmt_sdk /module/create_build.sh 1.10.1 $(date "+%Y%m%d")-test
    
    # Test SDK
    docker run -e PAT -v $PWD/github/workspace/:/github/workspace/ gmt_sdk /module/test_build.sh 1.10.1 $(date "+%Y%m%d")-test
    
Running over GitHub actions (official release)
----------------------------------------------

To create an official release, just create a release in the repo following the release normal creation procedure in this repo.
For documentation on release creation on github repositories, follow this documentation:
https://docs.github.com/en/repositories/releasing-projects-on-github/managing-releases-in-a-repository

Running over GitHub actions (release candidates)
----------------------------------------------

To create a release candidate, update the release candidate action file with the pull requests that has to be included on the RC.
When the change is pushed, a release candidate is automatically generated. 

Deploying on GMT release server
-------------------------------

1. Download the artifact to your computer

2. Unzip the file, for example `unzip ~/Downloads/gmt-sdk-1.9.0.20210625-eafdfdc.tar.gz.zip`

3. Copy release to the admin server 172.16.10.21:


    filename="gmt-sdk-1.9.0.20210625-eafdfdc.tar.gz"
    scp $filename root@172.16.10.21:

2. From root account on the admin server, copy the file to the release server running:


    ssh root@172.16.10.21 scp $filename fedora@52.52.46.32:/srv/gmt/releases/sdk/linux/
    
    