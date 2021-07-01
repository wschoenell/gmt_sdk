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
    docker run -e PAT -v $PWD/github/workspace/:/github/workspace/ gmt_sdk /module/create_build.sh 1.10.0 $(date "+%Y%m%d")-test
    
    # Test SDK
    docker run -e PAT -v $PWD/github/workspace/:/github/workspace/ gmt_sdk /module/test_build.sh 1.10.0 $(date "+%Y%m%d")-test
    
Deploying on GMT release server
-------------------------------

1. Download the artifact to your computer

2. Unzip the file, for example `unzip ~/Downloads/gmt-sdk-1.9.0.20210625-eafdfdc.tar.gz.zip`

3. Copy release to the admin server 172.16.10.21:


    scp gmt-sdk-1.9.0.20210625-eafdfdc.tar.gz root@172.16.10.21:

2. From root account on the admin server, copy the file to the release server running:


    scp gmt-sdk-1.9.0.20210625-eafdfdc.tar.gz fedora@52.52.46.32:/srv/gmt/releases/sdk/linux/
    
    