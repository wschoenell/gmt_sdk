Building locally:

    export PAT="my_personal_access_token"
    export ocs_core_fwk_pull_requests="233"
    docker build --no-cache --file Dockerfile -t gmt_release . 
    mkdir ./github/
    docker run -e PAT -e ocs_core_fwk_pull_requests --rm -v "$PWD/github/":/github/ -it gmt_release /module/create_build.sh 1.8.2 2
    
Testing locally:
    
    export PAT="my_personal_access_token"
    export ocs_core_fwk_pull_requests="233"
    docker build --file Dockerfile_test -t gmt_release_test . 
    docker run --rm -e PAT -e ocs_core_fwk_pull_requests -v "$PWD/github/":/github/ -it gmt_release_test /module/test_build.sh 1.8.2 2
