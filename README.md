Configuring forks
-----------------

To run actions on fork, a [Personal Access Token](https://docs.github.com/en/github/authenticating-to-github/keeping-your-account-and-data-secure/creating-a-personal-access-token) 
must be created with `repo` permissions. This token should be added as an [Encrypted secret](https://docs.github.com/en/actions/reference/encrypted-secrets)
named `PAT` in the forked repository. This secret is used to clone all the repositories needed to generate the 
release.  
