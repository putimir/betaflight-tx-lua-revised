#!/bin/bash

if [ ${TRAVIS_PULL_REQUEST} == false ]; then
    SHORT_HASH=`git rev-parse --short HEAD`
    GITHUB_OWNER=`echo "${TRAVIS_REPO_SLUG}" | cut -d "/" -f 1`
    SUBJECT=`git log -n 1 --pretty=format:%s`
    rm Makefile
    git config --global user.email "travis@travis-ci.org"
    git config --global user.name "Travis CI"
    git remote rm origin
    git remote add origin https://${GITHUB_OWNER}:${GITHUB_TOKEN}@github.com/${TRAVIS_REPO_SLUG}.git > /dev/null
    git add .
    git stash 
    git checkout ${TRAVIS_BRANCH} 
    git stash pop
    git add . 
    git commit -am "Minified: ${SUBJECT} [${SHORT_HASH}] [skip ci]"
    git push --set-upstream origin ${TRAVIS_BRANCH}
    echo "Done!"
else
    echo "Pull requests are not minified...Exiting."
fi