# Contributing

## Making a PR

Be warned that due to a GitHub limitation, a PR will always be opened against the upstream `99designs/aws-vault`. You will have to manually change the base branch in the PR page.

## CI tricks

### Build and download for macOS

    $ fly --target developers execute \
        --config=ci/tasks/build-darwin.yml \
        --input=aws-vault.git=. \
        --output=out=out \
        --tag=sequoia

## Making a release

The release strategy of this project is based on git tags from the master branch.

Steps to be performed by the Release Engineer:

1. Assume that the master branch already contains the features you want to release, properly tested.
2. The master branch must enter freeze mode: the only permitted merge will be the merge of the release preparation branch.
3. Assume that you want to release `v1.2.3`.
4. Make a dedicated branch, say `prepare-release-v1.2.3`, containing the updated CHANGELOG (and possibly the README).
5. Export the tag to avoid errors:
   ```
   $ export AWS_VAULT_NEW_TAG="v1.2.3"
   $ echo $AWS_VAULT_NEW_TAG
   ```
6. Make a PR as usual.
7. When ready to merge, do the merge locally, tag and push the merged master to the remote as follows.
8. Get an updated master
   ```
   $ git checkout master
   $ git pull
   ```
9. Perform a normal (non fast-forward) merge:
   ```
   $ git merge --no-ff prepare-release-v1.2.3
   ```
   The --no-ff flag ensures that the merge has two ancestors: master and prepare-release-vA.B.C.
   This makes the subsequent git push equivalent to clicking on the merge button in the GitHub UI.

10. Run the tests locally. You never know...
11. Tag the master branch
   ```
   $ git tag -a -m "Release $AWS_VAULT_NEW_TAG" $AWS_VAULT_NEW_TAG
   ```
12. Push the master branch and the tag
   ```
   $ git push origin master $AWS_VAULT_NEW_TAG
   ```
13. The master pipeline will see the merge commit, containing the tag, and will trigger a build.
14. When the master pipeline finished running, unfreeze the master branch.
15. Celebrate!
