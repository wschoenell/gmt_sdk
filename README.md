Configuring forks
-----------------

To run actions on fork, a [Personal Access Token](https://docs.github.com/en/github/authenticating-to-github/keeping-your-account-and-data-secure/creating-a-personal-access-token) 
must be created with `repo` permissions. This token should be added as an [Encrypted secret](https://docs.github.com/en/actions/reference/encrypted-secrets)
named `PAT` in the forked repository. This secret is used to clone all the repositories needed to generate the 
release.  

Running locally (requires docker)
---------------------------------
    # Personal Access Token needed for cloning GMT private repos
    export PAT="" # put a valid Personal Access Token
    
    # Build SDK
    cd release
    docker build -t gmt_sdk .
    eval $(grep '_pull_requests' ../.github/workflows/release_candidates.yaml | grep -v '^#' | sed 's/^/export/;s/: /=/g;')
    
    # Automated build:
    time docker run -e PAT \
                $(egrep '_pull_requests' ../.github/workflows/release_candidates.yaml | cut -f1 -d: | sed 's/^/-e/g') \
                -v $PWD/github/workspace/:/github/workspace/ \
                --cpuset-cpus="0-$(($(nproc)-1))" \
                gmt_sdk \
                /module/create_build.sh 1.14.0 $(date "+%Y%m%d")-test

    # Interactively build:
    docker run -e PAT \
                $(egrep '_pull_requests' ../.github/workflows/release_candidates.yaml | cut -f1 -d: | sed 's/^/-e/g') \
                -v $PWD/github/workspace/:/github/workspace/ \
                --cpuset-cpus="0-$(($(nproc)-1))" \
                -v $PWD/github/workspace/:/github/workspace/ \
                -it gmt_sdk  # /module/create_build.sh 1.14.0 $(date "+%Y%m%d")-test2
    
    # Test SDK
    docker run --cpuset-cpus="0-$(($(nproc)-1))" \
               -e PAT \
               $(egrep '_pull_requests' ../.github/workflows/release_candidates.yaml | cut -f1 -d: | sed 's/^/-e/g') \
               -v $PWD/github/workspace/:/github/workspace/ \
               gmt_sdk \
               /module/test_build.sh 1.14.0 $(date "+%Y%m%d")-test
    
Running over GitHub actions (official release)
----------------------------------------------

To create an official release, just create a release in the repo following the release normal creation procedure in this repo.
For documentation on release creation on github repositories, follow this documentation:
https://docs.github.com/en/repositories/releasing-projects-on-github/managing-releases-in-a-repository

Running over GitHub actions (release candidates)
----------------------------------------------

To create a release candidate, update the release candidate action file with the pull requests that has to be included on the RC.
When the change is pushed, a release candidate is automatically generated. 


Updating release versions
-------------------------
    
    release_version=1.13.0
    gh_username=wschoenell

    # gh login
    gh auth login -p ssh -h github.com
    
    mkdir tmp
    cd tmp
    
    # APP_SYS
    # checkout app_sys
    git clone git@github.com:$gh_username/ocs_app_sys.git
    cd ocs_app_sys/
    git remote add upstream git@github.com:GMTO/ocs_app_sys.git
    git pull upstream master
    # change version numbers
    gsed -i "s/set_cli_version.*'.*'/set_cli_version  '$release_version'/g" src/coffee/*/*/*app.coffee
    # add files
    for i in $(grep set_cli_version.*'.*' src/coffee/*/*/*app.coffee | cut -f1 -d:)
    do
        git add $i
    done
    # commit files
    git commit -m "bump to version $release_version"
    # push to a branch
    git checkout -b version_update_$release_version
    git push origin version_update_$release_version
    # create pull request
    gh repo set-default GMTO/ocs_app_sys
    gh pr create --title "bump to v$release_version" --head $gh_username:version_update_$release_version -b "bump to v$release_version"

    # DEV_FWK
    cd ..
    # checkout dev_fwk
    git clone git@github.com:$gh_username/ocs_dev_fwk.git
    cd ocs_dev_fwk/
    git remote add upstream git@github.com:GMTO/ocs_dev_fwk.git
    git pull upstream master
    # change version numbers
    gsed -i 's/@version.*".*"/@version   = "'$release_version'"/g' src/core/*.coffee
    gsed -i 's/\.version.*".*"/\.version "'$release_version'"/g' src/core/*.coffee
    gsed -i 's/version:.*"[0-9].*/version:        "'$release_version'"/g' src/core/*.coffee
    # add files
    git add -A
    # commit files
    git commit -m "bump to version $release_version"
    # push to a branch
    git checkout -b version_update_$release_version
    git push origin version_update_$release_version
    # create pull request
    gh repo set-default GMTO/ocs_dev_fwk
    gh pr create --title "bump to v$release_version" --head $gh_username:version_update_$release_version -b "bump to v$release_version"

    # SEQ_SYS
    cd ..
    # checkout seq_sys
    git clone git@github.com:$gh_username/ocs_seq_sys.git
    cd ocs_seq_sys/
    git remote add upstream git@github.com:GMTO/ocs_seq_sys.git
    git pull upstream master
    # change version numbers
    gsed -i 's/set_cli_version.*".*"/set_cli_version  "'$release_version'"/g' src/coffee/*/*.coffee
    # add files
    git add -A
    # commit files
    git commit -m "bump to version $release_version"
    # push to a branch
    git checkout -b version_update_$release_version
    git push origin version_update_$release_version
    # create pull request
    gh repo set-default GMTO/ocs_seq_sys
    gh pr create --title "bump to v$release_version" --head $gh_username:version_update_$release_version -b "bump to v$release_version"

    # CORE_FWK
    cd ..
    # checkout core_fwk
    git clone git@github.com:$gh_username/ocs_core_fwk.git
    cd ocs_core_fwk/
    git remote add upstream git@github.com:GMTO/ocs_core_fwk.git
    git pull upstream master
    # change version numbers
    gsed -i 's/set_cli_version.*/set_cli_version  "'$release_version'"/g' src/coffee/core_lib_pkg/Applications/GMTRuntimeSystemApp.coffee
    # add files
    git add -A
    # commit files
    git commit -m "bump to version $release_version"
    # push to a branch
    git checkout -b version_update_$release_version
    git push origin version_update_$release_version
    # create pull request
    gh repo set-default GMTO/ocs_core_fwk
    gh pr create --title "bump to v$release_version" --head $gh_username:version_update_$release_version -b "bump to v$release_version"

Creating release tags on all repositories
-----------------------------------------

    release_tag=v1.13.0
    gh_username=wschoenell
    gh auth login -p ssh -h github.com

    gh config set prompt disabled
    for repo in ocs_core_fwk ocs_dev_fwk ocs_sys  ocs_ctrl_fwk ocs_dp_fwk ocs_io_fwk ocs_pers_fwk ocs_test_fwk ocs_ui_fwk ocs_log_sys ocs_alarm_sys ocs_tele_sys ocs_conf_sys ocs_sup_sys ocs_data_sys ocs_app_sys ocs_seq_sys ocs_boost_ext ocs_eigen_ext ocs_nanomsg_ext ocs_msgpack_ext ocs_isample_dcs ocs_hdk_dcs 
    do
        echo "Tagging $repo"
        gh release create $release_tag -t $release_tag -R GMTO/$repo
    done

Deploying on GMT release server
-------------------------------

1. Download the artifact to your computer

2. Unzip the file, for example `unzip ~/Downloads/gmt-sdk-1.9.0.20210625-eafdfdc.tar.gz.zip`

3. Copy release to the admin server 172.16.10.21:


    filename="gmt-sdk-1.9.0.20210625-eafdfdc.tar.gz"
    scp $filename root@172.16.10.21:

2. From root account on the admin server, copy the file to the release server running:


    ssh root@172.16.10.21 scp $filename fedora@52.52.46.32:/srv/gmt/releases/sdk/linux/
    
    