#!/bin/sh

set -e

main() {
  if [ $TRAVIS_BRANCH == "master" && $TRAVIS_PULL_REQUEST == "false" ]; then
    cp -at $HOME/ dist

    cd $HOME
    git config --global user.email "deploy@travis-ci.org"
    git config --global user.name "Deployment Bot"

    git clone \
      --quiet \
      --branch=gh-pages \
      https://${GH_TOKEN}@github.com/${GH_USER}/${GH_REPO}.git \
      gh-pages > /dev/null

    cd gh-pages
    git rm -rf .
    cp -at . $HOME/dist/*

    echo "Allow files with underscore https://help.github.com/articles/files-that-start-with-an-underscore-are-missing/" > .nojekyll
    echo "[View live](https://${GH_USER}.github.io/${GH_REPO}/)" > README.md

    git add -f .
    git commit -m "Travis build $TRAVIS_BUILD_NUMBER"
    git push -fq origin gh-pages > /dev/null
  else
    echo "Skip: we only run on master branch"
  fi
}

main "$@"
